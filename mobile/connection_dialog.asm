MobileConnectionDialog:
; Run one frame of the shared adapter/download dialog in WRAM bank 1.
; The caller selects a state and supplies its cancel/resume states.
	ldh a, [rWBK]
	ld [wMobileMenuSavedWRAMBank], a
	ld a, $1
	ldh [rWBK], a

	call .RunJumptable

	ld a, [wMobileMenuSavedWRAMBank]
	ldh [rWBK], a
	ld a, $1
	ldh [hBGMapMode], a
	ret

.RunJumptable:
	jumptable .Jumptable, wMobileDialogJumptableIndex

.Jumptable:
	table_width 2
	dw MobileDialog_Init
	dw MobileDialog_CallCenter
	dw MobileDialog_ConnectionFees
	dw MobileDialog_AdapterReady
	dw MobileDialog_CheckAdapterReady
	dw MobileDialog_Connected
	dw MobileDialog_StartDelay
	dw MobileDialog_WaitForCommunicating
	dw MobileDialog_Communicating
	dw MobileDialog_DownloadFeeIntro
	dw MobileDialog_DownloadFee
	dw MobileDialog_CheckDownloadFee
	dw MobileDialog_ConnectionClosed
	dw MobileDialog_ConnectionTime
	dw MobileDialog_Close
	dw MobileDialog_PlaceCancelMenu
	dw MobileDialog_UpdateCancelMenu
	dw MobileDialog_NewData
	dw MobileDialog_DownloadData
	dw MobileDialog_CheckDownloadData
	dw MobileDialog_PreviouslyDownloaded
	dw MobileDialog_DataMissing
	dw MobileDialog_RedownloadData
	dw MobileDialog_CheckRedownloadData
	dw MobileDialog_NoNewData
	dw MobileDialog_Wait
	dw MobileDialog_CancelDownload
	dw MobileDialog_CheckCancelDownload
	dw MobileDialog_CommunicatingWithCancel
	dw MobileDialog_DownloadNews
	dw MobileDialog_CheckDownloadNews
	dw MobileDialog_NoNews
	dw MobileDialog_Wait
	assert_table_length NUM_MOBILE_DIALOG_STATES

MobileDialog_Init:
	call MobileDialog_DrawBox
	jp MobileDialog_IncrementJumptable

MobileDialog_CallCenter:
	hlcoord 4, 2
	ld de, MobileDialogCallCenterString
	call PlaceString
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_ConnectionFees:
	ld a, [wMobileDialogDelay]
	and a
	jr z, .show_fees
	dec a
	ld [wMobileDialogDelay], a
	scf
	ret

.show_fees
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogConnectionFeesString
	call PlaceString
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_AdapterReady:
	ld a, [wMobileDialogDelay]
	and a
	jr z, .show_prompt
	dec a
	ld [wMobileDialogDelay], a
	scf
	ret

.show_prompt
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogAdapterReadyString
	call PlaceString
	call MobileDialog_DrawYesNoBox
	xor a
	ld [wMobileDialogSelection], a
	jp MobileDialog_IncrementJumptable

MobileDialog_CheckAdapterReady:
	call MobileDialog_Joypad
	ret c
	call PlayClickSFX
	ld a, [wMobileDialogSelection]
	and a
	jr nz, .cancel
	call ExitMenu
	call MobileDialog_ClearText
	xor a
	ld [wScriptVar], a
	call MobileDialog_RequestPassword
	ld a, [wScriptVar]
	and a
	jr z, .dialing
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	farcall MobilePhone_Hide
	ld a, [wMobileConnectionEndState]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, MOBILE_RESULT_CANCELED
	ld [wMobileErrorCodeBuffer], a
	scf
	ret

.dialing
	hlcoord 4, 2
	ld de, MobileDialogDialingString
	call PlaceString
	ld a, $1
	ld [wc30d], a
	ld a, $1
	ld [wc314], a
	farcall HDMATransferTilemapAndAttrmap_Overworld
	and a
	ret

.cancel
	call ExitMenu
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, [wMobileDialogCancelState]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	farcall MobilePhone_Hide
	ld a, MOBILE_RESULT_CANCELED
	ld [wMobileErrorCodeBuffer], a
	scf
	ret

