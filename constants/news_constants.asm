; PokemonNews_RunScriptCommand / NewsScriptPointers
DEF NUM_NEWS_COMMANDS EQU $31
DEF NEWS_END EQU $ff

; PokemonNews_RunTextCommand / NewsTextPointers
DEF NUM_NEWS_TEXT_COMMANDS EQU $0f

DEF NEWS_ID_LENGTH EQU 12
DEF NEWS_BUFFER_SIZE EQU $1000

; The metadata contains two 16-entry tables of words: SRAM pointers and sizes.
DEF MAX_NEWS_RANKINGS EQU 16
; Each ranking starts with a four-byte total, two skipped bytes, a four-byte
; player rank, and a big-endian word giving the number of entries.
DEF NEWS_RANKING_COUNT_OFFSET EQU 10

; Downloaded metadata separates fields with $50. Upload records specify
; (bank, address, length), or ($fe, length, literal bytes), ending with $ff.
DEF NEWS_METADATA_DELIMITER EQU $50
DEF NEWS_UPLOAD_LITERAL EQU $fe
DEF NEWS_UPLOAD_END EQU $ff
DEF NEWS_URL_MAX_LENGTH EQU 165

; The embedded news samples contain Japanese WRAM addresses, $c bytes below
; the corresponding English news fields. Preserve these operands verbatim.
DEF NEWS_JP_RANKING_TOTAL               EQU $cd54
DEF NEWS_JP_PLAYER_RANKING              EQU $cd58
DEF NEWS_JP_RANKING                     EQU $cd62
DEF NEWS_JP_RANKING_CATEGORY            EQU $cd63
DEF NEWS_JP_RANKING_REGION              EQU $cd64
DEF NEWS_JP_QUIZ_POKEMON                EQU $cd65
DEF NEWS_JP_QUIZ_ANSWER                 EQU $cd66
DEF NEWS_JP_QUIZ_QUESTION               EQU $cd67
DEF NEWS_JP_QUIZ_SCORE                  EQU $cd68
DEF NEWS_JP_RANKINGS_UPDATE_RESULT      EQU $cd6e

; PostalMarkGFX is loaded at this tile in the news viewer.
DEF NEWS_POSTAL_MARK EQU $60

; PokemonNewsStatePointers indexes
	const_def
	const NEWS_STATE_LOAD_SCREEN
	const NEWS_STATE_SET_PALETTES
	const NEWS_STATE_JOYPAD
	const NEWS_STATE_RUN_SCRIPT
	const NEWS_STATE_WAIT_BUTTON
DEF NUM_NEWS_STATES EQU const_value
