; Built-in Japanese Pokémon News sample 1.
PokemonNews1:
	dw sPokemonNews
	dw $c107 ; checksum of the payload
	dw PokemonNews1End - PokemonNews1Root

PokemonNews1Root:
	db MUSIC_PROF_ELM ; music
	db 0 ; custom palette bitmask
	db 2 ; number of boxes
	db 0, 3, 20, 10, 1, 3 ; x, y, width, height, border, palette
	db 0, 12, 20, 6, 2, 4 ; x, y, width, height, border, palette
	db 1 ; number of strings
	dw 2 * SCREEN_WIDTH + 1 ; tilemap offset
	db "トレーナーランキング@"
	db 2, 5, 1, 4, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 4, 2, 4
	dw .AButton - PokemonNews1Root ; A
	dw .BButton - PokemonNews1Root ; B
	dw -1 ; Select
	dw -1 ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews1Root ; Up
	dw .DownButton - PokemonNews1Root ; Down
	db 5 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .ViewRankingsText - PokemonNews1Root
	dw .RankingExplanationText - PokemonNews1Root
	dw .UpdateRankingsText - PokemonNews1Root
	dw .CryQuizText - PokemonNews1Root
	dw .ExitText - PokemonNews1Root
	dw .ViewRankingsScript - PokemonNews1Root
	dw .RankingExplanationScript - PokemonNews1Root
	dw .UpdateRankingsScript - PokemonNews1Root
	dw .CryQuizScript - PokemonNews1Root
	dw .ExitScript - PokemonNews1Root
	dw .ViewRankingsDescription - PokemonNews1Root
	dw .RankingExplanationDescription - PokemonNews1Root
	dw .UpdateRankingsDescription - PokemonNews1Root
	dw .CryQuizDescription - PokemonNews1Root
	dw .ExitDescription - PokemonNews1Root

.AButton:
	news_command NewsScript_PlaySound
	db SFX_READ_TEXT
	news_command NewsScript_MenuScript
	news_end

.BButton:
	news_command NewsScript_PlaySound
	db SFX_MENU
	news_command NewsScript_Exit
	news_end

.UpButton:
	news_command NewsScript_MenuUp
	news_end

.DownButton:
	news_command NewsScript_MenuDown
	news_end

.ViewRankingsText:
	db "ランキング <WO>みる@"

.RankingExplanationText:
	db "ランキング <NO>せつめい@"

.UpdateRankingsText:
	db "ランキング <NO>こうしん@"

.CryQuizText:
	db "ポケモンなきごえクイズ@"

.ExitText:
	db "やめる@"

.ViewRankingsScript:
	news_command NewsScript_CompareRAM
	db $05
	dw sPokemonNewsID
	db $0c, $05
	dw sPokemonNewsRankingsID
	dw .ShowMessage - PokemonNews1Root
	dw .OpenRankingCategories - PokemonNews1Root
	dw .ShowMessage - PokemonNews1Root

.OpenRankingCategories:
	news_command NewsScript_LoadScreen
	dw PokemonNews1RankingCategories - PokemonNews1Root
	news_end

.ShowMessage:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message12Text - PokemonNews1Root
	news_end

.RankingExplanationScript:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message11Text - PokemonNews1Root
	news_end

.UpdateRankingsScript:
	news_command NewsScript_UpdateRankings
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_RANKINGS_UPDATE_RESULT
	dw .ShowMessage2 - PokemonNews1Root
	dw .ShowMessage3 - PokemonNews1Root
	dw .ShowMessage4 - PokemonNews1Root
	db $01, $01

.ShowMessage2:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message13Text - PokemonNews1Root
	news_command NewsScript_WaitButton
	news_end

.ShowMessage3:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message14Text - PokemonNews1Root
	news_command NewsScript_WaitButton
	news_end

.ShowMessage4:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message15Text - PokemonNews1Root
	news_command NewsScript_WaitButton
	news_end

.Message13Text:
	db $00, "ランキング<NO>こうしんを<LINE>しました!<DONE>"

.Message14Text:
	db $00, "ランキング<NO>こうしんを<LINE>やめました<DONE>"

.Message15Text:
	db $00, "ランキング<NO>こうしんに<LINE>しっぱい…<PARA>あたらしい"
	db " ニュースを<LINE>よみこんで ください<DONE>"

.CryQuizScript:
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.ExitScript:
	news_command NewsScript_Exit
	news_end

.Message11Text:
	db $00, "3つ<NO>テーマで ランキング!<LINE>いま おくった "
	db "レポート からも<CONT>なにか<GA>ランキング<NI>はいって<CONT>"
	db "いるかも しれません!<PARA><DONE>"

.Message12Text:
	db $00, "ランキングデータ<GA>ありません<LINE>ランキング<NO>こう"
	db "しん<WO>すれば<CONT>みること<GA>できます<PARA><DONE>"

.ViewRankingsDescription:
	db "いろいろな ランキングが<LINE>みれます@"

.RankingExplanationDescription:
	db "ランキング<NO>せつめいです@"

.UpdateRankingsDescription:
	db "さいしん<NO>ランキングを<LINE>ダウンロード します@"

.CryQuizDescription:
	db "#<NO>なきごえ<WO>あててね!@"

.ExitDescription:
	db "ニュース<WO>みるのを<LINE>やめます@"

