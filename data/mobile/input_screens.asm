MobilePasswordPalettes:
INCLUDE "gfx/mobile/mobile_password.pal"

AsciiFontGFX:
INCBIN "gfx/mobile/ascii_font.2bpp"

PasswordTopTilemap:
INCBIN "gfx/mobile/password_top.tilemap"

PasswordBottomTilemap:
INCBIN "gfx/mobile/password_bottom.tilemap"

PasswordShiftTilemap:
INCBIN "gfx/mobile/password_shift.tilemap"

ChooseMobileCenterTilemap:
INCBIN "gfx/mobile/mobile_center.tilemap"

MobilePasswordAttrmap:
INCBIN "gfx/mobile/password.attrmap"

ChooseMobileCenterAttrmap:
INCBIN "gfx/mobile/mobile_center.attrmap"

PasswordSlowpokeLZ:
INCBIN "gfx/pokedex/slowpoke.2bpp.lz"

MobilePasswordPromptString:
	db "パスワード<WO>いれてください@"
MobilePasswordCommandsString:
	db "きりかえ　やめる　　けってい@"
MobilePasswordShiftCommandsString:
	db "きりかえ　やめる　　"
MobileInputConfirmString:
	db "けってい@"
MobileCenterChooseString:
	db "せつぞくする　モバイルセンターを"
	next "えらんで　ください@"
