MobileTrade_SendCancellation:
	ld a, $1
	ld [wcd38], a
	jr MobileTrade_RunOfferRequest

MobileTrade_SendOffer:
	xor a
	ld [wcd38], a

MobileTrade_RunOfferRequest:
	call Mobile_InitConnection
	ld a, $18
	ld [wMobileConnectionEndState], a
	ld a, $19
	ld [wMobileConnectionErrorState], a
	ld a, MOBILE_PICHU_RESTORE_OVERWORLD
	ld [wMobilePichuRestoreState], a
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
.loop
	call JoyTextDelay
	call Mobile_UpdateConnectionTimer
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $1b
	jr c, .skip
	ld a, [wMobileConnectionErrorState]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.skip
	call Function1184a5
	call Mobile_WriteMessage
	farcall MobilePhone_Update
	farcall MobilePichu_Update
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wMobileConnectionEndState
	cp [hl]
	jr nz, .loop
	pop af
	ldh [rWBK], a
	call Mobile_CleanupConnection
	call ReturnToMapFromSubmenu
BattleTowerRoomMenu_DoNothing:
Mobile_ConnectionDoNothing:
	ret

BattleTower_UploadRecord:
	ld a, $1
	ld [wcd38], a
	call Mobile_InitConnection
	ld a, $18
	ld [wMobileConnectionEndState], a
	ld a, $19
	ld [wMobileConnectionErrorState], a
	ld a, MOBILE_PICHU_RESTORE_OVERWORLD
	ld [wMobilePichuRestoreState], a
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
.asm_11807d
	call JoyTextDelay
	call Mobile_UpdateConnectionTimer
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $1b
	jr c, .asm_118090
	ld a, [wMobileConnectionErrorState]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_118090
	call Function11857c
	call Mobile_WriteMessage
	farcall MobilePhone_Update
	farcall MobilePichu_Update
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wMobileConnectionEndState
	cp [hl]
	jr nz, .asm_11807d
	pop af
	ldh [rWBK], a
	call Mobile_CleanupConnection
	call ReturnToMapFromSubmenu
	ret

MobileTrade_ReceiveReply:
	call Mobile_InitConnection
	ld a, $22
	ld [wMobileConnectionEndState], a
	ld a, $23
	ld [wMobileConnectionErrorState], a
	ld a, MOBILE_PICHU_RESTORE_OVERWORLD
	ld [wMobilePichuRestoreState], a
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
.loop
	call JoyTextDelay
	call Mobile_UpdateConnectionTimer
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $28
	jr c, .check_cancel
	ld a, [wMobileConnectionErrorState]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.check_cancel
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $10
	jr c, .run_state
	cp $16
	jr nc, .run_state
	call Mobile_CheckConnectionCancel

.run_state
	call Function1184ec
	call Mobile_WriteMessage
	farcall MobilePhone_Update
	farcall MobilePichu_Update
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wMobileConnectionEndState
	cp [hl]
	jr nz, .loop
	pop af
	ldh [rWBK], a
	call Mobile_CleanupConnection
	call ReturnToMapFromSubmenu
	ret

Function11811a:
	ld a, 1
	ld [wcd38], a
	jr Function118125

_BattleTowerRoomMenu:
	xor a
	ld [wcd38], a
Function118125:
	call Mobile_InitConnection
	ld a, $3
	ld [wMobileConnectionEndState], a
	ld a, $d
	ld [wMobileConnectionErrorState], a
	ld a, MOBILE_PICHU_RESTORE_OVERWORLD
	ld [wMobilePichuRestoreState], a
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
.loop
	call JoyTextDelay
	call Mobile_UpdateConnectionTimer
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $f
	jr c, .skip
	ld a, [wMobileConnectionErrorState]
	ld [wBattleTowerRoomMenuJumptableIndex], a
.skip
	call BattleTowerRoomMenu_Jumptable
	call Mobile_WriteMessage
	farcall MobilePhone_Update
	farcall MobilePichu_Update
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wMobileConnectionEndState
	cp [hl]
	jr nz, .loop
	xor a
	ld [w3_d000], a
	pop af
	ldh [rWBK], a
	call Mobile_CleanupConnection
	call BattleTower_SaveHonorRoll
	call ReturnToMapFromSubmenu
	ret

BattleTower_SaveHonorRoll:
	ld a, [wScriptVar]
	and a
	ret nz
	ld a, [wcd38]
	and a
	ret z
	ld a, BANK(s5_a89c) ; aka BANK(s5_a8b2)
	call OpenSRAM
	ld hl, wcd69
	ld de, s5_a89c
	ld bc, 22
	call CopyBytes

	ldh a, [rWBK]
	push af
	ld a, BANK(w3_d202)
	ldh [rWBK], a

	ld de, w3_d202
	ld c, $96
	farcall CheckStringForErrors_IgnoreTerminator
	jr c, .return_d3

	ld de, w3_d202
	lb bc, 1, $96
	farcall CheckStringContainsLessThanBNextCharacters
	jr c, .return_d3

	ld hl, w3_d202
	ld de, s5_a8b2
	ld bc, 150
	call CopyBytes
.reset_banks
	pop af
	ldh [rWBK], a
	call CloseSRAM
	ret

.return_d3
	ld a, $d3
	ld [wMobileErrorCodeBuffer], a
	ld [wScriptVar], a
	jr .reset_banks

Mobile_DownloadNews:
	call Mobile_InitConnection
	ld a, $2
	ld [wcd38], a
	ld a, $21
	ld [wMobileConnectionEndState], a
	ld a, $22
	ld [wMobileConnectionErrorState], a
	ld a, MOBILE_PICHU_RESTORE_OVERWORLD
	ld [wMobilePichuRestoreState], a
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
.asm_1181f8
	call JoyTextDelay
	call Mobile_UpdateConnectionTimer
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $28
	jr c, .asm_11820b
	ld a, [wMobileConnectionErrorState]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_11820b
	call Mobile_DownloadNewsJumptable
	call Mobile_WriteMessage
	farcall MobilePhone_Update
	farcall MobilePichu_Update
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wMobileConnectionEndState
	cp [hl]
	jr nz, .asm_1181f8
	pop af
	ldh [rWBK], a
	call Mobile_CleanupConnection
	call ReturnToMapFromSubmenu
	ret

Mobile_UpdateNewsRankings:
	call Mobile_InitConnection
	ld a, $1b
	ld [wMobileConnectionEndState], a
	ld a, $1c
	ld [wMobileConnectionErrorState], a
	ld a, MOBILE_PICHU_RESTORE_NEWS
	ld [wMobilePichuRestoreState], a
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
.asm_11824c
	call JoyTextDelay
	call Mobile_UpdateConnectionTimer
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $1e
	jr c, .asm_11825f
	ld a, [wMobileConnectionErrorState]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_11825f
	call Mobile_UpdateNewsRankingsJumptable
	call Mobile_WriteMessage
	farcall MobilePhone_Update
	farcall MobilePichu_Update
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wMobileConnectionEndState
	cp [hl]
	jr nz, .asm_11824c
	pop af
	ldh [rWBK], a
	call Mobile_CleanupConnection
	ret

Mobile_DownloadStadiumData:
	call Mobile_InitConnection
	ld a, MOBILE_STADIUM_DOWNLOAD_DONE
	ld [wMobileConnectionEndState], a
	ld a, MOBILE_STADIUM_DOWNLOAD_ERROR
	ld [wMobileConnectionErrorState], a
	ld a, MOBILE_PICHU_RESTORE_STADIUM
	ld [wMobilePichuRestoreState], a
	ldh a, [rWBK]
	push af
	ld a, BANK(wMobileReceiveBuffer)
	ldh [rWBK], a
.loop
	call JoyTextDelay
	call Mobile_UpdateConnectionTimer
	ld a, [wMobileConnectionJumptableIndex]
	cp MOBILE_STADIUM_DOWNLOAD_UNUSED_DISCONNECT
	jr c, .run_state
	ld a, [wMobileConnectionErrorState]
	ld [wMobileConnectionJumptableIndex], a
.run_state
	call Mobile_DownloadStadiumJumptable
	call Mobile_WriteMessage
	farcall MobilePhone_Update
	farcall MobilePichu_Update
	call DelayFrame
	ld a, [wMobileConnectionJumptableIndex]
	ld hl, wMobileConnectionEndState
	cp [hl]
	jr nz, .loop
	pop af
	ldh [rWBK], a
	call Mobile_CleanupConnection
	ret

Function1182d5: ; unreferenced
	call Mobile_InitConnection
	ld a, $18
	ld [wMobileConnectionEndState], a
	ld a, $19
	ld [wMobileConnectionErrorState], a
	ld a, MOBILE_PICHU_RESTORE_OVERWORLD
	ld [wMobilePichuRestoreState], a
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
.asm_1182ee
	call JoyTextDelay
	call Mobile_UpdateConnectionTimer
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $1b
	jr c, .asm_118301
	ld a, [wMobileConnectionErrorState]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_118301
	call Function118746
	call Mobile_WriteMessage
	farcall MobilePhone_Update
	farcall MobilePichu_Update
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wMobileConnectionEndState
	cp [hl]
	jr nz, .asm_1182ee
	pop af
	ldh [rWBK], a
	call Mobile_CleanupConnection
	call ReturnToMapFromSubmenu
	ret

Function118329:
	call Mobile_InitConnection
	ld a, $15
	ld [wMobileConnectionEndState], a
	ld a, $16
	ld [wMobileConnectionErrorState], a
	ld a, MOBILE_PICHU_RESTORE_NEWS
	ld [wMobilePichuRestoreState], a
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
.asm_118342
	call JoyTextDelay
	call Mobile_UpdateConnectionTimer
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $18
	jr c, .asm_118355
	ld a, [wMobileConnectionErrorState]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_118355
	call Function118671
	call Mobile_WriteMessage
	farcall MobilePhone_Update
	farcall MobilePichu_Update
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wMobileConnectionEndState
	cp [hl]
	jr nz, .asm_118342
	pop af
	ldh [rWBK], a
	call Mobile_CleanupConnection
	ret

Function11837a:
	call Mobile_InitConnection
	ld a, $16
	ld [wMobileConnectionEndState], a
	ld a, $17
	ld [wMobileConnectionErrorState], a
	ld a, MOBILE_PICHU_RESTORE_NEWS
	ld [wMobilePichuRestoreState], a
	ldh a, [rWBK]
	push af
	ld a, $3
	ldh [rWBK], a
.asm_118393
	call JoyTextDelay
	call Mobile_UpdateConnectionTimer
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	cp $19
	jr c, .asm_1183a6
	ld a, [wMobileConnectionErrorState]
	ld [wBattleTowerRoomMenuJumptableIndex], a

.asm_1183a6
	call Function1186b2
	call Mobile_WriteMessage
	farcall MobilePhone_Update
	farcall MobilePichu_Update
	call DelayFrame
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	ld hl, wMobileConnectionEndState
	cp [hl]
	jr nz, .asm_118393
	pop af
	ldh [rWBK], a
	call Mobile_CleanupConnection
	ret

INCLUDE "mobile/connection.asm"

Function1184a5:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Mobile_InitOverworldConnectionDialog
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw Mobile_ReadPhoneNumber
	dw MobileAdapterCommunication
	dw Mobile_ReadLoginID
	dw MobileAdapterCommunication
	dw Mobile_ReadEmailAddress
	dw MobileAdapterCommunication
	dw Mobile_LoginToISP
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Mobile_DownloadTradeCornerIndex
	dw MobileAdapterCommunication
	dw Function118d80
	dw Mobile_HTTPPostTradeRequest
	dw MobileAdapterCommunication
	dw Function118ded
	dw Mobile_LogoutOfISP
	dw MobileAdapterCommunication
	dw DisplaySendToTradeCornerAnimation
	dw Mobile_StartDisconnectDialog
	dw Mobile_EndConnection
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Mobile_StartDisconnectDialog
	dw Mobile_WaitForDisconnectDialog
	dw Mobile_StartDisconnectDialog

Function1184ec:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Mobile_InitOverworldConnectionDialog
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw Mobile_ReadPhoneNumber
	dw MobileAdapterCommunication
	dw Mobile_ReadLoginID
	dw MobileAdapterCommunication
	dw Mobile_ReadEmailAddress
	dw MobileAdapterCommunication
	dw Mobile_LoginToISP
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Mobile_LoginToPOP3
	dw MobileAdapterCommunication
	dw Function119973
	dw MobileAdapterCommunication
	dw Function119987
	dw MobileAdapterCommunication
	dw Function1199b4
	dw Function1199ca
	dw MobileAdapterCommunication
	dw Function1199e2
	dw Function119b0d
	dw MobileAdapterCommunication
	dw DecodeReceivedTradeCornerTrade
	dw DeleteTradeEmail
	dw MobileAdapterCommunication
	dw Mobile_LogoutOfPOP3
	dw MobileAdapterCommunication
	dw Mobile_LogoutOfISP
	dw MobileAdapterCommunication
	dw Mobile_StartDisconnectDialog
	dw Mobile_EndConnection
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Mobile_StartDisconnectDialog
	dw Mobile_WaitForDisconnectDialog
	dw DeleteInvalidTradeEmail
	dw MobileAdapterCommunication
	dw Function119ac9
	dw Mobile_StartDisconnectDialog

BattleTowerRoomMenu_Jumptable:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw BattleTowerRoomMenu_PickLevelMessage
	dw BattleTowerRoomMenu_PlacePickLevelMenu
	dw BattleTowerRoomMenu_UpdatePickLevelMenu
	dw BattleTowerRoomMenu_DoNothing
	dw BattleTowerRoomMenu_PartyMonTopsThisLevelMessage
	dw BattleTowerRoomMenu_WaitForMessage
	dw BattleTowerRoomMenu_DelayRestartMenu
	dw BattleTowerRoomMenu_QuitMessage
	dw BattleTowerRoomMenu_PlaceYesNoMenu
	dw BattleTowerRoomMenu_UpdateYesNoMenu
	dw BattleTowerRoomMenu_UberRestrictionMessage
	dw BattleTowerRoomMenu_WaitForMessage
	dw BattleTowerRoomMenu_DelayRestartMenu
	dw Mobile_StartDisconnectDialog ; mobile
	dw Mobile_WaitForDisconnectDialog ; mobile
	dw Mobile_StartDisconnectDialog ; mobile

Function11857c:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Mobile_InitOverworldConnectionDialog
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw Mobile_ReadPhoneNumber
	dw MobileAdapterCommunication
	dw Mobile_ReadLoginID
	dw MobileAdapterCommunication
	dw Mobile_ReadEmailAddress
	dw MobileAdapterCommunication
	dw Mobile_LoginToISP
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Mobile_DownloadBattleTowerIndexWithTimer
	dw MobileAdapterCommunication
	dw BattleTower_ParseIndex
	dw Function1198ee
	dw BattleTower_HTTPPostRecord
	dw MobileAdapterCommunication
	dw Function119937
	dw Mobile_LogoutOfISP
	dw MobileAdapterCommunication
	dw Mobile_StartDisconnectDialog
	dw Mobile_EndConnection
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Mobile_StartDisconnectDialog
	dw Mobile_WaitForDisconnectDialog
	dw Mobile_StartDisconnectDialog

