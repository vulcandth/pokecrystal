TradeCornerHoldMon:
; special
	call MobileTrade_InitMenu
	call TradeCornerHoldMon_RunJumptable
	ret

MobileTrade_InitMenu:
	xor a
	ld [wJumptableIndex], a
	ld [wcf64], a
	ld [wcf65], a
	ld [wcf66], a
	call UpdateTime
	ret

TradeCornerHoldMon_RunJumptable:
.loop
	call .run_state
	call DelayFrame
	ld a, [wJumptableIndex]
	cp MOBILE_TRADE_DEPOSIT_DONE
	jr nz, .loop
	ret

.run_state:
	jumptable .Jumptable, wJumptableIndex

.Jumptable:
	table_width 2
	dw TradeCornerHoldMon_PrepareForUpload
	dw TradeCornerHoldMon_UploadOffer
	dw TradeCornerHoldMon_RemoveFromParty
	dw TradeCornerHoldMon_Success
	dw TradeCornerHoldMon_Noop ; unused
	assert_table_length NUM_MOBILE_TRADE_DEPOSIT_STATES

TradeCornerHoldMon_PrepareForUpload:
	call .init_request
	ld hl, wPlayerName
	ld a, NAME_LENGTH_JAPANESE - 1
.get_char
	push af
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	and a
	jr nz, .get_char

	ld de, PARTYMON_STRUCT_LENGTH
	ld hl, wPartyMon1Species
	ld a, [wMobileTradePartySelection]
	dec a
	push af

.get_next_party_mon
	and a
	jr z, .got_selected_mon
	add hl, de
	dec a
	jr .get_next_party_mon

.got_selected_mon
	push bc
	ld a, PARTYMON_STRUCT_LENGTH
.copy_mon_byte
	; Copy the selected party struct to bc.
	push af
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	and a
	jr nz, .copy_mon_byte

	pop de
	push bc
	ld a, [de]
	ld [wCurSpecies], a
	call GetBaseData
	ld hl, MON_LEVEL
	add hl, de
	ld a, [hl]
	ld [wCurPartyLevel], a
	ld hl, MON_MAXHP
	add hl, de
	push hl
	ld hl, MON_STAT_EXP - 1
	add hl, de
	pop de
	push de
	ld b, TRUE
	predef CalcMonStats
	pop de
	ld h, d
	ld l, e
	dec hl
	dec hl
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	pop bc
	ld de, NAME_LENGTH
	ld hl, wPartyMonOTs
	pop af
	push af
.find_ot
	and a
	jr z, .got_ot
	add hl, de
	dec a
	jr .find_ot

.got_ot
	ld a, NAME_LENGTH - 1
.copy_ot
	push af
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	and a
	jr nz, .copy_ot
	ld de, NAME_LENGTH
	ld hl, wPartyMonNicknames
	pop af
	push af
.find_nickname
	and a
	jr z, .got_nickname
	add hl, de
	dec a
	jr .find_nickname

.got_nickname
	ld a, NAME_LENGTH - 1
.copy_nickname
	push af
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	and a
	jr nz, .copy_nickname
	ld de, MAIL_STRUCT_LENGTH
	ld hl, sPartyMail
	pop af
.find_mail
	and a
	jr z, .got_mail
	add hl, de
	dec a
	jr .find_mail

.got_mail
	ld a, BANK(sPartyMail)
	call OpenSRAM
	ld a, MAIL_STRUCT_LENGTH
.copy_mail
	push af
	ld a, [hli]
	ld [bc], a
	inc bc
	pop af
	dec a
	and a
	jr nz, .copy_mail
	call CloseSRAM
	jp MobileIncJumptableIndex