PokemonNews1RankingCategories:
	db MUSIC_PROF_ELM ; music
	db 0 ; custom palette bitmask
	db 2 ; number of boxes
	db 0, 3, 20, 10, 1, 3 ; x, y, width, height, border, palette
	db 0, 12, 20, 6, 2, 4 ; x, y, width, height, border, palette
	db 1 ; number of strings
	dw 2 * SCREEN_WIDTH + 1 ; tilemap offset
	db "トレーナーランキング@"
	db 2, 5, 1, 4, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 4, 2, 4
	dw .AButton - PokemonNews1RankingCategories ; A
	dw .BButton - PokemonNews1RankingCategories ; B
	dw -1 ; Select
	dw .BButton - PokemonNews1RankingCategories ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews1RankingCategories ; Up
	dw .DownButton - PokemonNews1RankingCategories ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .BattleTowerWinsText - PokemonNews1RankingCategories
	dw .BugContestScoreText - PokemonNews1RankingCategories
	dw .MagikarpLengthText - PokemonNews1RankingCategories
	dw .BackText - PokemonNews1RankingCategories
	dw .BattleTowerWinsScript - PokemonNews1RankingCategories
	dw .BugContestScoreScript - PokemonNews1RankingCategories
	dw .MagikarpLengthScript - PokemonNews1RankingCategories
	dw .BackScript - PokemonNews1RankingCategories
	dw .BattleTowerWinsDescription - PokemonNews1RankingCategories
	dw .BattleTowerWinsDescription - PokemonNews1RankingCategories
	dw .BattleTowerWinsDescription - PokemonNews1RankingCategories
	dw .BattleTowerWinsDescription - PokemonNews1RankingCategories

.AButton:
	news_command NewsScript_PlaySound
	db SFX_READ_TEXT
	news_command NewsScript_MenuScript
	news_end

.UpButton:
	news_command NewsScript_MenuUp
	news_end

.DownButton:
	news_command NewsScript_MenuDown
	news_end

.BButton:
	news_command NewsScript_PlaySound
	db SFX_MENU

.BackScript:
	news_command NewsScript_LoadScreen
	dw PokemonNews1Root - PokemonNews1Root
	news_end

.BattleTowerWinsText:
	db "バトルタワーで かった かいすう@"

.BugContestScoreText:
	db "むしとりたいかい こうとくてん@"

.MagikarpLengthText:
	db "つった コイキング<NO>おおきさ@"

.BackText:
	db "もどる@"

.BattleTowerWinsScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING
	db $00
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_CATEGORY
	db $00
	news_command NewsScript_LoadScreen
	dw PokemonNews1RankingRegions - PokemonNews1Root
	news_end

.BugContestScoreScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING
	db $03
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_CATEGORY
	db $01
	news_command NewsScript_LoadScreen
	dw PokemonNews1RankingRegions - PokemonNews1Root
	news_end

.MagikarpLengthScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING
	db $06
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_CATEGORY
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews1RankingRegions - PokemonNews1Root
	news_end

.BattleTowerWinsDescription:
	db "みたい ランキングを<LINE>えらんで ください@"

PokemonNews1RankingRegions:
	db MUSIC_PROF_ELM ; music
	db 0 ; custom palette bitmask
	db 2 ; number of boxes
	db 0, 3, 20, 10, 1, 3 ; x, y, width, height, border, palette
	db 0, 12, 20, 6, 2, 4 ; x, y, width, height, border, palette
	db 1 ; number of strings
	dw 2 * SCREEN_WIDTH + 1 ; tilemap offset
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_CATEGORY
	dw .Category1Text - PokemonNews1RankingRegions
	dw .Category2Text - PokemonNews1RankingRegions
	dw .Category3Text - PokemonNews1RankingRegions
	db "@"
	db 2, 5, 1, 4, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 4, 2, 4
	dw .AButton - PokemonNews1RankingRegions ; A
	dw .BButton - PokemonNews1RankingRegions ; B
	dw -1 ; Select
	dw .StartButton - PokemonNews1RankingRegions ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews1RankingRegions ; Up
	dw .DownButton - PokemonNews1RankingRegions ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .NationwideText - PokemonNews1RankingRegions
	dw .PrefectureText - PokemonNews1RankingRegions
	dw .PostalCodeText - PokemonNews1RankingRegions
	dw .BackText - PokemonNews1RankingRegions
	dw .NationwideScript - PokemonNews1RankingRegions
	dw .PrefectureScript - PokemonNews1RankingRegions
	dw .PostalCodeScript - PokemonNews1RankingRegions
	dw .BackScript - PokemonNews1RankingRegions
	dw .NationwideDescription - PokemonNews1RankingRegions
	dw .NationwideDescription - PokemonNews1RankingRegions
	dw .NationwideDescription - PokemonNews1RankingRegions
	dw .NationwideDescription - PokemonNews1RankingRegions

.AButton:
	news_command NewsScript_PlaySound
	db SFX_READ_TEXT
	news_command NewsScript_MenuScript
	news_end

.UpButton:
	news_command NewsScript_MenuUp
	news_end

.DownButton:
	news_command NewsScript_MenuDown
	news_end

.StartButton:
	news_command NewsScript_PlaySound
	db SFX_MENU
	news_command NewsScript_LoadScreen
	dw PokemonNews1Root - PokemonNews1Root
	news_end

.NationwideText:
	db "ぜんこく <NO>ランキング@"

.PrefectureText:
	news_text_start
	news_text_command NewsText_PlayerPrefecture
	db $80
	news_text_end
	db " <NO>ランキング@"

.PostalCodeText:
	db NEWS_POSTAL_MARK
	news_text_start
	news_text_command NewsText_PlayerPostalCode
	db $83
	news_text_end
	db " <NO>ランキング@"