Mobile_DownloadNewsJumptable:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Mobile_InitOverworldConnectionDialog
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw Mobile_ReadPhoneNumber
	dw MobileAdapterCommunication
	dw Mobile_ReadLoginID
	dw MobileAdapterCommunication
	dw Mobile_ReadEmailAddress
	dw MobileAdapterCommunication
	dw Mobile_LoginToISP
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Mobile_DownloadNewsIndex
	dw MobileAdapterCommunication
	dw Mobile_DownloadNewsMetadata
	dw MobileAdapterCommunication
	dw Mobile_CheckDownloadedNewsID
	dw Function118ec6
	dw Function118f0d
	dw Function118f14
	dw Function118f5e
	dw MobileAdapterCommunication
	dw Mobile_TryDownloadNewsRankings
	dw MobileAdapterCommunication
	dw Mobile_SaveDownloadedNewsRankings
	dw Mobile_DownloadNewsData
	dw MobileAdapterCommunication
	dw Mobile_SaveDownloadedNews
	dw Mobile_LogoutOfISP
	dw MobileAdapterCommunication
	dw Mobile_StartDisconnectDialog
	dw Mobile_EndConnection
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Mobile_StartDisconnectDialog
	dw Mobile_WaitForDisconnectDialog
	dw BattleTowerRoomMenu_QuitMessage
	dw BattleTowerRoomMenu_PlaceYesNoMenu
	dw BattleTowerRoomMenu_UpdateYesNoMenu
	dw Function11914e
	dw Mobile_StartDisconnectDialog

Mobile_UpdateNewsRankingsJumptable:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Mobile_InitNewsConnectionDialog
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw Mobile_ReadPhoneNumber
	dw MobileAdapterCommunication
	dw Mobile_ReadLoginID
	dw MobileAdapterCommunication
	dw Mobile_ReadEmailAddress
	dw MobileAdapterCommunication
	dw Mobile_LoginToISP
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Mobile_DownloadNewsIndex
	dw MobileAdapterCommunication
	dw Mobile_DownloadNewsMetadata
	dw MobileAdapterCommunication
	dw Mobile_CheckNewsRankingsID
	dw Function118f68
	dw MobileAdapterCommunication
	dw Mobile_HTTPPostNewsRankings
	dw MobileAdapterCommunication
	dw Mobile_SaveDownloadedNewsRankings
	dw Mobile_LogoutOfISP
	dw MobileAdapterCommunication
	dw Mobile_StartDisconnectDialog
	dw Mobile_EndConnection
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Mobile_StartDisconnectDialog
	dw Mobile_WaitForDisconnectDialog
	dw Mobile_StartDisconnectDialog

Function118671:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Mobile_InitNewsConnectionDialog
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw Mobile_ReadPhoneNumber
	dw MobileAdapterCommunication
	dw Mobile_ReadLoginID
	dw MobileAdapterCommunication
	dw Mobile_ReadEmailAddress
	dw MobileAdapterCommunication
	dw Mobile_LoginToISP
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Function119380
	dw Function119388
	dw Function1193a0
	dw MobileAdapterCommunication
	dw Mobile_LogoutOfISP
	dw MobileAdapterCommunication
	dw Mobile_StartDisconnectDialog
	dw Mobile_EndConnection
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Mobile_StartDisconnectDialog
	dw Mobile_WaitForDisconnectDialog
	dw Mobile_StartDisconnectDialog

Function1186b2:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Mobile_InitNewsConnectionDialog
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw Mobile_ReadPhoneNumber
	dw MobileAdapterCommunication
	dw Mobile_ReadLoginID
	dw MobileAdapterCommunication
	dw Mobile_ReadEmailAddress
	dw MobileAdapterCommunication
	dw Mobile_LoginToISP
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Function119380
	dw Function1193e3
	dw Function1193fb
	dw MobileAdapterCommunication
	dw Function119413
	dw Mobile_LogoutOfISP
	dw MobileAdapterCommunication
	dw Mobile_StartDisconnectDialog
	dw Mobile_EndConnection
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Mobile_StartDisconnectDialog
	dw Mobile_WaitForDisconnectDialog
	dw Mobile_StartDisconnectDialog

Mobile_DownloadStadiumJumptable:
	jumptable .Jumptable, wMobileConnectionJumptableIndex

.Jumptable:
	table_width 2
	dw Mobile_InitStadiumConnectionDialog
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw Mobile_ReadPhoneNumber
	dw MobileAdapterCommunication
	dw Mobile_ReadLoginID
	dw MobileAdapterCommunication
	dw Mobile_ReadEmailAddress
	dw MobileAdapterCommunication
	dw Mobile_LoginToISP
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Mobile_DownloadStadiumIndex
	dw MobileAdapterCommunication
	dw MobileStadium_ParseIndex
	dw MobileStadium_NewDataMessage
	dw MobileStadium_PreviousDataMessage
	dw MobileStadium_ConfirmDownload
	dw MobileStadium_HTTPGetData
	dw MobileAdapterCommunication
	dw Mobile_LogoutOfISP
	dw MobileAdapterCommunication
	dw Mobile_StartDisconnectDialog
	dw Mobile_EndConnection
	dw MobileAdapterCommunication
	dw Mobile_ConnectionDoNothing
	dw MobileStadium_NoNewDataMessage
	dw MobileStadium_WaitNoNewData
	dw MobileStadium_CancelDownloadMessage
	dw MobileStadium_WaitCancelDownload
	dw Mobile_StartDisconnectDialog
	dw Mobile_WaitForDisconnectDialog
	dw Mobile_StartDisconnectDialog
	assert_table_length NUM_MOBILE_STADIUM_DOWNLOAD_STATES

Function118746:
	jumptable .Jumptable, wBattleTowerRoomMenuJumptableIndex

.Jumptable:
	dw Mobile_InitOverworldConnectionDialog
	dw InitMobileAdapter
	dw MobileAdapterCommunication
	dw Mobile_ReadPhoneNumber
	dw MobileAdapterCommunication
	dw Mobile_ReadLoginID
	dw MobileAdapterCommunication
	dw Mobile_ReadEmailAddress
	dw MobileAdapterCommunication
	dw Mobile_LoginToISP
	dw MobileAdapterCommunication
	dw StopPichuMobileAnimation
	dw Mobile_DownloadOddEggIndex
	dw MobileAdapterCommunication
	dw Function1196f2
	dw Function1197c9
	dw Function1197dc
	dw MobileAdapterCommunication
	dw Mobile_LogoutOfISP
	dw MobileAdapterCommunication
	dw Function119800
	dw Mobile_StartDisconnectDialog
	dw Mobile_EndConnection
	dw MobileAdapterCommunication
	dw BattleTowerRoomMenu_DoNothing
	dw Mobile_StartDisconnectDialog
	dw Mobile_WaitForDisconnectDialog
	dw Mobile_StartDisconnectDialog

MobileAdapterCommunication:
	ld a, [wMobileSDK_Status]
	bit MOBILE_SDK_ERROR_F, a
	jr nz, .error
	bit MOBILE_SDK_RECV_BUFFER_FULL_F, a
	jr nz, .buffer_full
	bit MOBILE_SDK_BUSY_F, a
	jr nz, .busy
	ld a, [wMobileDownloadFlags]
	and MOBILE_DOWNLOAD_OVERFLOW
	jr z, .advance_state
	ld a, BANK(wMobileReceiveBuffer)
	ldh [rWBK], a
.advance_state
	jp Mobile_IncrementConnectionState
.busy
	call Mobile_CheckCancelableConnection
	ret c
	ret
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
	ld a, [wMobilePichuRestoreState]
	ld [wMobilePichuJumptableIndex], a
	ld a, [wMobileConnectionErrorState]
	ld [wMobileConnectionJumptableIndex], a
	ret
.buffer_full
	ld hl, wMobileDownloadFlags
	bit MOBILE_DOWNLOAD_OVERFLOW_F, [hl]
	jr nz, .overflow
	set MOBILE_DOWNLOAD_OVERFLOW_F, [hl]
	ld a, BANK(wMobileReceiveBuffer2)
	ldh [rWBK], a
	ld de, wMobileReceiveBuffer2
	ld bc, MOBILE_RECEIVE_BUFFER_SIZE
	ld a, [hl]
	sla a
	jr c, .http_get
	sla a
	jr c, .http_post
	sla a
	jr c, .pop3_head
	ld a, MOBILEAPI_POP3RETR
	jr .resume_download
.pop3_head
	ld a, MOBILEAPI_POP3HEAD
	jr .resume_download
.http_get
	ld a, MOBILEAPI_HTTPGET
	jr .resume_download
.http_post
	ld a, MOBILEAPI_HTTPPOST
.resume_download
	call MobileAPI
	ret
.overflow
	ld a, MOBILE_ERROR_INVALID_DOWNLOAD

SetMobileErrorCode:
	ld [wMobileErrorCodeBuffer], a
	xor a
	ld [wMobileErrorCodeBuffer + 1], a
	ld [wMobileErrorCodeBuffer + 2], a
	ld a, MOBILEAPI_HANGUP
	call MobileAPI
	ld a, [wMobilePichuRestoreState]
	ld [wMobilePichuJumptableIndex], a
	ld a, [wMobileConnectionErrorState]
	ld [wMobileConnectionJumptableIndex], a
	ret

Mobile_CheckCancelableConnection:
	ld a, [wMobilePichuJumptableIndex]
	cp MOBILE_PICHU_ANIMATE
	jr c, .not_canceled
	cp MOBILE_PICHU_RESTORE_OVERWORLD
	jr z, .not_canceled
	ldh a, [hJoyDown]
	cp A_BUTTON | SELECT
	jr nz, .not_canceled
	ld a, MOBILEAPI_HANGUP
	call MobileAPI
	ld a, MOBILE_RESULT_CANCELED
	ld [wMobileErrorCodeBuffer], a
	ld a, [wMobilePichuRestoreState]
	ld [wMobilePichuJumptableIndex], a
	ld a, [wMobileConnectionErrorState]
	ld [wMobileConnectionJumptableIndex], a
	scf
	ret
.not_canceled
	and a
	ret

Mobile_CheckConnectionCancel:
	ldh a, [hJoyDown]
	cp A_BUTTON | SELECT
	jr nz, .not_canceled
	ld a, MOBILEAPI_HANGUP
	call MobileAPI
	ld a, MOBILE_RESULT_CANCELED
	ld [wMobileErrorCodeBuffer], a
	ld a, [wMobileConnectionErrorState]
	ld [wMobileConnectionJumptableIndex], a
	scf
	ret

.not_canceled
	and a
	ret

Mobile_InitNewsConnectionDialog:
	ld a, MOBILE_DIALOG_CONTEXT_NEWS
	jr Mobile_InitConnectionDialog

Mobile_InitStadiumConnectionDialog:
	ld a, MOBILE_DIALOG_CONTEXT_STADIUM
	jr Mobile_InitConnectionDialog

Mobile_InitOverworldConnectionDialog:
	xor a

Mobile_InitConnectionDialog:
	ld [wMobileDialogContext], a
	ld a, MOBILE_DIALOG_INIT
	ld [wMobileDialogJumptableIndex], a
	call Mobile_IncrementConnectionState
	ld a, [wMobileConnectionEndState]
	ld [wMobileDialogCancelState], a

InitMobileAdapter:
	call MobileConnectionDialog
	ret c
	xor a
	ld [wcf64], a
	ld [wc807], a
	ld de, wMobileAdapterColor
	ld hl, $46
	ld a, MOBILEAPI_INIT
	jp Mobile_CallAPIAndAdvanceState

Mobile_StopPendingOperation: ; unreferenced
	ld a, [wMobileSDK_Status]
	bit MOBILE_SDK_ERROR_F, a
	jr nz, .asm_1188a5
	bit MOBILE_SDK_RECV_BUFFER_FULL_F, a
	jr nz, .asm_1188a5
	bit MOBILE_SDK_BUSY_F, a
	jr z, .asm_1188aa

.asm_1188a5
	ld a, MOBILEAPI_STOP
	jp Mobile_CallAPIAndAdvanceState

.asm_1188aa
	call Mobile_IncrementConnectionState
	jp Mobile_IncrementConnectionState

Mobile_ReadPhoneNumber:
	ld de, wMobilePhoneNumberTable
	ld a, MOBILEAPI_READPHONENUMBERS
	jp Mobile_CallAPIAndAdvanceState

Mobile_ReadLoginID:
	ld de, wMobileLoginID
	ld a, MOBILEAPI_READUSERID
	jp Mobile_CallAPIAndAdvanceState

Mobile_ReadEmailAddress:
	ld de, wEmailAddress
	ld a, MOBILEAPI_READEMAIL
	jp Mobile_CallAPIAndAdvanceState

Mobile_LoginToISP:
	ld a, $1
	ld [wMobileConnectionTimerActive], a
	call Mobile_GetSelectedPhoneNumber
	ld hl, wc708
.copy_phone_number
	ld a, [de]
	inc de
	ld [hli], a
	and a
	jr nz, .copy_phone_number
	call Mobile_AppendLoginID
	call Mobile_AppendLoginPassword
	ld hl, wc708
	ld a, MOBILEAPI_ISPLOGIN
	jp Mobile_CallAPIAndAdvanceState

Mobile_GetSelectedPhoneNumber:
; Return de pointing to the selected phone number. Each table entry
; contains two null-terminated strings: the number and its description.
	ld de, wMobilePhoneNumberTable
	ld a, BANK(sMobilePhoneNumberIndex)
	call OpenSRAM
	ld a, [sMobilePhoneNumberIndex]
	call CloseSRAM
	and a
	ret z
	sla a
	ld c, a
.skip_string
	ld a, [de]
	inc de
	and a
	jr nz, .skip_string
	dec c
	jr nz, .skip_string
	ret

StopPichuMobileAnimation:
	ld a, [wMobilePichuRestoreState]
	ld [wMobilePichuJumptableIndex], a
	ld c, MOBILE_PHONE_ANIM_SIGNAL
	farcall MobilePhone_SetAnimation
	ld a, MOBILE_DIALOG_COMMUNICATING
	ld [wMobileDialogJumptableIndex], a
	call MobileConnectionDialog
	jp Mobile_IncrementConnectionState

BattleTower_ParseIndex:
	call Mobile_ParseIndexURLs
	jp BattleTowerRoomMenu_IncrementJumptable

INCLUDE "engine/events/battle_tower/level_menu.asm"

BattleTower_DownloadRoomCount: ; unreferenced
	ld a, [wcd55]
	ld l, a
	ld a, [wcd56]
	ld h, a
	ld de, wc3ec
	ld bc, $0004
	jp Mobile_HTTPGet

Mobile_DownloadBattleTowerIndex: ; unreferenced
	ld hl, BattleDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld de, w3_d000
	ld bc, $1000
	jp Mobile_HTTPGetIndex

Mobile_DownloadBattleTowerIndexWithTimer:
	ld hl, BattleDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld de, w3_d000
	ld bc, $1000
	jp Mobile_HTTPGetIndex

Mobile_DownloadTradeCornerIndex:
	ld hl, ExchangeDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld de, w3_d000
	ld bc, $1000
	jp Mobile_HTTPGetIndex

Mobile_DownloadNewsIndex:
	ld hl, NewsDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld a, $5
	ldh [rWBK], a
	ld de, w3_d100
	ld bc, $e00
	jr Mobile_HTTPGetIndex

Mobile_DownloadStadiumIndex:
	ld hl, StadiumDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld de, w3_d000
	ld bc, $1000
	jr Mobile_HTTPGetIndex

Mobile_DownloadOddEggIndex:
	ld hl, OddEggDownloadURL
	ld de, wcc60
	ld bc, $80
	call CopyBytes
	ld de, w3_d000
	ld bc, $1000
	jr Mobile_HTTPGetIndex

Mobile_HTTPGet:
	push bc
	push de
	push hl
	ld a, MOBILE_DIALOG_COMMUNICATING
	ld [wMobileDialogJumptableIndex], a
	call MobileConnectionDialog
	pop hl
	ld c, $0
	ld de, wcc60