.init_request:
	ld bc, wOfferTrainerID
	ld a, [wPlayerID]
	ld [wMobileTradeTrainerID], a
	ld [bc], a
	inc bc

	ld a, [wPlayerID + 1]
	ld [wMobileTradeTrainerID + 1], a
	ld [bc], a
	inc bc

	ld a, [wSecretID]
	ld [wMobileTradeSecretID], a
	ld [bc], a
	inc bc

	ld a, [wSecretID + 1]
	ld [wMobileTradeSecretID + 1], a
	ld [bc], a
	inc bc

	ld a, [wMobileTradeOfferGender]
	ld [bc], a
	inc bc

	ld a, [wMobileTradeOfferSpecies]
	ld [bc], a
	inc bc

	ld a, [wMobileTradeRequestedGender]
	ld [bc], a
	inc bc

	ld a, [wd265]
	ld [bc], a
	inc bc
	ret

TradeCornerHoldMon_UploadOffer:
	call MobileTrade_SendOffer
	ld a, [wScriptVar]
	and a
	jr nz, .exit
	call .save_offer
	jp MobileIncJumptableIndex

.exit
	ld a, MOBILE_TRADE_DEPOSIT_DONE
	ld [wJumptableIndex], a
	ret

.save_offer:
	ld a, BANK(wMobileTradeRequestBackup)
	ldh [rWBK], a

	ld hl, wMobileTradeRequestBackup
	ld de, wMobileTradeRequest
	ld bc, TRADE_CORNER_REQUEST_LENGTH
	call CopyBytes

	ld a, $1
	ldh [rWBK], a
	ld a, BANK(sMobileTradeState)
	call OpenSRAM

	ld de, sMobileTradeState
	ld a, MOBILE_TRADE_OFFERED
	ld [de], a
	inc de
	ld hl, wMobileTradeRequest
	ld bc, TRADE_CORNER_REQUEST_LENGTH
	call CopyBytes

	push de
	pop hl

	ldh a, [hRTCMinutes]
	ld [hli], a
	ldh a, [hRTCHours]
	ld [hli], a
	ldh a, [hRTCDayLo]
	ld [hli], a
	ldh a, [hRTCDayHi]
	ld [hl], a

	call CloseSRAM
	ret

TradeCornerHoldMon_RemoveFromParty:
	ld a, [wMobileTradePartySelection]
	dec a
	ld [wCurPartyMon], a
	; REMOVE_PARTY
	xor a
	ld [wPokemonWithdrawDepositParameter], a
	farcall RemoveMonFromPartyOrBox
	farcall MobileTrade_StartExpirationTimer
	farcall SaveAfterLinkTrade
	jp MobileIncJumptableIndex

TradeCornerHoldMon_Success:
	xor a
	ld [wScriptVar], a
	jp MobileIncJumptableIndex

TradeCornerHoldMon_Noop:
	ret

MobileTrade_CheckForTrade:
; Save the current save-file time and request identity before checking mail.
	ld a, 0
	call OpenSRAM
	ld hl, wRTC
	ld de, wMobileTradeSaveTimeBuffer
	ld bc, MOBILE_TRADE_TIMESTAMP_LENGTH
	call CopyBytes
	call CloseSRAM
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	ld hl, wMobileTradeSaveTimeBuffer
	ld de, sMobileTradeSaveTime
	ld bc, MOBILE_TRADE_TIMESTAMP_LENGTH
	call CopyBytes
	ld a, MOBILE_TRADE_CHECKING
	ld [sMobileTradeState], a
	ld a, [sOfferTrainerID]
	ld [wMobileTradeTrainerID], a
	ld a, [sOfferTrainerID + 1]
	ld [wMobileTradeTrainerID + 1], a
	ld a, [sOfferSecretID]
	ld [wMobileTradeSecretID], a
	ld a, [sOfferSecretID + 1]
	ld [wMobileTradeSecretID + 1], a
	ld a, [sOfferGender]
	ld [wMobileTradeOfferGender], a
	ld a, [sOfferSpecies]
	ld [wMobileTradeOfferSpecies], a
	ld a, [sOfferReqGender]
	ld [wMobileTradeRequestedGender], a
	ld a, [sOfferReqSpecies]
	ld [wMobileTradeRequestedSpecies], a
	call CloseSRAM
	call MobileTrade_InitMenu
	call .loop
	ret

