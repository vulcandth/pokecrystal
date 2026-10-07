MobilePassword:
	ldh a, [hInMenu]
	push af
	ld a, $1
	ldh [hInMenu], a
	call MobilePassword_Run
	pop af
	ldh [hInMenu], a
	ret

MobilePassword_Run:
	call MobilePassword_Init
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	call MobilePassword_Loop
	ld a, BANK(sMobilePasswordStateBackup)
	call OpenSRAM
	ld hl, sMobilePasswordStateBackup
	ld de, wMobilePasswordJumptableIndex
	ld bc, MOBILE_PASSWORD_STATE_SIZE
	call CopyBytes
	ld de, wMobilePasswordBuffer
	ld bc, MOBILE_LOGIN_PASSWORD_LENGTH
	call CopyBytes
	call CloseSRAM
	pop af
	ldh [rWBK], a
	ret

MobilePassword_Init:
	ld a, BANK(sMobilePasswordStateBackup)
	call OpenSRAM
	ld hl, wMobilePasswordJumptableIndex
	ld de, sMobilePasswordStateBackup
	ld bc, MOBILE_PASSWORD_STATE_SIZE
	call CopyBytes
	ld hl, wMobilePasswordBuffer
	ld bc, MOBILE_LOGIN_PASSWORD_LENGTH
	call CopyBytes
	call CloseSRAM
	xor a
	ld [wMobilePasswordJumptableIndex], a
	ld [wMobilePasswordLength], a
	ld [wMobilePasswordKeyboard], a
	ld [wMobilePasswordCursorX], a
	ld [wMobilePasswordCursorY], a
	ld [wMobilePasswordSelection], a
	ld [wMobilePasswordRemember], a
	ld hl, wMobilePasswordBuffer
	ld bc, MOBILE_LOGIN_PASSWORD_LENGTH
	call ByteFill
	call ClearBGPalettes
	call ClearSprites
	farcall MobilePassword_LoadScreen
	farcall HDMATransferTilemapAndAttrmap_Overworld
	farcall ClearSpriteAnims
	ret