.asm_118af5
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr z, .asm_118b06
	inc c
	ld a, c
	cp MOBILE_URL_MAX_LENGTH + 1
	jr c, .asm_118af5
	ld a, MOBILE_ERROR_URL_TOO_LONG
	jp SetMobileErrorCode

.asm_118b06
	call Mobile_BuildHTTPGetParameters
	pop de
	pop bc
	ld a, MOBILEAPI_HTTPGET
	jp Mobile_CallAPIAndAdvanceState

Mobile_HTTPGetIndex:
	push de
	push bc
	ld a, MOBILE_DIALOG_COMMUNICATING
	ld [wMobileDialogJumptableIndex], a
	call MobileConnectionDialog
	call Mobile_BuildHTTPGetParameters
	pop bc
	pop de
	ld a, MOBILEAPI_HTTPGET
	jp Mobile_CallAPIAndAdvanceState

Mobile_BuildHTTPGetParameters:
; Build Date/URL pointers and null-terminated credentials at wc346.
	ld hl, wc346
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, LOW(wMobileHTTPURL)
	ld [hli], a
	ld a, HIGH(wMobileHTTPURL)
	ld [hli], a
	call Mobile_AppendLoginID
	call Mobile_AppendLoginPassword
	ld a, MOBILE_DOWNLOAD_HTTP_GET
	ld [wMobileDownloadFlags], a
	ld hl, wc346
	ret

Mobile_ParseIndexURLs:
	ld hl, wd002
	ld a, l
	ld [wcd51], a
	ld a, h
	ld [wcd52], a
	call Mobile_TerminateIndexLine
	ld a, l
	ld [wcd55], a
	ld [wcd59], a
	ld a, h
	ld [wcd56], a
	ld [wcd5a], a
	call Mobile_TerminateIndexLine
	ld a, l
	ld [wcd53], a
	ld [wcd5d], a
	ld a, h
	ld [wcd54], a
	ld [wcd5e], a
	call Mobile_TerminateIndexLine
	ld a, l
	ld [wcd57], a
	ld [wcd5b], a
	ld a, h
	ld [wcd58], a
	ld [wcd5c], a
	call Mobile_TerminateIndexLine
	ld a, l
	ld [wcd5f], a
	ld a, h
	ld [wcd60], a
	ret

Mobile_TerminateIndexLine:
.asm_118b8c
	call Mobile_CheckDownloadPointer
	ret nc
	ld a, [hli]
	cp $d
	jr nz, .asm_118b8c
	dec hl
	xor a
	ld [hli], a
	ld [hli], a
	ret

Mobile_CheckDownloadPointer:
; Carry means hl is below the end of the switchable WRAM download buffer.
	ld a, h
	cp HIGH(wMobileReceiveBuffer + MOBILE_RECEIVE_BUFFER_SIZE)
	ret c
	ld a, MOBILE_ERROR_INVALID_DOWNLOAD
	call SetMobileErrorCode
	and a
	ret

pushc ascii

ExchangeDownloadURL:
	db "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTJ/exchange/index.txt", 0

BattleDownloadURL:
	db "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTJ/battle/index.txt", 0

NewsDownloadURL:
	db "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTJ/news/index.txt", 0

StadiumDownloadURL:
	db "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTJ/POKESTA/menu.cgb", 0

OddEggDownloadURL:
	db "http://gameboy.datacenter.ne.jp/cgb/download?name=/01/CGB-BXTJ/tamago/index.txt", 0

popc

ValidateBattleDownload: ; unreferenced
	ld hl, $d200
	ld a, [wcd38]
	and a
	jr nz, .asm_118d6e
	ld a, [hli]
	cp $94
	jr nz, .asm_118d7b
	ld a, [hl]
	cp $5
	jr nz, .asm_118d7b
	ld a, [wcd4f]
	sla a
	ld b, a
	sla a
	sla a
	add b
	ld b, a
	ld a, BANK(s5_b2fb)
	call OpenSRAM
	ld a, b
	ld [s5_b2fb], a
	call CloseSRAM
	farcall BattleTower_ResetChallengeStats
	farcall Function1700c4
	jr .asm_118d78

.asm_118d6e
	ld a, [hli]
	cp $96
	jr nz, .asm_118d7b
	ld a, [hl]
	cp $0
	jr nz, .asm_118d7b

.asm_118d78
	jp BattleTowerRoomMenu_IncrementJumptable

.asm_118d7b
	ld a, $d3
	jp SetMobileErrorCode

Function118d80:
	call Function118e06
	ld a, [wcd38]
	and a
	jr z, .asm_118d8e
	call BattleTowerRoomMenu_IncrementJumptable
	jr asm_118d9f

.asm_118d8e
	ld a, MOBILE_DIALOG_DOWNLOAD_FEE_INTRO
	ld [wMobileDialogJumptableIndex], a
	ld a, $12
	ld [wMobileDialogCancelState], a
	call BattleTowerRoomMenu_IncrementJumptable

Mobile_HTTPPostTradeRequest:
	call MobileConnectionDialog
	ret c

asm_118d9f:
	ld hl, wc608
	call Function119940
	ld a, [wcd38]
	and a
	jr nz, .asm_118db2
	ld a, TRADE_CORNER_REQUEST_LENGTH
	ld [wcd3b], a
	jr .asm_118db7

.asm_118db2
	ld a, $26
	ld [wcd3b], a

.asm_118db7
	ld hl, w3_d800
	ld a, LOW(wc608)
	ld [hli], a
	ld a, HIGH(wc608)
	ld [hli], a
	ld a, [wcd3b]
	ld [hli], a
	xor a
	ld [hli], a
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, [wcd39]
	ld [hli], a
	ld a, [wcd3a]
	ld [hli], a
	call Mobile_AppendLoginID
	call Mobile_AppendLoginPassword
	ld a, MOBILE_DOWNLOAD_HTTP_POST
	ld [wMobileDownloadFlags], a
	ld hl, w3_d800
	ld de, w3_de00
	ld bc, $200
	ld a, MOBILEAPI_HTTPPOST
	jp Mobile_CallAPIAndAdvanceState

Function118ded:
	ld a, [wcd38]
	and a
	jr z, .asm_118e03
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	farcall MobileTrade_RestoreOfferMon
	pop af
	ldh [rWBK], a

.asm_118e03
	jp BattleTowerRoomMenu_IncrementJumptable

Function118e06:
	ld hl, wd002
	ld a, [wcd38]
	and a
	jr z, .asm_118e1d
.asm_118e0f
	call Mobile_CheckDownloadPointer
	ret nc
	ld a, [hli]
	cp $d
	jr nz, .asm_118e0f
	ld a, [hli]
	cp $a
	jr nz, .asm_118e0f

.asm_118e1d
	ld a, l
	ld [wcd39], a
	ld a, h
	ld [wcd3a], a
.asm_118e25
	call Mobile_CheckDownloadPointer
	ret nc
	ld a, [hli]
	cp $d
	jr nz, .asm_118e25
	ld a, [hli]
	cp $a
	jr nz, .asm_118e25
	dec hl
	xor a
	ld [hld], a
	ld [hl], a
	jr Mobile_ParseDownloadFeeFromEnd

INCLUDE "mobile/download_fee.asm"

Mobile_LogoutOfISP:
	xor a
	ld [wMobileConnectionTimerActive], a
	ld a, MOBILEAPI_HANGUP
	jp Mobile_CallAPIAndAdvanceState

Mobile_StartDisconnectDialog:
	; Show the disconnect message and connection time.
	ld a, MOBILE_DIALOG_CONNECTION_CLOSED
	ld [wMobileDialogJumptableIndex], a
	jp Mobile_IncrementConnectionState

Mobile_EndConnection:
	call MobileConnectionDialog
	ret c
	ld a, MOBILEAPI_END
	jp Mobile_CallAPIAndAdvanceState

Mobile_WaitForDisconnectDialog:
	call MobileConnectionDialog
	ret c
	ld a, [wMobileConnectionEndState]
	ld [wMobileConnectionJumptableIndex], a
	ret

Mobile_DownloadNewsMetadata:
	call Function118440
	call Mobile_ParseRankingIndexURLs
	ld a, [wcd53]
	ld l, a
	ld a, [wcd54]
	ld h, a
	ld de, wcc60
	call Mobile_CopyNewsURL
	ret c
	ld de, w3_d800
	ld bc, $0800
	jp Mobile_HTTPGetIndex

Mobile_CheckDownloadedNewsID:
	call Function118440
	ld hl, w3_d802
	ld de, wBGMapBuffer
	ld bc, NEWS_ID_LENGTH
	call CopyBytes
	call Mobile_CheckNewsAlreadyDownloaded
	ret c
	jp BattleTowerRoomMenu_IncrementJumptable

Function118ec6:
	call Function118440
	call SpeechTextbox
	ld hl, w3_d80e
	ld de, wMobileMessageBuffer
	ld bc, $0026
	call CopyBytes
	xor a
	ld [wMobileMessageDelay], a
	ld a, LOW(wMobileMessageBuffer)
	ld [wMobileMessageSource], a
	ld a, HIGH(wMobileMessageBuffer)
	ld [wMobileMessageSource + 1], a
	hlcoord 1, 14
	ld a, l
	ld [wMobileMessageDest], a
	ld a, h
	ld [wMobileMessageDest + 1], a
	ld a, MOBILE_MESSAGE_PRINT_TEXT
	ld [wMobileMessageJumptableIndex], a
	ld a, MOBILE_DIALOG_DOWNLOAD_NEWS
	ld [wMobileDialogJumptableIndex], a
	ld a, $24
	ld [wMobileDialogCancelState], a
	ld a, $11
	ld [wMobileDialogResumeState], a
	ld a, $1c
	ld [wMobileDialogCancelConfirmState], a
	jp BattleTowerRoomMenu_IncrementJumptable

Function118f0d:
	call MobileConnectionDialog
	ret c
	call Function118440

Function118f14:
	call Function118440
	ld a, [wcd51]
	ld l, a
	ld a, [wcd52]
	ld h, a
	ld de, wcc60
	call Mobile_CopyNewsURL
	ret c
	ld a, [wcc60]
	and a
	jr z, .DontSendSaveFile
	ld hl, Text_SaveFileWillBeSent
	call Mobile_SetMessage

.DontSendSaveFile:
	ld a, [wcd57]
	ld l, a
	ld a, [wcd58]
	ld h, a
	ld de, wcc60
	call Mobile_CopyNewsURL
	ret c
	ld hl, wcc60
	call Mobile_ParseDownloadFee
	ld a, MOBILE_DIALOG_DOWNLOAD_FEE_INTRO
	ld [wMobileDialogJumptableIndex], a
	ld a, $24
	ld [wMobileDialogCancelState], a
	ld a, $13
	ld [wMobileDialogResumeState], a
	ld a, $1c
	ld [wMobileDialogCancelConfirmState], a
	jp BattleTowerRoomMenu_IncrementJumptable

Function118f5e:
	call MobileConnectionDialog
	ret c
	call Function118440
	call DelayFrame

Function118f68:
	call Mobile_PrepareNewsUpload
	ret c
	call Function118440
	ld a, [wcd51]
	ld l, a
	ld a, [wcd52]
	ld h, a
	ld de, wcc60
	call Mobile_CopyNewsURL
	ret c
	ld a, [wcc60]
	and a
	jr z, .asm_118fba
	ld hl, wc346
	ld a, LOW(wc608)
	ld [hli], a
	ld a, HIGH(wc608)
	ld [hli], a
	ld a, [wcd4b]
	ld [hli], a
	ld a, [wcd4c]
	ld [hli], a
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, LOW(wcc60)
	ld [hli], a
	ld a, HIGH(wcc60)
	ld [hli], a
	call Mobile_AppendLoginID
	call Mobile_AppendLoginPassword
	ld a, MOBILE_DOWNLOAD_HTTP_POST
	ld [wMobileDownloadFlags], a
	ld hl, wc346
	ld de, w3_de00
	ld bc, $200
	ld a, MOBILEAPI_HTTPPOST
	jp Mobile_CallAPIAndAdvanceState

.asm_118fba
	call BattleTowerRoomMenu_IncrementJumptable
	jp BattleTowerRoomMenu_IncrementJumptable

Mobile_TryDownloadNewsRankings:
	call Function118440
	ld a, [wcd55]
	ld l, a
	ld a, [wcd56]
	ld h, a
	ld de, wcc60
	call Mobile_CopyNewsURL
	ret c
	ld a, [wcc60]
	and a
	jr z, .asm_118ffa
	ld a, [wcd51]
	ld l, a
	ld a, [wcd52]
	ld h, a
	ld de, wcc60
	call Mobile_CopyNewsURL
	ret c
	ld a, [wcc60]
	and a
	jr z, .asm_118ff2
	ld hl, Text_SentSaveFileReadingNews
	jr .asm_118ff5

.asm_118ff2
	ld hl, Text_ReadingNews

.asm_118ff5
	call Mobile_SetMessage
	jr Mobile_HTTPPostNewsRankings

.asm_118ffa
	ld hl, Text_ReadingNews
	call Mobile_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable
	call BattleTowerRoomMenu_IncrementJumptable
	jp BattleTowerRoomMenu_IncrementJumptable

Mobile_HTTPPostNewsRankings:
	call Function118440
	call Mobile_BuildNewsRankingsRequest
	ld a, [wcd55]
	ld l, a
	ld a, [wcd56]
	ld h, a
	ld de, wcc60
	call Mobile_CopyNewsURL
	ret c
	ld hl, wc346
	ld a, LOW(wc608)
	ld [hli], a
	ld a, HIGH(wc608)
	ld [hli], a
	ld a, [wcd4b]
	ld [hli], a
	ld a, [wcd4c]
	ld [hli], a
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, LOW(wcc60)
	ld [hli], a
	ld a, HIGH(wcc60)
	ld [hli], a
	call Mobile_AppendLoginID
	call Mobile_AppendLoginPassword
	ld a, MOBILE_DOWNLOAD_HTTP_POST
	ld [wMobileDownloadFlags], a
	ld hl, wc346
	ld de, w3_d000
	ld bc, $1000
	ld a, MOBILEAPI_HTTPPOST
	jp Mobile_CallAPIAndAdvanceState

Mobile_SaveDownloadedNewsRankings:
	ld a, BANK(sPokemonNews)
	call OpenSRAM
	ld hl, wMobileReceiveBufferData
	ld a, [wcd4f]
	ld e, a
	ld a, [wcd50]
	ld d, a
	ld a, [wMobileReceiveBufferLength]
	ld c, a
	ld a, [wMobileReceiveBufferLength + 1]
	ld b, a
	call Mobile_CopyDataToSRAM
	ret c
	ld a, [wMobileDownloadFlags]
	and MOBILE_DOWNLOAD_OVERFLOW
	jr z, .save_metadata
	ld a, BANK(wMobileReceiveBuffer2)
	ldh [rWBK], a
	ld hl, wMobileReceiveBuffer2Data
	ld a, [wMobileReceiveBuffer2Length]
	ld c, a
	ld a, [wMobileReceiveBuffer2Length + 1]
	ld b, a
	call Mobile_CopyDataToSRAM
	ret c

.save_metadata
	call CloseSRAM
	ld a, BANK(wMobileReceiveBuffer)
	ldh [rWBK], a
; These news metadata fields are all in SRAM bank 5.
	ld a, BANK(sNewsRankingPointers)
	call OpenSRAM
	ld a, [wcd4f]
	ld [sNewsRankingPointers], a
	ld a, [wcd50]
	ld [sNewsRankingPointers + 1], a
	ld hl, wcd20
	ld de, sPokemonNewsRankingsID
	ld bc, NEWS_ID_LENGTH
	call CopyBytes
	ldh a, [rWBK]
	push af
	ld a, BANK(wPlayerPrefecture) ; aka BANK(wPlayerPostalCode)
	ldh [rWBK], a
	ld a, [wPlayerPrefecture]
	ld [sNewsPlayerPrefecture], a
	ld hl, wPlayerPostalCode
	ld de, sNewsPlayerPostalCode
	ld bc, 4
	call CopyBytes
	pop af
	ldh [rWBK], a
	call CloseSRAM
	jp BattleTowerRoomMenu_IncrementJumptable

