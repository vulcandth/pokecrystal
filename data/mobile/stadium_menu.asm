MobileStadiumMessageMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 12, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	dw NULL
	db 0 ; default option

MobileStadiumConfirmMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 14, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 0 ; default item

MobileStadiumYesNoString:
	db   "はい"
	next "いいえ@"

MobileStadiumEntryText:
	text_far _MobileStadiumEntryText
	text_end

MobileStadiumSuccessText:
	text_far _MobileStadiumSuccessText
	text_end
