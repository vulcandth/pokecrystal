Function17c000:
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

Function17d0f3:
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
	farcall Function17d1f1
	ld a, $1
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
	jr z, .asm_17d180
	ld a, $1
	ld [de], a

.asm_17d180
	call CloseSubmenu
	call RestartMapMusic
	ret

Mobile_CopyDefaultOTName:
	ld hl, Mobile5F_PlayersName
	ld de, wMobileMonOT
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ret

Mobile5F_PlayersName:
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
	ld hl, Mobile5F_PlayersName
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

Function17d1f1:
	ld a, [wCurPartySpecies]
	dec a
	call SetSeenAndCaughtMon

	ld a, [wCurPartySpecies]
	cp UNOWN
	jr nz, .asm_17d223

	ld hl, wPartyMon1DVs
	ld a, [wPartyCount]
	dec a
	ld bc, PARTYMON_STRUCT_LENGTH
	call AddNTimes
	predef GetUnownLetter
	callfar UpdateUnownDex
	ld a, [wFirstUnownSeen]
	and a
	jr nz, .asm_17d223

	ld a, [wUnownLetter]
	ld [wFirstUnownSeen], a

.asm_17d223
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Parameter: [wScriptVar] = 0..1
;
; if [wScriptVar] == FALSE
;    Show japanese menu options
;    - News - News - ??? - Cancel
; if [wScriptVar] == TRUE
;    Show BattleTower-Menu with 3 options in english language
;    - Challenge - Explanation - Cancel
Menu_ChallengeExplanationCancel:
	ld a, [wScriptVar]
	and a
	jr nz, .English
	ld a, $4
	ld [wScriptVar], a
	ld hl, PokemonNewsMenuHeader ; Japanese Menu, where you can choose 'News' as an option
	jr .Load_Interpret

.English:
	ld a, $4
	ld [wScriptVar], a
	ld hl, MenuHeader_ChallengeExplanationCancel ; English Menu

.Load_Interpret:
	call LoadMenuHeader
	call Function17d246
	call CloseWindow
	ret

Function17d246:
	call VerticalMenu
	jr c, .Exit
	ld a, [wScriptVar]
	cp $5
	jr nz, .UsewMenuCursorY
	ld a, [wMenuCursorY]
	cp $3
	ret z
	jr c, .UsewMenuCursorY
	dec a
	jr .LoadToScriptVar

.UsewMenuCursorY:
	ld a, [wMenuCursorY]

.LoadToScriptVar:
	ld [wScriptVar], a
	ret

.Exit:
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

BattleTowerMobileError:
	call FadeToMenu
	xor a
	ld [wc303], a
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a

	call DisplayMobileError

	pop af
	ldh [rWBK], a
	call ExitAllMenus
	ret

DisplayMobileError:
.loop
	call JoyTextDelay
	call .RunJumptable
	ld a, [wc303]
	bit JUMPTABLE_EXIT_F, a
	jr nz, .quit
	farcall HDMATransferAttrmapAndTilemapToWRAMBank3
	jr .loop

.quit
	call .deinit
	ret

.deinit
	ld a, [wMobileErrorCodeBuffer]
	cp $22
	jr z, .asm_17f597
	cp $31
	jr z, .asm_17f58a
	cp $33
	ret nz
	ld a, [wMobileErrorCodeBuffer + 1]
	cp $1
	ret nz
	ld a, [wMobileErrorCodeBuffer + 2]
	cp $2
	ret nz
	jr .asm_17f5a1

.asm_17f58a
	ld a, [wMobileErrorCodeBuffer + 1]
	cp $3
	ret nz
	ld a, [wMobileErrorCodeBuffer + 2]
	and a
	ret nz
	jr .asm_17f5a1

.asm_17f597
	ld a, [wMobileErrorCodeBuffer + 1]
	and a
	ret nz
	ld a, [wMobileErrorCodeBuffer + 2]
	and a
	ret nz