Mobile_DownloadNewsData:
	ld a, BANK(wMobileReceiveBuffer)
	ldh [rWBK], a
	ld a, [wcd57]
	ld l, a
	ld a, [wcd58]
	ld h, a
	ld de, wcc60
	call Mobile_CopyNewsURL
	ret c
	ld de, wMobileReceiveBuffer
	ld bc, MOBILE_RECEIVE_BUFFER_SIZE
	jp Mobile_HTTPGetIndex

Mobile_SaveDownloadedNews:
	ld a, BANK(sPokemonNewsID)
	call OpenSRAM
	ld hl, wBGMapBuffer
	ld de, sPokemonNewsID
	ld bc, NEWS_ID_LENGTH
	call CopyBytes
	call CloseSRAM
	ld a, BANK(sPokemonNewsDownloaded)
	call OpenSRAM
	ld a, $1
	ld [sPokemonNewsDownloaded], a
	call CloseSRAM
	ld a, BANK(sPokemonNews)
	call OpenSRAM
	ld a, [wMobileReceiveBufferLength]
	ld c, a
	ld a, [wMobileReceiveBufferLength + 1]
	ld b, a
	ld hl, wMobileReceiveBufferData
	ld de, sPokemonNews
	call Mobile_CopyDataToSRAM
	ret c
	ld a, [wMobileDownloadFlags]
	and MOBILE_DOWNLOAD_OVERFLOW
	jr z, .asm_11913e
	ld a, BANK(wMobileReceiveBuffer2)
	ldh [rWBK], a
	ld a, [wMobileReceiveBuffer2Length]
	ld c, a
	ld a, [wMobileReceiveBuffer2Length + 1]
	ld b, a
	ld hl, wMobileReceiveBuffer2Data
	call Mobile_CopyDataToSRAM
	ret c

.asm_11913e
	ld a, BANK("Battle Tower RAM")
	ldh [rWBK], a
	call CloseSRAM
	ld hl, Text_ReceivedNews
	call Mobile_SetMessage
	jp BattleTowerRoomMenu_IncrementJumptable

Function11914e:
	call MobileConnectionDialog
	ret c
	ld a, $1c
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, MOBILE_RESULT_CANCELED
	ld [wMobileErrorCodeBuffer], a
	ret

Mobile_CheckNewsRankingsID:
	ld hl, w3_d802
	ld de, wcd20
	ld bc, NEWS_ID_LENGTH
	call CopyBytes
	ld a, BANK(sPokemonNewsRankingsID)
	call OpenSRAM
	ld hl, wBGMapBuffer
	ld de, sPokemonNewsRankingsID
	ld c, NEWS_ID_LENGTH
.asm_119176
	ld a, [de]
	inc de
	cp [hl]
	jr nz, .asm_119184
	inc hl
	dec c
	jr nz, .asm_119176
	call BattleTowerRoomMenu_IncrementJumptable
	jr .asm_11918e

.asm_119184
	ld a, $16
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, $b
	ld [wMobileErrorCodeBuffer], a

.asm_11918e
	call CloseSRAM
	ret

Mobile_CopyDataToSRAM:
; Copy bc bytes from hl to de. Carry indicates that de reached $c000.
; The boundary check happens after each write, including the final byte.
	inc b
	inc c
	jr .check_count

.copy
	ld a, [hli]
	ld [de], a
	inc de
	ld a, $bf
	cp d
	jr c, .overflow

.check_count
	dec c
	jr nz, .copy
	dec b
	jr nz, .copy
	and a
	ret

.overflow
	ld a, $d3
	call SetMobileErrorCode
	scf
	ret

Mobile_CopyNewsURL:
; Copy a null-terminated URL from bank 5 at hl to de.
; URLs longer than MOBILE_URL_MAX_LENGTH bytes set carry and a mobile error.
	push bc
	ld c, $0
	ld a, $5
	ldh [rWBK], a
.copy
	ld a, [hli]
	ld [de], a
	inc de
	and a
	jr z, .done
	inc c
	ld a, c
	cp MOBILE_URL_MAX_LENGTH + 1
	jr c, .copy
	ld a, MOBILE_ERROR_URL_TOO_LONG
	call SetMobileErrorCode
	ld a, BANK("Battle Tower RAM")
	ldh [rWBK], a
	pop bc
	scf
	ret

.done
	ld a, BANK("Battle Tower RAM")
	ldh [rWBK], a
	pop bc
	and a
	ret

Mobile_ParseRankingIndexURLs:
	ld hl, w3_d100 + 2
	ld a, l
	ld [wcd53], a
	ld a, h
	ld [wcd54], a
	call Mobile_TerminateIndexURL
	ld a, l
	ld [wcd51], a
	ld a, [wcd4a]
	ld a, h
	ld [wcd52], a
	call Mobile_TerminateIndexURL
	ld a, l
	ld [wcd55], a
	ld a, [wcd4a]
	ld a, h
	ld [wcd56], a
	call Mobile_TerminateIndexURL
	ld a, [wcd49]
	ld a, l
	ld [wcd57], a
	ld a, [wcd4a]
	ld a, h
	ld [wcd58], a
	call Mobile_TerminateIndexURL
	ret

Mobile_TerminateIndexURL:
.asm_11920f
	call Mobile_CheckDownloadPointer
	ret nc
	ld a, [hli]
	cp $d
	jr nz, .asm_11920f
	ld a, [hli]
	cp $a
	jr nz, .asm_11920f
	dec hl
	xor a
	ld [hld], a
	ld [hli], a
	inc hl
	ret

Mobile_PrepareNewsUpload:
; Read the ranking destination and entry sizes from the news metadata, then
; gather the requested SRAM ranges and literal bytes into wc608.
	xor a
	ld [wcd4b], a
	ld [wcd4c], a
	ld a, BANK(sNewsEmailAddress)
	call OpenSRAM
	ld hl, wEmailAddress
	ld de, sNewsEmailAddress
	ld bc, MOBILE_EMAIL_LENGTH + 1
	call CopyBytes
	dec de
	xor a
	ld [de], a
	ld hl, w3_d810
.skip_message
	ld a, [hli]
	cp NEWS_METADATA_DELIMITER
	jr nz, .skip_message
	ld a, [hli]
	ld [wcd4f], a
	ld a, [hli]
	ld [wcd50], a
	ld a, [hli]
	ld [sNewsRankingTableSize], a
	ld c, a
	ld a, [hli]
	ld [sNewsRankingTableSize + 1], a
	ld b, a
	ld de, sNewsRankingEntrySizes
	call CopyBytes
	call CloseSRAM
	ld e, l
	ld d, h
	ld hl, wc608
.next_record
	ld a, [de]
	inc de
	cp NEWS_UPLOAD_END
	jr z, .done
	cp NEWS_UPLOAD_LITERAL
	jr z, .literal
	call OpenSRAM
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	inc de
	push de
	push af
	ld a, [wcd4b]
	ld e, a
	ld a, [wcd4c]
	ld d, a
	pop af
.copy_sram
	push af
	ld a, [bc]
	inc bc
	ld [hli], a
	inc de
	pop af
	dec a
	jr nz, .copy_sram
	call CloseSRAM
	ld a, e
	ld [wcd4b], a
	ld a, d
	ld [wcd4c], a
	pop de
.check_length
	and a
	jr z, .next_record
	ld a, $d3
	call SetMobileErrorCode
	scf
	ret

.literal
	ld a, [wcd4b]
	ld c, a
	ld a, [wcd4c]
	ld b, a
	ld a, [de]
	inc de
.copy_literal
	push af
	ld a, [de]
	inc de
	ld [hli], a
	inc bc
	pop af
	dec a
	jr nz, .copy_literal
	ld a, c
	ld [wcd4b], a
	ld a, b
	ld [wcd4c], a
	jr .check_length

.done
	ld a, e
	ld [wcd4d], a
	ld a, d
	ld [wcd4e], a
	and a
	ret

Mobile_CheckNewsAlreadyDownloaded:
	ld a, BANK(sPokemonNewsID)
	call OpenSRAM
	ld hl, sPokemonNewsID
	ld de, wc608
	ld bc, NEWS_ID_LENGTH
	call CopyBytes
	call CloseSRAM
	ld hl, wc608
	ld de, wcd20
	ld c, NEWS_ID_LENGTH
.asm_1192e8
	ld a, [de]
	inc de
	ld b, a
	ld a, [hli]
	cp b
	jr nz, .asm_1192fe
	dec c
	jr nz, .asm_1192e8
	ld a, MOBILE_DIALOG_NO_NEWS
	ld [wMobileDialogJumptableIndex], a
	ld a, $27
	ld [wBattleTowerRoomMenuJumptableIndex], a
	scf
	ret

.asm_1192fe
	and a
	ret

pushc ascii

Mobile_BuildNewsRankingsRequest:
; Build an ASCII form body in wc608. Metadata supplies the parameter names
; and SRAM ranges; each value is encoded as lowercase hexadecimal.
	xor a
	ld [wcd4b], a
	ld [wcd4c], a
	ld a, [wcd4d]
	ld e, a
	ld a, [wcd4e]
	ld d, a
	ld hl, wc608
	ld a, [wcd4b]
	ld c, a
	ld a, [wcd4c]
	ld b, a
.copy_parameter
	ld a, [de]
	inc de
	cp NEWS_METADATA_DELIMITER
	jr z, .parameter_value
	ld [hli], a
	inc bc
	jr .copy_parameter

.parameter_value
	ld a, '='
	ld [hli], a
	inc bc
	ld a, c
	ld [wcd4b], a
	ld a, b
	ld [wcd4c], a
	ld a, [de]
	inc de
	call OpenSRAM
	ld a, [de]
	inc de
	ld c, a
	ld a, [de]
	inc de
	ld b, a
	ld a, [de]
	inc de
	push de
	push af
	ld a, [wcd4b]
	ld e, a
	ld a, [wcd4c]
	ld d, a
	pop af
.hex_byte
	push af
	ld a, [bc]
	and $f0
	swap a
	call Mobile_EncodeASCIIHexDigit
	ld [hli], a
	inc de
	ld a, [bc]
	inc bc
	and $f
	call Mobile_EncodeASCIIHexDigit
	ld [hli], a
	inc de
	pop af
	dec a
	jr nz, .hex_byte
	call CloseSRAM
	ld a, e
	ld [wcd4b], a
	ld a, d
	ld [wcd4c], a
	pop de
	ld a, [de]
	cp NEWS_METADATA_DELIMITER
	jr z, .done
	ld a, [wcd4b]
	ld c, a
	ld a, [wcd4c]
	ld b, a
	ld a, '&'
	ld [hli], a
	inc bc
	jr .copy_parameter

.done
	ret

popc

Function119380:
	ld a, $80
	ld [wcd49], a
	jp BattleTowerRoomMenu_IncrementJumptable

Function119388:
	ld hl, wcd49
	dec [hl]
	ret nz
	ld hl, wcc60
	call Mobile_ParseDownloadFee
	ld a, MOBILE_DIALOG_DOWNLOAD_FEE_INTRO
	ld [wMobileDialogJumptableIndex], a
	ld a, $10
	ld [wMobileDialogCancelState], a
	call BattleTowerRoomMenu_IncrementJumptable

Function1193a0:
	call MobileConnectionDialog
	ret c
	call DelayFrame
	ld a, MOBILE_DIALOG_COMMUNICATING
	ld [wMobileDialogJumptableIndex], a
	call MobileConnectionDialog
	ld hl, wc346
	ld a, LOW(w3_d000)
	ld [hli], a
	ld a, HIGH(w3_d000)
	ld [hli], a
	ld a, [wcd3b]
	ld [hli], a
	xor a
	ld [hli], a
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, LOW(wcc60)
	ld [hli], a
	ld a, HIGH(wcc60)
	ld [hli], a
	call Mobile_AppendLoginID
	call Mobile_AppendLoginPassword
	ld a, MOBILE_DOWNLOAD_HTTP_POST
	ld [wMobileDownloadFlags], a
	ld hl, wc346
	ld de, w3_de00
	ld bc, $200
	ld a, MOBILEAPI_HTTPPOST
	jp Mobile_CallAPIAndAdvanceState

Function1193e3:
	ld hl, wcd49
	dec [hl]
	ret nz
	ld hl, wcc60
	call Mobile_ParseDownloadFee
	ld a, MOBILE_DIALOG_DOWNLOAD_FEE_INTRO
	ld [wMobileDialogJumptableIndex], a
	ld a, $11
	ld [wMobileDialogCancelState], a
	call BattleTowerRoomMenu_IncrementJumptable

Function1193fb:
	call MobileConnectionDialog
	ret c
	call DelayFrame
	ld a, MOBILE_DIALOG_COMMUNICATING
	ld [wMobileDialogJumptableIndex], a
	call MobileConnectionDialog
	ld de, w3_d000
	ld bc, $1000
	jp Mobile_HTTPGetIndex

Function119413:
	ld a, $6 ; ???
	call OpenSRAM
	ld a, [wMobileReceiveBufferLength]
	ld c, a
	ld a, [wMobileReceiveBufferLength + 1]
	ld b, a
	dec bc
	dec bc
	ld hl, wMobileReceiveBufferData
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	call Mobile_CopyDataToSRAM
	ret c
	ld a, [wMobileDownloadFlags]
	and MOBILE_DOWNLOAD_OVERFLOW
	jr z, .asm_119447
	ld a, BANK(wMobileReceiveBuffer2)
	ldh [rWBK], a
	ld a, [wMobileReceiveBuffer2Length]
	ld c, a
	ld a, [wMobileReceiveBuffer2Length + 1]
	ld b, a
	ld hl, wMobileReceiveBuffer2Data
	call Mobile_CopyDataToSRAM
	ret c

.asm_119447
	ld a, BANK("Battle Tower RAM")
	ldh [rWBK], a
	call CloseSRAM
	jp BattleTowerRoomMenu_IncrementJumptable

INCLUDE "mobile/stadium_download.asm"

Mobile_GetHTTPDateWeekday:
; Read the weekday from the HTTP Date header copied to wc708 by the SDK.
; Return b = 0 (Monday) through 6 (Sunday), or 7 if it is not recognized.
; This ordering differs from the game's SUNDAY-based weekday constants.
	ld b, 0
	ld hl, MobileHTTPWeekdays
.loop
	ld de, wc708
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr nz, .skip_two_chars
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr nz, .skip_one_char
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr nz, .next_day
	ret
.skip_two_chars
	inc hl
.skip_one_char
	inc hl
.next_day
	inc b
	ld a, b
	cp (MobileHTTPWeekdays.End - MobileHTTPWeekdays) / 3
	jr nz, .loop
	ret

INCLUDE "data/mobile/http_weekdays.asm"

Mobile_GetHTTPDateTime:
; The hours and minutes start 17 bytes into "Mon, 01 Jan 2001 00:00:00 GMT".
	ld de, wc719
	call Mobile_ParseTwoDigitDecimal
	ld [wMobileHTTPDateHour], a
	inc de
	call Mobile_ParseTwoDigitDecimal
	ld [wMobileHTTPDateMinute], a
	ret

pushc ascii

Mobile_ParseTwoDigitDecimal:
; Read two ASCII digits from de and return their value in a.
	ld a, [de]
	inc de
	sub '0'
	sla a
	ld b, a
	sla a
	sla a
	add b
	ld c, a
	add hl, bc
	ld a, [de]
	inc de
	sub '0'
	add c
	ret

