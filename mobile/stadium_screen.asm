MobileStadium_LoadScreen:
	ld a, ' '
	hlcoord 0, 0
	ld bc, SCREEN_AREA
	call ByteFill
	ld a, PAL_BG_TEXT
	hlcoord 0, 0, wAttrmap
	ld bc, SCREEN_AREA
	call ByteFill
	call DisableLCD
	ld hl, Stadium2N64GFX
	ld de, vTiles2 tile $00
	ld bc, 97 tiles
	call CopyBytes
	call EnableLCD
	ld hl, Stadium2N64Tilemap
	decoord 0, 0
	ld bc, SCREEN_AREA
	call CopyBytes
	ld hl, Stadium2N64Attrmap
	decoord 0, 0, wAttrmap
	ld bc, SCREEN_AREA
	call CopyBytes
	ret

MobileStadium_ApplyPalettes:
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, MobileStadiumPalettes
	ld de, wBGPals1
	ld bc, 8 palettes
	call CopyBytes
	ld hl, MobileStadiumPalettes
	ld de, wBGPals2
	ld bc, 8 palettes
	call CopyBytes
	call SetDefaultBGPAndOBP
	pop af
	ldh [rWBK], a
	ret

INCLUDE "data/mobile/stadium_screen.asm"