.BackText:
	db "もどる@"

.NationwideScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_REGION
	db $00
	news_command NewsScript_LoadScreen
	dw PokemonNews1Rankings - PokemonNews1Root
	news_end

.PrefectureScript:
	news_command NewsScript_AddValue
	dw NEWS_JP_RANKING
	db $01
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_REGION
	db $01
	news_command NewsScript_LoadScreen
	dw PokemonNews1Rankings - PokemonNews1Root
	news_end

.PostalCodeScript:
	news_command NewsScript_AddValue
	dw NEWS_JP_RANKING
	db $02
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_REGION
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews1Rankings - PokemonNews1Root
	news_end

.BButton:
	news_command NewsScript_PlaySound
	db SFX_MENU

.BackScript:
	news_command NewsScript_LoadScreen
	dw PokemonNews1RankingCategories - PokemonNews1Root
	news_end

.NationwideDescription:
	db "みたい ちいき を<LINE>えらんで ください@"

.Category1Text:
	db "バトルタワーで かった かいすう@"

.Category2Text:
	db "むしとりたいかい こうとくてん@"

.Category3Text:
	db "つった コイキング<NO>おおきさ@"

PokemonNews1Rankings:
	db MUSIC_PROF_ELM ; music
	db 0 ; custom palette bitmask
	db 2 ; number of boxes
	db 0, 3, 20, 10, 1, 3 ; x, y, width, height, border, palette
	db 0, 12, 20, 6, 2, 4 ; x, y, width, height, border, palette
	db 2 ; number of strings
	dw 2 * SCREEN_WIDTH + 1 ; tilemap offset
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_CATEGORY
	dw .Category1Text - PokemonNews1Rankings
	dw .Category2Text - PokemonNews1Rankings
	dw .Category3Text - PokemonNews1Rankings
	db "@"
	dw 5 * SCREEN_WIDTH + 2 ; tilemap offset
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_REGION
	dw .Region1Text - PokemonNews1Rankings
	dw .Region2Text - PokemonNews1Rankings
	dw .Region3Text - PokemonNews1Rankings
	db "@"
	db 2, 7, 1, 3, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 3, 2, 3
	dw .AButton - PokemonNews1Rankings ; A
	dw .BButton - PokemonNews1Rankings ; B
	dw -1 ; Select
	dw .StartButton - PokemonNews1Rankings ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews1Rankings ; Up
	dw .DownButton - PokemonNews1Rankings ; Down
	db 11 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 1 ; load ranking
	dw .RankedPlayerText - PokemonNews1Rankings
	dw .RankedPlayerText - PokemonNews1Rankings
	dw .RankedPlayerText - PokemonNews1Rankings
	dw .RankedPlayerText - PokemonNews1Rankings
	dw .RankedPlayerText - PokemonNews1Rankings
	dw .RankedPlayerText - PokemonNews1Rankings
	dw .RankedPlayerText - PokemonNews1Rankings
	dw .RankedPlayerText - PokemonNews1Rankings
	dw .RankedPlayerText - PokemonNews1Rankings
	dw .RankedPlayerText - PokemonNews1Rankings
	dw .PlayerRankingText - PokemonNews1Rankings
	dw .RankedPlayerScript - PokemonNews1Rankings
	dw .RankedPlayerScript - PokemonNews1Rankings
	dw .RankedPlayerScript - PokemonNews1Rankings
	dw .RankedPlayerScript - PokemonNews1Rankings
	dw .RankedPlayerScript - PokemonNews1Rankings
	dw .RankedPlayerScript - PokemonNews1Rankings
	dw .RankedPlayerScript - PokemonNews1Rankings
	dw .RankedPlayerScript - PokemonNews1Rankings
	dw .RankedPlayerScript - PokemonNews1Rankings
	dw .RankedPlayerScript - PokemonNews1Rankings
	dw .PlayerRankingScript - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings
	dw .RankedPlayerDescription - PokemonNews1Rankings

.AButton:
	news_command NewsScript_PlaySound
	db SFX_READ_TEXT
	news_command NewsScript_MenuScript
	news_end

.BButton:
	news_command NewsScript_PlaySound
	db SFX_MENU
	news_command NewsScript_SubtractRAM
	dw NEWS_JP_RANKING
	dw NEWS_JP_RANKING_REGION
	news_command NewsScript_LoadScreen
	dw PokemonNews1RankingRegions - PokemonNews1Root
	news_end

.UpButton:
	news_command NewsScript_MenuUp
	news_end

.DownButton:
	news_command NewsScript_MenuDown
	news_end

.StartButton:
	news_command NewsScript_PlaySound
	db SFX_MENU
	news_command NewsScript_LoadScreen
	dw PokemonNews1Root - PokemonNews1Root
	news_end

.RankedPlayerText:
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_CATEGORY
	dw .Category1Text2 - PokemonNews1Rankings
	dw .Category2Text2 - PokemonNews1Rankings
	dw .Category3Text2 - PokemonNews1Rankings
	db "@"

.Category1Text2:
	news_text_start
	news_text_command NewsText_RankingIndicator
	db $02, $03
	news_text_command NewsText_RankingText
	dw $0000
	db $06, $06
	news_text_command NewsText_RankingNumber
	dw $0018
	db $02, $05, $05, $00, $00
	news_text_end
	db "かい@"

.Category2Text2:
	news_text_start
	news_text_command NewsText_RankingIndicator
	db $02, $03
	news_text_command NewsText_RankingText
	dw $0000
	db $06, $06
	news_text_command NewsText_RankingNumber
	dw $0018
	db $02, $05, $05, $00, $00
	news_text_end
	db "てん@"