popc

Function1196f2:
	ld hl, wd002
.asm_1196f5
	call Mobile_CheckDownloadPointer
	ret nc
	ld a, [hli]
	cp $d
	jr nz, .asm_1196f5
	ld a, [hl]
	cp $a
	jr nz, .asm_1196f5
	xor a
	ld [hld], a
	ld [hli], a
	ld a, l
	ld [wcd5b], a
	ld a, h
	ld [wcd5c], a
	inc hl
	ld e, l
	ld d, h
	ld a, [de]
	inc de
	cp $d
	jr nz, .asm_119722
	ld a, [de]
	inc de
	cp $a
	jr nz, .asm_119722
	ld a, $b
	jp SetMobileErrorCode

.asm_119722
	call Random
	ld c, $0
	ld b, c
.asm_119728
	call Mobile_ReadASCIIHexWord
	ld a, d
	cp $ff
	jr nz, .asm_119735
	ld a, e
	cp $ff
	jr z, .asm_11974c

.asm_119735
	ldh a, [hRandomSub]
	cp d
	jr c, .asm_11974c
	jr z, .asm_11973e
	jr .asm_119745

.asm_11973e
	ldh a, [hRandomAdd]
	cp e
	jr c, .asm_11974c
	jr z, .asm_11974c

.asm_119745
	inc bc
	ld a, c
	or b
	jr z, .asm_119770
	jr .asm_119728

.asm_11974c
	ld a, [wcd5b]
	ld l, a
	ld a, [wcd5c]
	ld h, a
.asm_119754
	ld a, [hld]
	cp $58
	jr nz, .asm_119754
	ld d, $0
.asm_11975b
	inc d
	ld a, [hld]
	cp $58
	jr z, .asm_11975b
	inc hl
	inc hl
	ld a, d
	dec a
	jr z, .asm_11978e
	dec a
	jr z, .asm_119785
	dec a
	jr z, .asm_11977e
	dec a
	jr z, .asm_119775

.asm_119770
	ld a, $d3
	jp SetMobileErrorCode

.asm_119775
	ld a, b
	and $f0
	swap a
	call Mobile_EncodeASCIIHexDigit
	ld [hli], a

.asm_11977e
	ld a, b
	and $f
	call Mobile_EncodeASCIIHexDigit
	ld [hli], a

.asm_119785
	ld a, c
	and $f0
	swap a
	call Mobile_EncodeASCIIHexDigit
	ld [hli], a

.asm_11978e
	ld a, c
	and $f
	call Mobile_EncodeASCIIHexDigit
	ld [hli], a
	jp BattleTowerRoomMenu_IncrementJumptable

pushc ascii

Mobile_ReadASCIIHexWord:
; Read four lowercase ASCII hex digits at hl into de, advancing hl.
	ld d, $0
	ld e, d
	call Mobile_ReadASCIIHexDigit
	swap a
	or d
	ld d, a
	call Mobile_ReadASCIIHexDigit
	or d
	ld d, a
	call Mobile_ReadASCIIHexDigit
	swap a
	or e
	ld e, a
	call Mobile_ReadASCIIHexDigit
	or e
	ld e, a
	ret

Mobile_ReadASCIIHexDigit:
; Decode [hli] into a. The caller supplies '0'-'9' or 'a'-'f'.
	ld a, [hli]
	cp 'a'
	jr nc, .letter
	sub '0'
	ret

.letter
	sub 'a' - 10
	ret

Mobile_EncodeASCIIHexDigit:
; Encode a (0-15) as a lowercase ASCII hex digit.
	cp 10
	jr nc, .letter
	add '0'
	ret

.letter
	add 'a' - 10
	ret

popc

Function1197c9:
	ld hl, wd002
	call Mobile_ParseDownloadFee
	ld a, MOBILE_DIALOG_DOWNLOAD_FEE_INTRO
	ld [wMobileDialogJumptableIndex], a
	ld a, $12
	ld [wMobileDialogCancelState], a
	call BattleTowerRoomMenu_IncrementJumptable

Function1197dc:
	call MobileConnectionDialog
	ret c
	call DelayFrame
	ld hl, wd002
	ld de, wcc60
	ld bc, $0080
	call CopyBytes
	dec de
	xor a
	ld [de], a
	call Mobile_BuildHTTPGetParameters
	ld de, w3_d000
	ld bc, $1000
	ld a, MOBILEAPI_HTTPGET
	jp Mobile_CallAPIAndAdvanceState

Function119800:
	ld a, $fd
	ld [wc6d0], a
	ld [wOTTrademonSpecies], a
	ld a, [wMobileAdapterColor]
	ld [wMobileTradeAdapterColor], a
	ld a, [wJumptableIndex]
	push af
	ld a, [wcf64]
	push af
	ld a, [wcf65]
	push af
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	push af
	ld a, $1
	ldh [rWBK], a
	call FadeToMenu
	farcall Function10803d
	call MobileDialog_ReloadOverworld
	call RestartMapMusic
	ld a, BANK("Battle Tower RAM")
	ldh [rWBK], a
	pop af
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	ld [wcf65], a
	pop af
	ld [wcf64], a
	pop af
	ld [wJumptableIndex], a
	farcall MobilePhone_Hide
	jp BattleTowerRoomMenu_IncrementJumptable

DisplaySendToTradeCornerAnimation:
	ld a, [wcd80]
	and a
	jr nz, .asm_1198a0
	ld a, [wcd38]
	and a
	jr nz, .asm_1198a8
	farcall MobileTrade_LoadOfferForSending
	ld a, [wJumptableIndex]
	push af
	ld a, [wcf64]
	push af
	ld a, [wcf65]
	push af
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	push af
	ld a, $1
	ldh [rWBK], a
	call FadeToMenu
	farcall MobileTradeAnimation_SendGivemonToGTS
	call MobileDialog_ReloadOverworld
	call RestartMapMusic
	ld a, BANK("Battle Tower RAM")
	ldh [rWBK], a
	pop af
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	ld [wcf65], a
	pop af
	ld [wcf64], a
	pop af
	ld [wJumptableIndex], a
	farcall MobilePhone_Hide
	jp BattleTowerRoomMenu_IncrementJumptable

.asm_1198a0
	ld a, MOBILE_RESULT_CANCELED
	ld [wMobileErrorCodeBuffer], a
	jp BattleTowerRoomMenu_IncrementJumptable

.asm_1198a8
	farcall MobileTrade_LoadOfferForRetrieval
	ld a, [wJumptableIndex]
	push af
	ld a, [wcf64]
	push af
	ld a, [wcf65]
	push af
	ld a, [wBattleTowerRoomMenuJumptableIndex]
	push af
	ld a, $1
	ldh [rWBK], a
	call FadeToMenu
	farcall MobileTradeAnimation_RetrieveGivemonFromGTS
	call MobileDialog_ReloadOverworld
	call RestartMapMusic
	ld a, BANK("Battle Tower RAM")
	ldh [rWBK], a
	pop af
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	ld [wcf65], a
	pop af
	ld [wcf64], a
	pop af
	ld [wJumptableIndex], a
	farcall MobilePhone_Hide
	jp BattleTowerRoomMenu_IncrementJumptable

Function1198ee:
	ld hl, Text_RegisteringRecord
	call Mobile_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

BattleTower_HTTPPostRecord:
	ld a, [wMobileMessageJumptableIndex]
	and a
	ret nz
	ld hl, wc608 + 2
	call Function119940
	ld hl, w3_d800
	ld a, LOW(wc608)
	ld [hli], a
	ld a, HIGH(wc608)
	ld [hli], a
	ld a, $f6
	ld [hli], a
	xor a
	ld [hli], a
	ld a, LOW(wc708)
	ld [hli], a
	ld a, HIGH(wc708)
	ld [hli], a
	ld a, [wcd51]
	ld [hli], a
	ld a, [wcd52]
	ld [hli], a
	call Mobile_AppendLoginID
	call Mobile_AppendLoginPassword
	ld a, MOBILE_DOWNLOAD_HTTP_POST
	ld [wMobileDownloadFlags], a
	ld hl, w3_d800
	ld de, w3_de00
	ld bc, $200
	ld a, MOBILEAPI_HTTPPOST
	jp Mobile_CallAPIAndAdvanceState

Function119937:
	farcall BattleTowerAction_06
	jp BattleTowerRoomMenu_IncrementJumptable

Function119940:
	ld de, wEmailAddress
	ld c, MOBILE_EMAIL_LENGTH
.asm_119945
	ld a, [de]
	inc de
	ld [hli], a
	dec c
	jr z, .asm_119953
	and a
	jr nz, .asm_119945
	xor a
.asm_11994f
	ld [hli], a
	dec c
	jr nz, .asm_11994f

.asm_119953
	ret

Mobile_LoginToPOP3:
	ld a, MOBILE_DIALOG_COMMUNICATING_WITH_CANCEL
	ld [wMobileDialogJumptableIndex], a
	call MobileConnectionDialog
	ld hl, wc608
	ld de, wEmailAddress
.asm_119962
	ld a, [de]
	inc de
	ld [hli], a
	and a
	jr nz, .asm_119962
	call Mobile_AppendLoginPassword
	ld hl, wc608
	ld a, MOBILEAPI_POP3CONNECT
	jp Mobile_CallAPIAndAdvanceState

Function119973:
	ld a, $1
	ld [wcf64], a
	xor a
	ld [wcf65], a
	ld [wMobileTradeMailResult], a
	ld de, w3_d000
	ld a, MOBILEAPI_POP3STAT
	jp Mobile_CallAPIAndAdvanceState

Function119987:
	ld hl, w3_d000 + 1
	ld a, [w3_d000]
	or [hl]
	jr z, .asm_1199a0
	ld a, [wcf64]
	ld l, a
	ld a, [wcf65]
	ld h, a
	ld de, wBGPals2
	ld a, MOBILEAPI_POP3LIST
	jp Mobile_CallAPIAndAdvanceState

.asm_1199a0
	ld a, [wMobileTradeMailResult]
	and a
	jr z, .asm_1199ae
	ld a, $16
	ld [wBattleTowerRoomMenuJumptableIndex], a
	jp Function119b0d

.asm_1199ae
	ld a, $1b
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret

Function1199b4:
	ld a, [w3_d081 + 1]
	and a
	jr nz, .asm_1199c7
	ld a, [w3_d081]
	cp $7
	jr nc, .asm_1199c7
	call BattleTowerRoomMenu_IncrementJumptable
	jp Function1199ca

.asm_1199c7
	jp Function119ac9

Function1199ca:
	ld a, MOBILE_DOWNLOAD_POP3_HEAD
	ld [wMobileDownloadFlags], a
	ld a, [wcf64]
	ld l, a
	ld a, [wcf65]
	ld h, a
	ld de, w3_d100
	ld bc, $0700
	ld a, MOBILEAPI_POP3HEAD
	jp Mobile_CallAPIAndAdvanceState

Function1199e2:
	ld c, $c
	ld de, XGameCodePrefix
	call Mobile_FindMailHeader
	jp c, Function119ac9
	ld a, c
	cp $1
	jp nz, Function119ac9
	ld hl, w3_d880
	ld bc, XGameCode
.loop
	ld a, [bc]
	and a
	jr z, .game_result_prefix
	cp [hl]
	jp nz, Function119ac9
	inc bc
	inc hl
	jr .loop

.game_result_prefix
	ld c, $17
	ld de, XGameResultPrefix
	call Mobile_FindMailHeader
	jp c, .asm_119aa7
	ld a, c
	cp $1
	jp nz, .asm_119aa7
	ld a, [w3_d880]
	cp $31
	jp nz, .asm_119aa7
	ld a, [w3_d881]
	cp $20
	jp nz, .asm_119aa7
	ld a, [w3_d88a]
	cp $20
	jp nz, .asm_119aa7
	ld a, [w3_d894]
	cp $20
	jp nz, .asm_119aa7
	xor a
	ld [w3_d8a0], a
	ld [w3_d8a1], a
	ld [w3_d8a2], a
	ld [w3_d8a3], a
	ld hl, w3_d8a0
	ld bc, w3_d889
	call Mobile_DecodeMailHexWord
	call Mobile_DecodeMailHexWord
	ld hl, w3_d8a0
	ld a, [wMobileTradeSecretID + 1]
	cp [hl]
	jr nz, Function119ac9
	inc hl
	ld a, [wMobileTradeSecretID]
	cp [hl]
	jr nz, Function119ac9
	inc hl
	ld a, [wMobileTradeTrainerID + 1]
	cp [hl]
	jr nz, Function119ac9
	inc hl
	ld a, [wMobileTradeTrainerID]
	cp [hl]
	jr nz, Function119ac9
	xor a
	ld [w3_d8a0], a
	ld [w3_d8a1], a
	ld [w3_d8a2], a
	ld [w3_d8a3], a
	ld hl, w3_d8a0
	ld bc, w3_d88e
	call Mobile_DecodeMailHexWord
	ld bc, w3_d893
	call Mobile_DecodeMailHexWord
	ld hl, w3_d8a0
	ld a, [wMobileTradeOfferSpecies]
	cp [hl]
	jr nz, .asm_119aa7
	inc hl
	ld a, [wMobileTradeOfferGender]
	cp [hl]
	jr nz, .asm_119aa7
	inc hl
	ld a, [wMobileTradeRequestedSpecies]
	cp [hl]
	jr nz, .asm_119aa7
	inc hl
	ld a, [wMobileTradeRequestedGender]
	cp [hl]
	jr z, .asm_119aaf

.asm_119aa7
	ld a, $25
	ld [wBattleTowerRoomMenuJumptableIndex], a
	jp DeleteInvalidTradeEmail

.asm_119aaf
	ld a, [wMobileTradeMailResult]
	and a
	jr nz, .asm_119aa7
	ld a, [w3_d895]
	sub $30
	ld [wMobileTradeMailResult], a
	ld a, [wcf64]
	ld [wMobileTradeMailIndex], a
	ld a, [wcf65]
	ld [wMobileTradeMailIndex + 1], a

Function119ac9:
	ld a, [w3_d000]
	ld l, a
	ld a, [w3_d000 + 1]
	ld h, a
	dec hl
	ld a, l
	ld [w3_d000], a
	ld a, h
	ld [w3_d000 + 1], a
	ld a, [wcf64]
	ld l, a
	ld a, [wcf65]
	ld h, a
	inc hl
	ld a, l
	ld [wcf64], a
	ld a, h
	ld [wcf65], a
	ld a, $10
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret

pushc ascii

XGameCode:
	db "CGB-BXTJ-00", $0

XGameResult: ; unreferenced
	db "pokemon_crystal", $0

popc

Function119b0d:
	ld a, MOBILE_DIALOG_COMMUNICATING
	ld [wMobileDialogJumptableIndex], a
	call MobileConnectionDialog
	ld a, [wMobileTradeMailResult]
	cp MOBILE_TRADE_MAIL_MATCHED
	jr z, .asm_119b23
	ld a, $19
	ld [wBattleTowerRoomMenuJumptableIndex], a
	jr DeleteTradeEmail

.asm_119b23
	ld a, MOBILE_DOWNLOAD_POP3_RETR
	ld [wMobileDownloadFlags], a
	ld a, [wMobileTradeMailIndex]
	ld l, a
	ld a, [wMobileTradeMailIndex + 1]
	ld h, a
	ld de, w3_d100
	ld bc, $0700
	ld a, MOBILEAPI_POP3RETR
	jp Mobile_CallAPIAndAdvanceState

DeleteTradeEmail:
	ld a, [wMobileTradeMailIndex]
	ld l, a
	ld a, [wMobileTradeMailIndex + 1]
	ld h, a
	jr asm_119b4d

