Mobile_InitConnection:
	di
	ldh a, [rIE]
	ld [wMobileSavedIE], a
	call DoubleSpeed
	xor a
	ldh [rIF], a
	ld [wMobileErrorCodeBuffer], a
	ld [wMobileErrorCodeBuffer + 1], a
	ld [wMobileErrorCodeBuffer + 2], a
	ld [wcd80], a
	ld [wMobileConnectionTimerActive], a
	ld [wMobileConnectionTimeFrames], a
	ld [wMobileConnectionTimeSeconds], a
	ld [wMobileConnectionTimeMinutes], a
	ld [wMobileMessageJumptableIndex], a
	ld [wMobileDownloadFlags], a
	ld [wMobileLegacyInactivityCounter], a
	ld [wMobileLegacyInactivityCounter + 1], a
	ld [wc3ec], a
	ld [wc3ed], a
	ld [wc3ee], a
	ld [wc3ef], a
	ld hl, wStateFlags
	ld a, [hl]
	ld [wMobileSavedStateFlags], a
	set LAST_12_SPRITE_OAM_STRUCTS_RESERVED_F, [hl]
	ld a, IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
	ldh [rIE], a
	ld a, $1
	ldh [hMobileReceive], a
	ldh [hMobile], a
	ei
	farcall Stubbed_Function106462
	farcall Function106464
	farcall MobilePhone_Init
	farcall MobilePichu_Init
	ld a, BANK(s5_bfff)
	call OpenSRAM
	xor a
	ld [s5_bfff], a
	call CloseSRAM
	ret

Function118440:
	push af
	ld a, BANK(s5_bfff)
	call OpenSRAM
	ld a, [s5_bfff]
	inc a
	ld [s5_bfff], a
	call CloseSRAM
	pop af
	ret

Mobile_CleanupConnection:
	di
	xor a
	ldh [hMobileReceive], a
	ldh [hMobile], a
	ldh [hVBlank], a
	call NormalSpeed
	xor a
	ldh [rIF], a
	ld a, [wMobileSavedIE]
	ldh [rIE], a
	ei
	ld a, [wMobileSavedStateFlags]
	ld [wStateFlags], a
	ld a, [wMobileErrorCodeBuffer]
	ld [wScriptVar], a
	ret

Mobile_UpdateConnectionTimer:
	ld a, [wMobileConnectionTimerActive]
	and a
	ret z
	ld a, [wMobileConnectionTimeFrames]
	inc a
	ld [wMobileConnectionTimeFrames], a
	cp 60
	ret nz
	xor a
	ld [wMobileConnectionTimeFrames], a
	ld a, [wMobileConnectionTimeSeconds]
	inc a
	ld [wMobileConnectionTimeSeconds], a
	cp 60
	ret nz
	ld a, [wMobileConnectionTimeMinutes]
	inc a
	ld [wMobileConnectionTimeMinutes], a
	cp 99
	jr z, .ninety_nine
	xor a
	ld [wMobileConnectionTimeSeconds], a
	ret

.ninety_nine
	xor a
	ld [wMobileConnectionTimerActive], a
	ret