.Category3Text2:
	news_text_start
	news_text_command NewsText_RankingIndicator
	db $02, $03
	news_text_command NewsText_RankingText
	dw $0000
	db $06, $06
	news_text_command NewsText_RankingNumber
	dw $0018
	db $82, $04, $05, $04, $f2
	news_text_end
	db "センチ@"

.PlayerRankingText:
	news_text_start
	news_text_command NewsText_PlayerName
	db $00
	news_text_end
	db " <NO>じゅんい@"

.RankedPlayerScript:
	news_command NewsScript_CompareRAM
	db $00
	dw $cd22
	db $01, $00
	dw $cd5c
	dw .ShowMessage - PokemonNews1Rankings
	dw .ShowMessage2 - PokemonNews1Rankings
	dw .ShowMessage2 - PokemonNews1Rankings

.ShowMessage:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message13Text - PokemonNews1Rankings
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message14Text - PokemonNews1Rankings
	news_end

.ShowMessage2:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message15Text - PokemonNews1Rankings
	news_end

.Message15Text:
	db "ここに<WA>だれも<NEXT>ランクイン してません<PARA>@"

.PlayerRankingScript:
	news_command NewsScript_CompareRAM
	db $00
	dw NEWS_JP_PLAYER_RANKING
	db $04, $00
	dw NEWS_JP_RANKING_TOTAL
	dw .ShowMessage3 - PokemonNews1Rankings
	dw .ShowMessage3 - PokemonNews1Rankings
	dw .ShowMessage4 - PokemonNews1Rankings

.ShowMessage3:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message16Text - PokemonNews1Rankings
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_PLAYER_RANKING
	dw .Script12 - PokemonNews1Rankings
	dw .CheckValue - PokemonNews1Rankings
	dw .Script12 - PokemonNews1Rankings
	db $04, $00, $00, $00, $01

.CheckValue:
	news_command NewsScript_CompareBytes
	db $05
	dw sPokemonNews
	dw .Script12 - PokemonNews1Rankings
	dw .SetValue - PokemonNews1Rankings
	dw .Script12 - PokemonNews1Rankings
	db $01, $00

.SetValue:
	news_command NewsScript_SetValue
	dw $cd6a
	db $01
	news_command NewsScript_CopyBytes
	dw $cd6a
	dw sPokemonNews
	db $05
	dw $0001
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message21Text - PokemonNews1Rankings
	news_command NewsScript_WaitButton

.Script12:
	news_end

.ShowMessage4:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message17Text - PokemonNews1Rankings
	news_end

.Message21Text:
	db $00, "ランキングで トップ<WO>とった<NEXT>あなたに…<CONT>すて"
	db "きな プレゼント<GA>あります<CONT>おたのしみに!<DONE>"

.Message13Text:
	news_text_start
	news_text_command NewsText_RankingGender
	dw $000b
	db $04
	news_text_command NewsText_RankingNumber
	dw $000a
	db $01, $03, $04, $00, $00
	news_text_end
	db "さい "
	news_text_start
	news_text_command NewsText_RankingPrefecture
	dw $0007
	db $07
	news_text_end
	db "<PARA>@"

.Message14Text:
	news_text_start
	news_text_command NewsText_RankingMessage
	dw $000c
	news_text_end
	db "<PARA>@"

.Message16Text:
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_CATEGORY
	dw .Category1Text3 - PokemonNews1Rankings
	dw .Category2Text3 - PokemonNews1Rankings
	dw .Category3Text3 - PokemonNews1Rankings
	news_text_start
	news_text_command NewsText_PlayerName
	db $00
	news_text_end
	db " <NO>じゅんいは…<PARA>"
	news_text_start
	news_text_command NewsText_Number
	db $00
	dw NEWS_JP_PLAYER_RANKING
	db $04, $04, $04, $00, $00
	news_text_end
	db " ばん <NI>ランクイン!<LINE>おめでとう!<PARA>@"

.Message17Text:
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_CATEGORY
	dw .Category1Text3 - PokemonNews1Rankings
	dw .Category2Text3 - PokemonNews1Rankings
	dw .Category3Text3 - PokemonNews1Rankings
	news_text_start
	news_text_command NewsText_PlayerName
	db $00
	news_text_end
	db " <NO>じゅんいは…<PARA>ランクイン しなかった…<LINE>ざん"
	db "ねん…<PARA>@"

.Category1Text3:
	news_text_start
	news_text_command NewsText_PlayerName
	db $00
	news_text_end
	db " <NO>せいせきは<LINE>"
	news_text_start
	news_text_command NewsText_Number
	db $05
	dw $a016
	db $02, $05, $05, $00, $00
	news_text_end
	db "かい<PARA>@"

.Category2Text3:
	news_text_start
	news_text_command NewsText_PlayerName
	db $00
	news_text_end
	db " <NO>せいせきは<LINE>"
	news_text_start
	news_text_command NewsText_Number
	db $05
	dw $a07f
	db $02, $05, $05, $00, $00
	news_text_end
	db "てん<PARA>@"

.Category3Text3:
	news_text_start
	news_text_command NewsText_PlayerName
	db $00
	news_text_end
	db " <NO>せいせきは<LINE>"
	news_text_start
	news_text_command NewsText_Number
	db $05
	dw $a07b
	db $82, $04, $05, $04, $f2
	news_text_end
	db "センチ<PARA>@"

.RankedPlayerDescription:
	db "えらんだ ひと<NO>データを<LINE>みること<GA>できます@"