MobilePassword_Loop:
.loop
	call JoyTextDelay
	ld a, [wMobilePasswordJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr nz, .quit
	call MobilePassword_RunState
	farcall PlaySpriteAnimations
	farcall HDMATransferTilemapAndAttrmap_Overworld
	jr .loop

.quit
	farcall ClearSpriteAnims
	call ClearBGPalettes
	call ClearScreen
	call ClearSprites
	ret

MobilePassword_RunState:
	jumptable MobilePasswordStatePointers, wMobilePasswordJumptableIndex

MobilePasswordStatePointers:
	table_width 2
	dw MobilePassword_InitCursors
	dw MobilePassword_Joypad
	dw MobilePassword_AskSave
	dw MobilePassword_SaveMenuJoypad
	dw MobilePassword_StorePassword
	dw MobilePassword_WaitSaved
	dw MobilePassword_EmptyMessage
	dw MobilePassword_WaitEmpty
	assert_table_length NUM_MOBILE_PASSWORD_STATES

MobilePassword_InitCursors:
	farcall Mobile_LoadInputPalettes
	depixel 6, 3
	ld a, SPRITE_ANIM_OBJ_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, EZCHAT_CURSOR_PASSWORD_POSITION
	ld [hl], a
	depixel 9, 4
	ld a, SPRITE_ANIM_OBJ_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, EZCHAT_CURSOR_PASSWORD_KEYBOARD
	ld [hl], a
	ld a, MOBILE_PASSWORD_POSITION_CURSOR_MASK | MOBILE_PASSWORD_KEYBOARD_CURSOR_MASK
	ld [wEZChatCursorBlinkMask], a
	jp MobilePassword_IncrementJumptable

MobilePassword_Joypad:
	ld a, [wMobilePasswordLength]
	cp MOBILE_LOGIN_PASSWORD_MAX_LENGTH
	jr nz, .show_position_cursor
	ld a, MOBILE_PASSWORD_POSITION_CURSOR_MASK
	jr .joypad

.show_position_cursor
	xor a
.joypad
	ld [wEZChatCursorHiddenMask], a
	ld hl, hJoyPressed
	ld a, [hl]
	and PAD_SELECT
	jr nz, MobilePassword_Select
	ld a, [hl]
	and PAD_START
	jr nz, MobilePassword_SelectDone
	ld a, [hl]
	and PAD_A
	jp nz, MobilePassword_PressA
	ld a, [hl]
	and PAD_B
	jr nz, MobilePassword_DeleteCharacter
	ld hl, hJoyLast
	ld a, [hl]
	and PAD_UP
	jr nz, MobilePassword_MoveUp
	ld a, [hl]
	and PAD_DOWN
	jr nz, MobilePassword_MoveDown
	ld a, [hl]
	and PAD_LEFT
	jp nz, MobilePassword_MoveLeft
	ld a, [hl]
	and PAD_RIGHT
	jp nz, MobilePassword_MoveRight
	ret

MobilePassword_Select:
	farcall MobilePassword_SwitchKeyboard
	ret

MobilePassword_SelectDone:
	ld a, MOBILE_PASSWORD_COMMAND_DONE
	ld [wMobilePasswordCursorX], a
	ld a, MOBILE_PASSWORD_KEYBOARD_ROWS
	ld [wMobilePasswordCursorY], a
	ret

MobilePassword_CheckEmpty:
	ld a, MOBILE_PASSWORD_POSITION_CURSOR_MASK | MOBILE_PASSWORD_KEYBOARD_CURSOR_MASK
	ld [wEZChatCursorHiddenMask], a
	ld a, [wMobilePasswordLength]
	and a
	jr z, .empty
	jp MobilePassword_IncrementJumptable

.empty
	ld a, MOBILE_PASSWORD_EMPTY
	ld [wMobilePasswordJumptableIndex], a
	ret

MobilePassword_Cancel:
	ld a, JUMPTABLE_EXIT
	ld [wMobilePasswordJumptableIndex], a
	ld [wScriptVar], a
	jp MobilePassword_IncrementJumptable

MobilePassword_DeleteCharacter:
	call PlayClickSFX
	ld a, [wMobilePasswordLength]
	and a
	ret z
	dec a
	ld [wMobilePasswordLength], a
	ld e, a
	ld d, 0
	ld hl, wMobilePasswordBuffer
	add hl, de
	xor a
	ld [hl], a
	hlcoord 2, 4
	add hl, de
	ld [hl], a
	ret

MobilePassword_MoveUp:
	assert MOBILE_PASSWORD_COMMAND_COLUMN_SPACING == 5
	ld a, [wMobilePasswordCursorY]
	and a
	ret z
	dec a
	ld [wMobilePasswordCursorY], a
	cp MOBILE_PASSWORD_KEYBOARD_ROWS - 1
	ret nz
	ld a, [wMobilePasswordCursorX]
	ld e, a
	sla a
	sla a
	add e
MobilePassword_SetCursorColumn:
	ld [wMobilePasswordCursorX], a
	ret

MobilePassword_MoveDown:
	ld a, [wMobilePasswordCursorY]
	cp MOBILE_PASSWORD_KEYBOARD_ROWS
	ret z
	inc a
	ld [wMobilePasswordCursorY], a
	cp MOBILE_PASSWORD_KEYBOARD_ROWS
	ret nz
	ld a, [wMobilePasswordCursorX]
	cp 2 * MOBILE_PASSWORD_COMMAND_COLUMN_SPACING
	jr nc, .select_done
	cp MOBILE_PASSWORD_COMMAND_COLUMN_SPACING
	jr nc, .select_cancel
	xor a
	jr MobilePassword_SetCursorColumn

.select_done
	ld a, MOBILE_PASSWORD_COMMAND_DONE
	jr MobilePassword_SetCursorColumn

.select_cancel
	ld a, MOBILE_PASSWORD_COMMAND_CANCEL
	jr MobilePassword_SetCursorColumn

MobilePassword_MoveLeft:
	ld a, [wMobilePasswordCursorX]
	and a
	ret z
	dec a
	ld [wMobilePasswordCursorX], a
	ret

MobilePassword_MoveRight:
	ld e, MOBILE_PASSWORD_KEYBOARD_COLUMNS - 1
	ld a, [wMobilePasswordCursorY]
	cp MOBILE_PASSWORD_KEYBOARD_ROWS
	jr nz, .wrap
	ld e, MOBILE_PASSWORD_COMMAND_DONE
.wrap
	ld a, [wMobilePasswordCursorX]
	cp e
	ret z
	inc a
	ld [wMobilePasswordCursorX], a
	ret

MobilePassword_PressA:
	call PlayClickSFX
	ld a, [wMobilePasswordCursorY]
	cp MOBILE_PASSWORD_KEYBOARD_ROWS
	jr nz, .character_row
	ld a, [wMobilePasswordCursorX]
	cp MOBILE_PASSWORD_COMMAND_DONE
	jp z, MobilePassword_CheckEmpty
	cp MOBILE_PASSWORD_COMMAND_CANCEL
	jp z, MobilePassword_Cancel
	jp MobilePassword_Select

.character_row
	ld a, [wMobilePasswordLength]
	ld e, a
	cp MOBILE_LOGIN_PASSWORD_MAX_LENGTH
	jp z, MobilePassword_SelectDone
	inc a
	ld [wMobilePasswordLength], a
	ld d, $0
	ld a, [wMobilePasswordKeyboard]
	and a
	jr nz, .ascii_symbols
	ld hl, MobilePasswordLetters
	jr .got_ascii

.ascii_symbols
	ld hl, MobilePasswordSymbols
.got_ascii
	push de
	ld a, [wMobilePasswordCursorX]
	ld b, a
	ld a, [wMobilePasswordCursorY]
	ld c, MOBILE_PASSWORD_KEYBOARD_COLUMNS
	call SimpleMultiply
	add b
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld hl, wMobilePasswordBuffer
	add hl, de
	ld [hl], a
	pop de
	hlcoord 2, 4
	add hl, de
	sub MOBILE_ASCII_FONT_OFFSET
	ld [hl], a
	ld a, e
	cp MOBILE_LOGIN_PASSWORD_MAX_LENGTH - 1
	ret nz
	jp MobilePassword_SelectDone

MobilePassword_AskSave:
	ld hl, MobilePasswordMessageMenuHeader
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	ld hl, MobilePasswordYesNoMenuHeader
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	farcall HDMATransferTilemapAndAttrmap_Overworld
	hlcoord 16, 8
	ld de, MobilePasswordYesNoString
	call PlaceString
	hlcoord 15, 10
	ld a, '▶'
	ld [hl], a
	hlcoord 1, 14
	ld de, MobilePasswordAskSaveString
	call PlaceString
	ld a, $1
	ld [wMobilePasswordSelection], a
	jp MobilePassword_IncrementJumptable

MobilePassword_SaveMenuJoypad:
	ldh a, [hJoyPressed]
	cp PAD_B
	jr z, .b_button
	cp PAD_A
	jr z, .a_button
	cp PAD_DOWN
	jr z, .d_down
	cp PAD_UP
	ret nz
	ld a, [wMobilePasswordSelection]
	and a
	ret z
	dec a
	ld [wMobilePasswordSelection], a
	hlcoord 15, 8
	ld a, '▶'
	ld [hl], a
	hlcoord 15, 10
	ld a, ' '
	ld [hl], a
	ret

.d_down
	ld a, [wMobilePasswordSelection]
	and a
	ret nz
	inc a
	ld [wMobilePasswordSelection], a
	hlcoord 15, 8
	ld a, ' '
	ld [hl], a
	hlcoord 15, 10
	ld a, '▶'
	ld [hl], a
	ret

.a_button
	call PlayClickSFX
	ld a, [wMobilePasswordSelection]
	and a
	jr nz, .b_button
	call ExitMenu
	ld a, $1
	ld [wMobilePasswordRemember], a
	jp MobilePassword_IncrementJumptable

.b_button
	call ExitMenu
	call ExitMenu
	jp MobilePassword_IncrementJumptable

MobilePassword_StorePassword:
; The saved flag controls reuse; the text is stored for either answer.
	call SpeechTextbox
	hlcoord 1, 14
	ld de, MobilePasswordSavedString
	call PlaceString
	ld a, MOBILE_PASSWORD_MESSAGE_DELAY
	ld [wMobilePasswordDelay], a
	ld a, BANK(sMobileLoginPassword)
	call OpenSRAM
	ld a, [wMobilePasswordRemember]
	ld [sMobileLoginPasswordSaved], a
	ld hl, wMobilePasswordBuffer
	ld de, sMobileLoginPasswordBuffer
	ld bc, MOBILE_LOGIN_PASSWORD_LENGTH
	call CopyBytes
	call CloseSRAM
	ld a, [wMobilePasswordRemember]
	and a
	jr z, MobilePassword_Quit
	call MobilePassword_IncrementJumptable

MobilePassword_WaitSaved:
	ld hl, wMobilePasswordDelay
	dec [hl]
	ret nz
	call ExitMenu
MobilePassword_Quit:
	ld a, JUMPTABLE_EXIT
	ld [wMobilePasswordJumptableIndex], a
	ret

MobilePassword_EmptyMessage:
	ld hl, MobilePasswordMessageMenuHeader
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	farcall HDMATransferTilemapAndAttrmap_Overworld
	hlcoord 1, 14
	ld de, MobilePasswordEmptyString
	call PlaceString
	ld a, MOBILE_PASSWORD_MESSAGE_DELAY
	ld [wMobilePasswordDelay], a
	call MobilePassword_IncrementJumptable

MobilePassword_WaitEmpty:
	ld hl, wMobilePasswordDelay
	dec [hl]
	ret nz
	call ExitMenu
	ld a, MOBILE_PASSWORD_JOYPAD
	ld [wMobilePasswordJumptableIndex], a
	ret

INCLUDE "data/mobile/password_messages.asm"

MobilePassword_IncrementJumptable:
	ld hl, wMobilePasswordJumptableIndex
	inc [hl]
	ret

INCLUDE "data/mobile/password_keyboard.asm"
