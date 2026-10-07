MobileDialpadBGPalettes:
	RGB  0,  0,  0
	RGB  9, 10, 25
	RGB 16, 19, 31
	RGB 31, 31, 31

	RGB  5, 11,  9
	RGB  7, 14, 12
	RGB 17, 24, 22
	RGB 28, 31, 31

	RGB  0,  0,  0
	RGB  3,  0, 10
	RGB  3,  3, 16
	RGB  6,  8, 25

	RGB  5, 11,  9
	RGB 28, 31, 31
	RGB  7, 14, 12
	RGB 17, 24, 22

	RGB  0,  0,  0
	RGB  5,  2, 16
	RGB  8,  8, 26
	RGB 13,  9, 17

	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0

	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0

	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0

MobileDialpadOBPalettes:
	RGB 31, 31, 31
	RGB  4,  3,  3
	RGB 31, 13,  0
	RGB 31, 31, 31

	RGB 31, 31, 31
	RGB  0,  0,  0
	RGB 31, 31, 31
	RGB 31, 31, 31

	RGB 31,  0,  0
	RGB 16,  3,  0
	RGB 28, 19, 11
	RGB 31, 31, 31

	RGB 31, 16,  0
	RGB  9,  6,  4
	RGB 31, 16,  0
	RGB 31, 24,  0

	RGB 31, 18,  6
	RGB  0,  3,  0
	RGB  0,  9,  0
	RGB  0, 12,  0

	RGB  0, 16,  0
	RGB  0, 22,  0
	RGB  0, 25,  0
	RGB  0, 27,  0

	RGB  0, 31,  0
	RGB  3, 31,  0
	RGB  8, 31,  0
	RGB 14, 31,  0

	RGB 16, 31,  0
	RGB 22, 31,  0
	RGB 27, 31,  0
	RGB 31, 31,  0

DialpadTilemap:
INCBIN "gfx/mobile/dialpad.tilemap"

DialpadAttrmap:
INCBIN "gfx/mobile/dialpad.attrmap"

DialpadGFX:
INCBIN "gfx/mobile/dialpad.2bpp"

DialpadCursorGFX:
INCBIN "gfx/mobile/dialpad_cursor.2bpp"

MobileDialpadDigitCursorPalettes:
; The two-palette copy also reads 12 bytes from MobileCardListGFX.
	RGB  2,  6, 10
	RGB 24, 30, 29