.loop
	call .run_state
	call DelayFrame
	ld a, [wJumptableIndex]
	cp MOBILE_TRADE_CHECK_DONE
	jr nz, .loop
	ret

.run_state:
	jumptable .Jumptable, wJumptableIndex

.Jumptable:
	table_width 2
	dw MobileTrade_CheckMail
	dw MobileTrade_CheckMailNoop
	assert_table_length NUM_MOBILE_TRADE_CHECK_STATES

MobileTrade_CheckMail:
	call MobileTrade_ReceiveReply
	ld a, [wScriptVar]
	and a
	jr nz, .done
	ldh a, [rWBK]
	push af
	ld a, BANK(wMobileTradeMailResult)
	ldh [rWBK], a
	ld a, [wMobileTradeMailResult]
	ld b, a
	pop af
	ldh [rWBK], a
	ld a, b
	and a
	jr z, .check_expiration
	cp MOBILE_TRADE_MAIL_MATCHED
	jr nz, .done
	call MobileTrade_AddReceivedMon
	jr .done

.check_expiration
	farcall MobileTrade_CheckExpirationTimer
	ld a, [wScriptVar]
	and a
	jr z, .done
	xor a
	ld [wScriptVar], a
	ldh a, [rWBK]
	push af
	ld a, BANK(wMobileTradeMailResult)
	ldh [rWBK], a
	ld a, MOBILE_TRADE_MAIL_EXPIRED
	ld [wMobileTradeMailResult], a
	pop af
	ldh [rWBK], a

.done
	jp MobileIncJumptableIndex

MobileTrade_CheckMailNoop:
	ret

MobileTrade_AddReceivedMon:
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	ld a, [wMobileTradeRequestedGender]
	ld [wMobileTradeReceivedGender], a
	ld a, [wMobileTradeRequestedSpecies]
	ld [wMobileTradeReceivedSpecies], a

	ld a, LOW(wMobileTradeReceivedGender)
	ld [wMobileMonSpeciesPointer], a
	ld a, HIGH(wMobileTradeReceivedGender)
	ld [wMobileMonSpeciesPointer + 1], a

	ld a, LOW(wMobileMon)
	ld [wMobileMonStructPointer], a
	ld a, HIGH(wMobileMon)
	ld [wMobileMonStructPointer + 1], a

	ld a, LOW(wMobileMonOT)
	ld [wMobileMonOTPointer], a
	ld a, HIGH(wMobileMonOT)
	ld [wMobileMonOTPointer + 1], a

	ld a, LOW(wMobileMonNick)
	ld [wMobileMonNicknamePointer], a
	ld a, HIGH(wMobileMonNick)
	ld [wMobileMonNicknamePointer + 1], a

	ld a, LOW(wMobileMonMail)
	ld [wMobileMonMailPointer], a
	ld a, HIGH(wMobileMonMail)
	ld [wMobileMonMailPointer + 1], a

	ld a, BASE_HAPPINESS
	ld [wMobileMonHappiness], a

	ld de, wMobileMonOT
	ld c, NAME_LENGTH_JAPANESE - 1
	farcall CheckStringForErrors
	jr nc, .length_check_ot
	farcall Mobile_CopyDefaultOTName

.length_check_ot
	ld de, wMobileMonOT
	lb bc, 1, NAME_LENGTH_JAPANESE - 1
	farcall CheckStringContainsLessThanBNextCharacters
	jr nc, .error_check_nick
	farcall Mobile_CopyDefaultOTName

.error_check_nick
	ld de, wMobileMonNick
	ld c, NAME_LENGTH_JAPANESE - 1
	farcall CheckStringForErrors
	jr nc, .length_check_nick
	farcall Mobile_CopyDefaultNickname

