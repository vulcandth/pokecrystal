BattleTowerYesString:
	db "YES@"

BattleTowerNoString:
	db "NO@"

MobileDialogYesNoMenuHeader: ; unreferenced
	db MENU_BACKUP_TILES ; flags
	menu_coords 14, 6, SCREEN_WIDTH - 1, 10
	dw NULL
	db 0 ; default option

MobileDialogCancelMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 14, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 0 ; default option
