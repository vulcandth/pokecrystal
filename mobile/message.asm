Mobile_WriteMessage:
; Advance the text-script expansion or typewriter effect by one frame.
	jumptable .Jumptable, wMobileMessageJumptableIndex

.Jumptable:
	table_width 2
	dw MobileMessage_Idle
	dw MobileMessage_ExpandText
	dw MobileMessage_PlaceNextCharacter
	assert_table_length NUM_MOBILE_MESSAGE_STATES

MobileMessage_ExpandText:
; Expand TX_RAM strings and strip TX_START/"@" until "<DONE>".
; Other bytes, including PlaceString control characters, pass through.
	ld a, $1
	ldh [rWBK], a
	call SpeechTextbox
	ld a, "@"
	ld hl, wMobileMessageBuffer
	ld bc, MOBILE_MESSAGE_BUFFER_LENGTH
	call ByteFill
	ld a, [wMobileMessageSource]
	ld l, a
	ld a, [wMobileMessageSource + 1]
	ld h, a
	ld de, wMobileMessageBuffer
.read_script
	ld a, [hli]
	cp "<DONE>"
	jr z, .start_printing
	cp TX_START
	jr z, .read_script
	cp "@"
	jr z, .read_script
	cp TX_RAM
	jr z, .text_ram
	ld [de], a
	inc de
	jr .read_script

.text_ram
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.copy_ram
	ld a, [bc]
	inc bc
	cp "@"
	jr z, .read_script
	ld [de], a
	inc de
	jr .copy_ram

.start_printing
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
	ld hl, wMobileMessageJumptableIndex
	inc [hl]
	ld a, $3
	ldh [rWBK], a

MobileMessage_Idle:
	ret

MobileMessage_PlaceNextCharacter:
; Holding any button bypasses the inter-character delay.
	ld hl, wMobileMessageDelay
	ldh a, [hJoyDown]
	and a
	jr nz, .place_character
	ld a, [hl]
	and a
	jr z, .place_character
	dec [hl]
	ret

.place_character
	ld a, [wOptions]
	and TEXT_DELAY_MASK
	ld [hl], a
	ld hl, wMobileMessageCharBuffer
	ld a, [wMobileMessageSource]
	ld e, a
	ld a, [wMobileMessageSource + 1]
	ld d, a
	ld a, [de]
	inc de
	ld [hli], a
	ld a, e
	ld [wMobileMessageSource], a
	ld a, d
	ld [wMobileMessageSource + 1], a
	ld a, "@"
	ld [hl], a
	ld a, [wMobileMessageDest]
	ld l, a
	ld a, [wMobileMessageDest + 1]
	ld h, a
	ld de, wMobileMessageCharBuffer
	call PlaceString
	ld a, c
	ld [wMobileMessageDest], a
	ld a, b
	ld [wMobileMessageDest + 1], a
	ld a, [wMobileMessageCharBuffer]
	cp "@"
	jr nz, .done
	xor a
	ld [wMobileMessageJumptableIndex], a

.done
	ret

Mobile_SetMessage:
; hl points to a text script in this ROM bank.
	ld a, l
	ld [wMobileMessageSource], a
	ld a, h
	ld [wMobileMessageSource + 1], a
	ld a, MOBILE_MESSAGE_EXPAND_TEXT
	ld [wMobileMessageJumptableIndex], a
	ret
