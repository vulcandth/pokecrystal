Mobile_LoadTradeCornerOfferBackground:
	call DisableLCD

	ld hl, vTiles2
	ld bc, $31 tiles
	xor a
	call ByteFill

	call LoadStandardFont
	call LoadFontsExtra

	ld hl, HaveWantMap
	decoord 0, 0
	bccoord 0, 0, wAttrmap

	ld a, SCREEN_HEIGHT
.y
	push af
	ld a, SCREEN_WIDTH

	push hl
.x
	push af
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	jr nz, .x
	pop hl

	push bc
	ld bc, TILEMAP_WIDTH * 2
	add hl, bc
	pop bc

	pop af
	dec a
	jr nz, .y

	ldh a, [rWBK]
	push af

	ld a, BANK(wBGPals1)
	ldh [rWBK], a

	ld hl, HaveWantPals
	ld de, wBGPals1
	ld bc, 16 palettes
	call CopyBytes

	pop af
	ldh [rWBK], a

	ld hl, MobileSelectGFX
	ld de, vTiles0 tile $30
	ld bc, $20 tiles
	call CopyBytes

	ld a, 1
	ldh [rVBK], a

	ld hl, HaveWantGFX
	ld de, vTiles5
	ld bc, $80 tiles
	call CopyBytes

	ld hl, HaveWantGFX + $80 tiles
	ld de, vTiles4
	ld bc, $10 tiles
	call CopyBytes

	xor a
	ldh [rVBK], a

	call EnableLCD
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ret

HaveWantGFX:
INCBIN "gfx/mobile/havewant.2bpp"

MobileSelectGFX:
INCBIN "gfx/mobile/select.2bpp"

HaveWantMap:
; Interleaved tile/palette map.
INCBIN "gfx/mobile/havewant_map.bin"

HaveWantPals:
; BG and OBJ palettes.
	RGB  0,  0,  0
	RGB 21, 21, 21
	RGB  0,  0,  0
	RGB  0,  0,  0

	RGB  0,  0,  0
	RGB  4, 17, 29
	RGB  6, 19, 31
	RGB 31, 31, 31

	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0

	RGB  0,  0,  0
	RGB  2, 13, 18
	RGB  6, 19, 31
	RGB 31, 31, 31

	RGB  0,  0,  0
	RGB 31,  5,  5
	RGB 29, 21, 21
	RGB 31, 31, 31

	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0

	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0

	RGB  0,  0,  0
	RGB  4, 17, 29
	RGB  6, 19, 31
	RGB  2, 15, 27

	RGB  0,  0,  0
	RGB 28, 19, 18
	RGB 25,  9,  0
	RGB  0,  0,  0

	RGB  0,  0,  0
	RGB 31, 27, 27
	RGB 31, 10,  4
	RGB 29,  0,  0

	RGB  0,  0,  0
	RGB 31, 31, 31
	RGB 26,  8, 23
	RGB 22,  0, 16

	RGB  0,  0,  0
	RGB 31, 31, 31
	RGB 20,  8, 31
	RGB 15,  1, 26

	RGB  0,  0,  0
	RGB 31, 31, 31
	RGB 17, 12, 31
	RGB 12,  6, 31

	RGB  0, 16,  0
	RGB 11, 11, 14
	RGB  5,  5,  7
	RGB 31, 31, 31

	RGB  0, 31,  0
	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0

	RGB 16, 31,  0
	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0

CheckStringForErrors:
; Valid character ranges:
; $0, $5 - $13, $19 - $1c, $26 - $34, $3a - $3e, $40 - $48, $60 - $ff
.loop
	ld a, [de]
	inc de
	and a ; "<NULL>"
	jr z, .NextChar
	cp FIRST_REGULAR_TEXT_CHAR
	jr nc, .NextChar
	cp '<NEXT>'
	jr z, .NextChar
	cp '@'
	jr z, .Done
	cp 'ガ'
	jr c, .Fail
	cp '<PLAY_G>'
	jr c, .NextChar
	cp '<JP_18>' + 1
	jr c, .Fail
	cp '<NI>'
	jr c, .NextChar
	cp '<NO>' + 1
	jr c, .Fail
	cp '<ROUTE>'
	jr c, .NextChar
	cp '<GREEN>' + 1
	jr c, .Fail
	cp '<ENEMY>'
	jr c, .NextChar
	cp '<ENEMY>' + 1
	jr c, .Fail
	cp '<MOM>'
	jr c, .NextChar

.Fail:
	scf
	ret

.NextChar:
	dec c
	jr nz, .loop

.Done:
	and a
	ret

CheckStringForErrors_IgnoreTerminator:
; Find control chars
.loop
	ld a, [de]
	inc de
	and a
	jr z, .next
	cp '<DEXEND>' + 1
	jr nc, .next
	cp '<NEXT>'
	jr z, .next
	cp '@'
	jr z, .next

	cp 'ガ'
	jr c, .end
	cp '<PLAY_G>'
	jr c, .next
	cp '<JP_18>' + 1
	jr c, .end
	cp '<NI>'
	jr c, .next
	cp '<NO>' + 1
	jr c, .end
	cp '<ROUTE>'
	jr c, .next
	cp '<GREEN>' + 1
	jr c, .end
	cp '<ENEMY>'
	jr c, .next
	cp '<ENEMY>' + 1
	jr c, .end
	cp '<MOM>'
	jr c, .next

.end
	scf
	ret

.next
	dec c
	jr nz, .loop
	and a
	ret

