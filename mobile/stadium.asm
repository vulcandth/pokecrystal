MobileStadium:
	ldh a, [hInMenu]
	push af
	ld a, $1
	ldh [hInMenu], a
	call MobileStadium_Run
	pop af
	ldh [hInMenu], a
	ret

MobileStadium_Run:
	call MobileStadium_Init
	call MobileStadium_Loop
	ret

MobileStadium_Init:
	xor a
	ld [wJumptableIndex], a
	ld [wMobileStadiumMenuSelection], a
	ld [wcf65], a
	ld [wcf66], a
	call ClearBGPalettes
	call ClearSprites
	farcall MobileStadium_LoadScreen
	farcall HDMATransferAttrmapAndTilemapToWRAMBank3
	ret

MobileStadium_Redraw:
	call ClearBGPalettes
	call ClearSprites
	farcall MobileStadium_LoadScreen
	farcall MobileStadium_ApplyPalettes
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ret

MobileStadium_Loop:
	call JoyTextDelay
	ld a, [wJumptableIndex]
	bit JUMPTABLE_EXIT_F, a
	jr nz, .done
	call MobileStadium_RunState
	farcall HDMATransferAttrmapAndTilemapToWRAMBank3
	jr MobileStadium_Loop

.done
	call ClearBGPalettes
	call ClearSprites
	ret

MobileStadium_RunState:
	jumptable MobileStadiumStatePointers, wJumptableIndex

MobileStadiumStatePointers:
	table_width 2
	dw MobileStadium_LoadPalettes
	dw MobileStadium_WaitOpenMessage
	dw MobileStadium_EntryMessage
	dw MobileStadium_ConfirmMenu
	dw MobileStadium_ConfirmJoypad
	dw MobileStadium_DownloadAndSave
	dw MobileStadium_Success
	assert_table_length NUM_MOBILE_STADIUM_STATES

MobileStadium_LoadPalettes:
	farcall MobileStadium_ApplyPalettes
	ld a, MOBILE_STADIUM_OPEN_DELAY
	ld [wMobileStadiumMenuDelay], a
	jp MobileStadium_IncrementJumptable

MobileStadium_WaitOpenMessage:
	ld hl, wMobileStadiumMenuDelay
	dec [hl]
	ret nz
	ld hl, MobileStadiumMessageMenuHeader
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	jp MobileStadium_IncrementJumptable

MobileStadium_EntryMessage:
	ld hl, MobileStadiumEntryText
	call PrintText
	jp MobileStadium_IncrementJumptable

MobileStadium_ConfirmMenu:
	ld hl, MobileStadiumConfirmMenuHeader
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	hlcoord 16, 8
	ld de, MobileStadiumYesNoString
	call PlaceString
	hlcoord 15, 8
	ld a, '▶'
	ld [hl], a
	jp MobileStadium_IncrementJumptable

MobileStadium_ConfirmJoypad:
	ldh a, [hJoyPressed]
	cp PAD_B
	jr z, .b_button
	cp PAD_A
	jr z, .a_button
	cp PAD_DOWN
	jr z, .d_down
	cp PAD_UP
	ret nz
	ld a, [wMobileStadiumMenuSelection]
	and a
	ret z
	dec a
	ld [wMobileStadiumMenuSelection], a
	hlcoord 15, 8
	ld a, '▶'
	ld [hl], a
	hlcoord 15, 10
	ld a, ' '
	ld [hl], a
	ret

.d_down
	ld a, [wMobileStadiumMenuSelection]
	and a
	ret nz
	inc a
	ld [wMobileStadiumMenuSelection], a
	hlcoord 15, 8
	ld a, ' '
	ld [hl], a
	hlcoord 15, 10
	ld a, '▶'
	ld [hl], a
	ret

.a_button
	call PlayClickSFX
	ld a, [wMobileStadiumMenuSelection]
	and a
	jr nz, .b_button
	call ExitMenu
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	jp MobileStadium_IncrementJumptable

.b_button
	call ExitMenu
	call ExitMenu
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, JUMPTABLE_EXIT
	ld [wJumptableIndex], a
	ret

