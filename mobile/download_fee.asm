pushc ascii

Mobile_ParseDownloadFee:
; hl points to a null-terminated URL. Read the numeric filename prefix
; before the dot, converting its ASCII digits to the game font.
	ld a, [hli]
	and a
	jr nz, Mobile_ParseDownloadFee
	dec hl

Mobile_ParseDownloadFeeFromEnd:
	ld a, [hld]
	cp "/"
	jr nz, Mobile_ParseDownloadFeeFromEnd
	inc hl
	inc hl
	ld de, wMobileDownloadFeeString
	ld c, MOBILE_DOWNLOAD_FEE_LENGTH + 1
.read_digit
	ld a, [hli]
	cp "."
	jr z, .terminate
	cp "0"
	jr c, .not_digit
	cp "9" + 1
	jr nc, .not_digit
	sub "0"

popc

	add "０"
	ld [de], a
	inc de
	dec c
	jr nz, .read_digit
; Four digits produce an empty string, rejected by the fee dialog.
	ld de, wMobileDownloadFeeString
.terminate
	ld a, "@"
	ld [de], a
	ret
.not_digit
	ld a, MOBILE_DOWNLOAD_FEE_NONDIGIT
	ld [de], a
	inc de
	jr .terminate
