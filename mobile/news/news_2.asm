; Built-in Japanese Pokémon News sample 2.
PokemonNews2:
	dw sPokemonNews
	dw $dccc ; checksum of the payload
	dw PokemonNews2End - PokemonNews2Root

PokemonNews2Root:
	db MUSIC_PROF_ELM ; music
	db 0 ; custom palette bitmask
	db 2 ; number of boxes
	db 0, 3, 20, 10, 1, 3 ; x, y, width, height, border, palette
	db 0, 12, 20, 6, 2, 4 ; x, y, width, height, border, palette
	db 1 ; number of strings
	dw 2 * SCREEN_WIDTH + 1 ; tilemap offset
	db "ポケモンニュース そうかんごう@"
	db 2, 5, 1, 4, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 4, 2, 4
	dw .AButton - PokemonNews2Root ; A
	dw .BButton - PokemonNews2Root ; B
	dw -1 ; Select
	dw -1 ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews2Root ; Up
	dw .DownButton - PokemonNews2Root ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .NewsGuideText - PokemonNews2Root
	dw .TrainerRankingsText - PokemonNews2Root
	dw .PokemonQuizText - PokemonNews2Root
	dw .ExitText - PokemonNews2Root
	dw .NewsGuideScript - PokemonNews2Root
	dw .TrainerRankingsScript - PokemonNews2Root
	dw .PokemonQuizScript - PokemonNews2Root
	dw .ExitScript - PokemonNews2Root
	dw .NewsGuideDescription - PokemonNews2Root
	dw .TrainerRankingsDescription - PokemonNews2Root
	dw .PokemonQuizDescription - PokemonNews2Root
	dw .ExitDescription - PokemonNews2Root

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

.NewsGuideText:
	db "ニュースガイド@"

.TrainerRankingsText:
	db "トレーナーランキング@"

.PokemonQuizText:
	db "ポケモンカルト@"

.ExitText:
	db "やめる@"

.NewsGuideScript:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message9Text - PokemonNews2Root
	news_command NewsScript_WaitButton
	news_end

.TrainerRankingsScript:
	news_command NewsScript_LoadScreen
	dw PokemonNews2RankingsMenu - PokemonNews2Root
	news_end

.PokemonQuizScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_QUESTION
	db $00
	news_command NewsScript_SetValue
	dw NEWS_JP_QUIZ_SCORE
	db $00
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.ExitScript:
	news_command NewsScript_Exit
	news_end

.Message9Text:
	db $00, "#ニュース そうかんごうでは<LINE><TRAINER>ランキングと<CONT>"
	db "#カルトクイズで<CONT>おたのしみ ください!<PARA>あなた"
	db "<NO>ランキング<NO>せいせきは<LINE>ランキング<NO>こうしん<WO>"
	db "すれば<CONT>なんどでも かきかえられるので<CONT>がんばれ"
	db "ば トップ<NI>なれるかも!<DONE>"

.NewsGuideDescription:
	db "よみこんだ ニュースを<LINE>かんたん<NI>せつめいします"
	db "@"

.TrainerRankingsDescription:
	db "3つ<NO>テーマで<LINE>ランキング<WO>します!@"

.PokemonQuizDescription:
	db "これまで<NO>ぼうけん<WO>どこまで<LINE>おもいだせるか テ"
	db "ストします!@"

.ExitDescription:
	db "ニュース<WO>みるのを<LINE>やめます@"

PokemonNews2Quiz:
	db MUSIC_GAME_CORNER ; music
	db 0 ; custom palette bitmask
	db 1 ; number of boxes
	db 0, 14, 20, 4, 2, 4 ; x, y, width, height, border, palette
	db 1 ; number of strings
	dw 2 * SCREEN_WIDTH + 1 ; tilemap offset
	news_text_start
	news_text_command NewsText_Switch
	db 10
	dw NEWS_JP_QUIZ_QUESTION
	dw .Question1Text - PokemonNews2Quiz
	dw .Question2Text - PokemonNews2Quiz
	dw .Question3Text - PokemonNews2Quiz
	dw .Question4Text - PokemonNews2Quiz
	dw .Question5Text - PokemonNews2Quiz
	dw .Question6Text - PokemonNews2Quiz
	dw .Question7Text - PokemonNews2Quiz
	dw .Question8Text - PokemonNews2Quiz
	dw .Question9Text - PokemonNews2Quiz
	dw .Question10Text - PokemonNews2Quiz
	db "@"
	db 2, 16, 4, 1, 4, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 1, 0, 0, 0, 0, 4
	dw .AButton - PokemonNews2Quiz ; A
	dw .BButton - PokemonNews2Quiz ; B
	dw -1 ; Select
	dw .BButton - PokemonNews2Quiz ; Start
	dw .RightButton - PokemonNews2Quiz ; Right
	dw .LeftButton - PokemonNews2Quiz ; Left
	dw -1 ; Up
	dw -1 ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .FirstAnswerText - PokemonNews2Quiz
	dw .SecondAnswerText - PokemonNews2Quiz
	dw .ThirdAnswerText - PokemonNews2Quiz
	dw .ExitText - PokemonNews2Quiz
	dw .FirstAnswerScript - PokemonNews2Quiz
	dw .SecondAnswerScript - PokemonNews2Quiz
	dw .ThirdAnswerScript - PokemonNews2Quiz
	dw .ExitScript - PokemonNews2Quiz
	dw .FirstAnswerDescription - PokemonNews2Quiz
	dw .FirstAnswerDescription - PokemonNews2Quiz
	dw .FirstAnswerDescription - PokemonNews2Quiz
	dw .FirstAnswerDescription - PokemonNews2Quiz