.Category1Text:
	db "バトルタワーで かった かいすう@"

.Category2Text:
	db "むしとりたいかい こうとくてん@"

.Category3Text:
	db "つった コイキング<NO>おおきさ@"

.Region1Text:
	db "ぜんこく <NO>トップ10!@"

.Region2Text:
	news_text_start
	news_text_command NewsText_PlayerPrefecture
	db $80
	news_text_end
	db " <NO>トップ10!@"

.Region3Text:
	db NEWS_POSTAL_MARK
	news_text_start
	news_text_command NewsText_PlayerPostalCode
	db $83
	news_text_end
	db " <NO>トップ10!@"

PokemonNews1CryQuizMenu:
	db MUSIC_SHOW_ME_AROUND ; music
	db 0 ; custom palette bitmask
	db 2 ; number of boxes
	db 0, 3, 20, 10, 5, 3 ; x, y, width, height, border, palette
	db 0, 12, 20, 6, 2, 4 ; x, y, width, height, border, palette
	db 1 ; number of strings
	dw 2 * SCREEN_WIDTH + 1 ; tilemap offset
	db "ポケモンなきごえクイズ@"
	db 2, 5, 1, 4, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 4, 3, 4
	dw .AButton - PokemonNews1CryQuizMenu ; A
	dw .BButton - PokemonNews1CryQuizMenu ; B
	dw -1 ; Select
	dw .BButton - PokemonNews1CryQuizMenu ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews1CryQuizMenu ; Up
	dw .DownButton - PokemonNews1CryQuizMenu ; Down
	db 11 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .SuicuneText - PokemonNews1CryQuizMenu
	dw .ClefairyText - PokemonNews1CryQuizMenu
	dw .SpearowText - PokemonNews1CryQuizMenu
	dw .GastlyText - PokemonNews1CryQuizMenu
	dw .TogepiText - PokemonNews1CryQuizMenu
	dw .ZubatText - PokemonNews1CryQuizMenu
	dw .JynxText - PokemonNews1CryQuizMenu
	dw .EspeonText - PokemonNews1CryQuizMenu
	dw .MewtwoText - PokemonNews1CryQuizMenu
	dw .DunsparceText - PokemonNews1CryQuizMenu
	dw .BackText - PokemonNews1CryQuizMenu
	dw .SuicuneScript - PokemonNews1CryQuizMenu
	dw .ClefairyScript - PokemonNews1CryQuizMenu
	dw .SpearowScript - PokemonNews1CryQuizMenu
	dw .GastlyScript - PokemonNews1CryQuizMenu
	dw .TogepiScript - PokemonNews1CryQuizMenu
	dw .ZubatScript - PokemonNews1CryQuizMenu
	dw .JynxScript - PokemonNews1CryQuizMenu
	dw .EspeonScript - PokemonNews1CryQuizMenu
	dw .MewtwoScript - PokemonNews1CryQuizMenu
	dw .DunsparceScript - PokemonNews1CryQuizMenu
	dw .BackScript - PokemonNews1CryQuizMenu
	dw .SuicuneDescription - PokemonNews1CryQuizMenu
	dw .SuicuneDescription - PokemonNews1CryQuizMenu
	dw .SuicuneDescription - PokemonNews1CryQuizMenu
	dw .SuicuneDescription - PokemonNews1CryQuizMenu
	dw .SuicuneDescription - PokemonNews1CryQuizMenu
	dw .SuicuneDescription - PokemonNews1CryQuizMenu
	dw .SuicuneDescription - PokemonNews1CryQuizMenu
	dw .SuicuneDescription - PokemonNews1CryQuizMenu
	dw .SuicuneDescription - PokemonNews1CryQuizMenu
	dw .SuicuneDescription - PokemonNews1CryQuizMenu
	dw .BackDescription - PokemonNews1CryQuizMenu

.AButton:
	news_command NewsScript_PlaySound
	db SFX_READ_TEXT
	news_command NewsScript_MenuScript
	news_end

.UpButton:
	news_command NewsScript_MenuUp
	news_end

.DownButton:
	news_command NewsScript_MenuDown
	news_end

.BButton:
	news_command NewsScript_PlaySound
	db SFX_MENU
	news_command NewsScript_LoadScreen
	dw PokemonNews1Root - PokemonNews1Root
	news_end

.SuicuneText:
	db "スイクン@"

.ClefairyText:
	db "ピッピ@"

.SpearowText:
	db "オニスズメ@"

.GastlyText:
	db "ゴース@"

.TogepiText:
	db "トゲピー@"

.ZubatText:
	db "ズバット@"

.JynxText:
	db "ルージュラ@"

.EspeonText:
	db "エーフィ@"

.MewtwoText:
	db "ミュウツー@"

.DunsparceText:
	db "ノコッチ@"

.BackText:
	db "もどる@"

.SuicuneScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_POKEMON
	db $00
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.ClefairyScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_POKEMON
	db $01
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.SpearowScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_POKEMON
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.GastlyScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_POKEMON
	db $03
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.TogepiScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_POKEMON
	db $04
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.ZubatScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_POKEMON
	db $05
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.JynxScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_POKEMON
	db $06
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.EspeonScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_POKEMON
	db $07
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.MewtwoScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_POKEMON
	db $08
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.DunsparceScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_POKEMON
	db $09
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.BackScript:
	news_command NewsScript_LoadScreen
	dw PokemonNews1Root - PokemonNews1Root
	news_end

.SuicuneDescription:
	db "なきごえ<GA>わかる #を<LINE>えらんでください!@"

