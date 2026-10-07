BattleTowerPickLevelMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 12, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 0 ; default option

UnusedBattleTowerRoomMenuHeader: ; unreferenced
	db MENU_BACKUP_TILES ; flags
	menu_coords 15, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 0 ; default option

BattleTowerLevelMenuArrowString:
	db "   ▼@"

BattleTowerLevelMenuStrings:
	table_width BATTLETOWER_LEVEL_MENU_ENTRY_LENGTH
	db " L:10 @@"
	db " L:20 @@"
	db " L:30 @@"
	db " L:40 @@"
	db " L:50 @@"
	db " L:60 @@"
	db " L:70 @@"
	db " L:80 @@"
	db " L:90 @@"
	db " L:100@@"
	db "CANCEL@@"
	assert_table_length BATTLETOWER_NUM_LEVELS + 1

BattleTowerLevelMenuStringsBeforeHallOfFame:
	table_width BATTLETOWER_LEVEL_MENU_ENTRY_LENGTH
	db " L:10 @@"
	db " L:20 @@"
	db " L:30 @@"
	db " L:40 @@"
	db "CANCEL@@"
	assert_table_length BATTLETOWER_NUM_LEVELS_BEFORE_HOF + 1

BattleTowerCancelString: ; unreferenced
	db "CANCEL@"