.AButton:
	news_command NewsScript_PlaySound
	db SFX_READ_TEXT
	news_command NewsScript_MenuScript
	news_end

.RightButton:
	news_command NewsScript_MenuRight
	news_end

.LeftButton:
	news_command NewsScript_MenuLeft
	news_end

.BButton:
	news_command NewsScript_PlaySound
	db SFX_MENU
	news_command NewsScript_LoadScreen
	dw PokemonNews2Root - PokemonNews2Root
	news_end

.FirstAnswerText:
	db "1ばん@"

.SecondAnswerText:
	db "2ばん@"

.ThirdAnswerText:
	db "3ばん@"

.ExitText:
	db "やめる@"

.FirstAnswerScript:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_QUESTION
	db $01
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion - PokemonNews2Quiz
	dw .IncrementQuizScore - PokemonNews2Quiz
	dw .CheckQuizQuestion - PokemonNews2Quiz
	db $01, $01

.IncrementQuizScore:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_SCORE
	db $01
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion2 - PokemonNews2Quiz
	dw .OpenQuiz - PokemonNews2Quiz
	dw .CheckQuizQuestion2 - PokemonNews2Quiz
	db $01, $02

.OpenQuiz:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion2:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion3 - PokemonNews2Quiz
	dw .IncrementQuizScore2 - PokemonNews2Quiz
	dw .CheckQuizQuestion3 - PokemonNews2Quiz
	db $01, $03

.IncrementQuizScore2:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_SCORE
	db $03
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion3:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion4 - PokemonNews2Quiz
	dw .IncrementQuizScore3 - PokemonNews2Quiz
	dw .CheckQuizQuestion4 - PokemonNews2Quiz
	db $01, $04

.IncrementQuizScore3:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_SCORE
	db $01
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion4:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion5 - PokemonNews2Quiz
	dw .OpenQuiz2 - PokemonNews2Quiz
	dw .CheckQuizQuestion5 - PokemonNews2Quiz
	db $01, $05

.OpenQuiz2:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion5:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion6 - PokemonNews2Quiz
	dw .OpenQuiz3 - PokemonNews2Quiz
	dw .CheckQuizQuestion6 - PokemonNews2Quiz
	db $01, $06

.OpenQuiz3:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion6:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion7 - PokemonNews2Quiz
	dw .OpenQuiz4 - PokemonNews2Quiz
	dw .CheckQuizQuestion7 - PokemonNews2Quiz
	db $01, $07

.OpenQuiz4:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion7:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion8 - PokemonNews2Quiz
	dw .IncrementQuizScore4 - PokemonNews2Quiz
	dw .CheckQuizQuestion8 - PokemonNews2Quiz
	db $01, $08

.IncrementQuizScore4:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_SCORE
	db $03
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion8:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion9 - PokemonNews2Quiz
	dw .OpenQuiz5 - PokemonNews2Quiz
	dw .CheckQuizQuestion9 - PokemonNews2Quiz
	db $01, $09

.OpenQuiz5:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion9:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .Script63 - PokemonNews2Quiz
	dw .OpenQuizResults - PokemonNews2Quiz
	dw .Script63 - PokemonNews2Quiz
	db $01, $0a

.OpenQuizResults:
	news_command NewsScript_LoadScreen
	dw PokemonNews2QuizResults - PokemonNews2Root
	news_end

.Script63:
	news_end

.SecondAnswerScript:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_QUESTION
	db $01
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion10 - PokemonNews2Quiz
	dw .OpenQuiz6 - PokemonNews2Quiz
	dw .CheckQuizQuestion10 - PokemonNews2Quiz
	db $01, $01

.OpenQuiz6:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion10:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion11 - PokemonNews2Quiz
	dw .OpenQuiz7 - PokemonNews2Quiz
	dw .CheckQuizQuestion11 - PokemonNews2Quiz
	db $01, $02

.OpenQuiz7:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion11:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion12 - PokemonNews2Quiz
	dw .OpenQuiz8 - PokemonNews2Quiz
	dw .CheckQuizQuestion12 - PokemonNews2Quiz
	db $01, $03