MobileDialog_RequestPassword:
	ld a, BANK(sMobileLoginPassword)
	call OpenSRAM
	ld a, [sMobileLoginPassword]
	and a
	jr z, .request_password
	ld a, [sMobileLoginPassword + 1]
	call CloseSRAM
	and a
	ret nz
	ld a, BANK(sMobileLoginPassword)
	call OpenSRAM
	xor a
	ld [sMobileLoginPassword], a

.request_password
	call CloseSRAM
	ld a, [wBGMapPalBuffer]
	and a
	jr z, .overworld
	dec a
	jr z, .stadium
	jp MobileDialog_RequestPasswordForNews

.overworld
	ld a, BANK(w3_d800)
	ldh [rWBK], a
	ld hl, wc608
	ld de, w3_d800
	ld bc, 246
	call CopyBytes
	ld a, $1
	ldh [rWBK], a
	call FadeToMenu
	farcall Function11765d
	call MobileDialog_ReloadOverworld
	ld a, BANK(w3_d800)
	ldh [rWBK], a
	ld hl, w3_d800
	ld de, wc608
	ld bc, 246
	call CopyBytes
	ld a, $1
	ldh [rWBK], a
	farcall MobilePhone_Init
	ld c, MOBILE_PHONE_ANIM_DIALING
	farcall MobilePhone_SetAnimation
	ld a, $1
	ld [wMobilePhoneEnabled], a
	ret

.stadium
	xor a
	ld [wMenuBorderLeftCoord], a
	ld [wMenuBorderTopCoord], a
	ld a, SCREEN_WIDTH - 1
	ld [wMenuBorderRightCoord], a
	ld a, $5
	ld [wMenuBorderBottomCoord], a
	call PushWindow
	farcall Function11765d
	farcall Function117ab4
	farcall Stubbed_Function106462
	farcall Function106464
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	farcall MobilePhone_Init
	ld c, MOBILE_PHONE_ANIM_DIALING
	farcall MobilePhone_SetAnimation
	ld a, $1
	ld [wMobilePhoneEnabled], a
	ret

MobileDialog_RequestPasswordForNews:
	xor a
	ld [wMenuBorderLeftCoord], a
	ld [wMenuBorderTopCoord], a
	ld a, SCREEN_WIDTH - 1
	ld [wMenuBorderRightCoord], a
	ld a, SCREEN_HEIGHT - 1
	ld [wMenuBorderBottomCoord], a
	call PushWindow
	farcall Function11765d
	farcall PokemonNews_ClearScreen
	farcall Stubbed_Function106462
	farcall Function106464
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	farcall MobilePhone_Init
	ld c, MOBILE_PHONE_ANIM_DIALING
	farcall MobilePhone_SetAnimation
	ld a, $1
	ld [wMobilePhoneEnabled], a
	ret

MobileDialog_Connected:
	call MobileDialog_ClearText
	ld c, MOBILE_PHONE_ANIM_SIGNAL
	farcall MobilePhone_SetAnimation
	hlcoord 4, 2
	ld de, MobileDialogConnectedString
	call PlaceString
	and a
	ret

MobileDialog_StartDelay:
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_WaitForCommunicating:
	ld hl, wMobileDialogDelay
	dec [hl]
	ret nz
	ld a, [wMobileDialogJumptableIndex]
	inc a
	ld [wMobileDialogJumptableIndex], a

MobileDialog_Communicating:
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogCommunicatingString
	call PlaceString
	and a
	ret

MobileDialog_DownloadFeeIntro:
	ld hl, wMobileDownloadFeeString
	ld a, [hl]
	cp MOBILE_DOWNLOAD_FEE_NONDIGIT
	jr nz, .check_fee
	and a
	ret

.check_fee
	call MobileDialog_CheckDownloadFeeString
	ret c
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogDownloadFeeIntroString
	call PlaceString
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_DownloadFee:
	ld a, [wMobileDialogDelay]
	and a
	jr z, .show_fee
	dec a
	ld [wMobileDialogDelay], a
	scf
	ret

.show_fee
	call MobileDialog_ClearText
	call MobileDialog_BuildDownloadFeeString
	hlcoord 4, 2
	ld de, wMobileDownloadFeeQuestion
	call PlaceString
	call MobileDialog_DrawYesNoBox
	xor a
	ld [wMobileDialogSelection], a
	jp MobileDialog_IncrementJumptable

MobileDialog_CheckDownloadFee:
	call MobileDialog_Joypad
	ret c
	call PlayClickSFX
	ld a, [wMobileDialogSelection]
	and a
	jr nz, .cancel
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogCommunicatingString
	call PlaceString
	and a
	ret