.BackDescription:
	db "なきごえクイズ<WO>やめます@"

PokemonNews1CryQuiz:
	db MUSIC_SHOW_ME_AROUND ; music
	db 0 ; custom palette bitmask
	db 2 ; number of boxes
	db 0, 3, 20, 10, 5, 3 ; x, y, width, height, border, palette
	db 0, 12, 20, 6, 2, 4 ; x, y, width, height, border, palette
	db 1 ; number of strings
	dw 2 * SCREEN_WIDTH + 1 ; tilemap offset
	news_text_start
	news_text_command NewsText_Switch
	db 10
	dw NEWS_JP_QUIZ_POKEMON
	dw .Pokemon1Text - PokemonNews1CryQuiz
	dw .Pokemon2Text - PokemonNews1CryQuiz
	dw .Pokemon3Text - PokemonNews1CryQuiz
	dw .Pokemon4Text - PokemonNews1CryQuiz
	dw .Pokemon5Text - PokemonNews1CryQuiz
	dw .Pokemon6Text - PokemonNews1CryQuiz
	dw .Pokemon7Text - PokemonNews1CryQuiz
	dw .Pokemon8Text - PokemonNews1CryQuiz
	dw .Pokemon9Text - PokemonNews1CryQuiz
	dw .Pokemon10Text - PokemonNews1CryQuiz
	db "@"
	db 2, 5, 1, 4, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 4, 2, 4
	dw .AButton - PokemonNews1CryQuiz ; A
	dw .BButton - PokemonNews1CryQuiz ; B
	dw -1 ; Select
	dw .BButton - PokemonNews1CryQuiz ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews1CryQuiz ; Up
	dw .DownButton - PokemonNews1CryQuiz ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .FirstCryText - PokemonNews1CryQuiz
	dw .SecondCryText - PokemonNews1CryQuiz
	dw .ThirdCryText - PokemonNews1CryQuiz
	dw .BackText - PokemonNews1CryQuiz
	dw .FirstCryScript - PokemonNews1CryQuiz
	dw .SecondCryScript - PokemonNews1CryQuiz
	dw .ThirdCryScript - PokemonNews1CryQuiz
	dw .BackScript - PokemonNews1CryQuiz
	dw .FirstCryDescription - PokemonNews1CryQuiz
	dw .FirstCryDescription - PokemonNews1CryQuiz
	dw .FirstCryDescription - PokemonNews1CryQuiz
	dw .FirstCryDescription - PokemonNews1CryQuiz

.AButton:
	news_command NewsScript_MenuScript
	news_end

.UpButton:
	news_command NewsScript_MenuUp
	news_end

.DownButton:
	news_command NewsScript_MenuDown
	news_end

.BButton:
	news_command NewsScript_PlaySound
	db SFX_MENU
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.FirstCryText:
	db "なきごえ1@"

.SecondCryText:
	db "なきごえ2@"

.ThirdCryText:
	db "なきごえ3@"

.BackText:
	db "もどる@"

.FirstCryScript:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message16Text - PokemonNews1CryQuiz
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon - PokemonNews1CryQuiz
	dw .MOLTRESCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon - PokemonNews1CryQuiz
	db $01, $00

.MOLTRESCry:
	news_command NewsScript_PlayCry
	db MOLTRES
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon2 - PokemonNews1CryQuiz
	dw .JIGGLYPUFFCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon2 - PokemonNews1CryQuiz
	db $01, $01

.JIGGLYPUFFCry:
	news_command NewsScript_PlayCry
	db JIGGLYPUFF
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon2:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon3 - PokemonNews1CryQuiz
	dw .NATUCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon3 - PokemonNews1CryQuiz
	db $01, $02

.NATUCry:
	news_command NewsScript_PlayCry
	db NATU
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon3:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon4 - PokemonNews1CryQuiz
	dw .SPINARAKCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon4 - PokemonNews1CryQuiz
	db $01, $03

.SPINARAKCry:
	news_command NewsScript_PlayCry
	db SPINARAK
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon4:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon5 - PokemonNews1CryQuiz
	dw .TOGEPICry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon5 - PokemonNews1CryQuiz
	db $01, $04

.TOGEPICry:
	news_command NewsScript_PlayCry
	db TOGEPI
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $00
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon5:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon6 - PokemonNews1CryQuiz
	dw .ZUBATCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon6 - PokemonNews1CryQuiz
	db $01, $05

.ZUBATCry:
	news_command NewsScript_PlayCry
	db ZUBAT
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $00
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon6:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon7 - PokemonNews1CryQuiz
	dw .MANKEYCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon7 - PokemonNews1CryQuiz
	db $01, $06

.MANKEYCry:
	news_command NewsScript_PlayCry
	db MANKEY
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon7:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon8 - PokemonNews1CryQuiz
	dw .PERSIANCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon8 - PokemonNews1CryQuiz
	db $01, $07

.PERSIANCry:
	news_command NewsScript_PlayCry
	db PERSIAN
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon8:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon9 - PokemonNews1CryQuiz
	dw .MEWCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon9 - PokemonNews1CryQuiz
	db $01, $08

.MEWCry:
	news_command NewsScript_PlayCry
	db MEW
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon9:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .Script79 - PokemonNews1CryQuiz
	dw .DUNSPARCECry - PokemonNews1CryQuiz
	dw .Script79 - PokemonNews1CryQuiz
	db $01, $09

.DUNSPARCECry:
	news_command NewsScript_PlayCry
	db DUNSPARCE
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $00
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.Script79:
	news_end

