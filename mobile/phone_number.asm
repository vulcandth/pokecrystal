MobilePhoneNumberEntry::
; Edit the packed number at de. Nonzero c uses the mobile home box palette.
; Return carry on cancellation; otherwise de points to wStringBuffer1.
	call MobileDialpad_Init
	call MobileDialpad_Loop
	ld hl, wMobileDialpadFlags
	bit MOBILE_DIALPAD_ACCEPTED_F, [hl]
	jr z, .cancel
	ld de, wStringBuffer1
	push de
	call MobileDialpad_PackNumber
	pop de
	xor a
	ret

.cancel
	scf
	ret

MobileDialpad_Init:
	push de
	push bc
	ld hl, wMobileDialpadState
	ld bc, MOBILE_DIALPAD_STATE_SIZE
	xor a
	call ByteFill
	ld hl, wMobileDialpadDigits
	ld bc, MOBILE_PHONE_DIGITS_LENGTH
	ld a, $ff
	call ByteFill
	pop bc
	ld a, c
	and a
	jr z, .unpack_number
	ld hl, wMobileDialpadFlags
	set MOBILE_DIALPAD_HOME_PALETTE_F, [hl]
.unpack_number
	pop de
	call MobileDialpad_UnpackNumber
	call MobileDialpad_LoadGFX
	farcall Function106464
	call MobileDialpad_DrawScreen
	farcall HDMATransferAttrmapAndTilemapToWRAMBank3
	call MobileDialpad_LoadPalettes
	farcall LoadOW_BGPal7
	farcall Function49420
	call SetDefaultBGPAndOBP
	call DelayFrame
	ret

MobileDialpad_UnpackNumber:
; Each byte stores the first digit in its low nibble, then the second.
; A nibble >= 10 terminates the number.
	ld hl, wMobileDialpadDigits
	ld c, $0
	ld b, MOBILE_PHONE_BCD_LENGTH
.loop
	ld a, [de]
	call MobileDialpad_UnpackDigit
	jr c, .done
	ld a, [de]
	swap a
	call MobileDialpad_UnpackDigit
	jr c, .done
	inc de
	dec b
	jr nz, .loop
.done
	ld a, c
	ld [wMobileDialpadLength], a
	ret

MobileDialpad_UnpackDigit:
	and $f
	cp 10
	jr nc, .terminator
	ld [hli], a
	inc c
	and a
	ret

.terminator
	ld [hl], $ff
	scf
	ret

MobileDialpad_PackNumber:
; Pack up to 16 digits into eight bytes, padding unused nibbles with $f.
	push de
	ld h, d
	ld l, e
	ld bc, MOBILE_PHONE_BCD_LENGTH
	ld a, $ff
	call ByteFill
	pop de
	ld hl, wMobileDialpadDigits
	ld b, MOBILE_PHONE_BCD_LENGTH
.loop
	ld c, $0
	ld a, [hli]
	cp 10
	jr nc, .terminator
	ld c, a
	ld a, [hli]
	cp 10
	jr nc, .last_digit
	swap a
	or c
	ld [de], a
	inc de
	dec b
	jr nz, .loop
	ret

.terminator
	ld a, $ff
	ld [de], a
	ret

.last_digit
	ld a, $f0
	or c
	ld [de], a
	ret

MobileDialpad_Loop:
	xor a
	ld [wMobileDialpadJumptableIndex], a
