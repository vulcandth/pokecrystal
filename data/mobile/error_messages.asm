MobileCommunicationErrorText:
	db "つうしんエラー　　　ー@"

MobileUndefinedErrorText: ; unreferenced
	db   "みていぎ<NO>エラーです"
	next "プログラム<WO>"
	next "かくにん　してください"
	db   "@"

MobileErrorCodeTable:
	table_width 2
	dw MobileErrorCodes_10
	dw MobileErrorCodes_11
	dw MobileErrorCodes_12
	dw MobileErrorCodes_13
	dw MobileErrorCodes_14
	dw MobileErrorCodes_15
	dw MobileErrorCodes_16
	dw MobileErrorCodes_17
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_20
	dw MobileErrorCodes_21
	dw MobileErrorCodes_22
	dw MobileErrorCodes_23
	dw MobileErrorCodes_24
	dw MobileErrorCodes_25
	dw MobileErrorCodes_26
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_30
	dw MobileErrorCodes_31
	dw MobileErrorCodes_32
	dw MobileErrorCodes_33
	assert_table_length NUM_MOBILE_SDK_ERRORS

; Each SDK subtable begins with a count of (subcode, text pointer) pairs.
; A subcode of -1 supplies the fallback message for that class.
MobileErrorCodes_10:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_10_000_Text
.End:

MobileErrorCodes_11:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_11_000_Text
.End:

MobileErrorCodes_12:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_12_000_Text
.End:

MobileErrorCodes_13:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_13_000_Text
.End:

MobileErrorCodes_14:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_14_000_Text
.End:

MobileErrorCodes_15:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_15_000_Text
	dw $001, MobileErrorCode_15_001_Text
	dw $002, MobileErrorCode_15_002_Text
	dw $003, MobileErrorCode_15_003_Text
.End:

MobileErrorCodes_16:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_CommuncationErrorText
.End:

MobileErrorCodes_17:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_CommuncationErrorText
.End:

MobileErrorCodes_20:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_CommuncationErrorText
.End:

MobileErrorCodes_21:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_CommuncationErrorText
.End:

MobileErrorCodes_22:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_22_000_Text
.End:

MobileErrorCodes_23:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_23_000_Text
.End:

MobileErrorCodes_24:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_ServerConnectionFailedText
.End:

MobileErrorCodes_25:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_25_000_Text
.End:

MobileErrorCodes_26:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_26_000_Text
.End:

MobileErrorCodes_30:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_CommuncationErrorText
	dw $221, MobileErrorCode_ServerConnectionFailedText
	dw $421, MobileErrorCode_ServerConnectionFailedText
	dw $450, MobileErrorCode_30_450_Text
	dw $451, MobileErrorCode_ServerConnectionFailedText
	dw $452, MobileErrorCode_ServerConnectionFailedText
	dw $500, MobileErrorCode_CommuncationErrorText
	dw $501, MobileErrorCode_CommuncationErrorText
	dw $502, MobileErrorCode_CommuncationErrorText
	dw $503, MobileErrorCode_CommuncationErrorText
	dw $504, MobileErrorCode_CommuncationErrorText
	dw $550, MobileErrorCode_30_550_Text
	dw $551, MobileErrorCode_30_551_Text
	dw $552, MobileErrorCode_ServerConnectionFailedText
	dw $553, MobileErrorCode_30_553_Text
	dw $554, MobileErrorCode_ServerConnectionFailedText
	dw -1, MobileErrorCode_ServerConnectionFailedText
.End:

MobileErrorCodes_31:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_CommuncationErrorText
	dw $002, MobileErrorCode_31_002_Text
	dw $003, MobileErrorCode_31_003_Text
	dw $004, MobileErrorCode_CommuncationErrorText
	dw -1, MobileErrorCode_ServerConnectionFailedText
.End:

MobileErrorCodes_32:
	db (.End - .Entries) / 4
.Entries:
	dw $000, MobileErrorCode_CommuncationErrorText
	dw $301, MobileErrorCode_CommuncationErrorText
	dw $302, MobileErrorCode_CommuncationErrorText
	dw $400, MobileErrorCode_CommuncationErrorText
	dw $401, MobileErrorCode_CommuncationErrorText
	dw $403, MobileErrorCode_32_403_Text
	dw $404, MobileErrorCode_32_404_Text
	dw $405, MobileErrorCode_CommuncationErrorText
	dw $406, MobileErrorCode_CommuncationErrorText
	dw $407, MobileErrorCode_CommuncationErrorText
	dw $408, MobileErrorCode_32_408_Text
	dw $500, MobileErrorCode_ServerErrorText
	dw $501, MobileErrorCode_CommuncationErrorText
	dw $502, MobileErrorCode_ServerErrorText
	dw $503, MobileErrorCode_32_503_Text
	dw $504, MobileErrorCode_ServerErrorText
	dw -1, MobileErrorCode_ServerErrorText
.End:

MobileErrorCodes_33:
	db (.End - .Entries) / 4