.SecondCryScript:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message16Text - PokemonNews1CryQuiz
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon10 - PokemonNews1CryQuiz
	dw .LAPRASCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon10 - PokemonNews1CryQuiz
	db $01, $00

.LAPRASCry:
	news_command NewsScript_PlayCry
	db LAPRAS
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon10:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon11 - PokemonNews1CryQuiz
	dw .TOGETICCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon11 - PokemonNews1CryQuiz
	db $01, $01

.TOGETICCry:
	news_command NewsScript_PlayCry
	db TOGETIC
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon11:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon12 - PokemonNews1CryQuiz
	dw .WEEDLECry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon12 - PokemonNews1CryQuiz
	db $01, $02

.WEEDLECry:
	news_command NewsScript_PlayCry
	db WEEDLE
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon12:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon13 - PokemonNews1CryQuiz
	dw .GASTLYCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon13 - PokemonNews1CryQuiz
	db $01, $03

.GASTLYCry:
	news_command NewsScript_PlayCry
	db GASTLY
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $00
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon13:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon14 - PokemonNews1CryQuiz
	dw .MARILLCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon14 - PokemonNews1CryQuiz
	db $01, $04

.MARILLCry:
	news_command NewsScript_PlayCry
	db MARILL
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon14:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon15 - PokemonNews1CryQuiz
	dw .MAREEPCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon15 - PokemonNews1CryQuiz
	db $01, $05

.MAREEPCry:
	news_command NewsScript_PlayCry
	db MAREEP
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon15:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon16 - PokemonNews1CryQuiz
	dw .JYNXCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon16 - PokemonNews1CryQuiz
	db $01, $06

.JYNXCry:
	news_command NewsScript_PlayCry
	db JYNX
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $00
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon16:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon17 - PokemonNews1CryQuiz
	dw .PHANPYCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon17 - PokemonNews1CryQuiz
	db $01, $07

.PHANPYCry:
	news_command NewsScript_PlayCry
	db PHANPY
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon17:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon18 - PokemonNews1CryQuiz
	dw .MEWTWOCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon18 - PokemonNews1CryQuiz
	db $01, $08

.MEWTWOCry:
	news_command NewsScript_PlayCry
	db MEWTWO
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $00
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon18:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .Script83 - PokemonNews1CryQuiz
	dw .YANMACry - PokemonNews1CryQuiz
	dw .Script83 - PokemonNews1CryQuiz
	db $01, $09

.YANMACry:
	news_command NewsScript_PlayCry
	db YANMA
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.Script83:
	news_end

.ThirdCryScript:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message16Text - PokemonNews1CryQuiz
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon19 - PokemonNews1CryQuiz
	dw .SUICUNECry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon19 - PokemonNews1CryQuiz
	db $01, $00

.SUICUNECry:
	news_command NewsScript_PlayCry
	db SUICUNE
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $00
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon19:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon20 - PokemonNews1CryQuiz
	dw .CLEFAIRYCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon20 - PokemonNews1CryQuiz
	db $01, $01

.CLEFAIRYCry:
	news_command NewsScript_PlayCry
	db CLEFAIRY
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $00
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon20:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon21 - PokemonNews1CryQuiz
	dw .SPEAROWCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon21 - PokemonNews1CryQuiz
	db $01, $02

.SPEAROWCry:
	news_command NewsScript_PlayCry
	db SPEAROW
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $00
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon21:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon22 - PokemonNews1CryQuiz
	dw .PIDGEOTTOCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon22 - PokemonNews1CryQuiz
	db $01, $03

.PIDGEOTTOCry:
	news_command NewsScript_PlayCry
	db PIDGEOTTO
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon22:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon23 - PokemonNews1CryQuiz
	dw .GOLDEENCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon23 - PokemonNews1CryQuiz
	db $01, $04

.GOLDEENCry:
	news_command NewsScript_PlayCry
	db GOLDEEN
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon23:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon24 - PokemonNews1CryQuiz
	dw .UNOWNCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon24 - PokemonNews1CryQuiz
	db $01, $05

.UNOWNCry:
	news_command NewsScript_PlayCry
	db UNOWN
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon24:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon25 - PokemonNews1CryQuiz
	dw .CLOYSTERCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon25 - PokemonNews1CryQuiz
	db $01, $06

.CLOYSTERCry:
	news_command NewsScript_PlayCry
	db CLOYSTER
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon25:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon26 - PokemonNews1CryQuiz
	dw .ESPEONCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon26 - PokemonNews1CryQuiz
	db $01, $07

.ESPEONCry:
	news_command NewsScript_PlayCry
	db ESPEON
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $00
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon26:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon27 - PokemonNews1CryQuiz
	dw .PARASECTCry - PokemonNews1CryQuiz
	dw .CheckQuizPokemon27 - PokemonNews1CryQuiz
	db $01, $08

.PARASECTCry:
	news_command NewsScript_PlayCry
	db PARASECT
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.CheckQuizPokemon27:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .Script85 - PokemonNews1CryQuiz
	dw .QWILFISHCry - PokemonNews1CryQuiz
	dw .Script85 - PokemonNews1CryQuiz
	db $01, $09

.QWILFISHCry:
	news_command NewsScript_PlayCry
	db QWILFISH
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_ANSWER
	db $01
	news_command NewsScript_YesNo
	db $0d, $07
	dw .CheckQuizAnswer - PokemonNews1CryQuiz
	dw .ShowMessage - PokemonNews1CryQuiz
	news_end

.Script85:
	news_end

