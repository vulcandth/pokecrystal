; Built-in Japanese Pokémon News sample 3.
PokemonNews3:
	dw sPokemonNews
	dw $2751 ; checksum of the payload
	dw PokemonNews3End - PokemonNews3Root

PokemonNews3Root:
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
	dw .AButton - PokemonNews3Root ; A
	dw .BButton - PokemonNews3Root ; B
	dw -1 ; Select
	dw -1 ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews3Root ; Up
	dw .DownButton - PokemonNews3Root ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .ViewRankingsText - PokemonNews3Root
	dw .RankingExplanationText - PokemonNews3Root
	dw .UpdateRankingsText - PokemonNews3Root
	dw .ExitText - PokemonNews3Root
	dw .ViewRankingsScript - PokemonNews3Root
	dw .RankingExplanationScript - PokemonNews3Root
	dw .UpdateRankingsScript - PokemonNews3Root
	dw .ExitScript - PokemonNews3Root
	dw .ViewRankingsDescription - PokemonNews3Root
	dw .RankingExplanationDescription - PokemonNews3Root
	dw .UpdateRankingsDescription - PokemonNews3Root
	dw .ExitDescription - PokemonNews3Root

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

.ExitText:
	db "やめる@"

.ViewRankingsScript:
	news_command NewsScript_CompareRAM
	db $85
	dw sPokemonNewsID
	db $0c, $85
	dw sPokemonNewsRankingsID
	dw .ShowMessage - PokemonNews3Root
	dw .OpenRankingCategories - PokemonNews3Root
	dw .ShowMessage - PokemonNews3Root

.OpenRankingCategories:
	news_command NewsScript_LoadScreen
	dw PokemonNews3RankingCategories - PokemonNews3Root
	news_end

.ShowMessage:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message10Text - PokemonNews3Root
	news_end

.RankingExplanationScript:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message9Text - PokemonNews3Root
	news_end

.UpdateRankingsScript:
	news_command NewsScript_UpdateRankings
	news_end

.ExitScript:
	news_command NewsScript_Exit
	news_end

.Message9Text:
	db $00, "3つ<NO>テーマで ランキング!<LINE>いま おくった "
	db "レポート からも<CONT>なにか<GA>ランキング<NI>はいって<CONT>"
	db "いるかも しれません!<PARA><DONE>"

.Message10Text:
	db $00, "ランキングデータ<GA>ありません<LINE>ランキング<NO>こう"
	db "しん<WO>すれば<CONT>みること<GA>できます<PARA><DONE>"

.ViewRankingsDescription:
	db "いろいろな ランキングが<LINE>みれます@"

.RankingExplanationDescription:
	db "ランキング<NO>せつめいです@"

.UpdateRankingsDescription:
	db "さいしん<NO>ランキングを<LINE>ダウンロード します@"

.ExitDescription:
	db "ニュース<WO>みるのを<LINE>やめます@"

PokemonNews3RankingCategories:
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
	dw .AButton - PokemonNews3RankingCategories ; A
	dw .BButton - PokemonNews3RankingCategories ; B
	dw -1 ; Select
	dw .BButton - PokemonNews3RankingCategories ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews3RankingCategories ; Up
	dw .DownButton - PokemonNews3RankingCategories ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .ColosseumWinsText - PokemonNews3RankingCategories
	dw .BugContestScoreText - PokemonNews3RankingCategories
	dw .MagikarpLengthText - PokemonNews3RankingCategories
	dw .BackText - PokemonNews3RankingCategories
	dw .ColosseumWinsScript - PokemonNews3RankingCategories
	dw .BugContestScoreScript - PokemonNews3RankingCategories
	dw .MagikarpLengthScript - PokemonNews3RankingCategories
	dw .BackScript - PokemonNews3RankingCategories
	dw .ColosseumWinsDescription - PokemonNews3RankingCategories
	dw .ColosseumWinsDescription - PokemonNews3RankingCategories
	dw .ColosseumWinsDescription - PokemonNews3RankingCategories
	dw .ColosseumWinsDescription - PokemonNews3RankingCategories

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
	dw PokemonNews3Root - PokemonNews3Root
	news_end

.ColosseumWinsText:
	db "コロシアムで かった かいすう@"

.BugContestScoreText:
	db "むしとりたいかい こうとくてん@"