DeleteInvalidTradeEmail:
	ld a, [wcf64]
	ld l, a
	ld a, [wcf65]
	ld h, a

asm_119b4d:
	ld a, MOBILEAPI_POP3DELE
	jp Mobile_CallAPIAndAdvanceState

Mobile_LogoutOfPOP3:
	ld a, [wMobileTradeMailResult]
	cp MOBILE_TRADE_MAIL_MATCHED
	jr nz, .asm_119b66
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	ld a, MOBILE_TRADE_READY
	ld [sMobileTradeState], a
	call CloseSRAM

.asm_119b66
	ld a, MOBILEAPI_POP3QUIT
	jp Mobile_CallAPIAndAdvanceState

DecodeReceivedTradeCornerTrade:
	ld a, [wMobileTradeMailResult]
	cp MOBILE_TRADE_MAIL_MATCHED
	jr z, .asm_119b75
	jp BattleTowerRoomMenu_IncrementJumptable

.asm_119b75
	ld a, [w3_d100]
	ld b, a
	ld a, [w3_d100 + 1]
	or b
	jr z, .asm_119be3
	ld hl, wMobileTradeReplyBuffer
	ld de, w3_d100 + 2
.asm_119b85
	ld a, [de]
	inc de
	cp $d
	jr nz, .asm_119b85
	inc de
	ld a, [de]
	cp $d
	jr nz, .asm_119b85
	inc de
	inc de
.asm_119b93
	ld a, [de]
	inc de
	cp $d
	jr z, .asm_119bfa
	call .decodeBase64Character
	ret c
	ld [hli], a
	ld a, [de]
	inc de
	call .decodeBase64Character
	ret c
	ld [hli], a
	ld a, [de]
	inc de
	call .decodeBase64Character
	ret c
	ld [hli], a
	ld a, [de]
	inc de
	call .decodeBase64Character
	ret c
	ld [hl], a
	push de
	ld d, [hl]
	dec hl
	ld c, [hl]
	dec hl
	ld b, [hl]
	dec hl
	ld a, [hl]
	sla b
	sla b
	sla b
	rla
	sla b
	rla
	ld [hli], a
	ld [hl], b
	inc hl
	rrc c
	rrc c
	ld [hl], c
	dec hl
	ld a, $f
	and c
	or [hl]
	ld [hli], a
	ld a, [hli]
	and $c0
	or [hl]
	dec hl
	ld [hld], a
	dec hl
	pop de
	inc hl
	inc hl
	inc hl
	ld a, h
	cp $e0
	jr c, .asm_119b93

.asm_119be3
	ld a, $19
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	ld a, MOBILE_TRADE_OFFERED
	ld [sMobileTradeState], a
	call CloseSRAM
	xor a
	ld [wMobileTradeMailResult], a
	ret

.asm_119bfa
	inc de
	ld a, [de]
	cp $d
	jr nz, .asm_119b93
	ld a, l
	cp LOW(wMobileTradeReplyBufferEnd)
	jr nz, .asm_119be3
	ld a, h
	cp HIGH(wMobileTradeReplyBufferEnd)
	jr nz, .asm_119be3
	ld a, BANK(sMobileTradeMailIndex)
	call OpenSRAM
	ld a, [wcf64]
	ld [sMobileTradeMailIndex], a
	ld a, [wcf65]
	ld [sMobileTradeMailIndex + 1], a
	ld hl, wMobileTradeReplyBuffer
	ld de, sMobileTradeReply
	ld bc, TRADE_CORNER_REPLY_LENGTH
	call CopyBytes
	ld a, MOBILE_TRADE_RECEIVED
	ld [sMobileTradeState], a
	call CloseSRAM
	ld hl, wMobileTradeReplyBuffer
	ld de, wMobileTradeReply
	ld bc, TRADE_CORNER_REPLY_LENGTH
	call CopyBytes
	jp BattleTowerRoomMenu_IncrementJumptable

pushc ascii

.decodeBase64Character
	cp '+'
	jr c, .asm_119c68
	jr z, .asm_119c80
	cp '/'
	jr c, .asm_119c68
	jr z, .asm_119c84
	cp '0'
	jr c, .asm_119c68
	cp '9' + 1
	jr c, .asm_119c88
	cp '='
	jr c, .asm_119c68
	jr z, .asm_119c8c
	cp 'A'
	jr c, .asm_119c68
	cp 'Z' + 1
	jr c, .asm_119c8f
	cp 'a'
	jr c, .asm_119c68
	cp 'z' + 1
	jr c, .asm_119c93

popc

.asm_119c68
	ld a, $19
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	ld a, MOBILE_TRADE_OFFERED
	ld [sMobileTradeState], a
	call CloseSRAM
	xor a
	ld [wMobileTradeMailResult], a
	scf
	ret

.asm_119c80
	ld a, $3e
	and a
	ret

.asm_119c84
	ld a, $3f
	and a
	ret

.asm_119c88
	add $4
	and a
	ret

.asm_119c8c
	xor a
	and a
	ret

.asm_119c8f
	sub $41
	and a
	ret

.asm_119c93
	sub $47
	and a
	ret

BattleTowerRoomMenu_UberRestrictionMessage:
	ld hl, Text_UberRestriction
	call Mobile_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable
	jr BattleTowerRoomMenu_WaitForMessage

BattleTowerRoomMenu_PartyMonTopsThisLevelMessage:
	ld hl, Text_PartyMonTopsThisLevel
	call Mobile_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_WaitForMessage:
	ld a, [wMobileMessageJumptableIndex]
	and a
	ret nz
	ld a, $80
	ld [wcd50], a
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_DelayRestartMenu:
	; Loops while (--[wcd50] != 0),
	;   to create some sort of "delay" after the message is written on the screen,
	;   before starting the menu again.
	ld hl, wcd50
	dec [hl]
	ret nz
	ld a, $0
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret

BattleTowerRoomMenu_QuitMessage:
	ld a, [wcd38]
	and a
	jr z, .asm_119cd1
	dec a
	jr z, .asm_119cd6
	ld hl, Text_QuitReadingNews
	jr .asm_119cd9

.asm_119cd1
	ld hl, Text_CancelBattleRoomChallenge
	jr .asm_119cd9

.asm_119cd6
	ld hl, Text_ExitGymLeaderHonorRoll

.asm_119cd9
	call Mobile_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_PlaceYesNoMenu:
	ld a, [wMobileMessageJumptableIndex]
	and a
	ret nz
	ld a, MOBILE_DIALOG_PLACE_CANCEL_MENU
	ld [wMobileDialogJumptableIndex], a
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_UpdateYesNoMenu:
	; The dialog is in MOBILE_DIALOG_UPDATE_CANCEL_MENU here.
	call MobileConnectionDialog
	ret c
	ld a, [wMobileDialogResumeState]
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ret

INCLUDE "data/battle_tower/level_menu.asm"

INCLUDE "engine/events/battle_tower/level_checks.asm"

Mobile_CallAPIAndAdvanceState:
	call MobileAPI

BattleTowerRoomMenu_IncrementJumptable:
Mobile_IncrementConnectionState:
	ld hl, wMobileConnectionJumptableIndex
	inc [hl]
	ret

pushc ascii

XGameCodePrefix:
	db "X-Game-code:\n"

XGameResultPrefix:
	db "X-Game-result:\n"

popc

Mobile_FindMailHeader:
; Search the POP3 header buffer for the newline-terminated prefix at de.
; Skip the space after its colon, then copy up to c bytes to w3_d880,
; including the first CR. Carry means not found or the value was too long.
	push bc
	ld hl, w3_d100
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.search
	ld a, [de]
	cp [hl]
	jr z, .candidate
.next_byte
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .search
.failed
	pop bc
	scf
	ret

.candidate
	push de
.match_prefix
	ld a, [de]
	inc de
pushc ascii
	cp '\n'
popc
	jr z, .found
	cp [hl]
	jr nz, .unequal
	inc hl
	dec bc
	ld a, b
	or c
	jr nz, .match_prefix
	pop de
	jr .failed

.unequal
	pop de
	jr .next_byte

.found
	pop de
	pop bc
	inc hl
	ld de, w3_d880
.copy_value
	ld a, [hli]
	ld [de], a
	inc de
pushc ascii
	cp '\r'
popc
	jr z, .finish
	dec c
	jr nz, .copy_value
	scf
	ret

.finish
	and a
	ret

pushc ascii

Mobile_DecodeASCIIHexDigit:
; Decode an ASCII digit or lowercase hex letter in a.
; The original letter branch starts at the backtick character ($60).
	cp '`'
	jr c, .digit
	sub 'a' - 10
	ret

.digit
	sub '0'
	ret

popc

Mobile_DecodeMailHexWord:
; Read four ASCII hex digits backwards from bc into a little-endian word
; at hl. The caller must clear the destination; decoded nibbles are ORed in.
	ld a, $2
.loop
	push af
	ld a, [bc]
	dec bc
	call Mobile_DecodeASCIIHexDigit
	or [hl]
	ld [hl], a
	ld a, [bc]
	dec bc
	call Mobile_DecodeASCIIHexDigit
	rlca
	rlca
	rlca
	rlca
	or [hl]
	ld [hl], a
	inc hl
	pop af
	dec a
	and a
	jr nz, .loop
	ret

Mobile_AppendLoginID:
; Append the login ID and its terminator at hl, clamping it to 32 bytes.
	xor a
	ld [wMobileLoginID + MOBILE_LOGIN_ID_LENGTH], a
	ld de, wMobileLoginID
.loop
	ld a, [de]
	inc de
	ld [hli], a
	and a
	jr nz, .loop
	ret

Mobile_AppendLoginPassword:
; Skip the saved password status byte and copy through the null terminator.
	ld a, BANK(sMobileLoginPassword)
	call OpenSRAM
	xor a
	ld [sMobileLoginPasswordBuffer + MOBILE_LOGIN_PASSWORD_MAX_LENGTH], a
	ld de, sMobileLoginPasswordBuffer
.loop
	ld a, [de]
	inc de
	ld [hli], a
	and a
	jr nz, .loop
	call CloseSRAM
	ret

INCLUDE "mobile/connection_dialog.asm"

Function11a80c:
	ld de, hDivisor
	ld bc, hDividend
	ld hl, Unknown_11a89a
	call Function11a88c
	ld bc, hQuotient + 1
	ld hl, Unknown_11a8ba
	call Function11a88c
	ld bc, hPrintNumBuffer + 2
	ld hl, Unknown_11a8da
	call Function11a88c
	xor a
	ld b, a
	ldh a, [hDivisor]
	and $f
	ld e, a
	ldh a, [hPrintNumBuffer + 6]
	and $f
	call Function11a884
	ld e, a
	ldh a, [hPrintNumBuffer + 8]
	and $f
	call Function11a884
	ld [wcd62], a
	ld e, b
	xor a
	ld b, a
	ldh a, [hDivisor]
	and $f0
	swap a
	call Function11a884
	ld e, a
	ldh a, [hPrintNumBuffer + 6]
	and $f0
	swap a
	call Function11a884
	ld e, a
	ldh a, [hPrintNumBuffer + 8]
	and $f0
	swap a
	call Function11a884
	ld [wcd63], a
	ld e, b
	xor a
	ld b, a
	ldh a, [hMathBuffer]
	and $f
	call Function11a884
	ld e, a
	ldh a, [hPrintNumBuffer + 7]
	and $f
	call Function11a884
	ld e, a
	ldh a, [hPrintNumBuffer + 9]
	and $f
	call Function11a884
	ld [wcd64], a
	ret

Function11a884:
	add e
	cp $a
	ret c
	sub $a
	inc b
	ret

Function11a88c:
	ld a, [bc]
	sla a
	ld c, a
	xor a
	ld b, a
	add hl, bc
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ret

Unknown_11a89a:
for x, 16
	bcd x % 100, x / 100
endr

Unknown_11a8ba:
for x, 0, 16**2, 16
	bcd x % 100, x / 100
endr

Unknown_11a8da:
for x, 0, 16**3, 16**2
	bcd x % 100, x / 100
endr

INCLUDE "mobile/message.asm"

MobileDialog_ReloadOverworld:
	call ClearBGPalettes
	call ReloadTilesetAndPalettes
	call Call_ExitMenu
	farcall Stubbed_Function106462
	farcall Function106464
	call GSReloadPalettes
	farcall FinishExitMenu
	call UpdateSprites
	ret

MobileDialog_CheckLegacyInactivityTimeout:
; Stubbed out: always report that the dialog has not timed out.
	ld a, $1
	and a
	ret

Mobile_CheckLegacyInactivityTimeout: ; unreferenced
; Count one frame per call and time out after three minutes.
	ld a, [wMobileLegacyInactivityCounter]
	ld l, a
	ld a, [wMobileLegacyInactivityCounter + 1]
	ld h, a
	inc hl
	ld a, l
	ld [wMobileLegacyInactivityCounter], a
	ld a, h
	ld [wMobileLegacyInactivityCounter + 1], a
	ld de, -MOBILE_INACTIVITY_TIMEOUT_FRAMES
	add hl, de
	bit 7, h
	ret nz
	ld a, MOBILE_ERROR_INACTIVITY_TIMEOUT
	call SetMobileErrorCode
	and a
	ret

INCLUDE "data/mobile/messages.asm"
INCLUDE "data/battle_tower/room_menu_text.asm"

Function11ac3e:
	call SpeechTextbox
	call FadeToMenu
	callfar ClearSpriteAnims2
	call Function11ac51
	call CloseSubmenu
	ret

Function11ac51:
	xor a
	ldh [hBGMapMode], a
	ld hl, wOptions
	ld a, [hl]
	push af
	set 4, [hl]
	ld a, [wStateFlags]
	push af
	xor a
	ld [wStateFlags], a
	ldh a, [hInMenu]
	push af
	ld a, $1
	ldh [hInMenu], a
	xor a
	ldh [hMapAnims], a
	ld [wcd49], a
	ld [wcd4a], a
	ld [wcd4c], a
	ld [wcd4d], a
	ld [wcd4e], a
	call Function11ad1b
	call DelayFrame