.asm_17f5a1
	ld a, BANK(sMobileLoginPassword)
	call OpenSRAM
	xor a
	ld [sMobileLoginPassword], a
	call CloseSRAM
	ret

.RunJumptable:
	jumptable .Jumptable, wc303

.Jumptable:
	dw Function17f5c3
	dw Function17ff23
	dw Function17f5d2

Function17f5c3:
	call Function17f5e4
	farcall FinishExitMenu
	ld a, $1
	ld [wc303], a
	ret

Function17f5d2:
	call Function17f5e4
	farcall HDMATransferAttrmapAndTilemapToWRAMBank3
	call SetDefaultBGPAndOBP
	ld a, $1
	ld [wc303], a
	ret

Function17f5e4:
	ld a, $8
	ld [wMusicFade], a
	ld de, MUSIC_NONE
	ld a, e
	ld [wMusicFadeID], a
	ld a, d
	ld [wMusicFadeID + 1], a
	ld a, ' '
	hlcoord 0, 0
	ld bc, SCREEN_AREA
	call ByteFill
	ld a, $6
	hlcoord 0, 0, wAttrmap
	ld bc, SCREEN_AREA
	call ByteFill
	hlcoord 2, 1
	ld b, $1
	ld c, $e
	call Function3eea
	hlcoord 1, 4
	ld b, $c
	ld c, $10
	call Function3eea
	hlcoord 3, 2
	ld de, MobileCommunicationErrorText
	call PlaceString
	call Function17ff3c
	jr nc, .asm_17f632
	hlcoord 11, 2
	call Function17f6b7

.asm_17f632
	ld a, [wMobileErrorCodeBuffer]
	cp $d0
	jr nc, .asm_17f684
	cp $10
	jr c, .asm_17f679
	sub $10
	cp $24
	jr nc, .asm_17f679
	ld e, a
	ld d, 0
	ld hl, MobileErrorCodeTable
	add hl, de
	add hl, de
	ld a, [wMobileErrorCodeBuffer + 1]
	ld e, a
	ld a, [wMobileErrorCodeBuffer + 2]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld h, a
	ld l, c
	ld a, [hli]
	and a
	jr z, .asm_17f679
	ld c, a
.asm_17f65d
	ld a, [hli]
	ld b, a
	ld a, [hli]
	cp $ff
	jr nz, .asm_17f667
	cp b
	jr z, .asm_17f66e

.asm_17f667
	xor d
	jr nz, .asm_17f674
	ld a, b
	xor e
	jr nz, .asm_17f674

.asm_17f66e
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	jr .asm_17f67d

.asm_17f674
	inc hl
	inc hl
	dec c
	jr nz, .asm_17f65d

.asm_17f679
	ld a, $d9
	jr .asm_17f684

.asm_17f67d
	hlcoord 2, 6
	call PlaceString
	ret

.asm_17f684
	sub $d0
	ld e, a
	ld d, 0
	ld hl, Table_17f699
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	hlcoord 2, 6
	call PlaceString
	ret

Table_17f699:
	dw MobileErrorCode_101_000_Text
	dw MobileErrorCode_101_001_Text
	dw MobileErrorCode_101_002_Text
	dw MobileErrorCode_101_003_Text
	dw MobileErrorCode_101_004_Text
	dw MobileErrorCode_101_005_Text
	dw MobileErrorCode_101_006_Text
	dw MobileErrorCode_101_007_Text
	dw MobileErrorCode_101_008_Text
	dw MobileErrorCode_101_009_Text
	dw MobileErrorCode_101_009_Text

Palette_17f6af: ; unreferenced
	RGB  5,  5, 16
	RGB  8, 19, 28
	RGB  0,  0,  0
	RGB 31, 31, 31

Function17f6b7:
	ld a, [wMobileErrorCodeBuffer]
	call .bcd_two_digits
	inc hl
	ld a, [wMobileErrorCodeBuffer + 2]
	and $f
	call .bcd_digit
	ld a, [wMobileErrorCodeBuffer + 1]
	call .bcd_two_digits
	ret