.length_check_nick
	ld de, wMobileMonNick
	lb bc, 1, NAME_LENGTH_JAPANESE - 1
	farcall CheckStringContainsLessThanBNextCharacters
	jr nc, .error_check_mail
	farcall Mobile_CopyDefaultNickname

.error_check_mail
	ld de, wMobileMonMail
	ld c, MAIL_MSG_LENGTH + 1
	farcall CheckStringForErrors
	jr nc, .length_check_mail
	farcall Mobile_CopyDefaultMail

.length_check_mail
	ld de, wMobileMonMail
	lb bc, 2, MAIL_MSG_LENGTH + 1
	farcall CheckStringContainsLessThanBNextCharacters
	jr c, .fix_mail
	ld a, b
	cp $2
	jr nz, .mail_ok

.fix_mail
	farcall Mobile_CopyDefaultMail

.mail_ok
	ld de, wMobileMonMailAuthor
	ld c, NAME_LENGTH_JAPANESE - 1
	farcall CheckStringForErrors
	jr nc, .length_check_author
	farcall Mobile_CopyDefaultMailAuthor

.length_check_author
	ld de, wMobileMonMailAuthor
	lb bc, 1, NAME_LENGTH_JAPANESE - 1
	farcall CheckStringContainsLessThanBNextCharacters
	jr nc, .author_okay
	farcall Mobile_CopyDefaultMailAuthor

.author_okay
	ld a, [wMobileMonItem]
	cp -1
	jr nz, .item_okay
	xor a
	ld [wMobileMonItem], a

.item_okay
	ld a, [wMobileTradeRequestedSpecies]
	ld [wMobileMonSpecies], a
	ld [wCurSpecies], a
	call GetBaseData

	ld hl, wMobileMonLevel
	ld a, [hl]
	cp MIN_LEVEL
	ld a, MIN_LEVEL
	jr c, .replace_level
	ld a, [hl]
	cp MAX_LEVEL
	jr c, .done_level
	ld a, MAX_LEVEL
.replace_level
	ld [hl], a
.done_level
	ld [wCurPartyLevel], a

	ld hl, wMobileMonExp + 2
	ld de, wMobileMonMaxHP
	ld b, TRUE
	predef CalcMonStats
	ld de, wMobileMonMaxHP
	ld hl, wMobileMonHP
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	call AddMobileMonToParty
	ret

MobileTrade_CompleteReception:
	ld a, [wMobileMonSpecies]
	ld [wOTTrademonSpecies], a
	ld [wCurPartySpecies], a
	ld a, [wMobileAdapterColor]
	ld [wMobileTradeAdapterColor], a
	ld hl, wMobileMonOT
	ld de, wOTTrademonOTName
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ld a, '@'
	ld [de], a
	ld a, [wMobileMonID]
	ld [wOTTrademonID], a
	ld a, [wMobileMonID + 1]
	ld [wOTTrademonID + 1], a
	ld hl, wMobileMonDVs
	ld a, [hli]
	ld [wOTTrademonDVs], a
	ld a, [hl]
	ld [wOTTrademonDVs + 1], a
	ld bc, wMobileMon
	farcall GetCaughtGender
	ld a, c
	ld [wOTTrademonCaughtData], a
	call SpeechTextbox
	call FadeToMenu
	farcall MobileTradeAnimation_ReceiveGetmonFromGTS
	farcall Mobile_RegisterTradeMonInPokedex
	ld a, TRUE
	ld [wForceEvolution], a
	ld a, LINK_TRADECENTER
	ld [wLinkMode], a
	farcall EvolvePokemon
	xor a
	ld [wLinkMode], a
	farcall SaveAfterLinkTrade
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	ld a, MOBILE_TRADE_COMPLETE
	ld [sMobileTradeState], a
	call CloseSRAM
	ld a, [wMapGroup]
	ld b, a
	ld a, [wMapNumber]
	ld c, a
	call GetMapSceneID
	ld a, d
	or e
	jr z, .return_to_map
	ld a, $1
	ld [de], a

