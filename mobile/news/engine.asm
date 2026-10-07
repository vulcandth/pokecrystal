; Pokémon News screen, script, and text interpreters.
; Screens are loaded from SRAM into wNewsScreenBuffer. Script and text offsets
; are relative to that screen, except LoadScreen's issue-relative offset.
; See mobile/news/news.asm for the embedded Japanese samples.

DownloadPokemonNews:
	call PokemonNews_ClearMobileState
	farcall Mobile_DownloadNews
	ret

PokemonNews_ClearMobileState:
	xor a
	ld [wJumptableIndex], a
	ld [wcf64], a
	ld [wcf65], a
	ld [wcf66], a
	ret

ReadPokemonNews:
	ld a, BANK(sPokemonNewsDownloaded)
	call OpenSRAM
	ld a, [sPokemonNewsDownloaded]
	call CloseSRAM
	and a
	jr nz, .asm_17d2e2
	ld a, $1
	ld [wScriptVar], a
	ret

.asm_17d2e2
	call PokemonNews_ValidateChecksum
	ret c
	call SpeechTextbox
	call FadeToMenu
	ldh a, [rWBK]
	push af
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	call PokemonNews_Init
	call PokemonNews_JoypadLoop
	pop af
	ldh [rWBK], a
	ld de, MUSIC_MOBILE_CENTER
	ld a, e
	ld [wMapMusic], a
	ld [wMusicFadeID], a
	ld a, d
	ld [wMusicFadeID + 1], a
	call PlayMusic
	call ReturnToMapFromSubmenu
	call CloseSubmenu
	ret

PokemonNews_ValidateChecksum:
	ld a, BANK(sNewsRankingTableSize)
	call OpenSRAM
	ld a, [sNewsRankingTableSize]
	call CloseSRAM
	cp MAX_NEWS_RANKINGS * 2 + 1
	jr nc, .invalid
	ld a, BANK(sPokemonNewsData)
	call OpenSRAM
	ld l, 0
	ld h, l
	ld de, sPokemonNewsData
	ld a, [sPokemonNewsLength]
	ld c, a
	ld a, [sPokemonNewsLength + 1]
	ld b, a
.sum_bytes
	push bc
	ld a, [de]
	inc de
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or c
	jr nz, .sum_bytes
	ld a, [sPokemonNewsChecksum]
	cp l
	jr nz, .invalid
	ld a, [sPokemonNewsChecksum + 1]
	cp h
	jr nz, .invalid
	call CloseSRAM
	and a
	ret

.invalid
	call CloseSRAM
	ld a, BANK(sPokemonNewsID)
	call OpenSRAM
	xor a
	ld hl, sPokemonNewsID
	ld bc, NEWS_ID_LENGTH
	call ByteFill
	call CloseSRAM
	ld a, $2
	ld [wScriptVar], a
	scf
	ret

PokemonNews_Init:
	xor a
	ld [wNewsJumptableIndex], a
	ld [wNewsScriptPointer], a
	ld [wNewsScriptPointer + 1], a
	dec a
	ld [wNewsMusic], a
	call ClearBGPalettes
	call ClearSprites
	call ClearScreen
	farcall HDMATransferTilemapAndAttrmap_Overworld
	call DisableLCD
	ld hl, vTiles0 tile '▼'
	ld de, wNewsSavedScrollTile
	ld bc, 1 tiles
	call CopyBytes
	ld a, $1
	ldh [rVBK], a
	ld hl, PokemonNewsGFX
	ld de, vTiles4
	ld bc, $48 tiles
	call CopyBytes
	xor a
	ld hl, vTiles5 tile $7f
	ld bc, 1 tiles
	call ByteFill
	ld hl, wNewsSavedScrollTile
	ld de, vTiles3 tile '▼'
	ld bc, 1 tiles
	call CopyBytes
	xor a
	ldh [rVBK], a
	ld hl, PostalMarkGFX
	ld de, vTiles2 tile NEWS_POSTAL_MARK
	ld bc, 1 tiles
	call CopyBytes
	call EnableLCD
	call PokemonNews_LoadMetadata
	ld a, LOW(wNewsScreenBuffer)
	ld [wNewsScreenPointer], a
	ld a, HIGH(wNewsScreenBuffer)
	ld [wNewsScreenPointer + 1], a
	ld a, BANK(sPokemonNewsData)
	call OpenSRAM
	ld hl, sPokemonNewsData
	ld de, wNewsScreenBuffer
	ld bc, NEWS_BUFFER_SIZE
	call CopyBytes
	call CloseSRAM
	ret

PokemonNews_ClearScreen:
	call ClearBGPalettes
	call ClearSprites
	call ClearScreen
	farcall HDMATransferTilemapAndAttrmap_Overworld

PokemonNews_LoadGraphics:
	call DisableLCD
	ld hl, vTiles0 tile '▼'
	ld de, wNewsSavedScrollTile
	ld bc, 1 tiles
	call CopyBytes
	ld a, $1
	ldh [rVBK], a
	ld hl, PokemonNewsGFX
	ld de, vTiles4
	ld bc, $48 tiles
	call CopyBytes
	xor a
	ld hl, vTiles5 tile $7f
	ld bc, 1 tiles
	call ByteFill
	ld hl, wNewsSavedScrollTile
	ld de, vTiles3 tile '▼'
	ld bc, 1 tiles
	call CopyBytes
	xor a
	ldh [rVBK], a
	call EnableLCD
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, PokemonNewsPalettes
	ld de, wBGPals1
	ld bc, 8 palettes
	call CopyBytes
	call SetDefaultBGPAndOBP
	pop af
	ldh [rWBK], a
	ret

PokemonNews_JoypadLoop:
.asm_17d45a
	call JoyTextDelay
	ld a, [wNewsJumptableIndex]
	bit 7, a
	jr nz, .asm_17d46f
	call PokemonNews_RunState
	farcall HDMATransferTilemapAndAttrmap_Overworld
	jr .asm_17d45a

.asm_17d46f
	xor a
	ld [wScriptVar], a
	ret

PokemonNews_RunState:
	jumptable PokemonNewsStatePointers, wNewsJumptableIndex

PokemonNewsStatePointers:
	table_width 2
	dw PokemonNews_LoadScreen
	dw PokemonNews_SetPalettes
	dw PokemonNews_Joypad
	dw PokemonNews_RunScript
	dw PokemonNews_WaitButton
	assert_table_length NUM_NEWS_STATES

PokemonNews_LoadScreen:
; Decode the screen header, then its three menu pointer tables.
; Palette byte: bit n supplies a replacement for palette n.
	ld hl, PokemonNewsPalettes
	ld de, wNewsPaletteBuffer
	ld bc, 8 palettes
	call CopyBytes
	ld hl, PokemonNewsTileAttrmap
	decoord 0, 0
	bccoord 0, 0, wAttrmap
	ld a, SCREEN_HEIGHT
.asm_17d4a4
	push af
	ld a, SCREEN_WIDTH
	push hl
.asm_17d4a8
	push af
	ld a, [hli]
	cp ' '
	jr z, .asm_17d4b0
	add $80

.asm_17d4b0
	ld [de], a
	inc de
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	jr nz, .asm_17d4a8
	pop hl
	push bc
	ld bc, TILEMAP_WIDTH * 2
	add hl, bc
	pop bc
	pop af
	dec a
	jr nz, .asm_17d4a4
	ld a, [wNewsScreenPointer]
	ld l, a
	ld a, [wNewsScreenPointer + 1]
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, [wNewsMusic]
	cp e
	jr z, .asm_17d4e0
	ld a, e
	ld [wNewsMusic], a
	ld [wMapMusic], a
	ld d, $0
	call PlayMusic2

.asm_17d4e0
	ld a, [hli]
	ld de, wNewsPaletteBuffer
	ld c, $8
.asm_17d4e6
	srl a
	jr nc, .asm_17d4f6
	ld b, 1 palettes
	push af
.asm_17d4ed
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .asm_17d4ed
	pop af
	jr .asm_17d4fc

.asm_17d4f6
	push af
	ld a, e
	add 1 palettes
	ld e, a
	pop af

.asm_17d4fc
	dec c
	jr nz, .asm_17d4e6
	push hl
	call PokemonNews_CopyPalettes
	pop hl
	ld a, [hli]
	and a
	jr z, .asm_17d539
.asm_17d508
	push af
	ld a, [hli]
	ld [wNewsBoxX], a
	ld a, [hli]
	ld [wNewsBoxY], a
	ld a, [hli]
	ld [wNewsBoxWidth], a
	ld a, [hli]
	ld [wNewsBoxHeight], a
	ld a, [hli]
	sla a
	sla a
	sla a
	add $98
	ld [wNewsBoxTile], a
	ld de, wNewsBoxX
	call PokemonNews_DrawBox
	ld a, [hli]
	ld [wNewsBoxAttributes], a
	ld de, wNewsBoxX
	call PokemonNews_ApplyBoxAttributes
	pop af
	dec a
	jr nz, .asm_17d508

.asm_17d539
	ld a, [hli]
.asm_17d53a
	push af
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	push hl
	pop de
	hlcoord 0, 0
	add hl, bc
	call PlaceString
	push de
	pop hl
	inc hl
	pop af
	dec a
	jr nz, .asm_17d53a
	ld de, wNewsMenuX
	ld bc, wNewsMenuCursor - wNewsMenuX
	call CopyBytes
	xor a
	ld [wNewsMenuCursor], a
	ld [wNewsMenuScrollOffset], a
	inc a
	ld [wNewsMenuCursorColumn], a
	ld [wNewsMenuCursorRow], a
	ld de, wNewsJoypadScripts
	ld bc, wNewsMenuItems - wNewsJoypadScripts
	call CopyBytes
	ld a, [hli]
	ld [wNewsMenuItems], a
	ld a, [hli]
	ld [wNewsDescriptionCoord], a
	ld a, [hli]
	ld [wNewsDescriptionCoord + 1], a
	ld a, [hli]
	ld [wNewsDescriptionWidth], a
	ld a, [hli]
	ld [wNewsDescriptionHeight], a
	ld a, [hli]
	and a
	jr z, .asm_17d58a
	call PokemonNews_LoadRanking

