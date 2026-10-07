Function170000:
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
	ld hl, wc608
	ld de, $d800
	ld bc, TRADE_CORNER_REQUEST_LENGTH
	call CopyBytes
	ret

Function17005a:
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

INCLUDE "engine/events/battle_tower/battle_tower.asm"

Function170be4:
	ld a, BANK(s5_a894)
	call OpenSRAM
	xor a
	ld hl, s5_a894
	ld bc, 6 + 2
	call ByteFill
	call CloseSRAM
	ret

Clears5_a89a:
	ld a, BANK(s5_a89a)
	call OpenSRAM
	ld hl, s5_a89a
	xor a
	ld [hli], a
	ld [hl], a
	call CloseSRAM
	ret

Function170c06: ; unreferenced
	ld a, BANK(s5_a894)
	call OpenSRAM
	ld hl, s5_a894
	ld a, [wBattleResult]
	and a ; WIN?
	jr nz, .asm_170c15
	inc [hl]

.asm_170c15
	inc hl
	inc hl
	ld a, [s5_a89a + 1]
	add [hl]
	ld [hld], a
	ld a, [s5_a89a]
	adc [hl]
	ld [hli], a
	jr nc, .asm_170c27
	ld a, $ff
	ld [hld], a
	ld [hli], a

.asm_170c27
	inc hl
	push hl
	ld de, 0
	xor a
	ld [wTempByteValue], a
.asm_170c30
	ld hl, wPartyMon1HP
	ld a, [wTempByteValue]
	call GetPartyLocation
	ld a, [hli]
	ld b, a
	ld c, [hl]
	inc hl
	inc hl
	ld a, [hld]
	sub c
	ld c, a
	ld a, [hl]
	sbc b
	ld b, a
	push de
	pop hl
	add hl, bc
	push hl
	pop de
	jr c, .asm_170c58
	ld a, [wTempByteValue]
	inc a
	ld [wTempByteValue], a
	cp $3
	jr c, .asm_170c30
	jr .asm_170c5b

.asm_170c58
	ld de, -1

.asm_170c5b
	pop hl
	inc hl
	ld a, e
	add [hl]
	ld [hld], a
	ld a, d
	adc [hl]
	ld [hli], a
	jr nc, .asm_170c69
	ld a, $ff
	ld [hld], a
	ld [hli], a

.asm_170c69
	inc hl
	push hl
	ld b, $0
	ld c, $0
.asm_170c6f
	ld hl, wPartyMon1HP
	ld a, b
	push bc
	call GetPartyLocation
	pop bc
	ld a, [hli]
	or [hl]
	jr nz, .asm_170c7d
	inc c

.asm_170c7d
	inc b
	ld a, b
	cp $3
	jr c, .asm_170c6f
	pop hl
	ld a, [hl]
	add c
	ld [hl], a
	call CloseSRAM
	ret

Function170c8b:
	ld hl, wLastEnemyCounterMove
	ld b, $5
.asm_170c90
	ld a, [hl]
	xor $ff
	ld [hli], a
	dec b
	jr nz, .asm_170c90
	ret

CheckBTMonMovesForErrors:
	ld c, BATTLETOWER_PARTY_LENGTH
	ld hl, wBT_OTTempMon1Moves
.loop
	push hl
	ld a, [hl]
	cp NUM_ATTACKS + 1
	jr c, .okay
	ld a, POUND
	ld [hl], a

.okay
	inc hl
	ld b, NUM_MOVES - 1
.loop2
	ld a, [hl]
	and a
	jr z, .loop3
	cp NUM_ATTACKS + 1
	jr c, .next

.loop3
	xor a
	ld [hl], a
	inc hl
	dec b
	jr nz, .loop3
	jr .done

.next
	inc hl
	dec b
	jr nz, .loop2

.done
	pop hl
	ld de, NICKNAMED_MON_STRUCT_LENGTH
	add hl, de
	dec c
	jr nz, .loop
	ret

Function170cc6:
	ldh a, [rWBK]
	push af
	ld a, BANK(wDecompressScratch)
	ldh [rWBK], a
	ld hl, PichuAnimatedMobileGFX
	ld de, wDecompressScratch
	call Decompress
	ld a, 1
	ldh [rVBK], a
	ld de, wDecompressScratch
	ld hl, vTiles3
	lb bc, BANK(wDecompressScratch), 193
	call Get2bpp
	xor a
	ldh [rVBK], a
	ld hl, ElectroBallMobileGFX
	ld de, wDecompressScratch
	call Decompress
	ld de, wBGPals1
	ld hl, vTiles0
	lb bc, BANK(wDecompressScratch), 83
	call Get2bpp
	pop af
	ldh [rWBK], a
	ret

Function170d02:
	ld a, $1
	ldh [rVBK], a
	ld de, PichuBorderMobileGFX
	ld hl, vTiles3 tile $c1
	lb bc, BANK(PichuBorderMobileGFX), 24
	call Get2bpp
	xor a
	ldh [rVBK], a
	ret

PichuAnimatedMobileGFX:
INCBIN "gfx/mobile/pichu_animated.2bpp.lz"

ElectroBallMobileGFX:
INCBIN "gfx/mobile/electro_ball.2bpp.lz"

PichuBorderMobileGFX:
INCBIN "gfx/mobile/pichu_border.2bpp"
