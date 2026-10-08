MobileTrade_StartExpirationTimer:
; Start the offer expiration timer using the 140-day game clock.
	call UpdateTime
	ld a, BANK(sMobileTradeTimerDay)
	call OpenSRAM
	ld a, [wCurDay]
	ld [sMobileTradeTimerDay], a
	xor a
	ld [sMobileTradeTimerResetCount], a
	call CloseSRAM
	ret

MobileTrade_CheckExpirationTimer:
; Return TRUE in wScriptVar when the offer has expired, and clear the timer.
	xor a
	ld [wScriptVar], a
	ld a, BANK(sMobileTradeTimerDay)
	call OpenSRAM
	ld a, [sMobileTradeTimerDay]
	ld c, a
	ld a, [sMobileTradeTimerResetCount]
	ld b, a
	call CloseSRAM
	cp MOBILE_TRADE_MAX_CLOCK_RESETS
	jr nc, .expired
	push bc
	call UpdateTime
	pop bc
	ld a, [wCurDay]
	sub c
	jr c, .day_wrapped
	cp MOBILE_TRADE_EXPIRATION_DAYS
	jr nc, .expired
	ld a, b
	and a
	jr nz, .expired
	ret

.day_wrapped
	ld hl, wCurDay
	ld a, RTC_DAY_CYCLE
	sub c
	add [hl]
	cp MOBILE_TRADE_EXPIRATION_DAYS
	ret c
.expired
	ld a, TRUE
	ld [wScriptVar], a
	ld a, BANK(sMobileTradeTimerDay)
	call OpenSRAM
	xor a
	ld [sMobileTradeTimerDay], a
	ld [sMobileTradeTimerResetCount], a
	call CloseSRAM
	ret