.MagikarpLengthText:
	db "つった コイキング<NO>おおきさ@"

.BackText:
	db "もどる@"

.ColosseumWinsScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING
	db $00
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_CATEGORY
	db $00
	news_command NewsScript_LoadScreen
	dw PokemonNews3RankingRegions - PokemonNews3Root
	news_end

.BugContestScoreScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING
	db $03
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_CATEGORY
	db $01
	news_command NewsScript_LoadScreen
	dw PokemonNews3RankingRegions - PokemonNews3Root
	news_end

.MagikarpLengthScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING
	db $06
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_CATEGORY
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews3RankingRegions - PokemonNews3Root
	news_end

.ColosseumWinsDescription:
	db "みたい ランキングを<LINE>えらんで ください@"

PokemonNews3RankingRegions:
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
	dw .Category1Text - PokemonNews3RankingRegions
	dw .Category2Text - PokemonNews3RankingRegions
	dw .Category3Text - PokemonNews3RankingRegions
	db "@"
	db 2, 5, 1, 4, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 4, 2, 4
	dw .AButton - PokemonNews3RankingRegions ; A
	dw .BButton - PokemonNews3RankingRegions ; B
	dw -1 ; Select
	dw .StartButton - PokemonNews3RankingRegions ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews3RankingRegions ; Up
	dw .DownButton - PokemonNews3RankingRegions ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .NationwideText - PokemonNews3RankingRegions
	dw .PrefectureText - PokemonNews3RankingRegions
	dw .PostalCodeText - PokemonNews3RankingRegions
	dw .BackText - PokemonNews3RankingRegions
	dw .NationwideScript - PokemonNews3RankingRegions
	dw .PrefectureScript - PokemonNews3RankingRegions
	dw .PostalCodeScript - PokemonNews3RankingRegions
	dw .BackScript - PokemonNews3RankingRegions
	dw .NationwideDescription - PokemonNews3RankingRegions
	dw .NationwideDescription - PokemonNews3RankingRegions
	dw .NationwideDescription - PokemonNews3RankingRegions
	dw .NationwideDescription - PokemonNews3RankingRegions

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
	dw PokemonNews3Root - PokemonNews3Root
	news_end

.NationwideText:
	db "ぜんこく <NO>ランキング@"

.PrefectureText:
	db "とどうふけん <NO>ランキング@"

.PostalCodeText:
	db "ゆうびんばんごう <NO>ランキング@"

.BackText:
	db "もどる@"

.NationwideScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_REGION
	db $00
	news_command NewsScript_LoadScreen
	dw PokemonNews3Rankings - PokemonNews3Root
	news_end

.PrefectureScript:
	news_command NewsScript_AddValue
	dw NEWS_JP_RANKING
	db $01
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_REGION
	db $01
	news_command NewsScript_LoadScreen
	dw PokemonNews3Rankings - PokemonNews3Root
	news_end

.PostalCodeScript:
	news_command NewsScript_AddValue
	dw NEWS_JP_RANKING
	db $02
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_REGION
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews3Rankings - PokemonNews3Root
	news_end

.BButton:
	news_command NewsScript_PlaySound
	db SFX_MENU

.BackScript:
	news_command NewsScript_LoadScreen
	dw PokemonNews3RankingCategories - PokemonNews3Root
	news_end

.NationwideDescription:
	db "みたい ちいき を<LINE>えらんで ください@"

.Category1Text:
	db "コロシアムで かった かいすう@"

.Category2Text:
	db "むしとりたいかい こうとくてん@"

.Category3Text:
	db "つった コイキング<NO>おおきさ@"