.OpenQuiz8:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion12:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion13 - PokemonNews2Quiz
	dw .OpenQuiz9 - PokemonNews2Quiz
	dw .CheckQuizQuestion13 - PokemonNews2Quiz
	db $01, $04

.OpenQuiz9:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion13:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion14 - PokemonNews2Quiz
	dw .OpenQuiz10 - PokemonNews2Quiz
	dw .CheckQuizQuestion14 - PokemonNews2Quiz
	db $01, $05

.OpenQuiz10:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion14:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion15 - PokemonNews2Quiz
	dw .IncrementQuizScore5 - PokemonNews2Quiz
	dw .CheckQuizQuestion15 - PokemonNews2Quiz
	db $01, $06

.IncrementQuizScore5:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_SCORE
	db $01
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion15:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion16 - PokemonNews2Quiz
	dw .IncrementQuizScore6 - PokemonNews2Quiz
	dw .CheckQuizQuestion16 - PokemonNews2Quiz
	db $01, $07

.IncrementQuizScore6:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_SCORE
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion16:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion17 - PokemonNews2Quiz
	dw .OpenQuiz11 - PokemonNews2Quiz
	dw .CheckQuizQuestion17 - PokemonNews2Quiz
	db $01, $08

.OpenQuiz11:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion17:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion18 - PokemonNews2Quiz
	dw .IncrementQuizScore7 - PokemonNews2Quiz
	dw .CheckQuizQuestion18 - PokemonNews2Quiz
	db $01, $09

.IncrementQuizScore7:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_SCORE
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion18:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .Script65 - PokemonNews2Quiz
	dw .IncrementQuizScore8 - PokemonNews2Quiz
	dw .Script65 - PokemonNews2Quiz
	db $01, $0a

.IncrementQuizScore8:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_SCORE
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews2QuizResults - PokemonNews2Root
	news_end

.Script65:
	news_end

.ThirdAnswerScript:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_QUESTION
	db $01
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion19 - PokemonNews2Quiz
	dw .OpenQuiz12 - PokemonNews2Quiz
	dw .CheckQuizQuestion19 - PokemonNews2Quiz
	db $01, $01

.OpenQuiz12:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion19:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion20 - PokemonNews2Quiz
	dw .IncrementQuizScore9 - PokemonNews2Quiz
	dw .CheckQuizQuestion20 - PokemonNews2Quiz
	db $01, $02

.IncrementQuizScore9:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_SCORE
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion20:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion21 - PokemonNews2Quiz
	dw .OpenQuiz13 - PokemonNews2Quiz
	dw .CheckQuizQuestion21 - PokemonNews2Quiz
	db $01, $03

.OpenQuiz13:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion21:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion22 - PokemonNews2Quiz
	dw .OpenQuiz14 - PokemonNews2Quiz
	dw .CheckQuizQuestion22 - PokemonNews2Quiz
	db $01, $04

.OpenQuiz14:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion22:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion23 - PokemonNews2Quiz
	dw .IncrementQuizScore10 - PokemonNews2Quiz
	dw .CheckQuizQuestion23 - PokemonNews2Quiz
	db $01, $05

.IncrementQuizScore10:
	news_command NewsScript_AddValue
	dw NEWS_JP_QUIZ_SCORE
	db $03
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion23:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion24 - PokemonNews2Quiz
	dw .OpenQuiz15 - PokemonNews2Quiz
	dw .CheckQuizQuestion24 - PokemonNews2Quiz
	db $01, $06

.OpenQuiz15:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion24:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion25 - PokemonNews2Quiz
	dw .OpenQuiz16 - PokemonNews2Quiz
	dw .CheckQuizQuestion25 - PokemonNews2Quiz
	db $01, $07

.OpenQuiz16:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion25:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion26 - PokemonNews2Quiz
	dw .OpenQuiz17 - PokemonNews2Quiz
	dw .CheckQuizQuestion26 - PokemonNews2Quiz
	db $01, $08

.OpenQuiz17:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion26:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .CheckQuizQuestion27 - PokemonNews2Quiz
	dw .OpenQuiz18 - PokemonNews2Quiz
	dw .CheckQuizQuestion27 - PokemonNews2Quiz
	db $01, $09

.OpenQuiz18:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Quiz - PokemonNews2Root
	news_end

.CheckQuizQuestion27:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_QUESTION
	dw .Script67 - PokemonNews2Quiz
	dw .OpenQuizResults2 - PokemonNews2Quiz
	dw .Script67 - PokemonNews2Quiz
	db $01, $0a

.OpenQuizResults2:
	news_command NewsScript_LoadScreen
	dw PokemonNews2QuizResults - PokemonNews2Root
	news_end

.Script67:
	news_end

.ExitScript:
	news_command NewsScript_PlaySound
	db SFX_MENU
	news_command NewsScript_LoadScreen
	dw PokemonNews2Root - PokemonNews2Root
	news_end