.loop
	call JoyTextDelay
	ld a, [wJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr nz, .asm_11aca8
	call Function11b314
	call Function11acb7
	call Function11ad6e
	ld a, 30 * OBJ_SIZE
	ld [wCurSpriteOAMAddr], a
	farcall DoNextFrameForAllSprites
	farcall HDMATransferTilemapAndAttrmap_Overworld
	jr .loop

.asm_11aca8
	call ClearSprites
	pop af
	ldh [hInMenu], a
	pop af
	ld [wStateFlags], a
	pop af
	ld [wOptions], a
	ret

Function11acb7:
	ld hl, TilemapPack_11ba44
	ld a, [wcd49]
	ld c, a
	ld b, 0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	decoord 6, 6
	ld a, [hli]
	ld [de], a
	decoord 0, 7
	ld bc, 7
	call CopyBytes
	ld a, [wcd49]
	inc a
	ld [wcd49], a
	ld a, [hl]
	cp $ff
	jr nz, .get_the_other
	xor a
	ld [wcd49], a
.get_the_other
	ld hl, TilemapPack_11bb7d
	ld a, [wcd4a]
	ld c, a
	ld b, 0
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	add hl, bc
	decoord 3, 9
	ld bc, 7
	call CopyBytes
	ld a, [wcd4a]
	inc a
	ld [wcd4a], a
	inc hl
	ld a, [hl]
	cp $ff
	ret nz
	xor a
	ld [wcd4a], a
	ret

Function11ad1b:
	call ClearBGPalettes
	call ClearSprites
	call ClearTilemap
	farcall Mobile_LoadTradeCornerOfferBackground
	ld a, [wMenuCursorY]
	ld [wMobileTradePartySelection], a
	dec a
	ldh [hObjectStructIndex], a
	ld a, $10
	ld [wCurIconTile], a
	ld hl, LoadMenuMonIcon
	ld a, BANK(LoadMenuMonIcon)
	ld e, MONICON_MOBILE1
	rst FarCall
	ld hl, LoadMenuMonIcon
	ld a, BANK(LoadMenuMonIcon)
	ld e, MONICON_MOBILE2
	rst FarCall
	ld hl, wPokedexOrder
	ld bc, $0115
	xor a
	call ByteFill
	xor a
	ld [wJumptableIndex], a
	ld [wcf64], a
	ld [wcf65], a
	ld [wcf66], a
	ld [wcd30], a
	ld a, DEXMODE_ABC
	ld [wCurDexMode], a
	farcall Pokedex_OrderMonsByMode
	ret

Function11ad6e:
	ld a, [wJumptableIndex]
	ld hl, Jumptable_11ad78
	call Function11b239
	jp hl

Jumptable_11ad78:
	dw Function11b082
	dw Function11b0ff
	dw Function11ad95
	dw Function11adc4
	dw Function11ae4e
	dw Function11ae98
	dw Function11ad8f
	dw Function11af04
	dw Function11af4e

MobileIncJumptableIndex:
	ld hl, wJumptableIndex
	inc [hl]
	ret

Function11ad8f:
	ld hl, wJumptableIndex
	set JUMPTABLE_EXIT_F, [hl]
	ret

Function11ad95:
	ld hl, MenuHeader_11ae38
	call LoadMenuHeader
	call MenuBox
	hlcoord 12, 12
	ld de, String_11ae40
	call PlaceString
	hlcoord 10, 10, wAttrmap
	lb bc, 8, 8
	call Function11afd6
	farcall HDMATransferTilemapAndAttrmap_Overworld
	call MobileIncJumptableIndex
	ld a, $1
	ld [wMenuCursorY], a
	ld hl, Unknown_11afcc
	call Function11afb7

Function11adc4:
	ld hl, hJoyPressed
	ld a, [hl]
	and a
	ret z
	ld a, [hl]
	and PAD_UP
	jr nz, .asm_11ade6
	ld a, [hl]
	and PAD_DOWN
	jr nz, .asm_11aded
	ld a, [hl]
	and PAD_A
	jr nz, .asm_11ae06
	ld a, [hl]
	and PAD_B
	ret z
	call PlayClickSFX
	xor a
	ld [wJumptableIndex], a
	jr .asm_11ae2e

.asm_11ade6
	ld a, [wMenuCursorY]
	dec a
	ret z
	jr .asm_11adf4

.asm_11aded
	ld a, [wMenuCursorY]
	inc a
	cp $4
	ret z

.asm_11adf4
	push af
	ld hl, Unknown_11afcc
	call Function11afbb
	pop af
	ld [wMenuCursorY], a
	ld hl, Unknown_11afcc
	call Function11afb7
	ret

.asm_11ae06
	call PlayClickSFX
	ld a, [wMenuCursorY]
	dec a
	ld hl, wcd30
	ld [hl], a
	and a
	jr z, .asm_11ae28
	hlcoord 2, 14
	ld a, [wMenuCursorY]
	cp $2
	jr z, .asm_11ae23
	call Function11b272
	jr .asm_11ae2b

.asm_11ae23
	call Function11b267
	jr .asm_11ae2b

.asm_11ae28
	ld a, $3
	ld [hl], a

.asm_11ae2b
	call MobileIncJumptableIndex

.asm_11ae2e
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ret

MenuHeader_11ae38:
	db MENU_BACKUP_TILES ; flags
	menu_coords 10, 10, 17, SCREEN_HEIGHT - 1
	dw NULL
	db 0 ; default option

String_11ae40:
	db   "どちらでも"
	next "♂オス"
	next "♀メス"
	db   "@"

Function11ae4e:
	ld hl, MenuHeader_11afe8
	call LoadMenuHeader
	call MenuBox
	hlcoord 10, 14
	ld de, String_11aff0
	call PlaceString
	ld hl, MenuHeader_11b013
	call LoadMenuHeader
	call MenuBox
	hlcoord 16, 8
	ld de, String_11b01b
	call PlaceString
	hlcoord 14, 7, wAttrmap
	lb bc, 5, 6
	call Function11afd6
	hlcoord 9, 12, wAttrmap
	lb bc, 6, 11
	call Function11afd6
	farcall HDMATransferTilemapAndAttrmap_Overworld
	call MobileIncJumptableIndex
	ld a, $1
	ld [wMenuCursorY], a
	ld hl, Unknown_11afd2
	call Function11afb7

Function11ae98:
	ld hl, hJoyPressed
	ld a, [hl]
	and a
	ret z
	ld a, [hl]
	and PAD_UP
	jr nz, .asm_11aec1
	ld a, [hl]
	and PAD_DOWN
	jr nz, .asm_11aec8
	ld a, [hl]
	and PAD_A
	jr nz, .asm_11aee1
	ld a, [hl]
	and PAD_B
	ret z
	call PlayClickSFX
.asm_11aeb4
	hlcoord 2, 14
	ld a, $7f
	ld [hl], a
	ld a, $1
	ld [wJumptableIndex], a
	jr .asm_11aef7

.asm_11aec1
	ld a, [wMenuCursorY]
	dec a
	ret z
	jr .asm_11aecf

.asm_11aec8
	ld a, [wMenuCursorY]
	inc a
	cp $3
	ret z

.asm_11aecf
	push af
	ld hl, Unknown_11afd2
	call Function11afbb
	pop af
	ld [wMenuCursorY], a
	ld hl, Unknown_11afd2
	call Function11afb7
	ret

.asm_11aee1
	call PlayClickSFX
	ld a, [wMenuCursorY]
	cp $2
	jr z, .asm_11aeb4
	ld a, [wcd4b]
	ld [wScriptVar], a
	call Function11b022
	call MobileIncJumptableIndex

.asm_11aef7
	call ExitMenu
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ret

Function11af04:
	ld hl, MenuHeader_11afe8
	call LoadMenuHeader
	call MenuBox
	hlcoord 10, 14
	ld de, String_11b003
	call PlaceString
	ld hl, MenuHeader_11b013
	call LoadMenuHeader
	call MenuBox
	hlcoord 16, 8
	ld de, String_11b01b
	call PlaceString
	hlcoord 14, 7, wAttrmap
	lb bc, 5, 6
	call Function11afd6
	hlcoord 9, 12, wAttrmap
	lb bc, 6, 11
	call Function11afd6
	farcall HDMATransferTilemapAndAttrmap_Overworld
	call MobileIncJumptableIndex
	ld a, $2
	ld [wMenuCursorY], a
	ld hl, Unknown_11afd2
	call Function11afb7

Function11af4e:
	ld hl, hJoyPressed
	ld a, [hl]
	and a
	ret z
	ld a, [hl]
	and PAD_UP
	jr nz, .asm_11af77
	ld a, [hl]
	and PAD_DOWN
	jr nz, .asm_11af7e
	ld a, [hl]
	and PAD_A
	jr nz, .asm_11af97
	ld a, [hl]
	and PAD_B
	ret z
	call PlayClickSFX
.asm_11af6a
	hlcoord 2, 14
	ld a, $7f
	ld [hl], a
	ld a, $1
	ld [wJumptableIndex], a
	jr .asm_11afaa

.asm_11af77
	ld a, [wMenuCursorY]
	dec a
	ret z
	jr .asm_11af85

.asm_11af7e
	ld a, [wMenuCursorY]
	inc a
	cp $3
	ret z

.asm_11af85
	push af
	ld hl, Unknown_11afd2
	call Function11afbb
	pop af
	ld [wMenuCursorY], a
	ld hl, Unknown_11afd2
	call Function11afb7
	ret

.asm_11af97
	call PlayClickSFX
	ld a, [wMenuCursorY]
	cp $2
	jr z, .asm_11af6a
	ld a, $6
	ld [wJumptableIndex], a
	xor a
	ld [wScriptVar], a

.asm_11afaa
	call ExitMenu
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ret

Function11afb7:
	ld e, $ed
	jr asm_11afbd

Function11afbb:
	ld e, $7f

asm_11afbd:
	ld a, [wMenuCursorY]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	ld a, e
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld [de], a
	ret

Unknown_11afcc:
	dwcoord 11, 12
	dwcoord 11, 14
	dwcoord 11, 16

Unknown_11afd2:
	dwcoord 15,  8
	dwcoord 15, 10

Function11afd6:
	ld de, SCREEN_WIDTH
	ld a, $3
.row
	push bc
	push hl
.col
	ld [hli], a
	dec c
	jr nz, .col
	pop hl
	add hl, de
	pop bc
	dec b
	jr nz, .row
	ret

MenuHeader_11afe8:
	db MENU_BACKUP_TILES ; flags
	menu_coords 9, 12, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	dw NULL
	db 0 ; default option

String_11aff0:
	db   "この　じょうけんで"
	next "よろしいですか？@"

String_11b003:
	db   "こうかんを"
	next "ちゅうししますか？@"

MenuHeader_11b013:
	db MENU_BACKUP_TILES ; flags
	menu_coords 14, 7, SCREEN_WIDTH - 1, TEXTBOX_Y - 1
	dw NULL
	db 1 ; default option

String_11b01b:
	db   "はい"
	next "いいえ@"

Function11b022:
	ld a, [wcd2e]
	and a
	jr z, .asm_11b02e
	ld hl, wStringBuffer3
	call Function11b03d

.asm_11b02e
	ld a, [wcd30]
	and a
	ret z
	cp $3
	ret z
	ld hl, wStringBuffer4
	call Function11b03d
	ret

Function11b03d:
	push hl
	push af
	ld c, $1
.loop
	ld a, [hli]
	cp '♂'
	jr z, .gender
	cp '♀'
	jr z, .gender
	cp '@'
	jr z, .done
	inc c
	jr .loop

.gender
	dec hl
	ld a, '@'
	ld [hli], a

.done
	dec hl
	push hl
	ld e, 4
	ld d, 0
	add hl, de
	ld e, l
	ld d, h
	pop hl
.loop2
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, .loop2
	pop af
	pop de
	cp $1
	jr nz, .female
	ld hl, .MaleString
	jr .got_string

.female
	ld hl, .FemaleString

.got_string
	ld bc, 4 ; string length
	call CopyBytes
	ret

.MaleString: db "オスの　"
.FemaleString: db "メスの　"

Function11b082:
	call Function11b242
	ld a, $7
	ld [wc7d3], a
	call Function11b099
	call Function11b295
	call Function11b275
	call SetDefaultBGPAndOBP
	jp MobileIncJumptableIndex

Function11b099:
	ld c, $6
	hlcoord 11, 1
	ld a, [wc7d3]
	add a
	ld b, a
	xor a
	call Function11b236
	ld a, [wc7d0]
	ld e, a
	ld d, 0
	ld hl, wPokedexOrder
	add hl, de
	ld e, l
	ld d, h
	hlcoord 11, 2
	ld a, [wc7d3]
.loop
	push af
	ld a, [de]
	ld [wTempSpecies], a
	push de
	push hl
	call .PlaceMonNameOrPlaceholderString
	pop hl
	ld de, 2 * SCREEN_WIDTH
	add hl, de
	pop de
	inc de
	pop af
	dec a
	jr nz, .loop
	ret

.PlaceMonNameOrPlaceholderString:
	and a
	ret z

	call .CheckSeenFlag
	ret c

	call .SetCaughtFlag
	push hl
	call GetPokemonName
	pop hl
	call PlaceString
	ret

.SetCaughtFlag:
	call CheckCaughtMemMon
	jr nz, .okay
	inc hl
	ret

.okay
	ld a, $1
	ld [hli], a
	ret

.CheckSeenFlag:
	call CheckSeenMemMon
	ret nz

	inc hl
	ld de, .EmptySlot
	call PlaceString
	scf
	ret

.EmptySlot:
	db "ーーーーー@"

Function11b0ff:
	ld hl, hJoyPressed
	ld a, [hl]
	and PAD_B
	jr nz, .asm_11b141
	ld a, [hl]
	and PAD_A
	jr nz, .asm_11b131
	call Function11b175
	jr nc, .asm_11b125
	ld a, [wcd4c]
	inc a
	and $3
	ld [wcd4c], a
	xor a
	ldh [hBGMapMode], a
	call Function11b099
	ld a, $1
	ldh [hBGMapMode], a
	ret

.asm_11b125
	ld a, [wcd4c]
	and a
	ret z
	inc a
	and $3
	ld [wcd4c], a
	ret

.asm_11b131
	call Function11b20b
	call CheckSeenMemMon
	jr z, .asm_11b13d
	ld a, $1
	jr .asm_11b148

.asm_11b13d
	ld a, $2
	jr .asm_11b148

.asm_11b141
	ld hl, wJumptableIndex
	ld a, $7
	ld [hl], a
	ret

.asm_11b148
	call PlayClickSFX
	ld [wcd4b], a
	and a
	jr z, .asm_11b16c
	ld a, [wcf65]
	cp $0
	jr z, .asm_11b163
	cp $fe
	jr z, .asm_11b167
	cp $ff
	jr z, .asm_11b16b
	jp MobileIncJumptableIndex

.asm_11b163
	ld a, $1
	jr .asm_11b16c

.asm_11b167
	ld a, $2
	jr .asm_11b16c

.asm_11b16b
	xor a

.asm_11b16c
	ld [wcd30], a
	ld a, $4
	ld [wJumptableIndex], a
	ret

Function11b175:
	ld a, [wc7d3]
	ld d, a
	ld a, [wc7d2]
	ld e, a
	ld hl, hJoyLast
	ld a, [hl]
	and PAD_UP
	jr nz, .asm_11b19a
	ld a, [hl]
	and PAD_DOWN
	jr nz, .asm_11b1ae
	ld a, d
	cp e
	jr nc, .asm_11b1ed
	ld a, [hl]
	and PAD_LEFT
	jr nz, .asm_11b1c6
	ld a, [hl]
	and PAD_RIGHT
	jr nz, .asm_11b1d8
	jr .asm_11b1ed

.asm_11b19a
	ld hl, wc7d1
	ld a, [hl]
	and a
	jr z, .asm_11b1a4
	dec [hl]
	jr .asm_11b1ef

.asm_11b1a4
	ld hl, wc7d0
	ld a, [hl]
	and a
	jr z, .asm_11b1ed
	dec [hl]
	jr .asm_11b1ef

.asm_11b1ae
	ld hl, wc7d1
	ld a, [hl]
	inc a
	cp e
	jr nc, .asm_11b1ed
	cp d
	jr nc, .asm_11b1bc
	inc [hl]
	jr .asm_11b1ef

.asm_11b1bc
	ld hl, wc7d0
	add [hl]
	cp e
	jr nc, .asm_11b1ed
	inc [hl]
	jr .asm_11b1ef

.asm_11b1c6
	ld hl, wc7d0
	ld a, [hl]
	and a
	jr z, .asm_11b1ed
	cp d
	jr nc, .asm_11b1d4
	xor a
	ld [hl], a
	jr .asm_11b1ef

.asm_11b1d4
	sub d
	ld [hl], a
	jr .asm_11b1ef

.asm_11b1d8
	ld hl, wc7d0
	ld a, d
	add a
	add [hl]
	jr c, .asm_11b1e3
	cp e
	jr c, .asm_11b1e8

.asm_11b1e3
	ld a, e
	sub d
	ld [hl], a
	jr .asm_11b1ef

.asm_11b1e8
	ld a, [hl]
	add d
	ld [hl], a
	jr .asm_11b1ef

.asm_11b1ed
	and a
	ret

.asm_11b1ef
	call Function11b295
	call Function11b275
	scf
	ret

FillScreenWithTile32: ; unreferenced
	hlcoord 0, 0
	ld a, $32
	ld bc, SCREEN_AREA
	call ByteFill
	ret

CopyDataUntilFF: ; unreferenced
.loop
	ld a, [de]
	cp $ff
	ret z
	inc de
	ld [hli], a
	jr .loop

Function11b20b:
	ld a, [wc7d1]
	ld hl, wc7d0
	add [hl]
	ld e, a
	ld d, 0
	ld hl, wc6d0
	add hl, de
	ld a, [hl]
	ld [wTempSpecies], a
	ret

CheckCaughtMemMon:
	push de
	push hl
	ld a, [wTempSpecies]
	dec a
	call CheckCaughtMon
	pop hl
	pop de
	ret

CheckSeenMemMon:
	push de
	push hl
	ld a, [wTempSpecies]
	dec a
	call CheckSeenMon
	pop hl
	pop de
	ret

Function11b236:
	jp FillBoxWithByte

Function11b239:
	ld e, a
	ld d, 0
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

Function11b242:
	hlcoord 3, 4
	ld de, wStringBuffer3
	call PlaceString
	xor a
	ld [wMonType], a
	farcall GetGender
	hlcoord 1, 4
	ld a, [wCurPartySpecies]
	ld bc, wcd2f
	ld [bc], a
	dec bc
	jr c, asm_11b26a
	jr z, asm_11b26f
	ld a, $1
	ld [bc], a

Function11b267:
	ld [hl], $ef
	ret

asm_11b26a:
	xor a
	ld [bc], a
	ld [hl], $7f
	ret

asm_11b26f:
	ld a, $2
	ld [bc], a

Function11b272:
	ld [hl], $f5
	ret

Function11b275:
	call Function11b279
	ret

Function11b279:
	ld a, [wTempSpecies]
	ld [wCurSpecies], a
	call CheckSeenMemMon
	jr z, .asm_11b28f
	call GetBaseData
	ld a, [wBaseGender]
	ld [wcf65], a
	jr .asm_11b294

.asm_11b28f
	ld a, $ff
	ld [wcf65], a

.asm_11b294
	ret

Function11b295:
	hlcoord 4, 13
	ld de, String_11b308
	call PlaceString
	hlcoord 4, 14
	ld de, String_11b308
	call PlaceString
	call Function11b20b
	call CheckSeenMemMon
	jr z, .asm_11b2d1
	ld a, [wc608]
	ld c, a
	ld a, [wc608 + 1]
	ld b, a
	ld hl, $0007
	add hl, bc
	xor a
	ld [hl], a
	ld hl, $0003
	add hl, bc
	ld e, [hl]
	farcall FlyFunction_GetMonIcon
	hlcoord 4, 14
	push hl
	call GetPokemonName
	jr .asm_11b2e7

.asm_11b2d1
	ld a, [wc608]
	ld c, a
	ld a, [wc608 + 1]
	ld b, a
	ld hl, $0007
	add hl, bc
	ld a, $50
	ld [hl], a
	hlcoord 4, 13
	push hl
	ld de, String_11b30e

.asm_11b2e7
	ld a, NAME_LENGTH_JAPANESE
	ld bc, wStringBuffer4
.asm_11b2ec
	push af
	ld a, [de]
	ld [bc], a
	inc de
	inc bc
	pop af
	dec a
	and a
	jr nz, .asm_11b2ec
	pop hl
	ld de, wStringBuffer4
	call PlaceString
	ret

String_11b2fe: ; unreferenced
	db "あげる<POKEMON>@"

String_11b303: ; unreferenced
	db "ほしい<POKEMON>@"

String_11b308:
	db "　　　　　@"

String_11b30e:
	db "みはっけん@"

Function11b314:
	call Function11b31b
	call Function11b3d9
	ret

Function11b31b:
	ld hl, .Coords
	ld a, [wJumptableIndex]
	cp 2
	jr c, .tilemap_1
	ld a, [wc7d1]
	cp 4
	jr nc, .tilemap_3
	cp 3
	jr c, .tilemap_1
	ld a, [wJumptableIndex]
	cp 2
	jr z, .tilemap_1
	cp 3
	jr z, .tilemap_1
	cp 6
	jr z, .tilemap_1

	ld bc, .Tilemap2
	jr .load_sprites

.tilemap_3
	ld bc, .Tilemap3
	jr .load_sprites

.tilemap_1
	ld bc, .Tilemap1

.load_sprites
	call Function11b397
	ret

.Coords:
	dbpixel 3, 11, 2, 6 ;  0
	dbpixel 3, 12, 2, 6 ;  1
	dbpixel 3, 13, 2, 6 ;  2
	dbpixel 3, 14, 2, 6 ;  3
	dbpixel 3, 15, 2, 6 ;  4
	dbpixel 3, 16, 2, 6 ;  5
	dbpixel 3, 17, 2, 6 ;  6
	dbpixel 4, 11, 2, 6 ;  7
	dbpixel 4, 12, 2, 6 ;  8
	dbpixel 4, 13, 2, 6 ;  9
	dbpixel 4, 14, 2, 6 ; 10
	dbpixel 4, 15, 2, 6 ; 11
	dbpixel 4, 16, 2, 6 ; 12
	dbpixel 4, 17, 2, 6 ; 13
	db -1

.Tilemap1: ; vtiles
	db $30 ;  0
	db $31 ;  1
	db $31 ;  2
	db $31 ;  3
	db $31 ;  4
	db $31 ;  5
	db $32 ;  6
	db $40 ;  7
	db $41 ;  8
	db $41 ;  9
	db $41 ; 10
	db $41 ; 11
	db $41 ; 12
	db $42 ; 13

.Tilemap2: ; vtiles
	db $30 ;  0
	db $31 ;  1
	db $31 ;  2
	db $39 ;  3
	db $39 ;  4
	db $39 ;  5
	db $39 ;  6
	db $40 ;  7
	db $41 ;  8
	db $41 ;  9
	db $39 ; 10
	db $39 ; 11
	db $39 ; 12
	db $39 ; 13

.Tilemap3: ; vtiles
	db $39 ;  0
	db $39 ;  1
	db $39 ;  2
	db $39 ;  3
	db $39 ;  4
	db $39 ;  5
	db $39 ;  6
	db $39 ;  7
	db $39 ;  8
	db $39 ;  9
	db $39 ; 10
	db $39 ; 11
	db $39 ; 12
	db $39 ; 13

Function11b397:
	ld de, wShadowOAMSprite00
.loop
	ld a, [hl]
	cp $ff
	ret z
	ld a, [wc7d1]
	and $7
	swap a
	add [hl]
	inc hl
	ld [de], a ; y
	inc de

	ld a, [hli]
	ld [de], a ; x
	inc de

	ld a, [bc]
	inc bc
	ld [de], a ; tile id
	inc de
	ld a, $5
	ld [de], a ; attributes
	inc de
	jr .loop

Function11b3b6: ; unreferenced
.loop
	ld a, [hl]
	cp -1
	ret z
	ld a, [wcd4d]
	and $7
	swap a
	add [hl]
	inc hl
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	push hl
	ld l, c
	ld h, b
	ld a, [wcd4e]
	add [hl]
	inc bc
	ld [de], a
	inc de
	pop hl
	ld a, $5
	ld [de], a
	inc de
	jr .loop

Function11b3d9:
	ld de, wShadowOAMSprite28
	push de
	ld a, [wc7d2]
	dec a
	ld e, a
	ld a, [wc7d1]
	ld hl, wc7d0
	add [hl]
	cp e
	jr z, .skip
	ld hl, 0
	ld bc, $70
	call AddNTimes
	ld e, l
	ld d, h
	ld b, 0
	ld a, d
	or e
	jr z, .load_sprites
	ld a, [wc7d2]
	ld c, a
.loop1
	ld a, e
	sub c
	ld e, a
	ld a, d
	sbc $0
	ld d, a
	jr c, .load_sprites
	inc b
	jr .loop1

.skip
	ld b, 14 * TILE_WIDTH

.load_sprites
	ld a, 2 * TILE_WIDTH + 5
	add b
	pop hl
	ld [hli], a
	cp $41
	jr c, .version1
	ld a, [wJumptableIndex]
	cp 4
	jr z, .version2
	cp 5
	jr z, .version2
	cp 7
	jr z, .version2
	cp 8
	jr z, .version2

.version1
	ld a, 19 * TILE_WIDTH + 3
	ld [hli], a
	ld a, [wcd4c]
	add $3c
	ld [hli], a
	ld a, [wcd4c]
	add $1
	ld [hl], a
	ret

.version2
	ld a, 19 * TILE_WIDTH + 3
	ld [hli], a
	ld a, $39
	ld [hli], a
	xor a
	ld [hl], a
	ret

INCLUDE "mobile/trade_corner.asm"

TilemapPack_11ba44:
	db $47, $30, $0a, $0a, $0a, $0a, $0a, $56 ; 00
	db $46, $2f, $0a, $0a, $0a, $0a, $0a, $55 ; 01
	db $45, $3d, $0a, $0a, $0a, $0a, $0a, $54 ; 02
	db $44, $30, $0a, $0a, $0a, $0a, $0a, $53 ; 03
	db $43, $2f, $0a, $0a, $0a, $0a, $0a, $52 ; 04
	db $4a, $3d, $0a, $0a, $0a, $0a, $0a, $51 ; 05
	db $4a, $30, $0a, $0a, $0a, $0a, $0a, $50 ; 06
	db $4a, $2f, $0a, $0a, $0a, $0a, $0a, $4f ; 07
	db $4a, $3d, $0a, $0a, $0a, $0a, $0a, $4e ; 08
	db $4a, $30, $0a, $0a, $0a, $0a, $4d, $42 ; 09
	db $4a, $2f, $0a, $0a, $0a, $0a, $6b, $58 ; 0a
	db $4a, $3d, $0a, $0a, $0a, $0a, $6a, $58 ; 0b
	db $4a, $30, $0a, $0a, $0a, $0a, $69, $58 ; 0c
	db $4a, $2f, $0a, $0a, $0a, $0a, $68, $58 ; 0d
	db $4a, $3d, $0a, $0a, $0a, $66, $67, $58 ; 0e
	db $4a, $30, $0a, $0a, $0a, $65, $0a, $58 ; 0f
	db $4a, $2f, $0a, $0a, $0a, $64, $0a, $58 ; 10
	db $4a, $3d, $0a, $0a, $0a, $63, $0a, $58 ; 11
	db $4a, $30, $0a, $0a, $61, $62, $0a, $58 ; 12
	db $4a, $2f, $0a, $0a, $5f, $60, $0a, $58 ; 13
	db $4a, $3d, $0a, $61, $62, $0a, $0a, $58 ; 14
	db $4a, $30, $0a, $63, $0a, $0a, $0a, $58 ; 15
	db $4a, $2f, $69, $0a, $0a, $0a, $0a, $58 ; 16
	db $4a, $3d, $81, $0a, $0a, $0a, $0a, $58 ; 17
	db $4a, $30, $80, $0a, $0a, $0a, $0a, $58 ; 18
	db $4a, $2f, $7f, $0a, $0a, $0a, $0a, $58 ; 19
	db $4a, $3d, $0a, $0a, $0a, $0a, $0a, $58 ; 1a
	db $4a, $30, $0a, $0a, $0a, $0a, $0a, $58 ; 1b
	db $4a, $2f, $68, $87, $88, $89, $0a, $58 ; 1c
	db $4a, $3d, $6e, $6f, $70, $75, $76, $58 ; 1d
	db $4a, $30, $75, $76, $5c, $5d, $5e, $58 ; 1e
	db $4a, $2f, $71, $72, $73, $74, $6d, $58 ; 1f
	db $4a, $3d, $75, $76, $77, $8a, $8b, $58 ; 20
	db $4a, $30, $66, $67, $65, $0a, $6a, $58 ; 21
	db $4a, $2f, $83, $84, $0a, $83, $84, $58 ; 22
	db $4a, $3d, $0a, $85, $82, $84, $0a, $58 ; 23
	db $4a, $30, $41, $80, $40, $0a, $0a, $58 ; 24
	db $4a, $2f, $83, $0a, $0a, $0a, $0a, $58 ; 25
	db $4a, $3d, $40, $0a, $0a, $0a, $0a, $58 ; 26
	db -1

TilemapPack_11bb7d:
	db $0a, $0a, $0a, $0a, $0a, $0a, $16, $00 ; 00
	db $78, $0a, $0a, $0a, $0a, $0a, $8c, $00 ; 01
	db $79, $0a, $0a, $0a, $0a, $0a, $8d, $00 ; 02
	db $7a, $0a, $0a, $0a, $0a, $0a, $8e, $00 ; 03
	db $7b, $0a, $0a, $0a, $0a, $0a, $8c, $00 ; 04
	db $7c, $0a, $0a, $0a, $0a, $0a, $8d, $00 ; 05
	db $7d, $0a, $0a, $0a, $0a, $0a, $8e, $00 ; 06
	db $2e, $7e, $0a, $0a, $0a, $0a, $8c, $00 ; 07
	db $2e, $80, $0a, $0a, $0a, $0a, $8d, $00 ; 08
	db $2e, $81, $0a, $0a, $0a, $0a, $8e, $00 ; 09
	db $2e, $82, $0a, $0a, $0a, $0a, $8c, $00 ; 0a
	db $2e, $69, $0a, $0a, $0a, $0a, $8d, $00 ; 0b
	db $2e, $6a, $0a, $0a, $0a, $0a, $8e, $00 ; 0c
	db $2e, $6b, $0a, $0a, $0a, $0a, $8c, $00 ; 0d
	db $2e, $0a, $68, $0a, $0a, $0a, $8d, $00 ; 0e
	db $2e, $0a, $69, $0a, $0a, $0a, $8e, $00 ; 0f
	db $2e, $0a, $0a, $6a, $0a, $0a, $8c, $00 ; 10
	db $2e, $0a, $0a, $6b, $0a, $0a, $8d, $00 ; 11
	db $2e, $0a, $0a, $0a, $80, $0a, $8e, $00 ; 12
	db $2e, $0a, $0a, $0a, $82, $0a, $8c, $00 ; 13
	db $2e, $0a, $0a, $0a, $6c, $0a, $8d, $00 ; 14
	db $2e, $0a, $0a, $0a, $0a, $83, $8e, $00 ; 15
	db $2e, $0a, $6b, $0a, $0a, $0a, $8c, $00 ; 16
	db $2e, $0a, $0a, $69, $0a, $0a, $8d, $00 ; 17
	db $2e, $0a, $0a, $6a, $0a, $0a, $8e, $00 ; 18
	db $2e, $0a, $0a, $0a, $68, $0a, $8c, $00 ; 19
	db $2e, $0a, $0a, $0a, $63, $0a, $8d, $00 ; 1a
	db $2e, $0a, $0a, $61, $62, $0a, $8e, $00 ; 1b
	db $2e, $0a, $0a, $0a, $5f, $60, $8c, $00 ; 1c
	db $2e, $0a, $0a, $0a, $63, $0a, $8d, $00 ; 1d
	db $2e, $0a, $0a, $0a, $0a, $69, $8c, $00 ; 1e
	db $2e, $0a, $0a, $0a, $0a, $6b, $8d, $00 ; 1f
	db $2e, $0a, $0a, $0a, $0a, $83, $8e, $00 ; 20
	db $2e, $0a, $0a, $0a, $0a, $86, $8c, $00 ; 21
	db $2e, $0a, $85, $0a, $0a, $0a, $8d, $00 ; 22
	db $2e, $0a, $0a, $84, $0a, $0a, $8e, $00 ; 23
	db -1