.asm_17d58a
	ld a, l
	ld [wNewsMenuTextPointers], a
	ld a, h
	ld [wNewsMenuTextPointers + 1], a
	ld a, [wNewsMenuItems]
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, l
	ld [wNewsMenuScriptPointers], a
	ld a, h
	ld [wNewsMenuScriptPointers + 1], a
	add hl, bc
	add hl, bc
	ld a, l
	ld [wNewsMenuDescriptionPointers], a
	ld a, h
	ld [wNewsMenuDescriptionPointers + 1], a
	call PokemonNews_PlaceMenuItems
	call PokemonNews_PlaceCursor
	call PokemonNews_PlaceDescription
	farcall HDMATransferTilemapAndAttrmap_Overworld
	jp PokemonNews_IncrementState

PokemonNews_SetPalettes:
	call SetDefaultBGPAndOBP
	call PokemonNews_IncrementState

PokemonNews_Joypad:
	ldh a, [hJoyPressed]
	and a
	ret z
	ld c, 0
	ld b, c
	ld hl, wNewsJoypadScripts
.loop
	srl a
	jr c, .got_button
	inc c
	inc c
	jr .loop

.got_button
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	and c
	cp $ff
	ret z
	ld a, [wNewsScreenPointer]
	ld l, a
	ld a, [wNewsScreenPointer + 1]
	ld h, a
	add hl, bc
	ld a, l
	ld [wNewsScriptPointer], a
	ld a, h
	ld [wNewsScriptPointer + 1], a
	ld a, NEWS_STATE_RUN_SCRIPT
	ld [wNewsJumptableIndex], a
	ret

PokemonNews_CopyPalettes:
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, wNewsPaletteBuffer
	ld de, wBGPals1
	ld bc, 8 palettes
	call CopyBytes
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	ret

PokemonNews_LoadMetadata:
; Rebuild the pointer table using each ranking's big-endian entry count
; and its little-endian entry size from the downloaded metadata.
	ld a, BANK(sNewsRankingEntrySizes)
	call OpenSRAM
	ld hl, sNewsRankingEntrySizes
	ld de, wNewsRankingSizesBuffer
	ld bc, MAX_NEWS_RANKINGS * 2
	call CopyBytes
	ld a, [sNewsRankingTableSize]
	ld c, a
	ld a, [sNewsRankingTableSize + 1]
	ld b, a
	ld a, [sNewsRankingPointers]
	ld l, a
	ld a, [sNewsRankingPointers + 1]
	ld h, a
	call CloseSRAM
	ld a, BANK(sPokemonNews)
	call OpenSRAM
	ld de, wc708
	ld a, c
	and a
	jr z, .save_pointers
.next_ranking
	push bc
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ld bc, NEWS_RANKING_COUNT_OFFSET
	add hl, bc
	pop bc
	ld a, [hli]
	ld [wNewsMenuTextPointers + 1], a
	ld a, [hli]
	ld [wNewsMenuTextPointers], a
	push hl
	push de
	ld hl, wNewsRankingSizesBuffer
	ld e, b
	ld d, $0
	add hl, de
	ld a, [hli]
	ld [wNewsMenuScriptPointers], a
	ld a, [hl]
	ld [wNewsMenuScriptPointers + 1], a
	pop de
	pop hl
	inc b
	inc b
	dec c
	dec c
	jr z, .save_pointers
	push bc
	push de
	ld a, [wNewsMenuTextPointers]
	ld c, a
	ld a, [wNewsMenuTextPointers + 1]
	ld b, a
	ld a, [wNewsMenuScriptPointers]
	ld e, a
	ld a, [wNewsMenuScriptPointers + 1]
	ld d, a
.skip_entries
	add hl, de
	dec bc
	ld a, c
	or b
	jr nz, .skip_entries
	pop de
	pop bc
	jr .next_ranking

.save_pointers
	call CloseSRAM
	ld a, BANK(sNewsRankingEntrySizes)
	call OpenSRAM
	ld hl, wc708
	ld de, sNewsRankingPointers
	ld a, [sNewsRankingTableSize]
	ld c, a
	ld a, [sNewsRankingTableSize + 1]
	ld b, a
	call CopyBytes
	call CloseSRAM
	ret

PokemonNews_LoadRanking:
	push hl
	ld a, [wNewsRanking]
	ld c, a
	ld b, 0
	ld a, BANK(sNewsRankingEntrySizes)
	call OpenSRAM
	ld hl, sNewsRankingEntrySizes
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld [wNewsRankingEntrySize], a
	ld a, [hl]
	ld [wNewsRankingEntrySize + 1], a
	ld hl, sNewsRankingPointers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld h, a
	ld l, c
	call CloseSRAM
	ld a, BANK(sPokemonNews)
	call OpenSRAM
	ld a, l
	ld [wNewsRankingPointer], a
	ld a, h
	ld [wNewsRankingPointer + 1], a
	ld de, wNewsRankingTotal
	ld bc, $4
	call CopyBytes
	inc hl
	inc hl
	ld de, wNewsPlayerRanking
	ld bc, $4
	call CopyBytes
	ld a, [hli]
	ld [wNewsRankingEntries + 1], a
	ld a, [hli]
	ld [wNewsRankingEntries], a
	ld a, l
	ld [wNewsRankingEntriesPointer], a
	ld a, h
	ld [wNewsRankingEntriesPointer + 1], a
	call CloseSRAM
	pop hl
	ret