.FirstAnswerDescription:
	db "@"

.Question1Text:
	db "ウツギはかせ<GA>はじめに<NEXT>えらばせてくれた #<NEXT>ま"
	db "んなか<NI>いたのは?<NEXT><NEXT>1<DOT>ワニノコ  2<DOT>チコり"
	db "ータ<NEXT>3<DOT>ヒノアラシ<NEXT>@"

.Question2Text:
	db "ウツギはかせ<NO>よこに<NEXT>ある ごみばこに<NEXT>はい<TTE> "
	db "いるのは?<NEXT><NEXT>1<DOT>たべのこし 2<DOT>ジュースのびん"
	db "<NEXT>3<DOT>おかしのふくろ<NEXT>@"

.Question3Text:
	db "#<NO>つかまえかたを<NEXT>おしえて くれる<NEXT>おにいさん"
	db "<NO>りュックに<NEXT>きずくすり<WA>いくつ?<NEXT>1<DOT>1こ  "
	db " 2<DOT>2こ<NEXT>3<DOT>3こ<NEXT>@"

.Question4Text:
	db "おかあさんの<NEXT>とくい りょうりは<NEXT>「グレンふう "
	db "かざん ???」<NEXT>「???」<WA>なに?<NEXT>1<DOT>ハンバ"
	db "ーグ  2<DOT>カレー<NEXT>3<DOT>やきそば<NEXT>@"

.Question5Text:
	db "ジョバンニせんせいは<NEXT>はなしかけてから<NEXT>じゅく<NI>"
	db "はいるまで<NEXT>なんかい まわる?<NEXT>1<DOT>5かい   "
	db "2<DOT>6かい<NEXT>3<DOT>7かい<NEXT>@"

.Question6Text:
	db "つながりのどうくつに<NEXT>おちていない どうぐは?<NEXT>"
	db "<NEXT>1<DOT>プラスパワー 2<DOT>まひなおし<NEXT>3<DOT>きずぐす"
	db "り<NEXT>@"

.Question7Text:
	db "カモネギ<WO>つかまえるとき<NEXT>いちばん すくない て"
	db "かずは<NEXT>なんかい カモネギに<NEXT>はなしかければ い"
	db "い?<NEXT>1<DOT>3かい  2<DOT>4かい<NEXT>3<DOT>5かい<NEXT>@"

.Question8Text:
	db "ヤドンのいどに<NEXT>ヤドン<WO>たすけ<NI>いったとき<NEXT>いど"
	db "<NO>なか<NI>いるヤドンは<NEXT>なんひき だった?<NEXT>1<DOT>2"
	db "ひき  2<DOT>3ひき<NEXT>3<DOT>4ひき<NEXT>@"

.Question9Text:
	db "ヨシノシティ<NI>いる<NEXT>あんないじいさんは<NEXT>うみ <WO>"
	db "なんばんめに<NEXT>あんない してくれる?<NEXT>1<DOT>3ばん"
	db "め  2<DOT>4ばんめ<NEXT>3<DOT>5ばんめ<NEXT>@"

.Question10Text:
	db "#じいさん<NO>いえに<NEXT>がいこく<NO>ものが<NEXT>あるけど "
	db "このなかで<NEXT>ない ものは?<NEXT>1<DOT>コイン  2<DOT>き"
	db "<TTE><NEXT>3<DOT>ざっし<NEXT>@"

PokemonNews2QuizResults:
	db MUSIC_POKEMON_TALK ; music
	db 0 ; custom palette bitmask
	db 1 ; number of boxes
	db 0, 12, 20, 6, 2, 4 ; x, y, width, height, border, palette
	db 1 ; number of strings
	dw 0 * SCREEN_WIDTH + 0 ; tilemap offset
	db "@"
	db 4, 10, 1, 1, 0, 0 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 3, 0, 0, 0, 2, 1
	dw .AButton - PokemonNews2QuizResults ; A
	dw .AButton - PokemonNews2QuizResults ; B
	dw -1 ; Select
	dw .AButton - PokemonNews2QuizResults ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw -1 ; Up
	dw -1 ; Down
	db 1 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .ProfOakRatingText - PokemonNews2QuizResults
	dw .ProfOakRatingScript - PokemonNews2QuizResults
	dw .ProfOakRatingDescription - PokemonNews2QuizResults

.AButton:
	news_command NewsScript_PlaySound
	db SFX_READ_TEXT
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_TrainerPic
	dw $002e
	db $0a, $07
	news_command NewsScript_MenuScript
	news_command NewsScript_WaitButton
	news_command NewsScript_LoadScreen
	dw PokemonNews2Root - PokemonNews2Root
	news_end

.ProfOakRatingText:
	db "オーキドはかせの ひょうか@"

