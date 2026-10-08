MobileTrade_GetMailResult:
	ldh a, [rWBK]
	push af
	ld a, BANK(wMobileTradeMailResult)
	ldh [rWBK], a
	ld a, [wMobileTradeMailResult]
	ld [wScriptVar], a
	pop af
	ldh [rWBK], a
	ret

MobileTrade_RecoverSavedTrade:
; Recover a saved Trade Corner transaction after loading the game.
; wScriptVar is TRUE when the completed trade should be acknowledged.
	xor a
	ld [wScriptVar], a
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	ld a, [sMobileTradeState]
	call CloseSRAM
	cp NUM_MOBILE_TRADE_STATES
	jr nc, .invalid
	ld e, a
	ld d, 0
	ld hl, .Jumptable
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

.invalid
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	xor a
	ld [sMobileTradeState], a
	call CloseSRAM
	ret

.Jumptable:
	table_width 2
	dw .no_action
	dw .no_action
	dw .reset_to_offered
	dw .reset_to_offered
	dw .complete_trade
	dw .check_completed_trade
	assert_table_length NUM_MOBILE_TRADE_STATES

.reset_to_offered:
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	ld a, MOBILE_TRADE_OFFERED
	ld [sMobileTradeState], a
	call CloseSRAM

.no_action:
	ret

.complete_trade:
	ld a, BANK(sMobileTradeReply)
	call OpenSRAM
	ld hl, sMobileTradeReply
	ld de, wMobileTradeReply
	ld bc, TRADE_CORNER_REPLY_LENGTH
	call CopyBytes
	ld a, [sOfferReqGender]
	ld [wMobileTradeRequestedGender], a
	ld a, [sOfferReqSpecies]
	ld [wMobileTradeRequestedSpecies], a
	call CloseSRAM
	farcall MobileTrade_AddReceivedMon
	farcall MobileTrade_ResumeReception
	ld a, TRUE
	ld [wScriptVar], a
	ret

.check_completed_trade:
	ld a, 0
	call OpenSRAM
	ld hl, wRTC
	ld de, wMobileTradeSaveTimeBuffer
	ld bc, MOBILE_TRADE_TIMESTAMP_LENGTH
	call CopyBytes
	call CloseSRAM
	ld a, BANK(sMobileTradeSaveTime)
	call OpenSRAM
	ld hl, sMobileTradeSaveTime
	ld de, wMobileTradeSaveTimeBuffer
	ld c, MOBILE_TRADE_TIMESTAMP_LENGTH
.compare_loop
	ld a, [de]
	inc de
	cp [hl]
	jr nz, .new_save
	inc hl
	dec c
	jr nz, .compare_loop
	call CloseSRAM
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetMapSceneID
	ld a, d
	or e
	jr z, .no_scene
	ld a, [de]
	and a
	ret nz

.no_scene
	ld a, TRUE
	ld [wScriptVar], a
	ret

.new_save
	call CloseSRAM
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	xor a
	ld [sMobileTradeState], a
	call CloseSRAM
	ld [wScriptVar], a
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetMapSceneID
	ld a, d
	or e
	jr z, .done
	xor a
	ld [de], a

.done
	ret