.return_to_map
	call CloseSubmenu
	call RestartMapMusic
	ret

MobileTrade_GetOfferStatus:
; Return the saved trade state in wScriptVar, or CHECKING while fewer than
; two hours have passed on the same raw RTC day as the offer.
	farcall BattleTower_CheckSaveFileExistsAndIsYours
	ld a, [wScriptVar]
	and a
	ret z
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	ld a, [sMobileTradeState]
	ld [wScriptVar], a
	ld a, [sMobileTradeOfferMinutes]
	ld [wMobileTradeOfferMinutes], a
	ld a, [sMobileTradeOfferHours]
	ld [wMobileTradeOfferHours], a
	ld a, [sMobileTradeOfferDayLo]
	ld [wMobileTradeOfferDayLo], a
	ld a, [sMobileTradeOfferDayHi]
	ld [wMobileTradeOfferDayHi], a
	call CloseSRAM
	ld a, [wScriptVar]
	and a
	ret z
	ld hl, wMobileTradeOfferDayHi
	ldh a, [hRTCDayHi]
	cp [hl]
	ret nz
	dec hl
	ldh a, [hRTCDayLo]
	cp [hl]
	ret nz
	ld hl, wMobileTradeOfferHours
	ldh a, [hRTCHours]
	cp [hl]
	jr nc, .same_hour_order
	ld a, MAX_HOUR
	sub [hl]
	ld hl, hRTCHours
	add [hl]
	ld [wMobileTradeCurrentHours], a
	ldh a, [hRTCMinutes]
	ld [wMobileTradeCurrentMinutes], a
	xor a
	ld [wMobileTradeOfferHours], a
	jr .check_elapsed_minutes

.same_hour_order
	ldh a, [hRTCMinutes]
	ld [wMobileTradeCurrentMinutes], a
	ldh a, [hRTCHours]
	ld [wMobileTradeCurrentHours], a

.check_elapsed_minutes
	xor a
	ld l, a
	ld h, a
	ld b, a
	ld d, a
	ld a, [wMobileTradeCurrentMinutes]
	ld e, a
	ld a, [wMobileTradeCurrentHours]
	ld c, 60
	call AddNTimes
	add hl, de
	push hl
	xor a
	ld l, a
	ld h, a
	ld b, a
	ld d, a
	ld a, [wMobileTradeOfferMinutes]
	ld e, a
	ld a, [wMobileTradeOfferHours]
	ld c, 60
	call AddNTimes
	add hl, de
	ld a, l
	cpl
	add $1
	ld e, a
	ld a, h
	cpl
	adc 0
	ld d, a
	pop hl
	add hl, de
	ld de, -MOBILE_TRADE_COOLDOWN_MINUTES
	add hl, de
	bit 7, h
	ret z
	ld a, MOBILE_TRADE_CHECKING
	ld [wScriptVar], a
	ret

MobileTrade_CancelOffer:
	call MobileTrade_InitMenu
	ld a, BANK(sOfferTrainerID)
	call OpenSRAM
	ld hl, sOfferTrainerID
	ld de, wOfferTrainerID
	ld bc, 8
	call CopyBytes
	call CloseSRAM
	call MobileTrade_SendCancellation
	ret