PokemonNews_RunScript:
	ld a, [wNewsJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr nz, PokemonNews_FinishScript
	ld a, [wNewsScriptPointer]
	ld l, a
	ld a, [wNewsScriptPointer + 1]
	ld h, a
	ld a, [hl]
	cp NEWS_END
	jr z, PokemonNews_FinishScript

PokemonNews_RunScriptCommand:
.crash_loop
	cp NUM_NEWS_COMMANDS
	jr nc, .crash_loop
	ld e, a
	ld d, 0
	ld hl, NewsScriptPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

PokemonNews_FinishScript:
	call PokemonNews_PlaceDescription
	ld a, NEWS_STATE_JOYPAD
	ld [wNewsJumptableIndex], a
	ret

INCLUDE "data/mobile/news_scripts.asm"

NewsScript_Nothing:
; No operands. Does not advance the script pointer.
	ret

NewsScript_LoadScreen:
; dw offset from sPokemonNewsData to the new screen.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	call PokemonNews_SetScriptPointer
	ld a, BANK(sPokemonNewsData)
	call OpenSRAM
	ld hl, sPokemonNewsData
	add hl, bc
	ld de, wNewsScreenBuffer
	ld bc, NEWS_BUFFER_SIZE
	call CopyBytes
	call CloseSRAM
	xor a
	ld [wNewsJumptableIndex], a
	call ClearBGPalettes
	ret

NewsScript_PlayMusic:
; db music ID.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld d, 0
	call PlayMusic2
	call PokemonNews_SetScriptPointer
	ret

NewsScript_PlaySound:
; db sound effect ID.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld d, 0
	call PlaySFX
	call WaitSFX
	call PokemonNews_SetScriptPointer
	ret

NewsScript_PlayCry:
; db species.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	dec a
	ld e, a
	ld d, 0
	call PlayCry
	call WaitSFX
	call PokemonNews_SetScriptPointer
	ret

NewsScript_DrawBox:
; db x, y, width, height, border, palette.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld [wNewsBoxX], a
	ld a, [hli]
	ld [wNewsBoxY], a
	ld a, [hli]
	ld [wNewsBoxWidth], a
	ld a, [hli]
	ld [wNewsBoxHeight], a
	ld a, [hli]
	sla a
	sla a
	sla a
	add $98
	ld [wNewsBoxTile], a
	ld de, wNewsBoxX
	call PokemonNews_DrawBox
	ld a, [hli]
	ld [wNewsBoxAttributes], a
	ld de, wNewsBoxX
	call PokemonNews_ApplyBoxAttributes
	call PokemonNews_SetScriptPointer
	ret

NewsScript_PlaceText:
; dw tilemap offset, screen-relative string offset.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	call PokemonNews_SetScriptPointer
	call PokemonNews_GetScreenPointerInDE
	ld e, l
	ld d, h
	hlcoord 0, 0
	add hl, bc
	call PlaceString
	ret

NewsScript_DrawEZChatMessage:
; dw tilemap offset, screen-relative Easy Chat message offset.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	call PokemonNews_SetScriptPointer
	push de
	push bc
	call PokemonNews_BackUpRAM
	pop bc
	pop de
	call PokemonNews_GetScreenPointerInBC
	ld c, l
	ld b, h
	hlcoord 0, 0
	add hl, de
	ld e, l
	ld d, h
	farcall Function11c08f
	call PokemonNews_RestoreRAM
	ret

NewsScript_HTTPPost:
; dw screen-relative URL offset; then (db bank, dw address, db length)
; records, terminated by db $ff, describe the data to upload.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld hl, wNewsScreenBuffer
	add hl, de
	ld de, wcc60
.asm_17d86c
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, .asm_17d86c
	pop hl
	ld de, wc608
	ld c, $0
.asm_17d878
	ld a, [hli]
	cp $ff
	jr z, .asm_17d8c7
	ld [wcd4f], a
	ld a, [hli]
	ld [wcd50], a
	ld a, [hli]
	ld [wcd51], a
	ld a, [hli]
	ld [wcd52], a
	ld a, [wcd51]
	push af
	cp $c0
	jr c, .asm_17d89b
	ld a, [wcd4f]
	ldh [rWBK], a
	jr .asm_17d8a1

.asm_17d89b
	ld a, [wcd4f]
	call OpenSRAM

.asm_17d8a1
	push hl
	ld a, [wcd50]
	ld l, a
	ld a, [wcd51]
	ld h, a
	ld a, [wcd52]
.asm_17d8ad
	push af
	ld a, [hli]
	ld [de], a
	inc de
	inc c
	pop af
	dec a
	jr nz, .asm_17d8ad
	pop hl
	pop af
	cp $c0
	jr c, .asm_17d8c2
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	jr .asm_17d878

.asm_17d8c2
	call CloseSRAM
	jr .asm_17d878

.asm_17d8c7
	call PokemonNews_SetScriptPointer
	push bc
	ld a, $3
	ldh [rWBK], a
	ld hl, wc608
	ld de, wBGPals1
	ld b, $0
	call CopyBytes
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	call PokemonNews_BackUpRAM
	pop bc
	ld a, c
	ld [wNewsJoypadScripts + 9], a
	xor a
	ld [wcf66], a
	farcall Function118329
	ld a, [wMobileErrorCodeBuffer]
	and a
	jr z, .asm_17d8fe
	cp $a
	jr z, .asm_17d8fe
	call PokemonNews_DisplayError
	ret

.asm_17d8fe
	call PokemonNews_RestoreRAM
	ret

NewsScript_HTTPGet:
; dw screen-relative URL offset.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push de
	call PokemonNews_SetScriptPointer
	call PokemonNews_BackUpRAM
	pop de
	ld hl, wNewsScreenBuffer
	add hl, de
	ld de, wcc60
.asm_17d918
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr nz, .asm_17d918
	xor a
	ld [wcf66], a
	farcall Function11837a
	ld a, [wMobileErrorCodeBuffer]
	and a
	jr z, .asm_17d936
	cp $a
	jr z, .asm_17d936
	call PokemonNews_DisplayError
	ret

.asm_17d936
	call PokemonNews_RestoreRAM
	ret

NewsScript_PokemonPic:
; dw tilemap offset; db species, animation, palette.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $5
	call CopyBytes
	call PokemonNews_SetScriptPointer
	call PokemonNews_BackUpRAM
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	ld a, [wc70c]
	call PokemonNews_ApplyPicturePalette
	ld a, [wc70a]
	ld [wCurPartySpecies], a
	ld a, [wc70c]
	ld e, a
	farcall LoadMonPaletteAsNthBGPal
	call SetDefaultBGPAndOBP
	ld a, [wc708]
	ld l, a
	ld a, [wc709]
	ld h, a
	ld a, [wc70b]
	ld c, a
	decoord 0, 0
	add hl, de
	ld e, l
	ld d, h
	farcall HOF_AnimateFrontpic
	pop af
	ldh [rWBK], a
	call PokemonNews_RestoreRAM
	ret

NewsScript_TrainerPic:
; dw tilemap offset; db trainer class, palette.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $4
	call CopyBytes
	call PokemonNews_SetScriptPointer
	call PokemonNews_BackUpRAM
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	ld a, [wc70b]
	call PokemonNews_ApplyPicturePalette
	ld a, [wc70a]
	ld [wTrainerClass], a
	ld a, [wc70b]
	ld e, a
	farcall LoadTrainerClassPaletteAsNthBGPal
	call SetDefaultBGPAndOBP
	ld a, [wc708]
	ld e, a
	ld a, [wc709]
	ld d, a
	push de
	ld de, vTiles2
	farcall GetTrainerPic
	pop hl
	decoord 0, 0
	add hl, de
	ld bc, $707
	predef PlaceGraphic
	pop af
	ldh [rWBK], a
	call PokemonNews_RestoreRAM
	ret

NewsScript_CopyBytes:
; dw source, destination; db destination bank; dw length.
; Only the destination selects a RAM bank; the source uses the current bank.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $7
	call CopyBytes
	call PokemonNews_SetScriptPointer
	ld a, [wc70b]
	push af
	cp $c0
	jr c, .asm_17da01
	ld a, [wc70c]
	ldh [rWBK], a
	jr .asm_17da07

.asm_17da01
	ld a, [wc70c]
	call OpenSRAM

.asm_17da07
	ld a, [wc708]
	ld l, a
	ld a, [wc709]
	ld h, a
	ld a, [wc70a]
	ld e, a
	ld a, [wc70b]
	ld d, a
	ld a, [wc70d]
	ld c, a
	ld a, [wc70e]
	ld b, a
	call CopyBytes
	pop af
	cp $c0
	jr c, .asm_17da2d
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	jr .asm_17da30

.asm_17da2d
	call CloseSRAM

.asm_17da30
	ret

NewsScript_UpdateBit:
; dw address; db bank, bit (set bit 7 to clear the selected bit).
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $4
	call CopyBytes
	call PokemonNews_SetScriptPointer
	ld a, [wc709]
	push af
	cp $c0
	jr c, .asm_17da4f
	ld a, [wc70a]
	ldh [rWBK], a
	jr .asm_17da55

.asm_17da4f
	ld a, [wc70a]
	call OpenSRAM

.asm_17da55
	ld a, [wc708]
	ld e, a
	ld a, [wc709]
	ld d, a
	ld a, [wc70b]
	ld c, a
	bit 7, c
	jr nz, .asm_17da70
	ld hl, PokemonNewsSetBitMasks
	ld b, $0
	add hl, bc
	ld a, [de]
	or [hl]
	ld [de], a
	jr .asm_17da7d

.asm_17da70
	ld hl, PokemonNewsResetBitMasks
	ld a, c
	and $7f
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	and [hl]
	ld [de], a

.asm_17da7d
	pop af
	cp $c0
	jr c, .asm_17da88
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	jr .asm_17da8b

.asm_17da88
	call CloseSRAM

.asm_17da8b
	ret

INCLUDE "data/mobile/news_bitmasks.asm"

NewsScript_MenuUp:
; No operands. Move the cursor up, scrolling if needed.
	ld a, [wNewsMenuCursorRow]
	dec a
	jr z, .asm_17dabd
	push af
	call PokemonNews_EraseCursor
	pop af
	ld [wNewsMenuCursorRow], a
	ld hl, wNewsMenuColumns
	ld a, [wNewsMenuCursor]
	sub [hl]
	ld [wNewsMenuCursor], a
	call PokemonNews_PlaceCursor
	call PokemonNews_PlaceDescription
.asm_17daba
	jp PokemonNews_AdvanceScriptPointer

.asm_17dabd
	ld a, [wNewsMenuScrollOffset]
	and a
	jr z, .asm_17daba
	ld hl, wNewsMenuColumns
	sub [hl]
	ld [wNewsMenuScrollOffset], a
	ld a, [wNewsMenuCursor]
	sub [hl]
	ld [wNewsMenuCursor], a
	call PokemonNews_PlaceMenuItems
	call PokemonNews_PlaceCursor
	call PokemonNews_PlaceDescription
	jr .asm_17daba

NewsScript_MenuDown:
; No operands. Move the cursor down, scrolling if needed.
	ld a, [wNewsMenuCursor]
	ld hl, wNewsMenuColumns
	add [hl]
	ld hl, wNewsMenuItems
	cp [hl]
	jr z, .asm_17db0e
	jr nc, .asm_17db0e
	ld hl, wNewsMenuCursorRow
	ld a, [wNewsMenuVisibleRows]
	cp [hl]
	jr z, .asm_17db11
	call PokemonNews_EraseCursor
	ld a, [wNewsMenuCursorRow]
	inc a
	ld [wNewsMenuCursorRow], a
	ld hl, wNewsMenuColumns
	ld a, [wNewsMenuCursor]
	add [hl]
	ld [wNewsMenuCursor], a
	call PokemonNews_PlaceCursor
	call PokemonNews_PlaceDescription

.asm_17db0e
	jp PokemonNews_AdvanceScriptPointer

.asm_17db11
	ld hl, wNewsMenuColumns
	ld a, [wNewsMenuScrollOffset]
	add [hl]
	ld [wNewsMenuScrollOffset], a
	ld a, [wNewsMenuCursor]
	add [hl]
	ld [wNewsMenuCursor], a
	call PokemonNews_PlaceMenuItems
	call PokemonNews_PlaceCursor
	call PokemonNews_PlaceDescription
	jr .asm_17db0e

NewsScript_MenuRight:
; No operands. Move to the next column.
	ld a, [wNewsMenuCursorColumn]
	ld hl, wNewsMenuColumns
	cp [hl]
	jr z, .asm_17db53
	ld hl, wNewsMenuItems
	ld a, [wNewsMenuCursor]
	inc a
	cp [hl]
	jr z, .asm_17db53
	ld [wNewsMenuCursor], a
	call PokemonNews_EraseCursor
	ld a, [wNewsMenuCursorColumn]
	inc a
	ld [wNewsMenuCursorColumn], a
	call PokemonNews_PlaceCursor
	call PokemonNews_PlaceDescription

.asm_17db53
	jp PokemonNews_AdvanceScriptPointer

NewsScript_MenuLeft:
; No operands. Move to the previous column.
	ld a, [wNewsMenuCursorColumn]
	cp $1
	jr z, .asm_17db74
	call PokemonNews_EraseCursor
	ld a, [wNewsMenuCursorColumn]
	dec a
	ld [wNewsMenuCursorColumn], a
	ld a, [wNewsMenuCursor]
	dec a
	ld [wNewsMenuCursor], a
	call PokemonNews_PlaceCursor
	call PokemonNews_PlaceDescription

.asm_17db74
	jp PokemonNews_AdvanceScriptPointer

NewsScript_MenuNextPage:
; No operands. Scroll forward by wNewsMenuPageSize items.
	ld hl, wNewsMenuPageSize
	ld a, [wNewsMenuScrollOffset]
	add [hl]
	ld hl, wNewsMenuItems
	cp [hl]
	jr z, .asm_17dbae
	jr nc, .asm_17dbae
	call PokemonNews_EraseCursor
	ld hl, wNewsMenuPageSize
	ld a, [wNewsMenuScrollOffset]
	add [hl]
	ld [wNewsMenuScrollOffset], a
	ld a, [wNewsMenuCursor]
	add [hl]
	ld hl, wNewsMenuItems
	cp [hl]
	jr c, .asm_17db9f
	ld a, [hl]
	dec a

.asm_17db9f
	ld [wNewsMenuCursor], a
	call PokemonNews_ClampCursorToMenu
	call PokemonNews_PlaceMenuItems
	call PokemonNews_PlaceCursor
	call PokemonNews_PlaceDescription

.asm_17dbae
	jp PokemonNews_AdvanceScriptPointer

PokemonNews_ClampCursorToMenu:
	ld hl, wNewsMenuScrollOffset
	ld a, [wNewsMenuItems]
	sub [hl]
	ld hl, wNewsMenuPageSize
	cp [hl]
	ret nc
	ld a, $1
	ld [wNewsMenuCursorColumn], a
	ld [wNewsMenuCursorRow], a
	ld a, [wNewsMenuColumns]
	ld c, a
	ld a, [wNewsMenuColumns]
	ld b, a
	ld a, [wNewsMenuCursor]
	ld hl, wNewsMenuScrollOffset
	sub [hl]
.asm_17dbd4
	and a
	ret z
	push af
	ld hl, wNewsMenuCursorColumn
	ld a, b
	cp [hl]
	jr nz, .asm_17dbe4
	ld a, $1
	ld [hl], a
	ld hl, wNewsMenuCursorRow

.asm_17dbe4
	inc [hl]
	pop af
	dec a
	jr .asm_17dbd4

NewsScript_MenuPreviousPage:
; No operands. Scroll backward by wNewsMenuPageSize items.
	ld hl, wNewsMenuPageSize
	ld a, [wNewsMenuScrollOffset]
	sub [hl]
	bit 7, a
	jr z, .asm_17dbf5
	xor a

.asm_17dbf5
	ld [wNewsMenuScrollOffset], a
	ld a, [wNewsMenuCursorColumn]
	dec a
	ld c, a
	ld a, [wNewsMenuCursorRow]
	ld b, a
	xor a
	ld hl, wNewsMenuColumns
.asm_17dc05
	dec b
	jr z, .asm_17dc0b
	add [hl]
	jr .asm_17dc05

.asm_17dc0b
	add c
	ld hl, wNewsMenuScrollOffset
	add [hl]
	ld [wNewsMenuCursor], a
	call PokemonNews_PlaceMenuItems
	call PokemonNews_PlaceCursor
	call PokemonNews_PlaceDescription
	jp PokemonNews_AdvanceScriptPointer

NewsScript_YesNo:
; db x, y; dw screen-relative YES and NO script offsets.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc688
	ld bc, $6
	call CopyBytes
	call PokemonNews_BackUpRAM
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	ld hl, wc688
	ld a, $40
	ld [wc708], a
	ld a, [hli]
	ld [wc70a], a
	add $5
	ld [wc70c], a
	ld a, [hli]
	ld [wc709], a
	add $4
	ld [wc70b], a
	ld a, LOW(PokemonNewsYesNoMenuData)
	ld [wc70d], a
	ld a, HIGH(PokemonNewsYesNoMenuData)
	ld [wc70e], a
	ld a, $1
	ld [wc70f], a
	ld hl, wc708
	call LoadMenuHeader
	call VerticalMenu
	jr nc, .asm_17dc6e
	ld a, $2
	ld [wMenuCursorY], a

.asm_17dc6e
	call CloseWindow
	pop af
	ldh [rWBK], a
	ld a, [wMenuCursorY]
	cp $1
	jr nz, .asm_17dc85
	ld a, [wc68a]
	ld l, a
	ld a, [wc68a + 1]
	ld h, a
	jr .asm_17dc8d

.asm_17dc85
	ld a, [wc68a + 2]
	ld l, a
	ld a, [wc68a + 3]
	ld h, a

.asm_17dc8d
	push hl
	call PokemonNews_RestoreRAM
	pop hl
	call PokemonNews_Jump
	ret

PokemonNewsYesNoMenuData:
	db STATICMENU_CURSOR | STATICMENU_NO_TOP_SPACING | STATICMENU_WRAP ; flags
	db 2
	db "はい@"
	db "いいえ@"

NewsScript_FadeOut:
; No operands. Fade the screen out.
	call PokemonNews_AdvanceScriptPointer
	call PokemonNews_SetScriptPointer
	call RotateFourPalettesLeft
	ret

NewsScript_FadeIn:
; No operands. Fade the screen in.
	call PokemonNews_AdvanceScriptPointer
	call PokemonNews_SetScriptPointer

PokemonNews_FadeIn:
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, wBGPals1
	ld de, 1 palettes
	ld c, 8
.asm_17dcbb
	push hl
	ld a, $ff
	ld [hli], a
	ld a, ' '
	ld [hl], a
	pop hl
	add hl, de
	dec c
	jr nz, .asm_17dcbb
	call RotateThreePalettesRight
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	ret

NewsScript_MenuScript:
; No operands. Run the selected menu item's script.
	call PokemonNews_AdvanceScriptPointer
	push hl
	ld a, [wNewsMenuScriptPointers]
	ld l, a
	ld a, [wNewsMenuScriptPointers + 1]
	ld h, a
	ld a, [wNewsMenuCursor]
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	call PokemonNews_GetScreenPointerInBC
	call PokemonNews_SetScriptPointer
.asm_17dced
	ld a, [wNewsScriptPointer]
	ld l, a
	ld a, [wNewsScriptPointer + 1]
	ld h, a
	ld a, [hl]
	cp NEWS_END
	jr z, .asm_17dd0d
.crash_loop
	cp NUM_NEWS_COMMANDS
	jr nc, .crash_loop
	call PokemonNews_RunScriptCommand
	ld a, [wNewsJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr nz, .asm_17dd0d
	and a
	jr z, .asm_17dd11
	jr .asm_17dced

.asm_17dd0d
	pop hl
	jp PokemonNews_SetScriptPointer

.asm_17dd11
	pop hl
	ret

NewsScript_PrintText:
; dw tilemap offset, screen-relative text script offset.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	call PokemonNews_SetScriptPointer
	call PokemonNews_GetScreenPointerInDE
	push hl
	hlcoord 0, 0
	add hl, bc
	push hl
	pop bc
	pop hl
	call PrintTextboxTextAt
	ret

NewsScript_ClearText:
; dw tilemap offset; db width, height.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld b, 0
	ld a, [hli]
	push af
	call PokemonNews_SetScriptPointer
	pop af
	hlcoord 0, 0
	add hl, de
	call PokemonNews_ClearTextBox
	ret

NewsScript_CompareBytes:
; db bank; dw address, less, equal, greater; db length, bytes...
; Branch offsets are relative to the current screen.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $a
	call CopyBytes
	ld a, [wc711]
	ld c, a
	ld b, 0
	call CopyBytes
	ld a, [wc70a]
	cp $c0
	jr c, .sram
	ld a, [wc708]
	ldh [rWBK], a
	jr .got_bank

.sram
	ld a, [wc708]
	call OpenSRAM

.got_bank
	ld a, [wc709]
	ld l, a
	ld a, [wc70a]
	ld h, a
	ld de, wc688
	ld a, [wc711]
	ld c, a
	ld b, 0
	call CopyBytes
	ld a, [wc70a]
	cp $c0
	jr c, .close_sram
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	jr .exited_bank

.close_sram
	call CloseSRAM

.exited_bank
	ld a, [wc711]
	ld c, a
	ld hl, wc712
	ld de, wc688
.loop
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr z, .next
	jr c, .load
	jr .load2

.next
	dec c
	jr nz, .loop
	ld a, [wc70d]
	ld l, a
	ld a, [wc70e]
	ld h, a
	jr .done

.load2
	ld a, [wc70f]
	ld l, a
	ld a, [wc710]
	ld h, a
	jr .done

.load
	ld a, [wc70b]
	ld l, a
	ld a, [wc70c]
	ld h, a

.done
	call PokemonNews_Jump
	ret

NewsScript_CheckBit:
; db bank; dw address; db bit; dw set, clear script offsets.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $8
	call CopyBytes
	ld a, [wc70a]
	cp $c0
	jr c, .asm_17dde7
	ld a, [wc708]
	ldh [rWBK], a
	jr .asm_17dded

.asm_17dde7
	ld a, [wc708]
	call OpenSRAM

.asm_17dded
	ld a, [wc709]
	ld e, a
	ld a, [wc70a]
	ld d, a
	ld a, [de]
	ld [wc710], a
	ld a, [wc70b]
	ld c, a
	ld b, 0
	ld a, [wc70a]
	cp $c0
	jr c, .asm_17de0c
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	jr .asm_17de0f

.asm_17de0c
	call CloseSRAM

.asm_17de0f
	push hl
	ld hl, PokemonNewsSetBitMasks
	add hl, bc
	ld a, [hl]
	ld hl, wc710
	and [hl]
	pop hl
	jr nz, .asm_17de26
	ld a, [wc70e]
	ld l, a
	ld a, [wc70f]
	ld h, a
	jr .asm_17de2e

.asm_17de26
	ld a, [wc70c]
	ld l, a
	ld a, [wc70d]
	ld h, a

.asm_17de2e
	call PokemonNews_Jump
	ret

NewsScript_CompareRanking:
; dw entry offset, less, equal, greater; db length, bytes...
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $9
	call CopyBytes
	ld a, [wc710]
	ld c, a
	ld b, 0
	call CopyBytes
	ld a, BANK(sPokemonNews)
	call OpenSRAM
	call PokemonNews_GetRankingEntry
	ld a, [wc708]
	ld e, a
	ld a, [wc709]
	ld d, a
	add hl, de
	ld e, l
	ld d, h
	ld a, [wc710]
	ld c, a
	ld hl, wc711
.asm_17de61
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr z, .asm_17de6b
	jr c, .asm_17de82
	jr .asm_17de78

.asm_17de6b
	dec c
	jr nz, .asm_17de61
	ld a, [wc70c]
	ld l, a
	ld a, [wc70d]
	ld h, a
	jr .asm_17de8a

.asm_17de78
	ld a, [wc70e]
	ld l, a
	ld a, [wc70f]
	ld h, a
	jr .asm_17de8a

.asm_17de82
	ld a, [wc70a]
	ld l, a
	ld a, [wc70b]
	ld h, a

.asm_17de8a
	call CloseSRAM
	call PokemonNews_Jump
	ret

NewsScript_CheckRankingBit:
; dw entry offset; db bit; dw set, clear script offsets.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $7
	call CopyBytes
	ld a, BANK(sPokemonNews)
	call OpenSRAM
	call PokemonNews_GetRankingEntry
	ld a, [wc708]
	ld e, a
	ld a, [wc709]
	ld d, a
	add hl, de
	ld e, l
	ld d, h
	ld a, [wc70a]
	ld c, a
	ld b, 0
	ld hl, PokemonNewsSetBitMasks
	add hl, bc
	ld a, [hl]
	ld l, e
	ld h, d
	and [hl]
	jr nz, .asm_17deca
	ld a, [wc70d]
	ld l, a
	ld a, [wc70e]
	ld h, a
	jr .asm_17ded2

.asm_17deca
	ld a, [wc70b]
	ld l, a
	ld a, [wc70c]
	ld h, a

.asm_17ded2
	call CloseSRAM
	call PokemonNews_Jump
	ret

NewsScript_GivePokemon:
; 31 bytes of gift Pokémon parameters, ending with two
; screen-relative script offsets for success and failure.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $1f
	call CopyBytes
	call PokemonNews_BackUpRAM
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	ld hl, wc708
	ld a, [hli]
	ld [wCurPartySpecies], a
	ld [wTempEnemyMonSpecies], a
	ld a, [hli]
	ld [wCurPartyLevel], a
	ld a, [hli]
	ld b, a
	ld a, [wPartyCount]
	cp $6
	jp nc, PokemonNews_GivePokemonToBox
	xor a
	ld [wMonType], a
	push hl
	push bc
	predef TryAddMonToParty
	farcall SetCaughtData
	pop bc
	pop hl
	bit 1, b
	jr z, .asm_17df33
	push bc
	push hl
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonNicknames
	call SkipNames
	ld d, h
	ld e, l
	pop hl
	call CopyBytes
	pop bc
	jr .asm_17df37

.asm_17df33
	ld de, $6
	add hl, de

.asm_17df37
	bit 2, b
	jr z, .asm_17df5a
	push bc
	push hl
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMonOTs
	call SkipNames
	ld d, h
	ld e, l
	pop hl
	call CopyBytes
	ld a, [hli]
	ld b, a
	push hl
	farcall SetGiftPartyMonCaughtData
	pop hl
	pop bc
	jr .asm_17df5e

.asm_17df5a
	ld de, $7
	add hl, de

.asm_17df5e
	bit 3, b
	jr z, .asm_17df79
	push bc
	push hl
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1ID
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop bc
	jr .asm_17df7b

.asm_17df79
	inc hl
	inc hl

.asm_17df7b
	bit 4, b
	jr z, .asm_17dfd0
	push bc
	push hl
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1DVs
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	push hl
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Species
	call GetPartyLocation
	ld a, [hl]
	ld [wCurSpecies], a
	call GetBaseData
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1MaxHP
	call GetPartyLocation
	ld d, h
	ld e, l
	push hl
	ld b, FALSE
	farcall CalcMonStats
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1HP
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	pop hl
	pop bc
	jr .asm_17dfd2

.asm_17dfd0
	inc hl
	inc hl

.asm_17dfd2
	bit 5, b
	jr z, .asm_17dfea
	push bc
	push hl
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Item
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl
	ld a, [hli]
	ld [de], a
	pop bc
	jr .asm_17dfeb

.asm_17dfea
	inc hl

.asm_17dfeb
	bit 6, b
	jr z, .asm_17e01f
	push bc
	push hl
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1Moves
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl
	push de
	ld bc, $4
	call CopyBytes
	pop de
	push hl
	push de
	ld a, [wPartyCount]
	dec a
	ld hl, wPartyMon1PP
	call GetPartyLocation
	ld d, h
	ld e, l
	pop hl
	predef FillPP
	pop hl
	pop bc
	jp asm_17e0ee

.asm_17e01f
	ld de, $4
	add hl, de
	jp asm_17e0ee

PokemonNews_GivePokemonToBox:
	ld a, BANK(sBoxCount)
	call OpenSRAM
	ld a, [sBoxCount]
	call CloseSRAM
	cp $14
	jp nc, .asm_17e0ea
	bit 0, b
	jp z, .asm_17e0ea
	push bc
	push hl
	farcall LoadEnemyMon
	farcall SendMonIntoBox
	farcall SetBoxMonCaughtData
	pop hl
	pop bc
	ld a, BANK(sBoxMonNicknames)
	call OpenSRAM
	bit 1, b
	jr z, .asm_17e067
	push bc
	ld bc, $b
	ld de, sBoxMonNicknames
	call CopyBytes
	pop bc
	jr .asm_17e06b

.asm_17e067
	ld de, $6
	add hl, de

.asm_17e06b
	bit 2, b
	jr z, .asm_17e08e
	push bc
	ld bc, $6
	ld de, sBoxMonOTs
	call CopyBytes
	ld a, [hli]
	ld b, a
	push hl
	call CloseSRAM
	farcall SetGiftBoxMonCaughtData
	ld a, $1
	call OpenSRAM
	pop hl
	pop bc
	jr .asm_17e092

.asm_17e08e
	ld de, $7
	add hl, de

.asm_17e092
	bit 3, b
	jr z, .asm_17e0a2
	push bc
	ld de, sBoxMon1ID
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop bc
	jr .asm_17e0a4

.asm_17e0a2
	inc hl
	inc hl

.asm_17e0a4
	bit 4, b
	jr z, .asm_17e0b4
	push bc
	ld de, sBoxMon1DVs
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	pop bc
	jr .asm_17e0b6

.asm_17e0b4
	inc hl
	inc hl

.asm_17e0b6
	bit 5, b
	ld a, [hli]
	jr z, .asm_17e0be
	ld [sBoxMon1Item], a

.asm_17e0be
	bit 6, b
	jr z, .asm_17e0e1
	push bc
	ld de, sBoxMon1Moves
	ld bc, $4
	call CopyBytes
	push hl
	ld hl, sBoxMon1Moves
	ld de, sBoxMon1PP
	predef FillPP
	call CloseSRAM
	pop hl
	pop bc
	inc hl
	inc hl
	jr asm_17e0ee

.asm_17e0e1
	call CloseSRAM
	ld de, $6
	add hl, de
	jr asm_17e0ee

.asm_17e0ea
	ld bc, $1a
	add hl, bc

asm_17e0ee:
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ldh [rWBK], a
	push hl
	call PokemonNews_RestoreRAM
	pop hl
	call PokemonNews_Jump
	ret

NewsScript_GiveItem:
; db item, quantity; dw success, failure script offsets.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $6
	call CopyBytes
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	ld hl, wc708
	ld a, [hli]
	ld [wCurItem], a
	ld a, [hli]
	ld [wItemQuantityChange], a
	push hl
	ld hl, wNumItems
	call ReceiveItem
	pop hl
	jr c, .asm_17e127
	inc hl
	inc hl

.asm_17e127
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, a
	ld l, b
	pop af
	ldh [rWBK], a
	call PokemonNews_Jump
	ret

NewsScript_CheckPokemon:
; db species; dw owned, not-owned script offsets.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $5
	call CopyBytes
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	ld hl, wc708
	ld a, [hli]
	ld [wScriptVar], a
	push hl
	farcall MobileCheckOwnMonAnywhere
	pop hl
	jr c, .asm_17e159
	inc hl
	inc hl

.asm_17e159
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, a
	ld l, b
	pop af
	ldh [rWBK], a
	call PokemonNews_Jump
	ret

NewsScript_CheckItem:
; db item; dw owned, not-owned script offsets (bag or PC).
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $5
	call CopyBytes
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	ld hl, wc708
	ld a, [hli]
	ld [wCurItem], a
	push hl
	ld hl, wNumItems
	call CheckItem
	pop hl
	jr c, .asm_17e195
	push hl
	ld hl, wNumPCItems
	call CheckItem
	pop hl
	jr c, .asm_17e195
	inc hl
	inc hl

.asm_17e195
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, a
	ld l, b
	pop af
	ldh [rWBK], a
	call PokemonNews_Jump
	ret

NewsScript_CompareRAM:
; db bank1; dw address1; db length, bank2; dw address2;
; dw less, equal, greater script offsets.
	call PokemonNews_AdvanceScriptPointer
	ld de, wc708
	ld bc, $d
	call CopyBytes
	ld a, [wc70a]
	cp $c0
	jr c, .asm_17e1bb
	ld a, [wc708]
	ldh [rWBK], a
	jr .asm_17e1c1

.asm_17e1bb
	ld a, [wc708]
	call OpenSRAM

.asm_17e1c1
	ld a, [wc709]
	ld l, a
	ld a, [wc70a]
	ld h, a
	ld de, wc608
	ld a, [wc70b]
	ld c, a
	ld b, 0
	call CopyBytes
	ld a, [wc70a]
	cp $c0
	jr c, .asm_17e1e2
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	jr .asm_17e1e5

.asm_17e1e2
	call CloseSRAM

.asm_17e1e5
	ld a, [wc70e]
	cp $c0
	jr c, .asm_17e1f3
	ld a, [wc70c]
	ldh [rWBK], a
	jr .asm_17e1f9

.asm_17e1f3
	ld a, [wc70c]
	call OpenSRAM

.asm_17e1f9
	ld a, [wc70d]
	ld l, a
	ld a, [wc70e]
	ld h, a
	ld de, wc688
	ld a, [wc70b]
	ld c, a
	ld b, 0
	call CopyBytes
	ld a, [wc70e]
	cp $c0
	jr c, .asm_17e21a
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	jr .asm_17e21d

.asm_17e21a
	call CloseSRAM

.asm_17e21d
	ld a, [wc70b]
	ld c, a
	ld hl, wc688
	ld de, wc608
.asm_17e227
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr z, .asm_17e231
	jr c, .asm_17e23e
	jr .asm_17e248

.asm_17e231
	dec c
	jr nz, .asm_17e227
	ld a, [wc711]
	ld l, a
	ld a, [wc712]
	ld h, a
	jr .asm_17e250

.asm_17e23e
	ld a, [wc70f]
	ld l, a
	ld a, [wc710]
	ld h, a
	jr .asm_17e250

.asm_17e248
	ld a, [wc712 + 1]
	ld l, a
	ld a, [wc712 + 2]
	ld h, a

.asm_17e250
	call PokemonNews_Jump
	ret

NewsScript_SetValue:
; dw address; db value.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [de], a
	call PokemonNews_SetScriptPointer
	ret

NewsScript_AddValue:
; dw address; db amount to add.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	add [hl]
	ld [de], a
	inc hl
	call PokemonNews_SetScriptPointer
	ret

NewsScript_SubtractValue:
; dw address; db amount to subtract.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	sub [hl]
	ld [de], a
	inc hl
	call PokemonNews_SetScriptPointer
	ret

NewsScript_AddRAM:
; dw destination, address of the amount to add.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	call PokemonNews_SetScriptPointer
	ld l, c
	ld h, b
	ld a, [de]
	add [hl]
	ld [de], a
	ret

NewsScript_SubtractRAM:
; dw destination, address of the amount to subtract.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	call PokemonNews_SetScriptPointer
	ld l, c
	ld h, b
	ld a, [de]
	sub [hl]
	ld [de], a
	ret

NewsScript_UpdateRankings:
; No operands. Download rankings and set wNewsRankingsUpdateResult.
	call PokemonNews_AdvanceScriptPointer
	call PokemonNews_SetScriptPointer
	call PokemonNews_BackUpRAM
	xor a
	ld [wcf66], a
	farcall Mobile_UpdateNewsRankings
	ld de, PostalMarkGFX
	ld hl, vTiles2 tile NEWS_POSTAL_MARK
	lb bc, BANK(PostalMarkGFX), 1
	call Get2bpp
	ld a, [wMobileErrorCodeBuffer]
	and a
	jr z, .success
	cp $a
	jr z, .canceled
	cp $b
	jr z, .news_changed
	call PokemonNews_DisplayError
	ret

.success
	call PokemonNews_LoadMetadata
	call PokemonNews_RestoreRAM
	xor a
	ld [wNewsRankingsUpdateResult], a
	ld a, BANK(sPokemonNewsID)
	call OpenSRAM
	ld hl, sPokemonNewsID
	ld de, sPokemonNewsRankingsID
	ld bc, NEWS_ID_LENGTH
	call CopyBytes
	call CloseSRAM
	ret

.canceled
	call PokemonNews_RestoreRAM
	ld a, $1
	ld [wNewsRankingsUpdateResult], a
	ret

.news_changed
	call PokemonNews_RestoreRAM
	ld a, $2
	ld [wNewsRankingsUpdateResult], a
	ret

PokemonNews_DisplayError:
	ld a, MOBILE_ERROR_INIT_NO_FADE
	ld [wMobileErrorJumptableIndex], a
	call PokemonNews_FadeIn
	call ClearScreen
	call PokemonNews_RestoreRAM
	call PokemonNews_CopyPalettes
	farcall DisplayMobileError
	call PokemonNews_RestoreRAM
	call PokemonNews_FadeIn
	xor a
	ld [wNewsJumptableIndex], a
	ret

PokemonNews_BackUpRAM:
	ld a, BANK(sNewsPaletteBackup)
	call OpenSRAM
	ld hl, wNewsPaletteBuffer
	ld de, sNewsPaletteBackup
	ld bc, 8 palettes
	call CopyBytes
; de now points to sNewsStateBackup.
	ld hl, wNewsScreenPointer
	ld bc, wNewsStateEnd - wNewsScreenPointer
	call CopyBytes
	call CloseSRAM
	ret

PokemonNews_RestoreRAM:
	ld a, BANK(sNewsPaletteBackup)
	call OpenSRAM
	ld hl, sNewsPaletteBackup
	ld de, wNewsPaletteBuffer
	ld bc, 8 palettes
	call CopyBytes
; hl now points to sNewsStateBackup.
	ld de, wNewsScreenPointer
	ld bc, wNewsStateEnd - wNewsScreenPointer
	call CopyBytes
	call CloseSRAM
	ret

MACRO news_script_farcall
	call PokemonNews_AdvanceScriptPointer
	call PokemonNews_SetScriptPointer ; redundant
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	rept _NARG
		farcall \1
		shift
	endr
	pop af
	ldh [rWBK], a
	ret
ENDM

NewsScript_SaveGame:
	news_script_farcall _SaveGameData

NewsScript_SaveAfterLinkTrade:
	news_script_farcall SaveAfterLinkTrade

NewsScript_SaveBox:
	news_script_farcall SaveBox

NewsScript_SaveChecksum:
	news_script_farcall SaveChecksum

NewsScript_SaveTrainerRankings:
	news_script_farcall UpdateTrainerRankingsChecksum2, BackupGSBallFlag

NewsScript_Delay:
; db frame count.
	call PokemonNews_AdvanceScriptPointer
	ld a, [hli]
	ld c, a
	call PokemonNews_SetScriptPointer
	ld a, $1
	ldh [hBGMapMode], a
	call DelayFrames
	ret

NewsScript_WaitButton:
; No operands. Wait for A or B.
	call PokemonNews_AdvanceScriptPointer
	call PokemonNews_SetScriptPointer
.asm_17e3f6
	call JoyTextDelay
	ld hl, hJoyPressed
	ld a, [hl]
	and $1
	ret nz
	ld a, [hl]
	and $2
	ret nz
	call WaitBGMap
	jr .asm_17e3f6

NewsScript_Exit:
; No operands. Set the exit flag without advancing the script pointer.
	ld hl, wNewsJumptableIndex
	set JUMPTABLE_EXIT_F, [hl]
	ret

PokemonNews_Jump:
	ld de, wNewsScreenBuffer
	add hl, de
	jr PokemonNews_SetScriptPointer

PokemonNews_AdvanceScriptPointer:
	ld a, [wNewsScriptPointer]
	ld l, a
	ld a, [wNewsScriptPointer + 1]
	ld h, a
	inc hl

PokemonNews_SetScriptPointer:
	ld a, l
	ld [wNewsScriptPointer], a
	ld a, h
	ld [wNewsScriptPointer + 1], a
	ret

PokemonNews_WaitButton:
	ld hl, hJoyPressed
	ld a, [hl]
	and $1
	jr nz, .asm_17e432
	and $2
	ret z

.asm_17e432
	ld a, NEWS_STATE_RUN_SCRIPT
	ld [wNewsJumptableIndex], a
	ret

PokemonNews_IncrementState:
	ld hl, wNewsJumptableIndex
	inc [hl]
	ret

PokemonNews_GetScreenPointerInBC:
	ld a, [wNewsScreenPointer]
	ld l, a
	ld a, [wNewsScreenPointer + 1]
	ld h, a
	add hl, bc
	ret

PokemonNews_GetScreenPointerInDE:
	ld a, [wNewsScreenPointer]
	ld l, a
	ld a, [wNewsScreenPointer + 1]
	ld h, a
	add hl, de
	ret

PokemonNews_PlaceMenuItems:
	ld a, [wNewsMenuItems]
	and a
	ret z
	call PokemonNews_ClearMenu
	call PokemonNews_PlaceScrollArrows
	ld a, [wNewsMenuCursor]
	push af
	ld a, [wNewsMenuTextPointers]
	ld l, a
	ld a, [wNewsMenuTextPointers + 1]
	ld h, a
	ld a, [wNewsMenuScrollOffset]
	ld [wNewsMenuCursor], a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	push hl
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	ld a, [wNewsMenuY]
	call AddNTimes
	ld a, [wNewsMenuX]
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	ld a, [wNewsMenuRows]
.asm_17e48b
	push af
	push hl
	ld a, [wNewsMenuColumns]
.asm_17e490
	push af
	push hl
	ld a, [bc]
	inc bc
	ld e, a
	ld a, [bc]
	inc bc
	ld d, a
	push bc
	push hl
	ld a, [wNewsScreenPointer]
	ld l, a
	ld a, [wNewsScreenPointer + 1]
	ld h, a
	add hl, de
	push hl
	pop de
	pop hl
	call PlaceString
	pop bc
	pop hl
	ld a, [wNewsMenuColumnSpacing]
	ld e, a
	ld d, 0
	add hl, de
	ld a, [wNewsMenuCursor]
	inc a
	ld [wNewsMenuCursor], a
	ld e, a
	ld a, [wNewsMenuItems]
	cp e
	jr z, .asm_17e4d5
	pop af
	dec a
	jr nz, .asm_17e490
	pop hl
	ld a, [wNewsMenuRowSpacing]
	ld de, SCREEN_WIDTH
.asm_17e4cb
	add hl, de
	dec a
	jr nz, .asm_17e4cb
	pop af
	dec a
	jr nz, .asm_17e48b
	jr .asm_17e4d8

.asm_17e4d5
	pop af
	pop hl
	pop af

.asm_17e4d8
	pop af
	ld [wNewsMenuCursor], a
	ret

PokemonNews_PlaceScrollArrows:
	ld a, [wNewsMenuFlags]
	and $1
	ret z
	ld a, [wNewsScrollArrowY]
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	call AddNTimes
	ld a, [wNewsScrollArrowX]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wNewsMenuScrollOffset]
	and a
	jr z, .asm_17e4ff
	ld a, $61
	ld [hl], a

.asm_17e4ff
	ld a, [wNewsScrollArrowSpacing]
	ld bc, SCREEN_WIDTH
	call AddNTimes
	ld a, [wNewsMenuItems]
	ld c, a
	ld a, [wNewsMenuCursor]
	ld b, a
	ld a, [wNewsMenuColumns]
	add b
	cp c
	ret z
	ret nc
	ld a, '▼'
	ld [hl], a
	ret

PokemonNews_ClearMenu:
	ld a, [wNewsScrollArrowX]
	ld hl, wNewsMenuX
	sub [hl]
	inc a
	ld [wcd4f], a
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	ld a, [wNewsMenuY]
	dec a
	call AddNTimes
	ld a, [wNewsMenuX]
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wNewsMenuRows]
	ld c, a
	ld a, [wNewsMenuRowSpacing]
	call SimpleMultiply