.bcd_two_digits
	ld c, a
	and $f0
	swap a
	call .bcd_digit
	ld a, c
	and $f

.bcd_digit
	add '0'
	ld [hli], a
	ret

MobileCommunicationErrorText:
	db "つうしんエラー　　　ー@"

String_17f6e8: ; unreferenced
	db   "みていぎ<NO>エラーです"
	next "プログラム<WO>"
	next "かくにん　してください"
	db   "@"

MobileErrorCodeTable:
	dw MobileErrorCodes_10
	dw MobileErrorCodes_11
	dw MobileErrorCodes_12
	dw MobileErrorCodes_13
	dw MobileErrorCodes_14
	dw MobileErrorCodes_15
	dw MobileErrorCodes_16
	dw MobileErrorCodes_17
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_21
	dw MobileErrorCodes_22
	dw MobileErrorCodes_23
	dw MobileErrorCodes_24
	dw MobileErrorCodes_25
	dw MobileErrorCodes_26
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_31
	dw MobileErrorCodes_32
	dw MobileErrorCodes_33

MobileErrorCodes_10: db 1
	dw $000, MobileErrorCode_10_000_Text

MobileErrorCodes_11: db 1
	dw $000, MobileErrorCode_11_000_Text

MobileErrorCodes_12: db 1
	dw $000, MobileErrorCode_12_000_Text

MobileErrorCodes_13: db 1
	dw $000, MobileErrorCode_13_000_Text

MobileErrorCodes_14: db 1
	dw $000, MobileErrorCode_14_000_Text

MobileErrorCodes_15: db 4
	dw $000, MobileErrorCode_15_000_Text
	dw $001, MobileErrorCode_15_001_Text
	dw $002, MobileErrorCode_15_002_Text
	dw $003, MobileErrorCode_15_003_Text

MobileErrorCodes_16: db 1
	dw $000, MobileErrorCode_CommuncationErrorText

MobileErrorCodes_17: db 1
	dw $000, MobileErrorCode_CommuncationErrorText

MobileErrorCodes_20: db 1
	dw $000, MobileErrorCode_CommuncationErrorText

MobileErrorCodes_21: db 1
	dw $000, MobileErrorCode_CommuncationErrorText

MobileErrorCodes_22: db 1
	dw $000, MobileErrorCode_22_000_Text

MobileErrorCodes_23: db 1
	dw $000, MobileErrorCode_23_000_Text

MobileErrorCodes_24: db 1
	dw $000, MobileErrorCode_ServerConnectionFailedText

MobileErrorCodes_25: db 1
	dw $000, MobileErrorCode_25_000_Text

MobileErrorCodes_26: db 1
	dw $000, MobileErrorCode_26_000_Text

MobileErrorCodes_30: db 17
	dw $000, MobileErrorCode_CommuncationErrorText
	dw $221, MobileErrorCode_ServerConnectionFailedText
	dw $421, MobileErrorCode_ServerConnectionFailedText
	dw $450, MobileErrorCode_30_450_Text
	dw $451, MobileErrorCode_ServerConnectionFailedText
	dw $452, MobileErrorCode_ServerConnectionFailedText
	dw $500, MobileErrorCode_CommuncationErrorText
	dw $501, MobileErrorCode_CommuncationErrorText
	dw $502, MobileErrorCode_CommuncationErrorText
	dw $503, MobileErrorCode_CommuncationErrorText
	dw $504, MobileErrorCode_CommuncationErrorText
	dw $550, MobileErrorCode_30_550_Text
	dw $551, MobileErrorCode_30_551_Text
	dw $552, MobileErrorCode_ServerConnectionFailedText
	dw $553, MobileErrorCode_30_553_Text
	dw $554, MobileErrorCode_ServerConnectionFailedText
	dw -1, MobileErrorCode_ServerConnectionFailedText

MobileErrorCodes_31: db 5
	dw $000, MobileErrorCode_CommuncationErrorText
	dw $002, MobileErrorCode_31_002_Text
	dw $003, MobileErrorCode_31_003_Text
	dw $004, MobileErrorCode_CommuncationErrorText
	dw -1, MobileErrorCode_ServerConnectionFailedText

