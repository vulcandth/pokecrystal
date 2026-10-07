; News script and text opcodes are derived from their dispatch table entries.
; Arguments follow as db/dw data; see the corresponding NewsScript_/NewsText_
; handler for their layout. Screen offsets are relative to the current screen;
; NewsScript_LoadScreen offsets are relative to the issue's first screen.
MACRO news_command
	db (\1Command - NewsScriptPointers) / 2
ENDM

MACRO news_end
	db NEWS_END
ENDM

MACRO news_text_start
	db "<MOBILE>"
ENDM

MACRO news_text_command
	db (\1Command - NewsTextPointers) / 2 + 1
ENDM

MACRO news_text_end
	db "@"
ENDM