.asm_17e544
	push af
	push hl
	ld a, [wcd4f]
	ld c, a
	ld b, 0
	ld a, ' '
	call ByteFill
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop af
	dec a
	jr nz, .asm_17e544
	ret

PokemonNews_PlaceCursor:
	ld a, [wNewsMenuItems]
	and a
	ret z
	ld a, '▶'
	call PokemonNews_PlaceCursorTile
	ret

PokemonNews_EraseCursor:
	ld a, [wNewsMenuItems]
	and a
	ret z
	ld a, ' '
	call PokemonNews_PlaceCursorTile
	ret

PokemonNews_PlaceCursorTile:
	push af
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	ld a, [wNewsMenuY]
	call AddNTimes
	ld a, [wNewsMenuX]
	ld c, a
	ld b, 0
	add hl, bc
	dec hl
	push hl
	ld a, [wNewsMenuCursorRow]
	dec a
	ld c, a
	ld a, [wNewsMenuRowSpacing]
	call SimpleMultiply
	ld l, $0
	ld h, l
	ld bc, SCREEN_WIDTH
	call AddNTimes
	ld a, [wNewsMenuCursorColumn]
	dec a
	ld c, a
	ld a, [wNewsMenuColumnSpacing]
	call SimpleMultiply
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	add hl, bc
	pop af
	ld [hl], a
	ret

