GiveOddEgg:
	farcall _GiveOddEgg
	ret

INCLUDE "mobile/password.asm"

; everything from here to the end of the bank is related to the
; Mobile Stadium option from the continue/newgame menu.
; Needs better function names
MobileStudium:
	ldh a, [hInMenu]
	push af
	ld a, $1
	ldh [hInMenu], a
	call Function117a8d
	pop af
	ldh [hInMenu], a
	ret

Function117a8d:
	call Function117a94
	call Function117acd
	ret

Function117a94:
	xor a
	ld [wJumptableIndex], a
	ld [wcf64], a
	ld [wcf65], a
	ld [wcf66], a
	call ClearBGPalettes
	call ClearSprites
	farcall Function172e78
	farcall HDMATransferAttrmapAndTilemapToWRAMBank3
	ret

Function117ab4:
	call ClearBGPalettes
	call ClearSprites
	farcall Function172e78
	farcall Function172eb9
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ret

Function117acd:
	call JoyTextDelay
	ld a, [wJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr nz, .asm_117ae2
	call Function117ae9
	farcall HDMATransferAttrmapAndTilemapToWRAMBank3
	jr Function117acd

.asm_117ae2
	call ClearBGPalettes
	call ClearSprites
	ret

Function117ae9:
	jumptable .Jumptable, wJumptableIndex

.Jumptable:
	dw Function117b06
	dw Function117b14
	dw Function117b28
	dw Function117b31
	dw Function117b4f
	dw Function117bb6
	dw Function117c4a

Function117b06:
	farcall Function172eb9
	ld a, $10
	ld [wcf64], a
	jp MobileStudium_JumptableIncrement

Function117b14:
	ld hl, wcf64
	dec [hl]
	ret nz
	ld hl, MenuHeader_117cbc
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	jp MobileStudium_JumptableIncrement

Function117b28:
	ld hl, MobileStadiumEntryText
	call PrintText
	jp MobileStudium_JumptableIncrement

Function117b31:
	ld hl, MenuHeader_117cc4
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	hlcoord 16, 8
	ld de, YesNo117ccc
	call PlaceString
	hlcoord 15, 8
	ld a, '▶'
	ld [hl], a
	jp MobileStudium_JumptableIncrement

Function117b4f:
	ldh a, [hJoyPressed]
	cp PAD_B
	jr z, .b_button
	cp PAD_A
	jr z, .a_button
	cp PAD_DOWN
	jr z, .d_down
	cp PAD_UP
	ret nz
	ld a, [wcf64]
	and a
	ret z
	dec a
	ld [wcf64], a
	hlcoord 15, 8
	ld a, '▶'
	ld [hl], a
	hlcoord 15, 10
	ld a, ' '
	ld [hl], a
	ret

.d_down
	ld a, [wcf64]
	and a
	ret nz
	inc a
	ld [wcf64], a
	hlcoord 15, 8
	ld a, ' '
	ld [hl], a
	hlcoord 15, 10
	ld a, '▶'
	ld [hl], a
	ret

.a_button
	call PlayClickSFX
	ld a, [wcf64]
	and a
	jr nz, .b_button
	call ExitMenu
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	jp MobileStudium_JumptableIncrement

.b_button
	call ExitMenu
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, JUMPTABLE_EXIT
	ld [wJumptableIndex], a
	ret

Function117bb6:
	call Function117c89
	ld a, $1
	ldh [hBGMapMode], a
	farcall Function118284
	call ClearSprites
	ld a, [wMobileErrorCodeBuffer]
	and a
	jr z, .asm_117be7
	cp $a
	jr z, .asm_117be1
.asm_117bd0
	ld a, MOBILE_ERROR_INIT_NO_FADE
	ld [wMobileErrorJumptableIndex], a
	farcall DisplayMobileError
	ld a, JUMPTABLE_EXIT
	ld [wJumptableIndex], a
	ret

.asm_117be1
	ld a, JUMPTABLE_EXIT
	ld [wJumptableIndex], a
	ret

.asm_117be7
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
	ld a, [wMobileDownloadFlags]
	and MOBILE_DOWNLOAD_OVERFLOW
	jr nz, .asm_117c16
	ld a, [w3_d000]
	cp $fe
	jr nz, .asm_117c16
	ld a, [w3_d001]
	cp $f
	jr nz, .asm_117c16
	ld hl, w3_dfec
	ld de, wcd69
	ld c, $10
.asm_117c0b
	ld a, [de]
	inc de
	cp [hl]
	jr nz, .asm_117c16
	inc hl
	dec c
	jr nz, .asm_117c0b
	jr .asm_117c20

.asm_117c16
	pop af
	ldh [rWBK], a
	ld a, $d3
	ld [wMobileErrorCodeBuffer], a
	jr .asm_117bd0

.asm_117c20
	pop af
	ldh [rWBK], a
	farcall Function172eb9
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
	ld a, $7
	call OpenSRAM
	ld hl, w3_d002
	ld de, $b000
	ld bc, $1000
	call CopyBytes
	call CloseSRAM
	pop af
	ldh [rWBK], a
	jp MobileStudium_JumptableIncrement

Function117c4a:
	ld hl, MenuHeader_117cbc
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld hl, MobileStadiumSuccessText
	call PrintText
	ldh a, [rWBK]
	push af
	ld a, $5
	ldh [rWBK], a
	ld hl, wBGPals1
	ld de, 1 palettes
	ld c, 8
.loop
	push hl
	ld a, LOW(PALRGB_WHITE)
	ld [hli], a
	ld a, HIGH(PALRGB_WHITE)
	ld [hl], a
	pop hl
	add hl, de
	dec c
	jr nz, .loop
	call RotateThreePalettesRight
	pop af
	ldh [rWBK], a
	ld a, JUMPTABLE_EXIT
	ld [wJumptableIndex], a
	ret

Function117c89:
	ld a, $7
	call OpenSRAM
	ld l, $0
	ld h, l
	ld de, $b000
	ld bc, $0ffc
.asm_117c97
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
	jr nz, .asm_117c97
	ld a, l
	ld [wcd83], a
	ld a, h
	ld [wcd84], a
	ld hl, $bfea
	ld de, wcd69
	ld bc, $10
	call CopyBytes
	call CloseSRAM
	ret

MenuHeader_117cbc:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 12, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	dw NULL
	db 0 ; default option

MenuHeader_117cc4:
	db MENU_BACKUP_TILES ; flags
	menu_coords 14, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 0 ; default item

YesNo117ccc:
	db   "はい"
	next "いいえ@"

MobileStadiumEntryText:
	text_far _MobileStadiumEntryText
	text_end

MobileStadiumSuccessText:
	text_far _MobileStadiumSuccessText
	text_end

MobileStudium_JumptableIncrement:
	ld hl, wJumptableIndex
	inc [hl]
	ret