MobileTrade_RestoreOfferMon:
	ld a, BANK(sMobileTradeState)
	call OpenSRAM
	xor a
	ld [sMobileTradeState], a
	ld hl, sOfferGender
	ld de, wRetrievedOfferGender
	ld bc, TRADE_CORNER_REQUEST_LENGTH
	call CopyBytes
	call CloseSRAM

	ld a, LOW(wRetrievedOfferGender)
	ld [wMobileMonSpeciesPointer], a
	ld a, HIGH(wRetrievedOfferGender)
	ld [wMobileMonSpeciesPointer + 1], a

	ld a, LOW(wRetrievedOfferMon)
	ld [wMobileMonStructPointer], a
	ld a, HIGH(wRetrievedOfferMon)
	ld [wMobileMonStructPointer + 1], a

	ld a, LOW(wRetrievedOfferMonOT)
	ld [wMobileMonOTPointer], a
	ld a, HIGH(wRetrievedOfferMonOT)
	ld [wMobileMonOTPointer + 1], a

	ld a, LOW(wRetrievedOfferMonNick)
	ld [wMobileMonNicknamePointer], a
	ld a, HIGH(wRetrievedOfferMonNick)
	ld [wMobileMonNicknamePointer + 1], a

	ld a, LOW(wRetrievedOfferMonMail)
	ld [wMobileMonMailPointer], a
	ld a, HIGH(wRetrievedOfferMonMail)
	ld [wMobileMonMailPointer + 1], a
	call AddMobileMonToParty
	farcall SaveAfterLinkTrade
	ret

AddMobileMonToParty:
	ld hl, wPartyCount
	ld a, [hl]
	ld e, a
	inc [hl]

	ld a, [wMobileMonSpeciesPointer]
	ld l, a
	ld a, [wMobileMonSpeciesPointer + 1]
	ld h, a
	inc hl
	ld bc, wPartySpecies
	ld d, e
.find_species_slot
	inc bc
	dec d
	jr nz, .find_species_slot
	ld a, e
	ld [wCurPartyMon], a
	ld a, [hl]
	ld [bc], a
	inc bc
	ld a, -1
	ld [bc], a

	ld hl, wPartyMon1Species
	ld bc, PARTYMON_STRUCT_LENGTH
	ld a, e
	ld [wMobileMonIndex], a
.find_mon_slot
	add hl, bc
	dec a
	and a
	jr nz, .find_mon_slot
	ld e, l
	ld d, h
	ld a, [wMobileMonStructPointer]
	ld l, a
	ld a, [wMobileMonStructPointer + 1]
	ld h, a
	ld bc, PARTYMON_STRUCT_LENGTH
	call CopyBytes

	ld hl, wPartyMonOTs
	ld bc, NAME_LENGTH
	ld a, [wMobileMonIndex]
.find_ot_slot
	add hl, bc
	dec a
	and a
	jr nz, .find_ot_slot
	ld e, l
	ld d, h
	ld a, [wMobileMonOTPointer]
	ld l, a
	ld a, [wMobileMonOTPointer + 1]
	ld h, a
	ld bc, MON_NAME_LENGTH - 1
	call CopyBytes
	ld a, '@'
	ld [de], a

	ld hl, wPartyMonNicknames
	ld bc, MON_NAME_LENGTH
	ld a, [wMobileMonIndex]
.find_nickname_slot
	add hl, bc
	dec a
	and a
	jr nz, .find_nickname_slot
	ld e, l
	ld d, h
	ld a, [wMobileMonNicknamePointer]
	ld l, a
	ld a, [wMobileMonNicknamePointer + 1]
	ld h, a
	ld bc, MON_NAME_LENGTH - 1
	call CopyBytes
	ld a, '@'
	ld [de], a

	ld hl, sPartyMail
	ld bc, MAIL_STRUCT_LENGTH
	ld a, [wMobileMonIndex]
.find_mail_slot
	add hl, bc
	dec a
	and a
	jr nz, .find_mail_slot
	ld a, BANK(sPartyMail)
	call OpenSRAM
	ld e, l
	ld d, h
	ld a, [wMobileMonMailPointer]
	ld l, a
	ld a, [wMobileMonMailPointer + 1]
	ld h, a
	ld bc, MAIL_STRUCT_LENGTH
	call CopyBytes

	call CloseSRAM
	ret

MobileTrade_CheckPartyCanSpareMon:
; Clear wScriptVar if another party mon still has HP; otherwise return carry.
	farcall CheckCurPartyMonFainted
	ret c
	xor a
	ld [wScriptVar], a
	ret