.cancel
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, [wMobileDialogCancelState]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld [wcd80], a
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogCommunicatingString
	call PlaceString
	scf
	ret

MobileDialog_CheckDownloadFeeString:
; Reject an empty fee string (no price digits, or more than three).
	ld a, [wMobileDownloadFeeString]
	cp "@"
	jr nz, .valid
	ld a, MOBILE_ERROR_INVALID_DOWNLOAD
	call SetMobileErrorCode
	scf
	ret

.valid
	and a
	ret

MobileDialog_BuildDownloadFeeString:
	ld hl, MobileDialogDownloadFeePrefixString
	ld de, wMobileDownloadFeeQuestion
	call MobileDialog_CopyString
	ld hl, wMobileDownloadFeeString
	call MobileDialog_CopyString
	ld hl, MobileDialogDownloadFeeSuffixString
	call MobileDialog_CopyString
	ld a, "@"
	ld [de], a
	ret

MobileDialog_CopyString:
; Append hl to de, excluding the terminator.
.loop
	ld a, [hli]
	cp "@"
	ret z
	ld [de], a
	inc de
	jr .loop

MobileDialog_PlaceCancelMenu:
	ld hl, MobileDialogCancelMenuHeader
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	call ApplyTilemap
	hlcoord 16, 8
	ld de, BattleTowerYesString
	call PlaceString
	hlcoord 16, 10
	ld de, BattleTowerNoString
	call PlaceString
	hlcoord 15, 8
	ld a, "▶"
	ld [hl], a
	xor a
	ld [wMobileDialogSelection], a
	jp MobileDialog_IncrementJumptable

MobileDialog_UpdateCancelMenu:
	ld hl, hJoyPressed
	ld a, [hl]
	and PAD_A
	jr nz, .a_button
	ld a, [hl]
	and PAD_B
	jr nz, .b_button
	ld a, [hl]
	and PAD_UP
	jr nz, .d_up
	ld a, [hl]
	and PAD_DOWN
	jr nz, .d_down
.wait
	call MobileDialog_CheckLegacyInactivityTimeout
	scf
	ret

.d_up
	xor a
	ld [wMobileLegacyInactivityCounter], a
	ld [wMobileLegacyInactivityCounter + 1], a
	ld a, [wMobileDialogSelection]
	and a
	jr z, .wait
	xor a
	ld [wMobileDialogSelection], a
	hlcoord 15, 8
	ld a, "▶"
	ld [hl], a
	hlcoord 15, 10
	ld a, " "
	ld [hl], a
	jr .wait

.d_down
	xor a
	ld [wMobileLegacyInactivityCounter], a
	ld [wMobileLegacyInactivityCounter + 1], a
	ld a, [wMobileDialogSelection]
	and a
	jr nz, .wait
	inc a
	ld [wMobileDialogSelection], a
	hlcoord 15, 8
	ld a, " "
	ld [hl], a
	hlcoord 15, 10
	ld a, "▶"
	ld [hl], a
	jr .wait

.a_button
	xor a
	ld [wMobileLegacyInactivityCounter], a
	ld [wMobileLegacyInactivityCounter + 1], a
	call PlayClickSFX
	ld a, [wMobileDialogSelection]
	and a
	jr nz, .exit_no_carry
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, [wMobileDialogResumeState]
	cp $0
	jr z, .end_connection
	ld a, [wMobileDialogCancelConfirmState]
	jr .exit_carry

.end_connection
	ld a, [wMobileConnectionEndState]

.exit_carry
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, MOBILE_RESULT_CANCELED
	ld [wMobileErrorCodeBuffer], a
	scf
	ret

.b_button
	call PlayClickSFX

.exit_no_carry
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	and a
	ret

INCLUDE "data/mobile/connection_dialog_menus.asm"

MobileDialog_ConnectionClosed:
	call MobileDialog_ClearText
	ld c, MOBILE_PHONE_ANIM_IDLE
	farcall MobilePhone_SetAnimation
	hlcoord 4, 2
	ld de, MobileDialogConnectionClosedString
	call PlaceString
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_ConnectionTime:
	ld a, [wMobileDialogDelay]
	and a
	jr z, .show_time
	dec a
	ld [wMobileDialogDelay], a
	scf
	ret