PokemonNews_PlaceDescription:
	ld a, [wNewsMenuFlags]
	and $2
	ret z
	ld a, [wNewsDescriptionCoord]
	ld l, a
	ld a, [wNewsDescriptionCoord + 1]
	ld h, a
	bccoord 0, 0
	add hl, bc
	ld bc, $ffec
	add hl, bc
	ld a, [wNewsDescriptionWidth]
	ld c, a
	ld b, 0
	ld a, [wNewsDescriptionHeight]
	call PokemonNews_ClearTextBox
	ld a, [wNewsMenuCursor]
	ld c, a
	ld b, 0
	ld a, [wNewsMenuDescriptionPointers]
	ld l, a
	ld a, [wNewsMenuDescriptionPointers + 1]
	ld h, a
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [wNewsScreenPointer]
	ld l, a
	ld a, [wNewsScreenPointer + 1]
	ld h, a
	add hl, de
	push hl
	pop de
	ld a, [wNewsDescriptionCoord]
	ld l, a
	ld a, [wNewsDescriptionCoord + 1]
	ld h, a
	bccoord 0, 0
	add hl, bc
	call PlaceString
	ret

PokemonNews_ClearTextBox:
; Clear a rows of bc tiles at hl.
.asm_17e600
	push af
	push hl
	push bc
	ld a, ' '
	call ByteFill
	pop bc
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop af
	dec a
	jr nz, .asm_17e600
	ret