.ProfOakRatingScript:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_SCORE
	dw .PrintText - PokemonNews2QuizResults
	dw .PrintText - PokemonNews2QuizResults
	dw .CheckQuizScore - PokemonNews2QuizResults
	db $01, $05

.PrintText:
	news_command NewsScript_PrintText
	dw $0119
	dw .Message3Text - PokemonNews2QuizResults
	news_command NewsScript_PlaySound
	db SFX_DEX_FANFARE_LESS_THAN_20
	news_end

.CheckQuizScore:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_SCORE
	dw .PrintText2 - PokemonNews2QuizResults
	dw .PrintText2 - PokemonNews2QuizResults
	dw .CheckQuizScore2 - PokemonNews2QuizResults
	db $01, $0a

.PrintText2:
	news_command NewsScript_PrintText
	dw $0119
	dw .Message4Text - PokemonNews2QuizResults
	news_command NewsScript_PlaySound
	db SFX_DEX_FANFARE_140_169
	news_end

.CheckQuizScore2:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_SCORE
	dw .PrintText3 - PokemonNews2QuizResults
	dw .PrintText3 - PokemonNews2QuizResults
	dw .CheckQuizScore3 - PokemonNews2QuizResults
	db $01, $0f

.PrintText3:
	news_command NewsScript_PrintText
	dw $0119
	dw .Message5Text - PokemonNews2QuizResults
	news_command NewsScript_PlaySound
	db SFX_DEX_FANFARE_170_199
	news_end

.CheckQuizScore3:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_SCORE
	dw .PrintText4 - PokemonNews2QuizResults
	dw .PrintText4 - PokemonNews2QuizResults
	dw .CheckQuizScore4 - PokemonNews2QuizResults
	db $01, $13

.PrintText4:
	news_command NewsScript_PrintText
	dw $0119
	dw .Message6Text - PokemonNews2QuizResults
	news_command NewsScript_PlaySound
	db SFX_DEX_FANFARE_200_229
	news_end

.CheckQuizScore4:
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_QUIZ_SCORE
	dw .PrintText5 - PokemonNews2QuizResults
	dw .PrintText5 - PokemonNews2QuizResults
	dw .Script12 - PokemonNews2QuizResults
	db $01, $14

.PrintText5:
	news_command NewsScript_PrintText
	dw $0119
	dw .Message7Text - PokemonNews2QuizResults
	news_command NewsScript_PlaySound
	db SFX_DEX_FANFARE_230_PLUS
	news_end

.Script12:
	news_end

.ProfOakRatingDescription:
	db "クイズ しゅうりょう<LINE>ひょうか<WO>うけて ください"
	db "!@"

.Message3Text:
	db $00, "ぜんぜん まだまだ じゃな<LINE>これ<WA>おぼえてなく"
	db "ても いいだろう<CONT>というような ことまで おぼえ"
	db "るのが<CONT>#マニアと いうものじゃ<DONE>"

.Message4Text:
	db $00, "#マニア<NI>して<WA>まだ<LINE>ボりューム<GA>たりん!<PARA>い"
	db "ろいろな ものを<LINE>むだでも くまなく みるのじゃ"
	db "!<DONE>"

.Message5Text:
	db $00, "ふむ がんば<TTE>おるな<LINE>それなり<NI>#マニア<CONT>らし"
	db "く な<TTE>きておるよ!<PARA>ともだちと そうだん して"
	db "いるかな?<LINE>ひとりで<WA>たいへん だからな<DONE>"

.Message6Text:
	db $00, "エクセレントじゃ!<LINE>きみ<WA>じゅうばこ<NO>すみを<CONT>"
	db "つつくの<GA>すき なんじゃろ?<DONE>"

.Message7Text:
	db $00, "おおっ ゆめにまで みた<LINE>パーフェクトな #マ"
	db "ニアの<CONT>かんせいじゃ! <……> おめでとう!<DONE>"

PokemonNews2RankingsMenu:
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
	dw .AButton - PokemonNews2RankingsMenu ; A
	dw .BButton - PokemonNews2RankingsMenu ; B
	dw -1 ; Select
	dw -1 ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews2RankingsMenu ; Up
	dw .DownButton - PokemonNews2RankingsMenu ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .ViewRankingsText - PokemonNews2RankingsMenu
	dw .UpdateRankingsText - PokemonNews2RankingsMenu
	dw .RankingExplanationText - PokemonNews2RankingsMenu
	dw .ExitText - PokemonNews2RankingsMenu
	dw .ViewRankingsScript - PokemonNews2RankingsMenu
	dw .UpdateRankingsScript - PokemonNews2RankingsMenu
	dw .RankingExplanationScript - PokemonNews2RankingsMenu
	dw .ExitScript - PokemonNews2RankingsMenu
	dw .ViewRankingsDescription - PokemonNews2RankingsMenu
	dw .UpdateRankingsDescription - PokemonNews2RankingsMenu
	dw .RankingExplanationDescription - PokemonNews2RankingsMenu
	dw .ExitDescription - PokemonNews2RankingsMenu

