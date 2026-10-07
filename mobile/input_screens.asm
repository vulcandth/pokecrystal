MobilePassword_LoadScreen:
	call DisableLCD
	ld hl, AsciiFontGFX
	ld de, vTiles2 tile $00
	ld bc, $6e tiles
	call CopyBytes
	ld hl, PasswordSlowpokeLZ
	ld de, vTiles0 tile $00
	call Decompress
	call EnableLCD
	ld hl, PasswordTopTilemap
	decoord 0, 0
	ld bc, SCREEN_AREA
	call CopyBytes
	ld hl, MobilePasswordAttrmap
	decoord 0, 0, wAttrmap
	ld bc, SCREEN_AREA
	call CopyBytes
	hlcoord 3, 2
	ld de, MobilePasswordPromptString
	call PlaceString
	hlcoord 3, 16
	ld de, MobilePasswordCommandsString
	call PlaceString
	ret

Mobile_LoadInputPalettes:
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, MobilePasswordPalettes
	ld de, wBGPals1
	ld bc, 8 palettes
	call CopyBytes
	ld hl, wOBPals1 palette 0 color 1
	ld a, LOW(PALRGB_WHITE)
	ld [hli], a
	ld a, HIGH(PALRGB_WHITE)
	ld [hl], a
	call SetDefaultBGPAndOBP
	pop af
	ldh [rWBK], a
	ret

MobilePassword_SwitchKeyboard:
	xor a
	hlcoord 4, 15
	ld [hli], a
	ld [hli], a
	ld a, [wMobilePasswordKeyboard]
	xor MOBILE_PASSWORD_KEYBOARD_SYMBOLS
	ld [wMobilePasswordKeyboard], a
	and a
	jr nz, .shifted
	ld hl, PasswordBottomTilemap
	decoord 0, 7
	ld bc, SCREEN_WIDTH * (2 * MOBILE_PASSWORD_KEYBOARD_ROWS - 1)
	call CopyBytes
	hlcoord 3, 16
	ld de, MobilePasswordCommandsString
	jp PlaceString

.shifted
	ld hl, PasswordShiftTilemap
	decoord 0, 7
	ld bc, SCREEN_WIDTH * (2 * MOBILE_PASSWORD_KEYBOARD_ROWS - 1)
	call CopyBytes
	hlcoord 3, 16
	ld de, MobilePasswordShiftCommandsString
	jp PlaceString

MobileCenter_LoadScreen:
	call DisableLCD
	ld hl, AsciiFontGFX
	ld de, vTiles2 tile $00
	ld bc, $6e tiles
	call CopyBytes
	ld hl, PasswordSlowpokeLZ
	ld de, vTiles0 tile $00
	call Decompress
	call EnableLCD
	ld hl, ChooseMobileCenterTilemap
	decoord 0, 0
	ld bc, SCREEN_AREA
	call CopyBytes
	ld hl, ChooseMobileCenterAttrmap
	decoord 0, 0, wAttrmap
	ld bc, SCREEN_AREA
	call CopyBytes
	hlcoord 2, 2
	ld de, MobileCenterChooseString
	call PlaceString
	hlcoord 14, 16
	ld de, MobileInputConfirmString
	call PlaceString
	ret

INCLUDE "data/mobile/input_screens.asm"