PokemonNews_DrawBox:
	push hl
	hlcoord 0, 0
	ld bc, SCREEN_WIDTH
	ld a, [de]
	inc de
	push af
	ld a, [de]
	inc de
	and a
.asm_17e620
	jr z, .asm_17e626
	add hl, bc
	dec a
	jr .asm_17e620

.asm_17e626
	pop af
	ld c, a
	ld b, 0
	add hl, bc
	push hl
	ld a, [wNewsBoxTile]
	ld [hli], a
	ld a, [de]
	inc de
	dec a
	dec a
	jr z, .asm_17e63f
	ld c, a
	ld a, [wNewsBoxTile]
	inc a
.asm_17e63b
	ld [hli], a
	dec c
	jr nz, .asm_17e63b

.asm_17e63f
	ld a, [wNewsBoxTile]
	add $2
	ld [hl], a
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	ld a, [de]
	dec de
	dec a
	dec a
	jr z, .asm_17e674
	ld b, a
.asm_17e651
	push hl
	ld a, [wNewsBoxTile]
	add $3
	ld [hli], a
	ld a, [de]
	dec a
	dec a
	jr z, .asm_17e664
	ld c, a
	ld a, ' '
.asm_17e660
	ld [hli], a
	dec c
	jr nz, .asm_17e660

