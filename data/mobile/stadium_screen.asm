MobileStadiumPalettes:
	RGB  5, 12, 17
	RGB 31, 31, 31
	RGB 18, 25, 28
	RGB 10, 17, 21
	RGB  6, 13, 18
	RGB 31, 31, 31
	RGB 20, 26, 28
	RGB 12, 19, 23
	RGB  3, 10, 16
	RGB 31, 31, 31
	RGB  6, 13, 18
	RGB 20, 26, 28
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
	RGB  5,  5, 16
	RGB  8, 19, 28
	RGB  0,  0,  0
	RGB 31, 31, 31
	RGB 31, 31, 31
	RGB  0,  0,  0
	RGB  0,  0,  0
	RGB  0,  0,  0

Stadium2N64GFX:
INCBIN "gfx/mobile/stadium2_n64.2bpp"

Stadium2N64Tilemap:
if DEF(_CRYSTAL11)
; BUG: Crystal 1.1 corrupted this tilemap by treating $0a bytes as
; Unix newlines, and converting them to $0d $0a Windows newlines.
INCBIN "gfx/mobile/stadium2_n64_corrupt.tilemap"
else
INCBIN "gfx/mobile/stadium2_n64.tilemap"
endc

Stadium2N64Attrmap:
INCBIN "gfx/mobile/stadium2_n64.attrmap"