.BackScript:
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.CheckQuizAnswer:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_ANSWER
	dw .Delay2 - PokemonNews1CryQuiz
	dw .Delay - PokemonNews1CryQuiz
	dw .Delay2 - PokemonNews1CryQuiz
	db $01, $00

.Delay:
	news_command NewsScript_Delay
	db $14
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message19Text - PokemonNews1CryQuiz
	news_command NewsScript_PlaySound
	db SFX_DEX_FANFARE_50_79
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon28 - PokemonNews1CryQuiz
	dw .PokemonPic - PokemonNews1CryQuiz
	dw .CheckQuizPokemon28 - PokemonNews1CryQuiz
	db $01, $00

.PokemonPic:
	news_command NewsScript_PokemonPic
	dw $006f
	db $f5, $03, $07
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.CheckQuizPokemon28:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon29 - PokemonNews1CryQuiz
	dw .PokemonPic2 - PokemonNews1CryQuiz
	dw .CheckQuizPokemon29 - PokemonNews1CryQuiz
	db $01, $01

.PokemonPic2:
	news_command NewsScript_PokemonPic
	dw $006f
	db $23, $03, $07
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.CheckQuizPokemon29:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon30 - PokemonNews1CryQuiz
	dw .PokemonPic3 - PokemonNews1CryQuiz
	dw .CheckQuizPokemon30 - PokemonNews1CryQuiz
	db $01, $02

.PokemonPic3:
	news_command NewsScript_PokemonPic
	dw $006f
	db $15, $03, $07
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.CheckQuizPokemon30:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon31 - PokemonNews1CryQuiz
	dw .PokemonPic4 - PokemonNews1CryQuiz
	dw .CheckQuizPokemon31 - PokemonNews1CryQuiz
	db $01, $03

.PokemonPic4:
	news_command NewsScript_PokemonPic
	dw $006f
	db $5c, $03, $07
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.CheckQuizPokemon31:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon32 - PokemonNews1CryQuiz
	dw .PokemonPic5 - PokemonNews1CryQuiz
	dw .CheckQuizPokemon32 - PokemonNews1CryQuiz
	db $01, $04

.PokemonPic5:
	news_command NewsScript_PokemonPic
	dw $006f
	db $af, $03, $07
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.CheckQuizPokemon32:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon33 - PokemonNews1CryQuiz
	dw .PokemonPic6 - PokemonNews1CryQuiz
	dw .CheckQuizPokemon33 - PokemonNews1CryQuiz
	db $01, $05

.PokemonPic6:
	news_command NewsScript_PokemonPic
	dw $006f
	db $29, $03, $07
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.CheckQuizPokemon33:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon34 - PokemonNews1CryQuiz
	dw .PokemonPic7 - PokemonNews1CryQuiz
	dw .CheckQuizPokemon34 - PokemonNews1CryQuiz
	db $01, $06

.PokemonPic7:
	news_command NewsScript_PokemonPic
	dw $006f
	db $7c, $03, $07
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.CheckQuizPokemon34:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon35 - PokemonNews1CryQuiz
	dw .PokemonPic8 - PokemonNews1CryQuiz
	dw .CheckQuizPokemon35 - PokemonNews1CryQuiz
	db $01, $07

.PokemonPic8:
	news_command NewsScript_PokemonPic
	dw $006f
	db $c4, $03, $07
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.CheckQuizPokemon35:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .CheckQuizPokemon36 - PokemonNews1CryQuiz
	dw .PokemonPic9 - PokemonNews1CryQuiz
	dw .CheckQuizPokemon36 - PokemonNews1CryQuiz
	db $01, $08

.PokemonPic9:
	news_command NewsScript_PokemonPic
	dw $006f
	db $96, $03, $07
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.CheckQuizPokemon36:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_POKEMON
	dw .Script91 - PokemonNews1CryQuiz
	dw .PokemonPic10 - PokemonNews1CryQuiz
	dw .Script91 - PokemonNews1CryQuiz
	db $01, $09

.PokemonPic10:
	news_command NewsScript_PokemonPic
	dw $006f
	db $ce, $03, $07
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuizMenu - PokemonNews1Root
	news_end

.Script91:
	news_end

.Delay2:
	news_command NewsScript_Delay
	db $14
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message18Text - PokemonNews1CryQuiz
	news_command NewsScript_PlaySound
	db SFX_WRONG
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews1CryQuiz - PokemonNews1Root
	news_end

.ShowMessage:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message17Text - PokemonNews1CryQuiz
	news_end

.FirstCryDescription:
	db "なきごえは どれ?@"

.Message16Text:
	db "この なきごえ ですか?@"

.Message19Text:
	db "あたり!!!@"

.Message18Text:
	db "はずれ<……>…@"

.Message17Text:
	db "なきごえは どれ?@"

.Pokemon1Text:
	db "なきごえクイズ スイクン@"

.Pokemon2Text:
	db "なきごえクイズ ピッピ@"

.Pokemon3Text:
	db "なきごえクイズ オニスズメ@"

.Pokemon4Text:
	db "なきごえクイズ ゴース@"

.Pokemon5Text:
	db "なきごえクイズ トゲピー@"

.Pokemon6Text:
	db "なきごえクイズ ズバット@"

.Pokemon7Text:
	db "なきごえクイズ ルージュラ@"

.Pokemon8Text:
	db "なきごえクイズ エーフィ@"

.Pokemon9Text:
	db "なきごえクイズ ミュウツー@"

.Pokemon10Text:
	db "なきごえクイズ ノコッチ@"

PokemonNews1End:
	assert PokemonNews1End - PokemonNews1 == $0da6
