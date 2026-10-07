; Mobile communication error screen and error-code formatting.

BattleTowerMobileError:
	call FadeToMenu
	xor a
	ld [wMobileErrorJumptableIndex], a
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a

	call DisplayMobileError

	pop af
	ldh [rWBK], a
	call ExitAllMenus
	ret

DisplayMobileError:
.loop
	call JoyTextDelay
	call .RunJumptable
	ld a, [wMobileErrorJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr nz, .quit
	farcall HDMATransferAttrmapAndTilemapToWRAMBank3
	jr .loop

.quit
	call .deinit
	ret

.deinit
; Discard the saved password after login, POP3, or Mobile Center
; authentication errors 22-000, 31-003, and 33-201.
	ld a, [wMobileErrorCodeBuffer]
	cp $22
	jr z, .check_login_error
	cp $31
	jr z, .check_pop3_error
	cp $33
	ret nz
	ld a, [wMobileErrorCodeBuffer + 1]
	cp $1
	ret nz
	ld a, [wMobileErrorCodeBuffer + 2]
	cp $2
	ret nz
	jr .clear_password

.check_pop3_error
	ld a, [wMobileErrorCodeBuffer + 1]
	cp $3
	ret nz
	ld a, [wMobileErrorCodeBuffer + 2]
	and a
	ret nz
	jr .clear_password

.check_login_error
	ld a, [wMobileErrorCodeBuffer + 1]
	and a
	ret nz
	ld a, [wMobileErrorCodeBuffer + 2]
	and a
	ret nz

.clear_password
	ld a, BANK(sMobileLoginPassword)
	call OpenSRAM
	xor a
	ld [sMobileLoginPassword], a
	call CloseSRAM
	ret

.RunJumptable:
	jumptable .Jumptable, wMobileErrorJumptableIndex

.Jumptable:
	table_width 2
	dw MobileError_Init
	dw MobileError_WaitButton
	dw MobileError_InitNoFade
	assert_table_length NUM_MOBILE_ERROR_STATES

MobileError_Init:
	call MobileError_DrawScreen
	farcall FinishExitMenu
	ld a, MOBILE_ERROR_WAIT_BUTTON
	ld [wMobileErrorJumptableIndex], a
	ret

MobileError_InitNoFade:
	call MobileError_DrawScreen
	farcall HDMATransferAttrmapAndTilemapToWRAMBank3
	call SetDefaultBGPAndOBP
	ld a, MOBILE_ERROR_WAIT_BUTTON
	ld [wMobileErrorJumptableIndex], a
	ret

MobileError_DrawScreen:
	ld a, $8
	ld [wMusicFade], a
	ld de, MUSIC_NONE
	ld a, e
	ld [wMusicFadeID], a
	ld a, d
	ld [wMusicFadeID + 1], a
	ld a, ' '
	hlcoord 0, 0
	ld bc, SCREEN_AREA
	call ByteFill
	ld a, MOBILE_TEXTBOX_PALETTE
	hlcoord 0, 0, wAttrmap
	ld bc, SCREEN_AREA
	call ByteFill
	hlcoord 2, 1
	ld b, 1
	ld c, 14
	call MobileHome_PlaceBoxWithPalette
	hlcoord 1, 4
	ld b, 12
	ld c, 16
	call MobileHome_PlaceBoxWithPalette
	hlcoord 3, 2
	ld de, MobileCommunicationErrorText
	call PlaceString
	call MobileError_PrintGameCode
	jr nc, .find_message
	hlcoord 11, 2
	call MobileError_PrintSDKCode

.find_message
	ld a, [wMobileErrorCodeBuffer]
	cp MOBILE_GAME_ERROR_FIRST
	jr nc, .game_error
	cp MOBILE_SDK_ERROR_FIRST
	jr c, .unknown_error
	sub MOBILE_SDK_ERROR_FIRST
	cp NUM_MOBILE_SDK_ERRORS
	jr nc, .unknown_error
	ld e, a
	ld d, 0
	ld hl, MobileErrorCodeTable
	add hl, de
	add hl, de
	ld a, [wMobileErrorCodeBuffer + 1]
	ld e, a
	ld a, [wMobileErrorCodeBuffer + 2]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld h, a
	ld l, c
	ld a, [hli]
	and a
	jr z, .unknown_error
	ld c, a
.next_subcode
; A subcode of $ffff is the fallback for this SDK error class.
	ld a, [hli]
	ld b, a
	ld a, [hli]
	cp $ff
	jr nz, .compare_subcode
	cp b
	jr z, .found

.compare_subcode
	xor d
	jr nz, .skip_message
	ld a, b
	xor e
	jr nz, .skip_message

.found
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	jr .place_message

.skip_message
	inc hl
	inc hl
	dec c
	jr nz, .next_subcode

.unknown_error
	ld a, MOBILE_ERROR_DEFAULT
	jr .game_error

.place_message
	hlcoord 2, 6
	call PlaceString
	ret

.game_error
	sub MOBILE_GAME_ERROR_FIRST
	ld e, a
	ld d, 0
	ld hl, MobileGameErrorTexts
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	hlcoord 2, 6
	call PlaceString
	ret

INCLUDE "data/mobile/game_error_messages.asm"

MobileError_PrintSDKCode:
; Error class and subcode are packed BCD, displayed as xx-nnn.
	ld a, [wMobileErrorCodeBuffer]
	call .bcd_two_digits
	inc hl
	ld a, [wMobileErrorCodeBuffer + 2]
	and $f
	call .bcd_digit
	ld a, [wMobileErrorCodeBuffer + 1]
	call .bcd_two_digits
	ret

.bcd_two_digits
	ld c, a
	and $f0
	swap a
	call .bcd_digit
	ld a, c
	and $f

.bcd_digit
	add '0'
	ld [hli], a
	ret

INCLUDE "data/mobile/error_messages.asm"

MobileError_WaitButton:
	ldh a, [hJoyPressed]
	and a
	ret z
	ld a, $8
	ld [wMusicFade], a
	ld a, [wMapMusic]
	ld [wMusicFadeID], a
	xor a
	ld [wMusicFadeID + 1], a
	ld hl, wMobileErrorJumptableIndex
	set JUMPTABLE_EXIT_F, [hl]
	ret

MobileError_PrintGameCode:
; Print 101-nnn for game errors. Carry means the caller must print an SDK code.
	nop
	ld a, [wMobileErrorCodeBuffer]
	cp MOBILE_GAME_ERROR_FIRST
	ret c
	hlcoord 10, 2
	ld de, MobileGameErrorPrefixText
	call PlaceString
	ld a, [wMobileErrorCodeBuffer]
	push af
	sub MOBILE_GAME_ERROR_FIRST
	inc a
	ld [wMobileErrorCodeBuffer], a
	hlcoord 14, 2
	ld de, wMobileErrorCodeBuffer
	lb bc, PRINTNUM_LEADINGZEROS | 1, 3
	call PrintNum
	pop af
	ld [wMobileErrorCodeBuffer], a
	and a
	ret

MobileGameErrorPrefixText:
	db "１０１@"