.asm_17e664
	ld a, [wNewsBoxTile]
	add $4
	ld [hl], a
	pop hl
	push bc
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop bc
	dec b
	jr nz, .asm_17e651

.asm_17e674
	ld a, [wNewsBoxTile]
	add $5
	ld [hli], a
	ld a, [de]
	dec a
	dec a
	jr z, .asm_17e689
	ld c, a
	ld a, [wNewsBoxTile]
	add $6
.asm_17e685
	ld [hli], a
	dec c
	jr nz, .asm_17e685

.asm_17e689
	ld a, [wNewsBoxTile]
	add $7
	ld [hl], a
	pop hl
	ret

PokemonNews_ApplyBoxAttributes:
	push hl
	ld hl, NULL
	ld bc, SCREEN_WIDTH
	ld a, [de]
	inc de
	push af
	ld a, [de]
	inc de
	inc de
	and a
.asm_17e69f
	jr z, .asm_17e6a5
	add hl, bc
	dec a
	jr .asm_17e69f

.asm_17e6a5
	pop af
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	dec de
.asm_17e6ac
	push af
	push hl
	ld a, [de]
.asm_17e6af
	push af
	push hl
	push hl
	bccoord 0, 0
	add hl, bc
	ld a, [hl]
	cp ' '
	jr z, .asm_17e6c2
	ld a, [wNewsBoxAttributes]
	add $8
	jr .asm_17e6c7

.asm_17e6c2
	ld a, [wNewsBoxAttributes]
	jr .asm_17e6c7

.asm_17e6c7
	pop hl
	bccoord 0, 0, wAttrmap
	add hl, bc
	ld [hl], a
	pop hl
	inc hl
	pop af
	dec a
	jr nz, .asm_17e6af
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	pop af
	dec a
	jr nz, .asm_17e6ac
	pop hl
	ret

PokemonNews_ApplyPicturePalette:
	push af
	ld a, [wc708]
	ld l, a
	ld a, [wc709]
	ld h, a
	decoord 0, 0, wAttrmap
	add hl, de
	pop af
	ld b, $7
.asm_17e6ee
	push hl
	ld c, $7
.asm_17e6f1
	ld [hli], a
	dec c
	jr nz, .asm_17e6f1
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, .asm_17e6ee
	ret

PokemonNewsGFX:
INCBIN "gfx/mobile/pokemon_news.2bpp"

PostalMarkGFX:
INCBIN "gfx/font/postal_mark.2bpp"

PokemonNewsTileAttrmap:
INCBIN "gfx/mobile/pokemon_news.bin"

PokemonNewsPalettes:
INCLUDE "gfx/mobile/pokemon_news.pal"

PokemonNews_PlaceText::
	ld a, BANK(sPokemonNews)
	call OpenSRAM
	inc de
.loop
	call PokemonNews_RunTextCommand
	jr c, .finished
	jr .loop

.finished
	call CloseSRAM
	ret

PokemonNews_RunTextCommand:
	ld a, [de]
	inc de
	cp '@'
	jr z, .finished
	cp NUM_NEWS_TEXT_COMMANDS + 1
	jr nc, .finished
	dec a
	push de
	ld e, a
	ld d, 0
	ld hl, NewsTextPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.finished
	scf
	ret

INCLUDE "data/mobile/news_text.asm"

NewsText_RankingNumber:
; dw entry offset; db size/flags, digits, advance, insert position, character.
	pop hl
	call PokemonNews_CheckRankingEntry
	jr c, .asm_17f09f
	ld de, 4
	add hl, de
	ld a, [hli]
	inc hl
	inc hl
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	cp '@'
	jr z, .asm_17f09d
	and a
	ret

.asm_17f09d
	scf
	ret

.asm_17f09f
	push bc
	ld de, wcd54
	ld bc, 7
	call CopyBytes
	pop bc
	push hl
	push bc
	call PokemonNews_GetRankingEntry
	pop bc
	ld a, [wcd54]
	ld e, a
	ld a, [wcd55]
	ld d, a
	add hl, de
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	push hl
	ld a, [wcd56]
	ld b, a
	ld a, [wcd57]
	ld c, a
	call MobilePrintNum
	ld a, l
	ld [wcd52], a
	ld a, h
	ld [wcd53], a
	ld a, [wcd59]
	and a
	jr z, .asm_17f0ee
	ld c, a
	ld a, [wcd57]
	inc a
	ld b, a
	ld e, l
	ld d, h
	dec de
.asm_17f0e0
	ld a, c
	cp b
	jr z, .asm_17f0ea
	ld a, [de]
	dec de
	ld [hld], a
	dec b
	jr .asm_17f0e0

.asm_17f0ea
	ld a, [wcd5a]
	ld [hl], a

.asm_17f0ee
	pop hl
	ld a, [wcd58]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

NewsText_RankingText:
; dw entry offset; db string length, advance.
	pop hl
	call PokemonNews_CheckRankingEntry
	jr c, .asm_17f114
	ld de, $3
	add hl, de
	ld a, [hli]
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	cp '@'
	jr z, .asm_17f112
	and a
	ret

.asm_17f112
	scf
	ret

.asm_17f114
	push bc
	ld de, wcd54
	ld bc, $4
	call CopyBytes
	pop bc
	push hl
	push bc
	call PokemonNews_GetRankingEntry
	ld a, [wcd54]
	ld e, a
	ld a, [wcd55]
	ld d, a
	add hl, de
	ld de, wc608
	ld a, [wcd56]
	ld c, a
	ld b, 0
	call CopyBytes
	ld a, '@'
	ld [de], a
	pop hl
	ld de, wc608
	call PlaceString
	ld a, c
	ld [wcd52], a
	ld a, b
	ld [wcd53], a
	ld a, [wcd57]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

NewsText_RankingMessage:
; dw entry offset of the Easy Chat message.
	pop hl
	call PokemonNews_CheckRankingEntry
	jr c, .asm_17f167
	inc hl
	inc hl
	ld e, l
	ld d, h
	ld a, [de]
	cp '@'
	jr z, .asm_17f165
	and a
	ret

.asm_17f165
	scf
	ret

.asm_17f167
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	pop bc
	push hl
	push bc
	call PokemonNews_GetRankingEntry
	add hl, de
	ld c, l
	ld b, h
	pop de
	farcall Function11c08f
	ld c, l
	ld b, h
	pop de
	and a
	ret

NewsText_RankingPrefecture:
; dw entry offset of the prefecture; db advance.
	pop hl
	call PokemonNews_CheckRankingEntry
	jr c, .asm_17f19d
	ld de, $2
	add hl, de
	ld a, [hli]
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	cp '@'
	jr z, .asm_17f19b
	and a
	ret

.asm_17f19b
	scf
	ret

.asm_17f19d
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [wcd54], a
	pop bc
	push hl
	push bc
	call PokemonNews_GetRankingEntry
	add hl, de
	ld a, [hl]
	ld c, a
	ld de, wc608
	farcall Function48c63
	pop hl
	ld de, wc608
	call PlaceString
	ld a, c
	ld [wcd52], a
	ld a, b
	ld [wcd53], a
	ld a, [wcd54]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

NewsText_RankingPokemon:
; dw entry offset of the species; db advance.
	pop hl
	call PokemonNews_CheckRankingEntry
	jr c, .asm_17f1ec
	ld de, $2
	add hl, de
	ld a, [hli]
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	cp '@'
	jr z, .asm_17f1ea
	and a
	ret

.asm_17f1ea
	scf
	ret

.asm_17f1ec
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [wcd54], a
	pop bc
	push hl
	push bc
	call PokemonNews_GetRankingEntry
	add hl, de
	ld a, [hl]
	ld a, BANK(wNamedObjectIndex)
	ldh [rWBK], a
	ld [wNamedObjectIndex], a
	call GetPokemonName
	pop hl
	call PlaceString
	ld a, c
	ld [wcd52], a
	ld a, b
	ld [wcd53], a
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	ld a, [wcd54]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