.show_time
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogConnectionTimeString
	call PlaceString
	hlcoord 9, 4
	ld de, wMobileConnectionTimeMinutes
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	hlcoord 14, 4
	ld de, wMobileConnectionTimeSeconds
	lb bc, PRINTNUM_LEADINGZEROS | 1, 2
	call PrintNum
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_Close:
	ld a, [wMobileDialogDelay]
	and a
	jr z, .close
	dec a
	ld [wMobileDialogDelay], a
	scf
	ret

.close
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	farcall MobilePhone_Hide
	and a
	ret

MobileDialog_NewData:
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogNewDataString
	call PlaceString
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_DownloadData:
	ld a, [wMobileDialogDelay]
	and a
	jr z, .show_prompt
	dec a
	ld [wMobileDialogDelay], a
	scf
	ret

.show_prompt
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogDownloadDataString
	call PlaceString
	call MobileDialog_DrawYesNoBox
	xor a
	ld [wMobileDialogSelection], a
	jp MobileDialog_IncrementJumptable

MobileDialog_CheckDownloadData:
	call MobileDialog_Joypad
	ret c
	call PlayClickSFX
	ld a, [wMobileDialogSelection]
	and a
	jr nz, .cancel
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogCommunicatingString
	call PlaceString
	and a
	ret

.cancel
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, [wMobileDialogCancelState]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld [wcd80], a
	scf
	ret

MobileDialog_PreviouslyDownloaded:
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogPreviouslyDownloadedString
	call PlaceString
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_DataMissing:
	ld a, [wMobileDialogDelay]
	and a
	jr z, .show_message
	dec a
	ld [wMobileDialogDelay], a
	scf
	ret

.show_message
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogDataMissingString
	call PlaceString
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_RedownloadData:
	ld a, [wMobileDialogDelay]
	and a
	jr z, .show_prompt
	dec a
	ld [wMobileDialogDelay], a
	scf
	ret

.show_prompt
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogDownloadDataString
	call PlaceString
	call MobileDialog_DrawYesNoBox
	xor a
	ld [wMobileDialogSelection], a
	jp MobileDialog_IncrementJumptable

MobileDialog_CheckRedownloadData:
	call MobileDialog_Joypad
	ret c
	call PlayClickSFX
	ld a, [wMobileDialogSelection]
	and a
	jr nz, .cancel
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogCommunicatingString
	call PlaceString
	and a
	ret

.cancel
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, $1c
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld [wcd80], a
	scf
	ret

MobileDialog_NoNewData:
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogNoNewDataString
	call PlaceString
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_NoNews:
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogNoNewsString
	call PlaceString
	ld a, MOBILE_DIALOG_DELAY_FRAMES
	ld [wMobileDialogDelay], a
	jp MobileDialog_IncrementJumptable

MobileDialog_Wait:
	ld a, [wMobileDialogDelay]
	and a
	jr z, .done
	dec a
	ld [wMobileDialogDelay], a
	scf
	ret

.done
	and a
	ret

MobileDialog_CancelDownload:
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogCancelDownloadString
	call PlaceString
	call MobileDialog_DrawYesNoBox
	xor a
	ld [wMobileDialogSelection], a
	jp MobileDialog_IncrementJumptable

MobileDialog_CheckCancelDownload:
	call MobileDialog_Joypad
	ret c
	call PlayClickSFX
	ld a, [wMobileDialogSelection]
	and a
	jr nz, .resume
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogCommunicatingString
	call PlaceString
	ld a, $14
	ld [wBattleTowerRoomMenuJumptableIndex], a
	and a
	ret

.resume
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, [wMobileDialogResumeState]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld [wcd80], a
	scf
	ret

MobileDialog_CommunicatingWithCancel:
	call MobileDialog_ClearText
	ld de, MobileDialogCommunicatingWithCancelString
	hlcoord 4, 2
	call PlaceString
	ret

MobileDialog_DownloadNews:
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogDownloadNewsString
	call PlaceString
	call MobileDialog_DrawYesNoBox
	xor a
	ld [wMobileDialogSelection], a
	jp MobileDialog_IncrementJumptable

MobileDialog_CheckDownloadNews:
	call MobileDialog_Joypad
	ret c
	call PlayClickSFX
	ld a, [wMobileDialogSelection]
	and a
	jr nz, .cancel
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	call MobileDialog_ClearText
	hlcoord 4, 2
	ld de, MobileDialogCommunicatingString
	call PlaceString
	and a
	ret

