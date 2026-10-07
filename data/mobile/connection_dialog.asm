MobileDialogCallCenterString:
	db   "これから　モバイルセンターに"
	next "でんわ<WO>かけます@"

MobileDialogAdapterReadyString:
	db   "モバイルアダプタ<NO>じゅんびは"
	next "できて　いますか？@"

MobileDialogDialingString:
	db   "でんわ<WO>かけています"
	next "しばらく　おまちください@"

MobileDialogConnectionFeesString:
	db   "でんわをかけると　つうわりょう"
	next "せつぞくりょう<GA>かかります@"

MobileDialogConnectedString:
	db   "せつぞく　しました@"

MobileDialogCommunicatingString:
	db   "つうしん　ちゅう@"

MobileDialogCommunicatingWithCancelString:
	db   "つうしん　ちゅう"
	next "セレクト　エーでちゅうし@"

MobileDialogDownloadFeeIntroString:
	db   "この　サービスには"
	next "つうわりょう<NO>ほかに@"

MobileDialogDownloadFeePrefixString:
	db   "おかね<GA>@"

MobileDialogDownloadFeeSuffixString:
	db   "えん"
	next "かかります　よろしい　ですか？@"

MobileDialogConnectionClosedString:
	db   "つうしん　しゅうりょう@"

MobileDialogConnectionTimeString:
	db   "つないだ　じかん"
	next "　　やく　　　ふん　　　びょう@"

MobileDialogNewDataString:
	db   "もっていない　データが"
	next "あります！@"

MobileDialogDownloadDataString:
	db   "データ<WO>よみこみますか？@"

MobileDialogPreviouslyDownloadedString:
	db   "おなじ　データ<WO>よみこんだ"
	next "こと<GA>ありますが@"

MobileDialogDataMissingString:
	db   "そのデータ<WA>なくなっているか"
	next "こわれて　います@"

MobileDialogNoNewDataString:
	db   "もっている　データと"
	next "おなじデータしか　ありません！@"

MobileDialogCancelDownloadString:
	db   "データ<NO>よみこみを"
	next "ちゅうし　しますか？@"

MobileDialogNoNewsString:
	db   "あたらしい　ニュースは"
	next "ありません　でした@"

MobileDialogDownloadNewsString:
	db   "あたらしいニュース<GA>あります"
	next "ニュース<WO>よみこみますか？@"

MobileDialogBlankLineString:
	db   "　　　　　　　　　　　　　　　@"

MobileDialogMenuHeader: ; unreferenced
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 0, SCREEN_WIDTH - 1, 5
	dw NULL
	db 0 ; default option
