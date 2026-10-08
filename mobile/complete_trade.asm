MobileTrade_ResumeReception:
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
	ld bc, wMobileMonSpecies
	farcall GetCaughtGender
	ld a, c
	ld [wOTTrademonCaughtData], a
	call SpeechTextbox
	call FadeToMenu
	farcall MobileTradeAnimation_ResumeReceiveGetmonFromGTS
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

Mobile_CopyDefaultOTName:
	ld hl, MobileDefaultOTName
	ld de, wMobileMonOT
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ret

MobileDefaultOTName:
	dname "クりス", NAME_LENGTH_JAPANESE - 1

Mobile_CopyDefaultNickname:
	ld hl, .DefaultNickname
	ld de, wMobileMonNick
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ret

.DefaultNickname:
	dname "？？？？？", NAME_LENGTH_JAPANESE - 1

Mobile_CopyDefaultMail:
	ld a, '@'
	ld hl, wMobileMonMail
	ld bc, MAIL_MSG_LENGTH + 1
	call ByteFill
	ld hl, .DefaultMessage
	ld de, wMobileMonMail
	ld bc, .DefaultMessageEnd - .DefaultMessage
	call CopyBytes
	ret

.DefaultMessage:
	db "こんにちは@"
.DefaultMessageEnd:

Mobile_CopyDefaultMailAuthor:
	ld a, '@'
	ld de, wMobileMonMailAuthor
	ld bc, NAME_LENGTH_JAPANESE - 1
	call ByteFill
	ld hl, MobileDefaultOTName
	ld de, wMobileMonMailAuthor
	ld bc, NAME_LENGTH_JAPANESE - 1
	call CopyBytes
	ret