.cancel
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, [wMobileDialogCancelState]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld [wcd80], a
	scf
	ret

MobileDialog_Joypad:
; Carry while waiting; selection 0 is YES, 1 is NO (also selected by B).
	ld hl, hJoyPressed
	ld a, [hl]
	and PAD_A
	jr nz, .done
	ld a, [hl]
	and PAD_B
	jr nz, .b_button
	ld a, [hl]
	and PAD_UP
	jr nz, .d_up
	ld a, [hl]
	and PAD_DOWN
	jr nz, .d_down
.check_timeout
	ld a, [wMobileDialogJumptableIndex]
	cp MOBILE_DIALOG_CHECK_ADAPTER_READY
	jr z, .wait
	call MobileDialog_CheckLegacyInactivityTimeout
	jr nz, .wait
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld

.wait
	scf
	ret

.d_up
	xor a
	ld [wMobileLegacyInactivityCounter], a
	ld [wMobileLegacyInactivityCounter + 1], a
	ld a, [wMobileDialogSelection]
	and a
	jr z, .check_timeout
	xor a
	ld [wMobileDialogSelection], a
	hlcoord 15, 7
	ld a, "▶"
	ld [hl], a
	hlcoord 15, 9
	ld a, " "
	ld [hl], a
	jr .check_timeout

.d_down
	xor a
	ld [wMobileLegacyInactivityCounter], a
	ld [wMobileLegacyInactivityCounter + 1], a
	ld a, [wMobileDialogSelection]
	and a
	jr nz, .check_timeout
	inc a
	ld [wMobileDialogSelection], a
	hlcoord 15, 7
	ld a, " "
	ld [hl], a
	hlcoord 15, 9
	ld a, "▶"
	ld [hl], a
	jr .check_timeout

.b_button
	ld a, $1
	ld [wMobileDialogSelection], a

.done
	xor a
	ld [wMobileLegacyInactivityCounter], a
	ld [wMobileLegacyInactivityCounter + 1], a
	and a
	ret

MobileDialog_IncrementJumptable:
	ld a, [wMobileDialogJumptableIndex]
	inc a
	ld [wMobileDialogJumptableIndex], a
	scf
	ret

MobileDialog_DrawBox:
	xor a
	ld [wMenuBorderLeftCoord], a
	ld [wMenuBorderTopCoord], a
	ld a, SCREEN_WIDTH - 1
	ld [wMenuBorderRightCoord], a
	ld a, $5
	ld [wMenuBorderBottomCoord], a
	call PushWindow
	hlcoord 0, 0, wAttrmap
	ld b, $6
	ld c, SCREEN_WIDTH
	hlcoord 0, 0
	ld b, $4
	ld c, SCREEN_WIDTH - 2
	call MobileHome_PlaceBoxWithPalette
	farcall HDMATransferTilemapAndAttrmap_Overworld
	call UpdateSprites
	ld c, MOBILE_PHONE_ANIM_DIALING
	farcall MobilePhone_SetAnimation
	ld a, $1
	ld [wMobilePhoneEnabled], a
	ret

MobileDialog_DrawYesNoBox:
	ld a, $e
	ld [wMenuBorderLeftCoord], a
	ld a, SCREEN_WIDTH - 1
	ld [wMenuBorderRightCoord], a
	ld a, $6
	ld [wMenuBorderTopCoord], a
	ld a, $a
	ld [wMenuBorderBottomCoord], a
	call PushWindow
	hlcoord 14, 6, wAttrmap
	ld b, $5
	ld c, $6
	hlcoord 14, 6
	ld b, $3
	ld c, $4
	call MobileHome_PlaceBoxWithPalette
	hlcoord 16, 7
	ld de, BattleTowerYesString
	call PlaceString
	hlcoord 16, 9
	ld de, BattleTowerNoString
	call PlaceString
	hlcoord 15, 7
	ld a, "▶"
	ld [hl], a
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ret

MobileDialog_ClearText:
	hlcoord 4, 1
	ld de, MobileDialogBlankLineString
	call PlaceString
	hlcoord 4, 2
	ld de, MobileDialogBlankLineString
	call PlaceString
	hlcoord 4, 3
	ld de, MobileDialogBlankLineString
	call PlaceString
	hlcoord 4, 4
	ld de, MobileDialogBlankLineString
	call PlaceString
	ret

INCLUDE "data/mobile/connection_dialog.asm"