NewsText_RankingGender:
; dw entry offset of the gender; db advance.
	pop hl
	call PokemonNews_CheckRankingEntry
	jr c, .asm_17f23c
	ld de, $2
	add hl, de
	ld a, [hli]
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	cp '@'
	jr z, .asm_17f23a
	and a
	ret

.asm_17f23a
	scf
	ret

.asm_17f23c
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [wcd54], a
	pop bc
	push hl
	push bc
	call PokemonNews_GetRankingEntry
	add hl, de
	ld a, [hl]
	ld e, a
	ld d, 0
	ld hl, .Genders
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	pop hl
	call PlaceString
	ld a, c
	ld [wcd52], a
	ld a, b
	ld [wcd53], a
	ld a, [wcd54]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

.Genders: dw .Boy, .Girl
.Boy:     db "Boy@"
.Girl:    db "Girl@"

NewsText_RankingItem:
; dw entry offset of the item; db advance.
	pop hl
	call PokemonNews_CheckRankingEntry
	jr c, .asm_17f297
	ld de, $2
	add hl, de
	ld a, [hli]
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	cp '@'
	jr z, .asm_17f295
	and a
	ret

.asm_17f295
	scf
	ret

.asm_17f297
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld [wcd54], a
	pop bc
	push hl
	push bc
	call PokemonNews_GetRankingEntry
	add hl, de
	ld a, [hl]
	ld a, $1
	ldh [rWBK], a
	ld [wNamedObjectIndex], a
	call GetItemName
	pop hl
	call PlaceString
	ld a, c
	ld [wcd52], a
	ld a, b
	ld [wcd53], a
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	ld a, [wcd54]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

NewsText_RankingIndicator:
; db digits, advance. Print the selected row number, starting at 1.
	pop hl
	push bc
	ld a, [hli]
	ld [wcd54], a
	ld a, [hli]
	ld [wcd55], a
	ld a, [wNewsMenuCursor]
	inc a
	ld [wcd56], a
	pop bc
	push hl
	ld l, c
	ld h, b
	push hl
	ld de, wcd56
	ld b, $1
	ld a, [wcd54]
	ld c, a
	call MobilePrintNum
	ld a, l
	ld [wcd52], a
	ld a, h
	ld [wcd53], a
	pop hl
	ld a, [wcd55]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

NewsText_PlayerName:
; db advance.
	pop hl
	push bc
	ld a, [hli]
	ld [wcd54], a
	pop bc
	push hl
	push bc
	ld a, $1
	ldh [rWBK], a
	ld hl, wPlayerName
	ld de, wc608
	ld bc, NAME_LENGTH_JAPANESE
	call CopyBytes
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	pop hl
	ld de, wc608
	call PlaceString
	ld a, c
	ld [wcd52], a
	ld a, b
	ld [wcd53], a
	ld a, [wcd54]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

NewsText_PlayerPrefecture:
; db advance; bit 7 selects the backed-up prefecture.
	pop hl
	push bc
	ld a, [hli]
	ld [wcd55], a
	and $f
	ld [wcd54], a
	pop bc
	push hl
	ld l, c
	ld h, b
	push hl
	ld a, [wcd55]
	bit 7, a
	jr nz, .asm_17f355
	ld a, BANK(sCrystalData)
	call OpenSRAM
	ld a, [sCrystalData + 2]
	jr .asm_17f35d

.asm_17f355
	ld a, BANK(sNewsPlayerPrefecture)
	call OpenSRAM
	ld a, [sNewsPlayerPrefecture]

.asm_17f35d
	ld c, a
	call CloseSRAM
	ld de, wc608
	farcall Function48c63
	pop hl
	ld de, wc608
	call PlaceString
	ld a, c
	ld [wcd52], a
	ld a, b
	ld [wcd53], a
	ld a, [wcd54]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

NewsText_PlayerPostalCode:
; db advance; bit 7 selects the backed-up postal code.
	pop hl
	push bc
	ld a, [hli]
	ld [wcd55], a
	and $f
	ld [wcd54], a
	pop bc
	push hl
	push bc
	ld l, c
	ld h, b
	ld a, [wcd55]
	bit 7, a
	jr nz, .asm_17f3a3
	ld a, BANK(sCrystalData)
	call OpenSRAM
	ld de, sCrystalData + 3
	jr .asm_17f3ab

.asm_17f3a3
	ld a, BANK(sNewsPlayerPostalCode)
	call OpenSRAM
	ld de, sNewsPlayerPostalCode

.asm_17f3ab
	ld a, PRINTNUM_LEADINGZEROS | 2
	ld b, a
	ld a, 3
	ld c, a
	call PrintNum
	call CloseSRAM
	ld a, l
	ld [wcd52], a
	ld a, h
	ld [wcd53], a
	pop hl
	ld a, [wcd54]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

NewsText_PlayerMessage:
; No operands. Print the player's introductory Easy Chat message.
	push bc
	ld hl, wNewsJoypadScripts + 4
	ld de, wc708
	ld bc, 12
	call CopyBytes
	pop de
	ld c, $0
	farcall Function11c075
	push hl
	ld hl, wc708
	ld de, wNewsJoypadScripts + 4
	ld bc, 12
	call CopyBytes
	pop bc
	pop de
	and a
	ret

NewsText_Switch:
; db count; dw selector address; dw screen-relative string offsets...
; Ends this run of news text commands without requiring an @ terminator.
	pop hl
	push hl
	ld a, [hli]
	push af
	push bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, wNewsScreenBuffer
	add hl, de
	ld e, l
	ld d, h
	pop hl
	call PlaceString
	pop af
	ld e, a
	ld d, 0
	pop hl
	add hl, de
	add hl, de
	inc hl
	inc hl
	inc hl
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	scf
	ret

NewsText_NextRow:
; db column. Continue on the next tilemap row at this column.
	pop hl
	ld a, [hli]
	push hl
	push af
	ld l, c
	ld h, b
	ld bc, -wTilemap + $10000
	add hl, bc
	ld de, -SCREEN_WIDTH
	ld c, $1
.asm_17f42c
	ld a, h
	and a
	jr nz, .asm_17f435
	ld a, l
	cp SCREEN_WIDTH
	jr c, .asm_17f439

.asm_17f435
	add hl, de
	inc c
	jr .asm_17f42c

.asm_17f439
	hlcoord 0, 0
	ld de, SCREEN_WIDTH
	ld a, c
.asm_17f440
	and a
	jr z, .asm_17f447
	add hl, de
	dec a
	jr .asm_17f440

.asm_17f447
	pop af
	ld e, a
	ld d, 0
	add hl, de
	pop de
	and a
	ret

NewsText_Number:
; db bank; dw address; db size/flags, digits, advance, insert position, character.
	pop hl
	call PokemonNews_CheckRankingEntry
	jr c, .asm_17f46d
	ld de, $5
	add hl, de
	ld a, [hli]
	inc hl
	inc hl
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [de]
	cp '@'
	jr z, .asm_17f46b
	and a
	ret

.asm_17f46b
	scf
	ret

.asm_17f46d
	push bc
	ld de, wcd54
	ld bc, $8
	call CopyBytes
	pop bc
	push hl
	push bc
	ld a, [wcd56]
	cp $c0
	jr c, .asm_17f488
	ld a, [wcd54]
	ldh [rWBK], a
	jr .asm_17f48e

.asm_17f488
	ld a, [wcd54]
	call OpenSRAM

.asm_17f48e
	ld a, [wcd55]
	ld l, a
	ld a, [wcd56]
	ld h, a
	ld de, wc608
	ld a, [wcd57]
	ld c, a
	ld b, 0
	call CopyBytes
	ld a, [wcd56]
	cp $c0
	jr c, .asm_17f4af
	ld a, BANK(wNewsScreenBuffer)
	ldh [rWBK], a
	jr .asm_17f4b7

.asm_17f4af
	call CloseSRAM
	ld a, BANK(sPokemonNews)
	call OpenSRAM

.asm_17f4b7
	ld de, wc608
	pop hl
	push hl
	ld a, [wcd57]
	ld b, a
	ld a, [wcd58]
	ld c, a
	call MobilePrintNum
	ld a, l
	ld [wcd52], a
	ld a, h
	ld [wcd53], a
	ld a, [wcd5a]
	and a
	jr z, .asm_17f4ec
	ld c, a
	ld a, [wcd58]
	inc a
	ld b, a
	ld e, l
	ld d, h
	dec de
.asm_17f4de
	ld a, c
	cp b
	jr z, .asm_17f4e8
	ld a, [de]
	dec de
	ld [hld], a
	dec b
	jr .asm_17f4de

.asm_17f4e8
	ld a, [wcd5b]
	ld [hl], a

.asm_17f4ec
	pop hl
	ld a, [wcd59]
	call PokemonNews_AdvanceTextPointer
	pop de
	and a
	ret

PokemonNews_GetRankingEntry:
	ld a, [wNewsRankingEntriesPointer]
	ld l, a
	ld a, [wNewsRankingEntriesPointer + 1]
	ld h, a
	ld a, [wNewsRankingEntrySize]
	ld c, a
	ld a, [wNewsRankingEntrySize + 1]
	ld b, a
	ld a, [wNewsMenuCursor]
.asm_17f509
	and a
	ret z
	dec a
	add hl, bc
	jr .asm_17f509

PokemonNews_AdvanceTextPointer:
	and a
	jr z, .asm_17f519
	ld c, a
	ld b, 0
	add hl, bc
	ld c, l
	ld b, h
	ret

.asm_17f519
	ld a, [wcd52]
	ld c, a
	ld l, a
	ld a, [wcd53]
	ld b, a
	ld h, a
	ret

PokemonNews_CheckRankingEntry:
; Carry if the selected row has ranking data, or is the final menu item.
	push hl
	push bc
	push de
	ld a, [wNewsMenuItems]
	dec a
	ld b, a
	ld a, [wNewsMenuCursor]
	cp b
	jr z, .asm_17f53a
	ld hl, wNewsRankingEntries
	cp [hl]
.asm_17f536
	pop de
	pop bc
	pop hl
	ret

.asm_17f53a
	scf
	jr .asm_17f536
