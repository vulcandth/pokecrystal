Text_SaveFileWillBeSent:
	text "SAVE FILE will be"
	line "sent."
	done

Text_SentSaveFileReadingNews:
	text "Sent SAVE FILE."
	line "Reading NEWS…"
	done

Text_ReadingNews:
	text "Reading NEWS…"
	done

Text_ReceivedNews:
	text "Received NEWS!"
	done

Text_QuitReadingNews:
	text "Quit reading NEWS?"
	done

Text_CanceledSendingSaveFile: ; unreferenced
	text "Canceled sending"
	line "SAVE FILE."
	done

Text_ReceivedOddEgg: ; unreferenced
	text "ODD EGG"
	line "was received!"
	done

Text_RegisteringRecord:
	text "Registering your"
	line "record…"
	done

Text_BattleRoomVisitLimit: ; unreferenced
	text "One visit per day"
	line "per BATTLE ROOM!"
	done

Text_PartyMonTopsThisLevel:
	text "A party #MON"
	line "tops this level."
	done

Text_UberRestriction:
	text_ram wcd49
	text " may go"
	line "only to BATTLE"

	para "ROOMS that are"
	line "Lv.70 or higher."
	done

Text_CancelBattleRoomChallenge:
	text "Cancel your BATTLE"
	line "ROOM challenge?"
	done

Text_ExitGymLeaderHonorRoll:
	text "Exit GYM LEADER"
	line "HONOR ROLL?"
	done

Text_LinkingWithCenter: ; unreferenced
	text "Linking with the"
	line "CENTER…"
	done

Text_WhatLevelDoYouWantToChallenge:
	text "What level do you"
	line "want to challenge?"
	done

Text_CheckBattleRoomListByMaxLevel:
	text "Check BATTLE ROOM"
	line "list by max level?"
	done

Text_EnterWhichBattleRoom: ; unreferenced
	text "Enter which"
	line "BATTLE ROOM?"
	done

Text_WhichBattleRoom: ; unreferenced
	text "Which BATTLE ROOM?"
	done

Text_ThisBattleRoomPleaseWait: ; unreferenced
	text_ram wStringBuffer3
	text "'s ROOM"
	line "@"
	text_ram wStringBuffer4
	text "?"
	cont "Please wait…"
	done