Mobile_CompleteTrade:
	ld a, [wMobileMonSpecies]
	ld [wOTTrademonSpecies], a
	ld [wCurPartySpecies], a
	ld a, [wcd81]
	ld [wc74e], a
	ld hl, wMobileMonOT
	ld de, wOTTrademonOTName
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ld a, '@'
	ld [de], a
	ld a, [wMobileMonID]
	ld [wOTTrademonID], a
	ld a, [wMobileMonID + 1]
	ld [wOTTrademonID + 1], a
	ld hl, wMobileMonDVs
	ld a, [hli]
	ld [wOTTrademonDVs], a
	ld a, [hl]
	ld [wOTTrademonDVs + 1], a
	ld bc, wMobileMonSpecies
	farcall GetCaughtGender
	ld a, c
	ld [wOTTrademonCaughtData], a
	call SpeechTextbox
	call FadeToMenu
	farcall Function10804d
	farcall Mobile_RegisterTradeMonInPokedex
	ld a, TRUE
	ld [wForceEvolution], a
	ld a, LINK_TRADECENTER
	ld [wLinkMode], a
	farcall EvolvePokemon
	xor a
	ld [wLinkMode], a
	farcall SaveAfterLinkTrade
	ld a, BANK(s5_a800)
	call OpenSRAM
	ld a, BANK(s5_a800)
	ld [s5_a800], a
	call CloseSRAM
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetMapSceneID
	ld a, d
	or e
	jr z, .return_to_map
	ld a, $1
	ld [de], a

.return_to_map
	call CloseSubmenu
	call RestartMapMusic
	ret

Mobile_CopyDefaultOTName:
	ld hl, MobileDefaultOTName
	ld de, wMobileMonOT
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ret

MobileDefaultOTName:
	dname "クりス", NAME_LENGTH_JAPANESE - 1

Mobile_CopyDefaultNickname:
	ld hl, .DefaultNickname
	ld de, wMobileMonNick
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ret

.DefaultNickname:
	dname "？？？？？", NAME_LENGTH_JAPANESE - 1

Mobile_CopyDefaultMail:
	ld a, '@'
	ld hl, wMobileMonMail
	ld bc, MAIL_MSG_LENGTH + 1
	call ByteFill
	ld hl, .DefaultMessage
	ld de, wMobileMonMail
	ld bc, .DefaultMessageEnd - .DefaultMessage
	call CopyBytes
	ret

.DefaultMessage:
	db "こんにちは@"
.DefaultMessageEnd:

Mobile_CopyDefaultMailAuthor:
	ld a, '@'
	ld de, wMobileMonMailAuthor
	ld bc, NAME_LENGTH_JAPANESE - 1
	call ByteFill
	ld hl, MobileDefaultOTName
	ld de, wMobileMonMailAuthor
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ret

CheckStringContainsLessThanBNextCharacters:
.loop
	ld a, [de]
	inc de
	cp '<NEXT>'
	jr nz, .next_char
	dec b
	jr z, .done

.next_char
	dec c
	jr nz, .loop
	and a
	ret

.done
	scf
	ret

Mobile_RegisterTradeMonInPokedex:
	ld a, [wCurPartySpecies]
	dec a
	call SetSeenAndCaughtMon

	ld a, [wCurPartySpecies]
	cp UNOWN
	jr nz, .done

	ld hl, wPartyMon1DVs
	ld a, [wPartyCount]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	predef GetUnownLetter
	callfar UpdateUnownDex
	ld a, [wFirstUnownSeen]
	and a
	jr nz, .done

	ld a, [wUnownLetter]
	ld [wFirstUnownSeen], a

.done
	ret

Menu_ChallengeExplanationCancel:
; wScriptVar = FALSE: Japanese Download News / View News / Explanation / Cancel.
; Otherwise: English Challenge / Explanation / Cancel.
; Return the one-based menu choice in wScriptVar; B returns 4.
	ld a, [wScriptVar]
	and a
	jr nz, .battle_tower_menu
	ld a, $4
	ld [wScriptVar], a
	ld hl, PokemonNewsMenuHeader
	jr .load_menu

.battle_tower_menu:
	ld a, $4
	ld [wScriptVar], a
	ld hl, MenuHeader_ChallengeExplanationCancel

.load_menu:
	call LoadMenuHeader
	call Mobile_GetServiceMenuChoice
	call CloseWindow
	ret

Mobile_GetServiceMenuChoice:
	call VerticalMenu
	jr c, .cancel
	ld a, [wScriptVar]
	cp $5
	jr nz, .use_cursor
	ld a, [wMenuCursorY]
	cp $3
	ret z
	jr c, .use_cursor
	dec a
	jr .store_choice

.use_cursor:
	ld a, [wMenuCursorY]

.store_choice:
	ld [wScriptVar], a
	ret

.cancel:
	ld a, $4
	ld [wScriptVar], a
	ret

PokemonNewsMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 9
	dw PokemonNewsMenuData
	db 1 ; default option

PokemonNewsMenuData:
	db STATICMENU_CURSOR | STATICMENU_WRAP ; flags
	db 4
	db "ニュース<WO>よみこむ@"
	db "ニュース<WO>みる@"
	db "せつめい@"
	db "やめる@"

MenuHeader_ChallengeExplanationCancel:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, 14, 7
	dw MenuData_ChallengeExplanationCancel
	db 1 ; default option

MenuData_ChallengeExplanationCancel:
	db STATICMENU_CURSOR | STATICMENU_WRAP ; flags
	db 3
	db "Challenge@"
	db "Explanation@"
	db "Cancel@"

INCLUDE "mobile/news/engine.asm"

INCLUDE "mobile/error.asm"