MobileErrorCodes_32: db 17
	dw $000, MobileErrorCode_CommuncationErrorText
	dw $301, MobileErrorCode_CommuncationErrorText
	dw $302, MobileErrorCode_CommuncationErrorText
	dw $400, MobileErrorCode_CommuncationErrorText
	dw $401, MobileErrorCode_CommuncationErrorText
	dw $403, MobileErrorCode_32_403_Text
	dw $404, MobileErrorCode_32_404_Text
	dw $405, MobileErrorCode_CommuncationErrorText
	dw $406, MobileErrorCode_CommuncationErrorText
	dw $407, MobileErrorCode_CommuncationErrorText
	dw $408, MobileErrorCode_32_408_Text
	dw $500, MobileErrorCode_ServerErrorText
	dw $501, MobileErrorCode_CommuncationErrorText
	dw $502, MobileErrorCode_ServerErrorText
	dw $503, MobileErrorCode_32_503_Text
	dw $504, MobileErrorCode_ServerErrorText
	dw -1, MobileErrorCode_ServerErrorText

MobileErrorCodes_33: db 19
	dw $101, MobileErrorCode_33_101_Text
	dw $102, MobileErrorCode_33_102_Text
	dw $103, MobileErrorCode_33_103_Text
	dw $104, MobileErrorCode_33_104_Text
	dw $105, MobileErrorCode_33_105_Text
	dw $106, MobileErrorCode_33_106_Text
	dw $201, MobileErrorCode_33_201_Text
	dw $202, MobileErrorCode_CommuncationErrorText
	dw $203, MobileErrorCode_33_203_Text
	dw $204, MobileErrorCode_CommuncationErrorText
	dw $205, MobileErrorCode_ServerErrorText
	dw $206, MobileErrorCode_33_206_Text
	dw $299, MobileErrorCode_33_299_Text
	dw $301, MobileErrorCode_ServerErrorText
	dw $401, MobileErrorCode_ServerErrorText
	dw $402, MobileErrorCode_ServerErrorText
	dw $403, MobileErrorCode_ServerErrorText
	dw $404, MobileErrorCode_ServerErrorText
	dw -1, MobileErrorCode_ServerErrorText

MobileErrorCode_10_000_Text:
; The Mobile Adapter is not properly plugged in.
; Ensure you have taken a good look at and properly followed the instructions.
	db   "モバイルアダプタが　ただしく"
	next "さしこまれていません"
	next "とりあつかいせつめいしょを"
	next "ごらんのうえ　しっかりと"
	next "さしこんで　ください"
	db   "@"

MobileErrorCode_11_000_Text:
MobileErrorCode_13_000_Text:
; Could not connect because either the phone cannot make the call, or the telephone line is busy.
; Please wait for a while and call again.
	db   "でんわが　うまく　かけられないか"
	next "でんわかいせんが　こんでいるので"
	next "つうしん　できません"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_12_000_Text:
; As the telephone line is busy, the phone was not able to gather enough information (?)
; Please wait for a while and call again.
	db   "でんわかいせんが　こんでいるため"
	next "でんわが　かけられません"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_15_000_Text:
MobileErrorCode_15_001_Text:
MobileErrorCode_15_002_Text:
MobileErrorCode_15_003_Text:
; There is an error with the Mobile Adapter.
; Please wait for a little while before calling again.
; If the problem persists, please contact the Mobile Support Center.
	db   "モバイルアダプタの　エラーです"
	next "しばらく　まって"
	next "かけなおして　ください"
	next "なおらない　ときは"
	next "モバイルサポートセンターへ"
	next "おといあわせください"
	db   "@"

MobileErrorCode_CommuncationErrorText:
; Communication error.
; Please wait a moment, and then try again.
; If the issue persists, please contact the Mobile Support Center.
	db   "つうしんエラーです"
	next "しばらく　まって"
	next "かけなおして　ください"
	next "なおらない　ときは"
	next "モバイルサポートセンターへ"
	next "おといあわせください"
	db   "@"