.Entries:
	dw $101, MobileErrorCode_33_101_Text
	dw $102, MobileErrorCode_33_102_Text
	dw $103, MobileErrorCode_33_103_Text
	dw $104, MobileErrorCode_33_104_Text
	dw $105, MobileErrorCode_33_105_Text
	dw $106, MobileErrorCode_33_106_Text
	dw $201, MobileErrorCode_33_201_Text
	dw $202, MobileErrorCode_CommuncationErrorText
	dw $203, MobileErrorCode_33_203_Text
	dw $204, MobileErrorCode_CommuncationErrorText
	dw $205, MobileErrorCode_ServerErrorText
	dw $206, MobileErrorCode_33_206_Text
	dw $299, MobileErrorCode_33_299_Text
	dw $301, MobileErrorCode_ServerErrorText
	dw $401, MobileErrorCode_ServerErrorText
	dw $402, MobileErrorCode_ServerErrorText
	dw $403, MobileErrorCode_ServerErrorText
	dw $404, MobileErrorCode_ServerErrorText
	dw -1, MobileErrorCode_ServerErrorText
.End:

MobileErrorCode_10_000_Text:
; The Mobile Adapter is not properly plugged in.
; Ensure you have taken a good look at and properly followed the instructions.
	db   "モバイルアダプタが　ただしく"
	next "さしこまれていません"
	next "とりあつかいせつめいしょを"
	next "ごらんのうえ　しっかりと"
	next "さしこんで　ください"
	db   "@"

MobileErrorCode_11_000_Text:
MobileErrorCode_13_000_Text:
; Could not connect because either the phone cannot make the call, or the telephone line is busy.
; Please wait for a while and call again.
	db   "でんわが　うまく　かけられないか"
	next "でんわかいせんが　こんでいるので"
	next "つうしん　できません"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_12_000_Text:
; As the telephone line is busy, the phone was not able to gather enough information (?)
; Please wait for a while and call again.
	db   "でんわかいせんが　こんでいるため"
	next "でんわが　かけられません"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_15_000_Text:
MobileErrorCode_15_001_Text:
MobileErrorCode_15_002_Text:
MobileErrorCode_15_003_Text:
; There is an error with the Mobile Adapter.
; Please wait for a little while before calling again.
; If the problem persists, please contact the Mobile Support Center.
	db   "モバイルアダプタの　エラーです"
	next "しばらく　まって"
	next "かけなおして　ください"
	next "なおらない　ときは"
	next "モバイルサポートセンターへ"
	next "おといあわせください"
	db   "@"

MobileErrorCode_CommuncationErrorText:
; Communication error.
; Please wait a moment, and then try again.
; If the issue persists, please contact the Mobile Support Center.
	db   "つうしんエラーです"
	next "しばらく　まって"
	next "かけなおして　ください"
	next "なおらない　ときは"
	next "モバイルサポートセンターへ"
	next "おといあわせください"
	db   "@"

MobileErrorCode_22_000_Text:
; There is a mistake either with the login password, or the login ID.
; Please confirm the password, wait for a while, and try again.
	db   "ログインパスワードか"
	next "ログイン　アイディーに"
	next "まちがいがあります"
	next "パスワードを　かくにんして"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_23_000_Text:
; The call was ended.
; Please see the instruction manual, wait a moment, and try again.
	db   "でんわが　きれました"
	next "とりあつかいせつめいしょを"
	next "ごらんのうえ"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_ServerErrorText:
; There was a communication error with the mobile center.
; Please wait a moment and then try again.
	db   "モバイルセンターの"
	next "つうしんエラーです"
	next "しばらくまって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_14_000_Text:
MobileErrorCode_25_000_Text:
; The Mobile Adapter's details have expired and the information is not correct.
; Please use the Mobile Trainer to repeat the initial registration (process).
	db   "モバイルアダプタに"
	next "とうろくされた　じょうほうが"
	next "ただしく　ありません"
	next "モバイルトレーナーで"
	next "しょきとうろくを　してください"
	db   "@"

MobileErrorCode_32_503_Text:
; Could not connect because the Mobile Center is busy.
; Please wait a moment and try again.
; For details, please see the instruction manual.
	db   "モバイルセンターが"
	next "こんでいて　つながりません"
	next "しばらくまって"
	next "かけなおして　ください"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_30_450_Text:
MobileErrorCode_30_550_Text:
MobileErrorCode_30_551_Text:
MobileErrorCode_30_553_Text:
; There is a mistake with the email address of the addressee.
; Please replace with a / the correct email address.
	db   "あてさき　メールアドレスに"
	next "まちがいがあります"
	next "ただしい　メールアドレスを"
	next "いれなおしてください"
	db   "@"

MobileErrorCode_31_002_Text:
; There is a mistake with the email address.
; Please see the instruction manual, and use the Mobile Trainer to repeat the initial registration (process).
	db   "メールアドレスに"
	next "まちがいが　あります"
	next "とりあつかいせつめいしょを"
	next "ごらんのうえ"
	next "モバイルトレーナーで"
	next "しょきとうろくを　してください"
	db   "@"