MobileStadium_DownloadAndSave:
	call MobileStadium_ReadPreviousData
	ld a, $1
	ldh [hBGMapMode], a
	farcall Mobile_DownloadStadiumData
	call ClearSprites
	ld a, [wMobileErrorCodeBuffer]
	and a
	jr z, .validate_download
	cp MOBILE_RESULT_CANCELED
	jr z, .exit
.error
	ld a, MOBILE_ERROR_INIT_NO_FADE
	ld [wMobileErrorJumptableIndex], a
	farcall DisplayMobileError
	ld a, JUMPTABLE_EXIT
	ld [wJumptableIndex], a
	ret

.exit
	ld a, JUMPTABLE_EXIT
	ld [wJumptableIndex], a
	ret

.validate_download
	ldh a, [rWBK]
	push af
	ld a, BANK(wMobileReceiveBuffer)
	ldh [rWBK], a
	ld a, [wMobileDownloadFlags]
	and MOBILE_DOWNLOAD_OVERFLOW
	jr nz, .invalid_download
	ld a, [wMobileReceiveBufferLength]
	cp LOW(MOBILE_STADIUM_DOWNLOAD_LENGTH)
	jr nz, .invalid_download
	ld a, [wMobileReceiveBufferLength + 1]
	cp HIGH(MOBILE_STADIUM_DOWNLOAD_LENGTH)
	jr nz, .invalid_download
	ld hl, wMobileReceiveBufferData + MOBILE_STADIUM_ID_OFFSET
	ld de, wMobileStadiumDataID
	ld c, MOBILE_STADIUM_ID_LENGTH
.compare_id
	ld a, [de]
	inc de
	cp [hl]
	jr nz, .invalid_download
	inc hl
	dec c
	jr nz, .compare_id
	jr .save_data

.invalid_download
	pop af
	ldh [rWBK], a
	ld a, MOBILE_ERROR_INVALID_DOWNLOAD
	ld [wMobileErrorCodeBuffer], a
	jr .error

.save_data
	pop af
	ldh [rWBK], a
	farcall MobileStadium_ApplyPalettes
	ldh a, [rWBK]
	push af
	ld a, BANK(wMobileReceiveBuffer)
	ldh [rWBK], a
	ld a, BANK(sMobileStadiumData)
	call OpenSRAM
	ld hl, wMobileReceiveBufferData
	ld de, sMobileStadiumData
	ld bc, MOBILE_STADIUM_DATA_SIZE
	call CopyBytes
	call CloseSRAM
	pop af
	ldh [rWBK], a
	jp MobileStadium_IncrementJumptable

MobileStadium_Success:
	ld hl, MobileStadiumMessageMenuHeader
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld hl, MobileStadiumSuccessText
	call PrintText
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, wBGPals1
	ld de, 1 palettes
	ld c, 8
.loop
	push hl
	ld a, LOW(PALRGB_WHITE)
	ld [hli], a
	ld a, HIGH(PALRGB_WHITE)
	ld [hl], a
	pop hl
	add hl, de
	dec c
	jr nz, .loop
	call RotateThreePalettesRight
	pop af
	ldh [rWBK], a
	ld a, JUMPTABLE_EXIT
	ld [wJumptableIndex], a
	ret

MobileStadium_ReadPreviousData:
	ld a, BANK(sMobileStadiumData)
	call OpenSRAM
	ld l, $0
	ld h, l
	ld de, sMobileStadiumData
	ld bc, MOBILE_STADIUM_CHECKSUM_LENGTH
.checksum
	push bc
	ld a, [de]
	inc de
	ld c, a
	ld b, 0
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or c
	jr nz, .checksum
	ld a, l
	ld [wMobileStadiumChecksum], a
	ld a, h
	ld [wMobileStadiumChecksum + 1], a
	ld hl, sMobileStadiumDataID
	ld de, wMobileStadiumDataID
	ld bc, MOBILE_STADIUM_ID_LENGTH
	call CopyBytes
	call CloseSRAM
	ret

INCLUDE "data/mobile/stadium_menu.asm"

MobileStadium_IncrementJumptable:
	ld hl, wJumptableIndex
	inc [hl]
	ret