.loop
	call MobileDialpad_ReadJoypad
	call MobileDialpad_RunState
	call MobileDialpad_DrawNumber
	call MobileDialpad_UpdateSprites
	call MobileDialpad_UpdateTilemap
	ld hl, wMobileDialpadBlinkCounter
	inc [hl]
	ld a, [wMobileDialpadJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr z, .loop
	ret

MobileDialpad_UpdateSprites:
	ldh a, [hOAMUpdate]
	push af
	ld a, $1
	ldh [hOAMUpdate], a
	call HideSprites
	call MobileDialpad_DrawSprites
	pop af
	ldh [hOAMUpdate], a
	ret

MobileDialpad_ReadJoypad:
	ldh a, [hInMenu]
	push af
	ld a, $1
	ldh [hInMenu], a
	call JoyTextDelay
	pop af
	ldh [hInMenu], a
	ret

MobileDialpad_UpdateTilemap:
	ld hl, wMobileDialpadFlags
	bit MOBILE_DIALPAD_UPDATE_ATTRMAP_F, [hl]
	res MOBILE_DIALPAD_UPDATE_ATTRMAP_F, [hl]
	jr nz, .update_attrmap
	farcall HDMATransferTilemapToWRAMBank3
	ret

.update_attrmap
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ret

MobileDialpad_IncrementJumptable: ; unreferenced
	ld a, [wMobileDialpadJumptableIndex]
	inc a
	ld [wMobileDialpadJumptableIndex], a
	ret

MobileDialpad_RunState:
	ld a, [wMobileDialpadJumptableIndex]
	ld hl, MobileDialpadStatePointers
	rst JumpTable
	ret

MobileDialpadStatePointers:
	table_width 2
	dw MobileDialpad_InitCursor
	dw MobileDialpad_Joypad
	dw MobileDialpad_WaitKeyHighlight
	dw MobileDialpad_WaitAccept
	dw MobileDialpad_ErrorJoypad
	dw MobileDialpad_WaitCancel
	assert_table_length NUM_MOBILE_DIALPAD_STATES

MobileDialpad_InitCursor:
	ld a, MOBILE_DIALPAD_KEY_5
	call MobileDialpad_SetCursor
	ld a, MOBILE_DIALPAD_JOYPAD
	ld [wMobileDialpadJumptableIndex], a
	ret

MobileDialpad_Joypad:
	call MobileDialpad_GetJoypad
	call MobileDialpad_CheckButtons
	ret c
	call MobileDialpad_MoveCursor
	ret

MobileDialpad_WaitKeyHighlight:
	call MobileDialpad_GetJoypad
	call MobileDialpad_MoveCursor
	ld hl, wMobileDialpadKeyDelay
	dec [hl]
	ret nz
	call MobileDialpad_LoadTilemap
	call MobileDialpad_LoadAttrmap
	ld hl, wMobileDialpadFlags
	set MOBILE_DIALPAD_UPDATE_ATTRMAP_F, [hl]
	ld a, MOBILE_DIALPAD_JOYPAD
	ld [wMobileDialpadJumptableIndex], a
	ret

MobileDialpad_WaitCancel:
	ld hl, wMobileDialpadKeyDelay
	dec [hl]
	ret nz
	ld hl, wMobileDialpadJumptableIndex
	set JUMPTABLE_EXIT_F, [hl]
	ret

MobileDialpad_WaitAccept:
	ld hl, wMobileDialpadKeyDelay
	dec [hl]
	ret nz
	call MobileDialpad_LoadTilemap
	call MobileDialpad_LoadAttrmap
	ld hl, wMobileDialpadFlags
	set MOBILE_DIALPAD_UPDATE_ATTRMAP_F, [hl]
	ld hl, wMobileDialpadFlags
	set MOBILE_DIALPAD_ACCEPTED_F, [hl]
	ld hl, wMobileDialpadJumptableIndex
	set JUMPTABLE_EXIT_F, [hl]
	ret

MobileDialpad_ErrorJoypad:
	call IsSFXPlaying
	ret nc
	ldh a, [hJoyPressed]
	and PAD_A | PAD_B
	ret z
	call ExitMenu
	call MobileDialpad_LoadTilemap
	call MobileDialpad_LoadAttrmap
	ld hl, wMobileDialpadFlags
	set MOBILE_DIALPAD_UPDATE_ATTRMAP_F, [hl]
	ld hl, wMobileDialpadFlags
	res MOBILE_DIALPAD_ERROR_F, [hl]
	ld a, MOBILE_DIALPAD_JOYPAD
	ld [wMobileDialpadJumptableIndex], a
	ret

MobileDialpad_GetJoypad:
	ldh a, [hJoyLast]
	and PAD_CTRL_PAD
	ld c, a
	ldh a, [hJoyPressed]
	and PAD_A | PAD_B | PAD_START
	or c
	ld c, a
	ret

MobileDialpad_MoveCursor:
	ld a, c
	and PAD_UP | PAD_LEFT
	cp PAD_UP | PAD_LEFT
	jr z, .up_left
	ld a, c
	and PAD_UP | PAD_RIGHT
	cp PAD_UP | PAD_RIGHT
	jr z, .up_right
	ld a, c
	and PAD_DOWN | PAD_LEFT
	cp PAD_DOWN | PAD_LEFT
	jr z, .down_left
	ld a, c
	and PAD_DOWN | PAD_RIGHT
	cp PAD_DOWN | PAD_RIGHT
	jr z, .down_right
	bit B_PAD_UP, c
	jr nz, .up
	bit B_PAD_DOWN, c
	jr nz, .down
	bit B_PAD_LEFT, c
	jr nz, .left
	bit B_PAD_RIGHT, c
	jr nz, .right
	xor a
	ret

.up_left
	ld a, MOBILE_DIALPAD_UP_LEFT
	call MobileDialpad_MoveToNeighbor
	scf
	ret

.up_right
	ld a, MOBILE_DIALPAD_UP_RIGHT
	call MobileDialpad_MoveToNeighbor
	scf
	ret

.down_left
	ld a, MOBILE_DIALPAD_DOWN_LEFT
	call MobileDialpad_MoveToNeighbor
	scf
	ret

.down_right
	ld a, MOBILE_DIALPAD_DOWN_RIGHT
	call MobileDialpad_MoveToNeighbor
	scf
	ret

.up
	ld a, MOBILE_DIALPAD_UP
	call MobileDialpad_MoveToNeighbor
	scf
	ret

.down
	ld a, MOBILE_DIALPAD_DOWN
	call MobileDialpad_MoveToNeighbor
	scf
	ret

.left
	ld a, MOBILE_DIALPAD_LEFT
	call MobileDialpad_MoveToNeighbor
	scf
	ret

.right
	ld a, MOBILE_DIALPAD_RIGHT
	call MobileDialpad_MoveToNeighbor
	scf
	ret

MobileDialpad_CheckButtons:
	bit B_PAD_B, c
	jr nz, .b_button
	bit B_PAD_A, c
	jr nz, .a_button
	bit B_PAD_START, c
	jr nz, .start
	xor a
	ret

.b_button
	ld a, MOBILE_DIALPAD_KEY_DELETE
	ld [wMobileDialpadSelectedKey], a
	call MobileDialpad_HighlightKey
	call MobileDialpad_DeleteDigit
	call MobileDialpad_PlayKeySound
	scf
	ret

.a_button
	call MobileDialpad_SelectKey
	call MobileDialpad_HighlightKey
	call MobileDialpad_PressKey
	scf
	ret

.start
	ld a, MOBILE_DIALPAD_KEY_DONE
	call MobileDialpad_SetCursor
	scf
	ret

MobileDialpad_PressKey:
	ld a, MOBILE_DIALPAD_VALUE
	call MobileDialpad_GetCursorKeyField
	ld a, [hl]
	cp MOBILE_DIALPAD_VALUE_DELETE
	jr z, .delete
	cp MOBILE_DIALPAD_VALUE_DONE
	jr z, .done
	cp MOBILE_DIALPAD_VALUE_CANCEL
	jr z, .cancel
	ld e, a
	call MobileDialpad_AppendDigit
	ld a, MOBILE_DIALPAD_WAIT_KEY_HIGHLIGHT
	ld [wMobileDialpadJumptableIndex], a
	call MobileDialpad_PlayKeySound
	ret

.delete
	call MobileDialpad_DeleteDigit
	call MobileDialpad_PlayKeySound
	ret

.done
	call MobileDialpad_SelectKey
	call MobileDialpad_HighlightKey
	call MobileDialpad_CheckNumberLength
	call MobileDialpad_PlayKeySound
	ret

.cancel
	call MobileDialpad_HighlightKey
	ld a, MOBILE_DIALPAD_WAIT_CANCEL
	ld [wMobileDialpadJumptableIndex], a
	xor a
	call MobileDialpad_PlayKeySound
	ret

MobileDialpad_CheckNumberLength:
	ld a, [wMobileDialpadLength]
	cp MOBILE_DIALPAD_MIN_DIGITS
	jr c, .too_short
	ld a, MOBILE_DIALPAD_WAIT_ACCEPT
	ld [wMobileDialpadJumptableIndex], a
	xor a
	ret

.too_short
	call LoadStandardMenuHeader
	call MobileDialpad_DrawError
	ld hl, wMobileDialpadFlags
	set MOBILE_DIALPAD_UPDATE_ATTRMAP_F, [hl]
	ld hl, wMobileDialpadFlags
	set MOBILE_DIALPAD_ERROR_F, [hl]
	ld a, MOBILE_DIALPAD_ERROR_JOYPAD
	ld [wMobileDialpadJumptableIndex], a
	scf
	ret

MobileDialpad_DeleteDigit:
	ld a, [wMobileDialpadLength]
	and a
	jr z, .cancel
	dec a
	ld [wMobileDialpadLength], a
	ld c, a
	ld b, 0
	ld hl, wMobileDialpadDigits
	add hl, bc
	ld [hl], $ff
	ld a, MOBILE_DIALPAD_WAIT_KEY_HIGHLIGHT
	ld [wMobileDialpadJumptableIndex], a
	and a
	ret

.cancel
	ld a, MOBILE_DIALPAD_WAIT_CANCEL
	ld [wMobileDialpadJumptableIndex], a
	xor a
	ret

MobileDialpad_AppendDigit:
	ld a, [wMobileDialpadLength]
	cp MOBILE_PHONE_DIGITS_LENGTH
	jr nc, .full
	ld c, a
	ld b, 0
	inc a
	ld [wMobileDialpadLength], a
	ld hl, wMobileDialpadDigits
	add hl, bc
	ld [hl], e
	and a
	ret

.full
	scf
	ret

MobileDialpad_DrawNumber:
	hlcoord 1, 1
	lb bc, 2, 18
	call ClearBox
	hlcoord 3, 2
	ld de, wMobileDialpadDigits
	ld a, [wMobileDialpadLength]
	and a
	ret z
	ld c, a
.loop
	ld a, [de]
	inc de
	cp 10
	jr nc, .done
	add '０'
	ld [hli], a
	dec c
	jr nz, .loop
	ret

.done
	ret

MobileDialpad_DrawError:
	hlcoord 0, 12
	ld b, 4
	ld c, SCREEN_WIDTH - 2
	call MobileDialpad_Textbox
	hlcoord 2, 14
	ld de, MobileDialpadInvalidNumberString
	call PlaceString
	ret

MobileDialpadInvalidNumberString:
	db   "でんわばんごうが　ただしく"
	next "はいって　いません！"
	db   "@"

MobileDialpad_DrawSprites:
	ld de, wShadowOAM
	ld hl, wMobileDialpadFlags
	bit MOBILE_DIALPAD_ERROR_F, [hl]
	jr nz, .error
	call MobileDialpad_DrawPhoneIcon
	call MobileDialpad_DrawKeyCursor
	call MobileDialpad_DrawDigitCursor
	ret

.error
	call MobileDialpad_DrawPhoneIcon
	ret

MobileDialpad_DrawPhoneIcon:
	ld a, $3
	ld [wMobileDialpadSpriteAttributes], a
	ld hl, MobileDialpadKeyCursor
	ld b, $8
	ld c, $8
	ld a, $5
	call MobileDialpad_DrawOAM
	ret

MobileDialpad_DrawDigitCursor:
	ld a, [wMobileDialpadLength]
	cp MOBILE_PHONE_DIGITS_LENGTH
	ret nc
	ld a, [wMobileDialpadBlinkCounter]
	swap a
	and $1
	add $1
	ld [wMobileDialpadSpriteAttributes], a
	ld a, [wMobileDialpadLength]
	cp MOBILE_PHONE_DIGITS_LENGTH
	jr c, .okay
	dec a
.okay
	ld c, TILE_WIDTH
	call SimpleMultiply
	add 3 * TILE_WIDTH
	ld b, a
	ld c, $11
	ld hl, MobileDialpadDigitCursor
	ld a, $4
	call MobileDialpad_DrawOAM
	ret

MobileDialpad_DrawKeyCursor:
	ld a, $0
	ld [wMobileDialpadSpriteAttributes], a
	push de
	ld a, MOBILE_DIALPAD_X
	call MobileDialpad_GetCursorKeyField
	add a
	add a
	add a
	add $0
	push af
	ld a, MOBILE_DIALPAD_Y
	call MobileDialpad_GetCursorKeyField
	add a
	add a
	add a
	add $8
	ld c, a
	pop af
	ld b, a
	pop de
	ld a, $0
	ld hl, MobileDialpadKeyCursor
	call MobileDialpad_DrawOAM
	ret

MobileDialpad_DrawOAM:
; Draw frame hl at pixel coordinates b, c into OAM at de, using tile offset a.
	ld [wMobileDialpadSpriteTile], a
	ld a, b
	add OAM_X_OFS
	ld b, a
	ld a, c
	add OAM_Y_OFS
	ld c, a
	ld a, [hli]
.loop
	push af
	ld a, [hli]
	add c
	ld [de], a
	inc de
	ld a, [hli]
	add b
	ld [de], a
	inc de
	ld a, [wMobileDialpadSpriteTile]
	add [hl]
	inc hl
	ld [de], a
	inc de
	ld a, [wMobileDialpadSpriteAttributes]
	or [hl]
	inc hl
	ld [de], a
	inc de
	pop af
	dec a
	jr nz, .loop
	ret

MobileDialpadDigitCursor:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite 0, 0, 0, 0, 0, 0
.End:

MobileDialpadKeyCursor:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite 0, 0, 0, 0, 0, 0
	dbsprite 1, 0, 0, 0, 1, 0
	dbsprite 0, 1, 0, 0, 2, 0
	dbsprite 1, 1, 0, 0, 3, 0
.End:

MobileDialpad_PlayKeySound:
	jr c, MobileDialpad_PlayErrorSound
	ld de, SFX_SWITCH_POKEMON
	call PlaySFX
	ret

MobileDialpad_PlayErrorSound:
	ld de, SFX_WRONG
	call PlaySFX
	ret

MobileDialpad_HighlightKey:
	ld a, MOBILE_DIALPAD_KEY_DELAY
	ld [wMobileDialpadKeyDelay], a
	call MobileDialpad_GetKeyAttrmapAddress
	call MobileDialpad_SetKeyHighlight
	ld hl, wMobileDialpadFlags
	set MOBILE_DIALPAD_UPDATE_ATTRMAP_F, [hl]
	ret

MobileDialpad_GetKeyAttrmapAddress:
	ld a, MOBILE_DIALPAD_X
	call MobileDialpad_GetSelectedKeyField
	ld c, a
	ld b, 0
	hlcoord 0, 0, wAttrmap
	add hl, bc
	push hl
	ld a, MOBILE_DIALPAD_Y
	call MobileDialpad_GetSelectedKeyField
	ld bc, SCREEN_WIDTH
	pop hl
	call AddNTimes
	ret

MobileDialpad_SetKeyHighlight:
	ld a, BG_BANK1 | 3
	push hl
	ld [hli], a
	ld [hli], a
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	ld [hli], a
	ld [hli], a
	ret

MobileDialpad_MoveToNeighbor:
	call MobileDialpad_GetCursorKeyField

MobileDialpad_SetCursor:
	ld [wMobileDialpadCursor], a
	ret

MobileDialpad_SelectKey:
	push af
	ld a, [wMobileDialpadCursor]
	ld [wMobileDialpadSelectedKey], a
	pop af
	ret

MobileDialpad_GetCursorKeyField:
	call MobileDialpad_SelectKey

MobileDialpad_GetSelectedKeyField:
; Return field a of wMobileDialpadSelectedKey in a, with hl pointing to it.
	push af
	ld a, [wMobileDialpadSelectedKey]
	ld bc, MOBILE_DIALPAD_KEY_SIZE
	ld hl, MobileDialpadKeys
	call AddNTimes
	pop af
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ret

INCLUDE "data/mobile/dialpad.asm"

MobileDialpad_LoadGFX:
	ldh a, [rVBK]
	push af
	ld a, $1
	ldh [rVBK], a

	ld hl, vTiles5 tile $00
	ld de, DialpadGFX
	; Includes the first four tiles of DialpadCursorGFX.
	lb bc, BANK(DialpadGFX), 128
	call Get2bpp

	pop af
	ldh [rVBK], a

	ld hl, vTiles0 tile $00
	ld de, DialpadCursorGFX
	lb bc, BANK(DialpadCursorGFX), 5
	call Get2bpp

	ld hl, vTiles0 tile $05
	ld de, MobileDialingGFX
	lb bc, BANK(MobileDialingGFX), 4
	call Get2bpp
	ret

MobileDialpad_LoadPalettes:
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a

	ld hl, MobileDialpadBGPalettes
	ld de, wBGPals1
	ld bc, 6 palettes
	call CopyBytes

	ld hl, MobileDialpadOBPalettes
	ld de, wOBPals1
	ld bc, 8 palettes
	call CopyBytes

	ld hl, MobileDialpadDigitCursorPalettes
	ld de, wOBPals1 palette 1
	ld bc, 2 palettes
	call CopyBytes

	ld hl, MapObjectPals palette 1
	ld de, wOBPals1 palette 3
	ld bc, 1 palettes
	ld a, BANK(MapObjectPals)
	call FarCopyBytes

	pop af
	ldh [rWBK], a
	ret

MobileDialpad_DrawScreen:
	call MobileDialpad_LoadTilemap
	call MobileDialpad_LoadAttrmap
	hlcoord 0, 0
	ld b, 2
	ld c, SCREEN_WIDTH - 2
	call MobileDialpad_Textbox
	ret

MobileDialpad_LoadTilemap:
	ld hl, DialpadTilemap
	decoord 0, 4
	ld bc, (SCREEN_HEIGHT - 4) * SCREEN_WIDTH
	call CopyBytes
	ret

MobileDialpad_LoadAttrmap:
	ld hl, DialpadAttrmap
	decoord 0, 4, wAttrmap
	ld bc, (SCREEN_HEIGHT - 4) * SCREEN_WIDTH
	call CopyBytes
	hlcoord 0, 4, wAttrmap
	ld bc, (SCREEN_HEIGHT - 4) * SCREEN_WIDTH
.loop
	ld a, [hl]
	or BG_BANK1
	ld [hli], a
	dec bc
	ld a, b
	or c
	jr nz, .loop
	ret

MobileDialpad_Textbox:
	ld a, [wMobileDialpadFlags]
	bit MOBILE_DIALPAD_HOME_PALETTE_F, a
	jr nz, .mobile_home
	call Textbox
	ret

.mobile_home
	call MobileHome_PlaceBoxWithPalette
	ret

INCLUDE "data/mobile/dialpad_gfx.asm"