MobileErrorCode_31_003_Text:
MobileErrorCode_33_201_Text:
; There is either an error with the login password, or an error with the Mobile Center.
; Please confirm the password, wait a moment, and then try again.
	db   "ログインパスワードに"
	next "まちがいが　あるか"
	next "モバイルセンターの　エラーです"
	next "パスワードを　かくにんして"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_32_403_Text:
MobileErrorCode_32_404_Text:
; Cannot read data.
; Please wait a moment, and then try again.
; If the issue persists, please contact the Mobile Support Center.
	db   "データの　よみこみが　できません"
	next "しばらくまって"
	next "かけなおして　ください"
	next "なおらない　ときは"
	next "モバイルサポートセンターへ"
	next "おといあわせください"
	db   "@"

MobileErrorCode_26_000_Text:
MobileErrorCode_32_408_Text:
; Out of time.
; The call was ended.
; Please try again.
; For details, please see the instruction manual.
	db   "じかんぎれです"
	next "でんわが　きれました"
	next "でんわを　かけなおしてください"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_33_101_Text:
; The service cannot be used if payments for usage fees are late.
; For details, please see the instruction manual.
	db   "ごりよう　りょうきんの　"
	next "おしはらいが　おくれたばあいには"
	next "ごりようが　できなくなります"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_33_102_Text:
MobileErrorCode_33_299_Text:
; Your access to this service has been restricted. Service cannot be used.
; For details, please see the instruction manual.
	db   "おきゃくさまの　ごつごうにより"
	next "ごりようできません"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_ServerConnectionFailedText:
; The telephone line is busy. Due to this error, the Mobile Center cannot communicate.
; Please wait for a little while and call again.
	db   "でんわかいせんが　こんでいるか"
	next "モバイルセンターの　エラーで"
	next "つうしんが　できません"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_33_103_Text:
; Service cannot be used this month because usage fees have exceeded conditions.
; For details, please see the instruction manual.
	db   "ごりよう　りょうきんが"
	next "じょうげんを　こえているため"
	next "こんげつは　ごりようできません"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_33_106_Text:
; Cannot communicate because the Mobile Center is currently undergoing maintenance.
; Please wait a moment, then try again.
	db   "げんざい　モバイルセンターの"
	next "てんけんを　しているので"
	next "つうしんが　できません"
	next "しばらく　まって"
	next "かけなおして　ください"
	db   "@"

MobileErrorCode_33_104_Text:
MobileErrorCode_33_105_Text:
MobileErrorCode_33_203_Text:
MobileErrorCode_33_206_Text:
MobileErrorCode_101_005_Text:
; Cannot read data.
; For details, please see the instruction manual.
	db   "データの　よみこみが　できません"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileErrorCode_101_007_Text:
; Call ended because more than 3 minutes elapsed with no input.
	db   "３ぷん　いじょう　なにも"
	next "にゅうりょく　しなかったので"
	next "でんわが　きれました"
	db   "@"

MobileErrorCode_101_002_Text:
MobileErrorCode_101_003_Text:
; Could not connect properly.
; Please try again from the beginning (of the process).
	db   "つうしんが　うまく"
	next "できませんでした"
	next "もういちど　はじめから"
	next "やりなおしてください"
	db   "@"

MobileErrorCode_101_004_Text:
MobileErrorCode_101_009_Text:
MobileErrorCode_101_010_Text:
MobileErrorCode_101_011_Text:
; Cannot read data.
; Please wait a moment, then try again.
; If the issue persists, please contact the Mobile Support Center.
	db   "データの　よみこみが　できません"
	next "しばらくまって"
	next "かけなおして　ください"
	next "なおらない　ときは"
	next "モバイルサポートセンターへ"
	next "おといあわせください"
	db   "@"

MobileErrorCode_101_008_Text:
; Call ended due to long waiting time.
	db   "まちじかんが　ながいので"
	next "でんわが　きれました"
	db   "@"

MobileErrorCode_101_006_Text:
; (Your adapter's) type differs from the other user’s Mobile Adapter.
; For details, please see the instruction manual.
	db   "あいての　モバイルアダプタと"
	next "タイプが　ちがいます"
	next "くわしくは　とりあつかい"
	next "せつめいしょを　ごらんください"
	db   "@"

MobileNewsChangedErrorText: ; unreferenced
; Cannot send your save data because Pokémon News is being updated.
; Please send your save data after loading new Pokémon News.
	db   "ポケモンニュースが"
	next "あたらしくなっているので"
	next "レポートを　おくれません"
	next "あたらしい　ポケモンニュースの"
	next "よみこみを　さきに　してください"
	db   "@"

MobileErrorCode_101_001_Text:
; Either bad communication status, or the other user called was the incorrect user.
; Please confirm and try again.
	db   "つうしんの　じょうきょうが"
	next "よくないか　かけるあいてが"
	next "まちがっています"
	next "もういちど　かくにんをして"
	next "でんわを　かけなおして　ください"
	db   "@"
