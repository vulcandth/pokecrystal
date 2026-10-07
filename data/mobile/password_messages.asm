MobilePasswordMessageMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 12, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	dw NULL
	db 0 ; default option

MobilePasswordYesNoMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 14, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 0 ; default option

MobilePasswordYesNoString:
	db   "はい"
	next "いいえ@"

MobilePasswordAskSaveString:
	db   "こ<NO>パスワード<WO>ほぞんして"
	line "おきますか？@"

MobilePasswordEmptyString:
	db   "パスワード<GA>にゅうりょく"
	line "されていません！@"

MobilePasswordSavedString:
	db   "ログインパスワード<WO>ほぞん"
	line "しました@"
