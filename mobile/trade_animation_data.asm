MobileTrade_LoadOfferForSending:
	ld a, [wOfferSpecies]
	ld [wPlayerTrademonSpecies], a
	ld hl, wOfferMonSender
	ld de, wPlayerTrademonSenderName
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ld a, '@'
	ld [de], a
	ld hl, wOfferMonOT
	ld de, wPlayerTrademonOTName
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ld a, '@'
	ld [de], a
	ld hl, wOfferMonDVs
	ld a, [hli]
	ld [wPlayerTrademonDVs], a
	ld a, [hl]
	ld [wPlayerTrademonDVs + 1], a
	ld hl, wOfferMonID
	ld a, [hli]
	ld [wPlayerTrademonID], a
	ld a, [hl]
	ld [wPlayerTrademonID + 1], a
	ld bc, wOfferMon
	farcall GetCaughtGender
	ld a, c
	ld [wPlayerTrademonCaughtData], a
	ld a, [wcd81]
	ld [wc74e], a
	ld hl, wMobileTradeRequest
	ld de, wMobileTradeRequestBackup
	ld bc, TRADE_CORNER_REQUEST_LENGTH
	call CopyBytes
	ret

MobileTrade_LoadOfferForRetrieval:
	ld a, BANK(sOfferMon)
	call OpenSRAM
	ld a, [sOfferSpecies]
	ld [wOTTrademonSpecies], a
	ld hl, sOfferMonSender
	ld de, wOTTrademonSenderName
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ld a, '@'
	ld [de], a
	ld hl, sOfferMonOT
	ld de, wOTTrademonOTName
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ld a, '@'
	ld [de], a
	ld hl, sOfferMonDVs
	ld a, [hli]
	ld [wOTTrademonDVs], a
	ld a, [hl]
	ld [wOTTrademonDVs + 1], a
	ld hl, sOfferMonID
	ld a, [hli]
	ld [wOTTrademonID], a
	ld a, [hl]
	ld [wOTTrademonID + 1], a
	ld bc, sOfferMon
	farcall GetCaughtGender
	ld a, c
	ld [wOTTrademonCaughtData], a
	ld a, [wcd81]
	ld [wc74e], a
	call CloseSRAM
	ret
