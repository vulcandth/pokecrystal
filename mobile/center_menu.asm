MobileCenterMenu:
	ldh a, [hInMenu]
	push af
	ld a, $1
	ldh [hInMenu], a
	call MobileCenter_Run
	pop af
	ldh [hInMenu], a
	ret

MobileCenter_Run:
	farcall Mobile_InitConnection
	call MobileCenter_Init
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	call MobileCenter_Loop
	pop af
	ldh [rWBK], a
	ret

MobileCenter_Init:
	xor a
	ld [wMobileCenterJumptableIndex], a
	ld [wMobileCenterIndex], a
	dec a
	ld [wMobileCenterLastIndex], a
	call ClearBGPalettes
	call ClearSprites
	farcall MobileCenter_LoadScreen
	farcall HDMATransferTilemapAndAttrmap_Overworld
	farcall ClearSpriteAnims
	ret

MobileCenter_Loop:
.loop
	call JoyTextDelay
	ld a, [wMobileCenterJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr nz, .done
	call MobileCenter_RunState
	farcall PlaySpriteAnimations
	farcall HDMATransferTilemapAndAttrmap_Overworld
	jr .loop
.done
	farcall ClearSpriteAnims
	call ClearSprites
	ret

MobileCenter_RunState:
	jumptable MobileCenterStatePointers, wMobileCenterJumptableIndex

MobileCenterStatePointers:
	table_width 2
	dw MobileCenter_ConnectingMessage
	dw MobileCenter_InitAdapter
	dw MobileCenter_WaitForAPI
	dw MobileCenter_ReadPhoneNumbers
	dw MobileCenter_WaitForAPI
	dw MobileCenter_DrawList
	dw MobileCenter_InitCursors
	dw MobileCenter_Joypad
	dw MobileCenter_ConfirmJoypad
	dw MobileCenter_WaitSaved
	dw MobileCenter_StartErrorDelay
	dw MobileCenter_ShowError
	assert_table_length NUM_MOBILE_CENTER_STATES

MobileCenter_WaitForAPI:
	ld a, [wMobileSDK_Status]
	bit MOBILE_SDK_ERROR_F, a
	jr nz, .error
	bit MOBILE_SDK_BUSY_F, a
	ret nz
	jp MobileCenter_IncrementJumptable

.error
	ld a, MOBILEAPI_ERRORCHECK
	call MobileAPI
	ld [wMobileErrorCodeBuffer], a
	ld a, l
	ld [wMobileErrorCodeBuffer + 1], a
	ld a, h
	ld [wMobileErrorCodeBuffer + 2], a
	ld a, MOBILEAPI_HANGUP
	call MobileAPI
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	farcall Mobile_CleanupConnection
	pop af
	ldh [rWBK], a
	ld a, MOBILE_CENTER_ERROR_DELAY
	ld [wMobileCenterJumptableIndex], a
	ret

MobileCenter_ConnectingMessage:
	farcall Mobile_LoadInputPalettes
	hlcoord 2, 8
	ld de, MobileCenterConnectingString
	call PlaceString
	jp MobileCenter_IncrementJumptable

MobileCenterConnectingString:
	db   "モバイルアダプタに"
	next "せつぞく　しています"
	next "しばらく　おまちください"
	db   "@"

MobileCenter_InitAdapter:
	ld de, wMobileAdapterColor
	ld hl, $5c
	ld a, MOBILEAPI_INIT
	call MobileAPI
	jp MobileCenter_IncrementJumptable

MobileCenter_ReadPhoneNumbers:
	xor a
	ld hl, wMobileCenterTable
	ld bc, MOBILE_CENTER_TABLE_SIZE
	call ByteFill
	ld de, wMobileCenterTable
	ld a, MOBILEAPI_READPHONENUMBERS
	call MobileAPI
	jp MobileCenter_IncrementJumptable

MobileCenter_DrawList:
	assert MOBILE_CENTER_NUMBER_LENGTH == MOBILE_CENTER_NAME_LENGTH
	assert MOBILE_CENTER_ROW_SPACING == 3
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	farcall Mobile_CleanupConnection
	pop af
	ldh [rWBK], a
	hlcoord 2, 6
	ld a, NUM_MOBILE_CENTERS * MOBILE_CENTER_ROW_SPACING - 1
.clear_row
	push af
	push hl
	xor a
	ld bc, MOBILE_CENTER_NAME_LENGTH
	call ByteFill
	pop hl
	ld de, SCREEN_WIDTH
	add hl, de
	pop af
	dec a
	jr nz, .clear_row
	hlcoord 2, 7
	ld a, NUM_MOBILE_CENTERS
	ld de, wMobileCenterTable
.draw_entry
	push af
	push hl
	ld a, [de]
	and a
	jr z, .next_entry
	ld a, [wMobileCenterLastIndex]
	inc a
	ld [wMobileCenterLastIndex], a
	push hl
	call MobileCenter_PlaceASCIIString
	pop hl
	ld bc, -SCREEN_WIDTH
	add hl, bc
	call MobileCenter_PlaceASCIIString
.next_entry
	pop hl
	ld bc, SCREEN_WIDTH
	add hl, bc
	add hl, bc
	add hl, bc
	pop af
	dec a
	jr nz, .draw_entry
	jp MobileCenter_IncrementJumptable

MobileCenter_PlaceASCIIString:
	ld a, [de]
	inc de
	and a
	ret z
	sub MOBILE_ASCII_FONT_OFFSET
	ld [hli], a
	jr MobileCenter_PlaceASCIIString

MobileCenter_InitCursors:
	depixel 8, 2
	ld a, SPRITE_ANIM_OBJ_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, EZCHAT_CURSOR_MOBILE_CENTER_LEFT
	ld [hl], a

	depixel 8, 19
	ld a, SPRITE_ANIM_OBJ_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, EZCHAT_CURSOR_MOBILE_CENTER_RIGHT
	ld [hl], a

	depixel 17, 14, 2, 0
	ld a, SPRITE_ANIM_OBJ_EZCHAT_CURSOR
	call InitSpriteAnimStruct
	ld hl, SPRITEANIMSTRUCT_VAR1
	add hl, bc
	ld a, EZCHAT_CURSOR_MOBILE_CENTER_CONFIRM
	ld [hl], a

	ld a, MOBILE_CENTER_LIST_CURSOR_MASK
	ld [wEZChatCursorBlinkMask], a
	ld a, MOBILE_CENTER_CONFIRM_CURSOR_MASK
	ld [wEZChatCursorHiddenMask], a
	jp MobileCenter_IncrementJumptable

MobileCenter_Joypad:
	ld hl, hJoyPressed
	ld a, [hl]
	and PAD_B
	jp nz, MobileCenter_Cancel
	ld a, [hl]
	and PAD_A
	jp nz, MobileCenter_SelectConfirm
	ld a, [hl]
	and PAD_UP
	jr nz, MobileCenter_MoveUp
	ld a, [hl]
	and PAD_DOWN
	jr nz, MobileCenter_MoveDown
	ret

MobileCenter_Cancel:
	ld a, JUMPTABLE_EXIT
	ld [wMobileCenterJumptableIndex], a
	ret

MobileCenter_MoveUp:
	ld a, [wMobileCenterIndex]
	and a
	ret z
	dec a
	ld [wMobileCenterIndex], a
	ret

MobileCenter_MoveDown:
	ld a, [wMobileCenterLastIndex]
	ld c, a
	ld a, [wMobileCenterIndex]
	cp c
	ret z
	inc a
	ld [wMobileCenterIndex], a
	ret

MobileCenter_SelectConfirm:
	call PlayClickSFX
	ld a, MOBILE_CENTER_CONFIRM_CURSOR_MASK
	ld [wEZChatCursorBlinkMask], a
	xor a
	ld [wEZChatCursorHiddenMask], a
	jp MobileCenter_IncrementJumptable

MobileCenter_ConfirmJoypad:
	ld hl, hJoyPressed
	ld a, [hl]
	and PAD_B
	jp nz, MobileCenter_ReturnToList
	ld a, [hl]
	and PAD_A
	jp nz, MobileCenter_SaveSelection
	ret

MobileCenter_ReturnToList:
	ld a, MOBILE_CENTER_LIST_CURSOR_MASK
	ld [wEZChatCursorBlinkMask], a
	ld a, MOBILE_CENTER_CONFIRM_CURSOR_MASK
	ld [wEZChatCursorHiddenMask], a
	ld hl, wMobileCenterJumptableIndex
	dec [hl]
	ret

MobileCenter_SaveSelection:
	ld a, BANK(sMobilePhoneNumberIndex)
	call OpenSRAM
	ld a, [wMobileCenterIndex]
	ld [sMobilePhoneNumberIndex], a
	call CloseSRAM
	ld hl, MobileCenterMessageMenuHeader
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	farcall HDMATransferTilemapAndAttrmap_Overworld
	hlcoord 1, 14
	ld de, MobileCenterSavedString
	call PlaceString
	ld a, [wMobileCenterIndex]
	cp NUM_MOBILE_CENTERS - 1
	jr z, .hide_last_entry_cursors
	ld a, MOBILE_CENTER_CONFIRM_CURSOR_MASK
	jr .set_hidden_cursors
.hide_last_entry_cursors
	ld a, MOBILE_CENTER_LIST_CURSOR_MASK | MOBILE_CENTER_CONFIRM_CURSOR_MASK
.set_hidden_cursors
	ld [wEZChatCursorHiddenMask], a
	ld a, MOBILE_CENTER_SAVED_DELAY
	ld [wMobileCenterDelay], a
	call MobileCenter_IncrementJumptable

MobileCenter_WaitSaved:
	ld hl, wMobileCenterDelay
	dec [hl]
	ret nz
	call ExitMenu
	call ClearBGPalettes
	jr MobileCenter_Exit

MobileCenter_StartErrorDelay:
	ld a, MOBILE_CENTER_ERROR_DELAY_FRAMES
	ld [wMobileCenterDelay], a
	call MobileCenter_IncrementJumptable

MobileCenter_ShowError:
	ld hl, wMobileCenterDelay
	dec [hl]
	ret nz
	call ClearBGPalettes
	farcall Stubbed_Function106462
	farcall Function106464
	ld a, MOBILE_ERROR_INIT_NO_FADE
	ld [wMobileErrorJumptableIndex], a
	farcall DisplayMobileError
MobileCenter_Exit:
	ld a, JUMPTABLE_EXIT
	ld [wMobileCenterJumptableIndex], a
	ret

MobileCenter_IncrementJumptable:
	ld hl, wMobileCenterJumptableIndex
	inc [hl]
	ret

MobileCenterMessageMenuHeader:
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 12, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	dw NULL
	db 0 ; default option

MobileCenterSavedString:
	db   "モバイルセンターを　けってい"
	next "しました@"