PokemonNews3Rankings:
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
	dw .Category1Text - PokemonNews3Rankings
	dw .Category2Text - PokemonNews3Rankings
	dw .Category3Text - PokemonNews3Rankings
	db "@"
	dw 5 * SCREEN_WIDTH + 2 ; tilemap offset
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_REGION
	dw .Region1Text - PokemonNews3Rankings
	dw .Region2Text - PokemonNews3Rankings
	dw .Region3Text - PokemonNews3Rankings
	db "@"
	db 2, 7, 1, 3, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 3, 2, 3
	dw .AButton - PokemonNews3Rankings ; A
	dw .BButton - PokemonNews3Rankings ; B
	dw -1 ; Select
	dw .StartButton - PokemonNews3Rankings ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews3Rankings ; Up
	dw .DownButton - PokemonNews3Rankings ; Down
	db 11 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 1 ; load ranking
	dw .RankedPlayerText - PokemonNews3Rankings
	dw .RankedPlayerText - PokemonNews3Rankings
	dw .RankedPlayerText - PokemonNews3Rankings
	dw .RankedPlayerText - PokemonNews3Rankings
	dw .RankedPlayerText - PokemonNews3Rankings
	dw .RankedPlayerText - PokemonNews3Rankings
	dw .RankedPlayerText - PokemonNews3Rankings
	dw .RankedPlayerText - PokemonNews3Rankings
	dw .RankedPlayerText - PokemonNews3Rankings
	dw .RankedPlayerText - PokemonNews3Rankings
	dw .PlayerRankingText - PokemonNews3Rankings
	dw .RankedPlayerScript - PokemonNews3Rankings
	dw .RankedPlayerScript - PokemonNews3Rankings
	dw .RankedPlayerScript - PokemonNews3Rankings
	dw .RankedPlayerScript - PokemonNews3Rankings
	dw .RankedPlayerScript - PokemonNews3Rankings
	dw .RankedPlayerScript - PokemonNews3Rankings
	dw .RankedPlayerScript - PokemonNews3Rankings
	dw .RankedPlayerScript - PokemonNews3Rankings
	dw .RankedPlayerScript - PokemonNews3Rankings
	dw .RankedPlayerScript - PokemonNews3Rankings
	dw .PlayerRankingScript - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings
	dw .RankedPlayerDescription - PokemonNews3Rankings

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
	dw PokemonNews3RankingRegions - PokemonNews3Root
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
	dw PokemonNews3Root - PokemonNews3Root
	news_end

.RankedPlayerText:
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_CATEGORY
	dw .Category1Text2 - PokemonNews3Rankings
	dw .Category2Text2 - PokemonNews3Rankings
	dw .Category3Text2 - PokemonNews3Rankings
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
	db $03, $04, $04, $00, $00
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
	db $02, $03, $03, $00, $00
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
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message13Text - PokemonNews3Rankings
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message14Text - PokemonNews3Rankings
	news_end

.PlayerRankingScript:
	news_command NewsScript_CompareRAM
	db $00
	dw NEWS_JP_PLAYER_RANKING
	db $04, $00
	dw NEWS_JP_RANKING_TOTAL
	dw .ShowMessage - PokemonNews3Rankings
	dw .ShowMessage - PokemonNews3Rankings
	dw .ShowMessage2 - PokemonNews3Rankings

.ShowMessage:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message15Text - PokemonNews3Rankings
	news_end

.ShowMessage2:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message16Text - PokemonNews3Rankings
	news_end

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

.Message15Text:
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_CATEGORY
	dw .Category1Text3 - PokemonNews3Rankings
	dw .Category2Text3 - PokemonNews3Rankings
	dw .Category3Text3 - PokemonNews3Rankings
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

.Message16Text:
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_CATEGORY
	dw .Category1Text3 - PokemonNews3Rankings
	dw .Category2Text3 - PokemonNews3Rankings
	dw .Category3Text3 - PokemonNews3Rankings
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
	db $85
	dw $a063
	db $03, $04, $04, $00, $00
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
	db $85
	dw $a07f
	db $02, $03, $03, $00, $00
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
	db $85
	dw $a07b
	db $82, $04, $05, $04, $f2
	news_text_end
	db "センチ<PARA>@"

.RankedPlayerDescription:
	db "えらんだ ひと<NO>データを<LINE>みること<GA>できます@"

.Category1Text:
	db "コロシアムで かった かいすう@"

.Category2Text:
	db "むしとりたいかい こうとくてん@"

.Category3Text:
	db "つった コイキング<NO>おおきさ@"

.Region1Text:
	db "ぜんこく <NO>トップ10!@"

.Region2Text:
	db "とどうふけん <NO>トップ10!@"

.Region3Text:
	db "ゆうびんばんごう <NO>トップ10!@"

PokemonNews3End:
	assert PokemonNews3End - PokemonNews3 == $05b6