.AButton:
	news_command NewsScript_PlaySound
	db SFX_READ_TEXT
	news_command NewsScript_MenuScript
	news_end

.BButton:
	news_command NewsScript_PlaySound
	db SFX_MENU
	news_command NewsScript_LoadScreen
	dw PokemonNews2Root - PokemonNews2Root
	news_end

.UpButton:
	news_command NewsScript_MenuUp
	news_end

.DownButton:
	news_command NewsScript_MenuDown
	news_end

.ViewRankingsText:
	db "ランキング <WO>みる@"

.UpdateRankingsText:
	db "ランキング <NO>こうしん@"

.RankingExplanationText:
	db "ランキング <NO>せつめい@"

.ExitText:
	db "やめる@"

.ViewRankingsScript:
	news_command NewsScript_CompareRAM
	db $05
	dw sPokemonNewsID
	db $0c, $05
	dw sPokemonNewsRankingsID
	dw .ShowMessage - PokemonNews2RankingsMenu
	dw .OpenRankingCategories - PokemonNews2RankingsMenu
	dw .ShowMessage - PokemonNews2RankingsMenu

.OpenRankingCategories:
	news_command NewsScript_LoadScreen
	dw PokemonNews2RankingCategories - PokemonNews2Root
	news_end

.ShowMessage:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message10Text - PokemonNews2RankingsMenu
	news_end

.UpdateRankingsScript:
	news_command NewsScript_UpdateRankings
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_RANKINGS_UPDATE_RESULT
	dw .ShowMessage2 - PokemonNews2RankingsMenu
	dw .ShowMessage3 - PokemonNews2RankingsMenu
	dw .ShowMessage4 - PokemonNews2RankingsMenu
	db $01, $01

.ShowMessage2:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message11Text - PokemonNews2RankingsMenu
	news_command NewsScript_WaitButton
	news_end

.ShowMessage3:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message12Text - PokemonNews2RankingsMenu
	news_command NewsScript_WaitButton
	news_end

.ShowMessage4:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message13Text - PokemonNews2RankingsMenu
	news_command NewsScript_WaitButton
	news_end

.Message11Text:
	db $00, "ランキング<NO>こうしんを<LINE>しました!<DONE>"

.Message12Text:
	db $00, "ランキング<NO>こうしんを<LINE>やめました<DONE>"

.Message13Text:
	db $00, "ランキング<NO>こうしんに<LINE>しっぱい…<PARA>あたらしい"
	db " ニュースを<LINE>よみこんで ください<DONE>"

.RankingExplanationScript:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PrintText
	dw $0119
	dw .Message9Text - PokemonNews2RankingsMenu
	news_command NewsScript_WaitButton
	news_end

.ExitScript:
	news_command NewsScript_LoadScreen
	dw PokemonNews2Root - PokemonNews2Root
	news_end

.Message9Text:
	db $00, "バトルタワーで かった かいすうは<LINE>40ばんど"
	db "うろ<NO>バトルタワーで<CONT>あなた<GA>これまで<NI>なんにん"
	db "の<CONT><TRAINER>と<NO>しょうぶ<NI>かったか<CONT>にんずうで きそい"
	db "ます<PARA>コイキング<NO>おおきさは<LINE>いかりのみずうみ<NI>"
	db "いる<CONT>つりめいじん<NI>はか<TTE>もらった<CONT>コイキング<NO>"
	db "うち いちばん<CONT>おおきかった もので きそいます"
	db "<PARA>むしとりたいかい こうとくてんは<LINE>しぜんこうえ"
	db "んで おこなわれる<CONT>むしとりたいかいで これまで"
	db "に<CONT>とった いちばん たかい<CONT>てんすうで きそい"
	db "ます<DONE>"

.Message10Text:
	db $00, "ランキングデータ<GA>ありません<LINE>ランキング<NO>こう"
	db "しん<WO>すれば<CONT>みること<GA>できます<PARA><DONE>"

.ViewRankingsDescription:
	db "いろいろな ランキングが<LINE>みれます@"

.UpdateRankingsDescription:
	db "ランキング<WO>よみこみなおします<LINE>あなた<NO>せいせき"
	db "も かわります@"

.RankingExplanationDescription:
	db "こんかい<NO>ランキングの<LINE>テーマ<NI>ついて せつめい"
	db "します@"

.ExitDescription:
	db "さいしょ<NO>ぺージ<NI>もどります@"