MobileErrorCode_22_000_Text:
; There is a mistake either with the login password, or the login ID.
; Please confirm the password, wait for a while, and try again.
	db   "ログインパスワードか"
	next "ログイン　アイディーに"
	next "まちがいがあります"
	next "パスワードを　かくにんして"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_23_000_Text:
; The call was ended.
; Please see the instruction manual, wait a moment, and try again.
	db   "でんわが　きれました"
	next "とりあつかいせつめいしょを"
	next "ごらんのうえ"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_ServerErrorText:
; There was a communication error with the mobile center.
; Please wait a moment and then try again.
	db   "モバイルセンターの"
	next "つうしんエラーです"
	next "しばらくまって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_14_000_Text:
MobileErrorCode_25_000_Text:
; The Mobile Adapter's details have expired and the information is not correct.
; Please use the Mobile Trainer to repeat the initial registration (process).
	db   "モバイルアダプタに"
	next "とうろくされた　じょうほうが"
	next "ただしく　ありません"
	next "モバイルトレーナーで"
	next "しょきとうろくを　してください"
	db   "@"

MobileErrorCode_32_503_Text:
; Could not connect because the Mobile Center is busy.
; Please wait a moment and try again.
; For details, please see the instruction manual.
	db   "モバイルセンターが"
	next "こんでいて　つながりません"
	next "しばらくまって"
	next "かけなおして　ください"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_30_450_Text:
MobileErrorCode_30_550_Text:
MobileErrorCode_30_551_Text:
MobileErrorCode_30_553_Text:
; There is a mistake with the email address of the addressee.
; Please replace with a / the correct email address.
	db   "あてさき　メールアドレスに"
	next "まちがいがあります"
	next "ただしい　メールアドレスを"
	next "いれなおしてください"
	db   "@"

MobileErrorCode_31_002_Text:
; There is a mistake with the email address.
; Please see the instruction manual, and use the Mobile Trainer to repeat the initial registration (process).
	db   "メールアドレスに"
	next "まちがいが　あります"
	next "とりあつかいせつめいしょを"
	next "ごらんのうえ"
	next "モバイルトレーナーで"
	next "しょきとうろくを　してください"
	db   "@"

MobileErrorCode_31_003_Text:
MobileErrorCode_33_201_Text:
; There is either an error with the login password, or an error with the Mobile Center.
; Please confirm the password, wait a moment, and then try again.
	db   "ログインパスワードに"
	next "まちがいが　あるか"
	next "モバイルセンターの　エラーです"
	next "パスワードを　かくにんして"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_32_403_Text:
MobileErrorCode_32_404_Text:
; Cannot read data.
; Please wait a moment, and then try again.
; If the issue persists, please contact the Mobile Support Center.
	db   "データの　よみこみが　できません"
	next "しばらくまって"
	next "かけなおして　ください"
	next "なおらない　ときは"
	next "モバイルサポートセンターへ"
	next "おといあわせください"
	db   "@"

MobileErrorCode_26_000_Text:
MobileErrorCode_32_408_Text:
; Out of time.
; The call was ended.
; Please try again.
; For details, please see the instruction manual.
	db   "じかんぎれです"
	next "でんわが　きれました"
	next "でんわを　かけなおしてください"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_33_101_Text:
; The service cannot be used if payments for usage fees are late.
; For details, please see the instruction manual.
	db   "ごりよう　りょうきんの　"
	next "おしはらいが　おくれたばあいには"
	next "ごりようが　できなくなります"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_33_102_Text:
MobileErrorCode_33_299_Text:
; Your access to this service has been restricted. Service cannot be used.
; For details, please see the instruction manual.
	db   "おきゃくさまの　ごつごうにより"
	next "ごりようできません"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_ServerConnectionFailedText:
; The telephone line is busy. Due to this error, the Mobile Center cannot communicate.
; Please wait for a little while and call again.
	db   "でんわかいせんが　こんでいるか"
	next "モバイルセンターの　エラーで"
	next "つうしんが　できません"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_33_103_Text:
; Service cannot be used this month because usage fees have exceeded conditions.
; For details, please see the instruction manual.
	db   "ごりよう　りょうきんが"
	next "じょうげんを　こえているため"
	next "こんげつは　ごりようできません"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_33_106_Text:
; Cannot communicate because the Mobile Center is currently undergoing maintenance.
; Please wait a moment, then try again.
	db   "げんざい　モバイルセンターの"
	next "てんけんを　しているので"
	next "つうしんが　できません"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_33_104_Text:
MobileErrorCode_33_105_Text:
MobileErrorCode_33_203_Text:
MobileErrorCode_33_206_Text:
MobileErrorCode_101_004_Text:
; Cannot read data.
; For details, please see the instruction manual.
	db   "データの　よみこみが　できません"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_101_006_Text:
; Call ended because more than 3 minutes elapsed with no input.
	db   "３ぷん　いじょう　なにも"
	next "にゅうりょく　しなかったので"
	next "でんわが　きれました"
	db   "@"

MobileErrorCode_101_001_Text:
MobileErrorCode_101_002_Text:
; Could not connect properly.
; Please try again from the beginning (of the process).
	db   "つうしんが　うまく"
	next "できませんでした"
	next "もういちど　はじめから"
	next "やりなおしてください"
	db   "@"

MobileErrorCode_101_003_Text:
MobileErrorCode_101_008_Text:
MobileErrorCode_101_009_Text:
; Cannot read data.
; Please wait a moment, then try again.
; If the issue persists, please contact the Mobile Support Center.
	db   "データの　よみこみが　できません"
	next "しばらくまって"
	next "かけなおして　ください"
	next "なおらない　ときは"
	next "モバイルサポートセンターへ"
	next "おといあわせください"
	db   "@"

MobileErrorCode_101_007_Text:
; Call ended due to long waiting time.
	db   "まちじかんが　ながいので"
	next "でんわが　きれました"
	db   "@"

MobileErrorCode_101_005_Text:
; (Your adapter's) type differs from the other user’s Mobile Adapter.
; For details, please see the instruction manual.
	db   "あいての　モバイルアダプタと"
	next "タイプが　ちがいます"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

String_17fe9a: ; unreferenced
; Cannot send your save data because Pokémon News is being updated.
; Please send your save data after loading new Pokémon News.
	db   "ポケモンニュースが"
	next "あたらしくなっているので"
	next "レポートを　おくれません"
	next "あたらしい　ポケモンニュースの"
	next "よみこみを　さきに　してください"
	db   "@"

MobileErrorCode_101_000_Text:
; Either bad communication status, or the other user called was the incorrect user.
; Please confirm and try again.
	db   "つうしんの　じょうきょうが"
	next "よくないか　かけるあいてが"
	next "まちがっています"
	next "もういちど　かくにんをして"
	next "でんわを　かけなおして　ください"
	db   "@"

Function17ff23:
	ldh a, [hJoyPressed]
	and a
	ret z
	ld a, $8
	ld [wMusicFade], a
	ld a, [wMapMusic]
	ld [wMusicFadeID], a
	xor a
	ld [wMusicFadeID + 1], a
	ld hl, wc303
	set JUMPTABLE_EXIT_F, [hl]
	ret

Function17ff3c:
	nop
	ld a, [wMobileErrorCodeBuffer]
	cp $d0
	ret c
	hlcoord 10, 2
	ld de, String_17ff68
	call PlaceString
	ld a, [wMobileErrorCodeBuffer]
	push af
	sub $d0
	inc a
	ld [wMobileErrorCodeBuffer], a
	hlcoord 14, 2
	ld de, wMobileErrorCodeBuffer
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum
	pop af
	ld [wMobileErrorCodeBuffer], a
	and a
	ret

String_17ff68:
	db "１０１@"