PokemonNews2RankingCategories:
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
	dw .AButton - PokemonNews2RankingCategories ; A
	dw .BButton - PokemonNews2RankingCategories ; B
	dw -1 ; Select
	dw .BButton - PokemonNews2RankingCategories ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews2RankingCategories ; Up
	dw .DownButton - PokemonNews2RankingCategories ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .BattleTowerWinsText - PokemonNews2RankingCategories
	dw .BugContestScoreText - PokemonNews2RankingCategories
	dw .MagikarpLengthText - PokemonNews2RankingCategories
	dw .BackText - PokemonNews2RankingCategories
	dw .BattleTowerWinsScript - PokemonNews2RankingCategories
	dw .BugContestScoreScript - PokemonNews2RankingCategories
	dw .MagikarpLengthScript - PokemonNews2RankingCategories
	dw .BackScript - PokemonNews2RankingCategories
	dw .BattleTowerWinsDescription - PokemonNews2RankingCategories
	dw .BattleTowerWinsDescription - PokemonNews2RankingCategories
	dw .BattleTowerWinsDescription - PokemonNews2RankingCategories
	dw .BattleTowerWinsDescription - PokemonNews2RankingCategories

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
	dw PokemonNews2RankingsMenu - PokemonNews2Root
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
	dw PokemonNews2RankingRegions - PokemonNews2Root
	news_end

.BugContestScoreScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING
	db $03
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_CATEGORY
	db $01
	news_command NewsScript_LoadScreen
	dw PokemonNews2RankingRegions - PokemonNews2Root
	news_end

.MagikarpLengthScript:
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING
	db $06
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_CATEGORY
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews2RankingRegions - PokemonNews2Root
	news_end

.BattleTowerWinsDescription:
	db "みたい ランキングを<LINE>えらんで ください@"

PokemonNews2RankingRegions:
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
	dw .Category1Text - PokemonNews2RankingRegions
	dw .Category2Text - PokemonNews2RankingRegions
	dw .Category3Text - PokemonNews2RankingRegions
	db "@"
	db 2, 5, 1, 4, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 4, 2, 4
	dw .AButton - PokemonNews2RankingRegions ; A
	dw .BButton - PokemonNews2RankingRegions ; B
	dw -1 ; Select
	dw .StartButton - PokemonNews2RankingRegions ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews2RankingRegions ; Up
	dw .DownButton - PokemonNews2RankingRegions ; Down
	db 4 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 0 ; load ranking
	dw .NationwideText - PokemonNews2RankingRegions
	dw .PrefectureText - PokemonNews2RankingRegions
	dw .PostalCodeText - PokemonNews2RankingRegions
	dw .BackText - PokemonNews2RankingRegions
	dw .NationwideScript - PokemonNews2RankingRegions
	dw .PrefectureScript - PokemonNews2RankingRegions
	dw .PostalCodeScript - PokemonNews2RankingRegions
	dw .BackScript - PokemonNews2RankingRegions
	dw .NationwideDescription - PokemonNews2RankingRegions
	dw .NationwideDescription - PokemonNews2RankingRegions
	dw .NationwideDescription - PokemonNews2RankingRegions
	dw .NationwideDescription - PokemonNews2RankingRegions

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
	dw PokemonNews2RankingsMenu - PokemonNews2Root
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
	dw PokemonNews2Rankings - PokemonNews2Root
	news_end

.PrefectureScript:
	news_command NewsScript_AddValue
	dw NEWS_JP_RANKING
	db $01
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_REGION
	db $01
	news_command NewsScript_LoadScreen
	dw PokemonNews2Rankings - PokemonNews2Root
	news_end

.PostalCodeScript:
	news_command NewsScript_AddValue
	dw NEWS_JP_RANKING
	db $02
	news_command NewsScript_SetValue
	dw NEWS_JP_RANKING_REGION
	db $02
	news_command NewsScript_LoadScreen
	dw PokemonNews2Rankings - PokemonNews2Root
	news_end

.BButton:
	news_command NewsScript_PlaySound
	db SFX_MENU

.BackScript:
	news_command NewsScript_LoadScreen
	dw PokemonNews2RankingCategories - PokemonNews2Root
	news_end

.NationwideDescription:
	db "みたい ちいき を<LINE>えらんで ください@"

.Category1Text:
	db "バトルタワーで かった かいすう@"

.Category2Text:
	db "むしとりたいかい こうとくてん@"

.Category3Text:
	db "つった コイキング<NO>おおきさ@"

PokemonNews2Rankings:
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
	dw .Category1Text - PokemonNews2Rankings
	dw .Category2Text - PokemonNews2Rankings
	dw .Category3Text - PokemonNews2Rankings
	db "@"
	dw 5 * SCREEN_WIDTH + 2 ; tilemap offset
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_REGION
	dw .Region1Text - PokemonNews2Rankings
	dw .Region2Text - PokemonNews2Rankings
	dw .Region3Text - PokemonNews2Rankings
	db "@"
	db 2, 7, 1, 3, 0, 2 ; menu x, y, columns, rows, column spacing, row spacing
; scroll arrow x, y, spacing, visible rows, flags, page size
	db 18, 4, 7, 3, 2, 3
	dw .AButton - PokemonNews2Rankings ; A
	dw .BButton - PokemonNews2Rankings ; B
	dw -1 ; Select
	dw .StartButton - PokemonNews2Rankings ; Start
	dw -1 ; Right
	dw -1 ; Left
	dw .UpButton - PokemonNews2Rankings ; Up
	dw .DownButton - PokemonNews2Rankings ; Down
	db 11 ; number of menu items
	dw 14 * SCREEN_WIDTH + 1 ; description tilemap offset
	db 18, 4 ; description width, height
	db 1 ; load ranking
	dw .RankedPlayerText - PokemonNews2Rankings
	dw .RankedPlayerText - PokemonNews2Rankings
	dw .RankedPlayerText - PokemonNews2Rankings
	dw .RankedPlayerText - PokemonNews2Rankings
	dw .RankedPlayerText - PokemonNews2Rankings
	dw .RankedPlayerText - PokemonNews2Rankings
	dw .RankedPlayerText - PokemonNews2Rankings
	dw .RankedPlayerText - PokemonNews2Rankings
	dw .RankedPlayerText - PokemonNews2Rankings
	dw .RankedPlayerText - PokemonNews2Rankings
	dw .PlayerRankingText - PokemonNews2Rankings
	dw .RankedPlayerScript - PokemonNews2Rankings
	dw .RankedPlayerScript - PokemonNews2Rankings
	dw .RankedPlayerScript - PokemonNews2Rankings
	dw .RankedPlayerScript - PokemonNews2Rankings
	dw .RankedPlayerScript - PokemonNews2Rankings
	dw .RankedPlayerScript - PokemonNews2Rankings
	dw .RankedPlayerScript - PokemonNews2Rankings
	dw .RankedPlayerScript - PokemonNews2Rankings
	dw .RankedPlayerScript - PokemonNews2Rankings
	dw .RankedPlayerScript - PokemonNews2Rankings
	dw .PlayerRankingScript - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings
	dw .RankedPlayerDescription - PokemonNews2Rankings

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
	dw PokemonNews2RankingRegions - PokemonNews2Root
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
	dw PokemonNews2RankingsMenu - PokemonNews2Root
	news_end

.RankedPlayerText:
	news_text_start
	news_text_command NewsText_Switch
	db 3
	dw NEWS_JP_RANKING_CATEGORY
	dw .Category1Text2 - PokemonNews2Rankings
	dw .Category2Text2 - PokemonNews2Rankings
	dw .Category3Text2 - PokemonNews2Rankings
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
	dw .ShowMessage - PokemonNews2Rankings
	dw .ShowMessage2 - PokemonNews2Rankings
	dw .ShowMessage2 - PokemonNews2Rankings

.ShowMessage:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message13Text - PokemonNews2Rankings
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message14Text - PokemonNews2Rankings
	news_end

.ShowMessage2:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message15Text - PokemonNews2Rankings
	news_end

.Message15Text:
	db "ここに<WA>だれも<NEXT>ランクイン してません<PARA>@"

.PlayerRankingScript:
	news_command NewsScript_CompareRAM
	db $00
	dw NEWS_JP_PLAYER_RANKING
	db $04, $00
	dw NEWS_JP_RANKING_TOTAL
	dw .ShowMessage3 - PokemonNews2Rankings
	dw .ShowMessage3 - PokemonNews2Rankings
	dw .ShowMessage4 - PokemonNews2Rankings

.ShowMessage3:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message16Text - PokemonNews2Rankings
	news_command NewsScript_CompareBytes
	db $00
	dw NEWS_JP_PLAYER_RANKING
	dw .Script12 - PokemonNews2Rankings
	dw .CheckValue - PokemonNews2Rankings
	dw .Script12 - PokemonNews2Rankings
	db $04, $00, $00, $00, $01

.CheckValue:
	news_command NewsScript_CompareBytes
	db $05
	dw sPokemonNews
	dw .Script12 - PokemonNews2Rankings
	dw .SetValue - PokemonNews2Rankings
	dw .Script12 - PokemonNews2Rankings
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
	dw .Message21Text - PokemonNews2Rankings
	news_command NewsScript_WaitButton

.Script12:
	news_end

.ShowMessage4:
	news_command NewsScript_ClearText
	dw $0105
	db $12, $04
	news_command NewsScript_PlaceText
	dw $0119
	dw .Message17Text - PokemonNews2Rankings
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
	dw .Category1Text3 - PokemonNews2Rankings
	dw .Category2Text3 - PokemonNews2Rankings
	dw .Category3Text3 - PokemonNews2Rankings
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
	dw .Category1Text3 - PokemonNews2Rankings
	dw .Category2Text3 - PokemonNews2Rankings
	dw .Category3Text3 - PokemonNews2Rankings
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
	dw $a014
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
	db "えらんだ ひと<NO>プロフィールを<LINE>みること<GA>できま"
	db "す@"

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
; Unreferenced trailing byte, included in the original payload checksum.
	db $04

PokemonNews2End:
	assert PokemonNews2End - PokemonNews2 == $0fcc
