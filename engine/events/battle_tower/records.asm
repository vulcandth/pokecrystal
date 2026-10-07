BattleTower_ResetChallengeStats:
	ld a, BANK(sBattleTowerChallengeStats)
	call OpenSRAM
	xor a
	ld hl, sBattleTowerChallengeStats
	ld bc, BATTLETOWER_RECORD_STATS_LENGTH + 2
	call ByteFill
	call CloseSRAM
	ret

BattleTower_ResetBattleTurns:
	ld a, BANK(sBattleTowerBattleTurns)
	call OpenSRAM
	ld hl, sBattleTowerBattleTurns
	xor a
	ld [hli], a
	ld [hl], a
	call CloseSRAM
	ret

BattleTower_UpdateChallengeStats: ; unreferenced
; Accumulate wins, turns, HP lost and fainted party members.
; The two-byte totals saturate at $ffff.
	ld a, BANK(sBattleTowerChallengeStats)
	call OpenSRAM
	ld hl, sBattleTowerChallengeStats
	ld a, [wBattleResult]
	and a ; WIN?
	jr nz, .add_turns
	inc [hl]

.add_turns
	inc hl
	inc hl
	ld a, [sBattleTowerBattleTurns + 1]
	add [hl]
	ld [hld], a
	ld a, [sBattleTowerBattleTurns]
	adc [hl]
	ld [hli], a
	jr nc, .sum_hp_lost
	ld a, $ff
	ld [hld], a
	ld [hli], a

.sum_hp_lost
	inc hl
	push hl
	ld de, 0
	xor a
	ld [wTempByteValue], a
.party_hp
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
	jr c, .cap_hp_lost
	ld a, [wTempByteValue]
	inc a
	ld [wTempByteValue], a
	cp BATTLETOWER_PARTY_LENGTH
	jr c, .party_hp
	jr .add_hp_lost

.cap_hp_lost
	ld de, -1

.add_hp_lost
	pop hl
	inc hl
	ld a, e
	add [hl]
	ld [hld], a
	ld a, d
	adc [hl]
	ld [hli], a
	jr nc, .count_fainted
	ld a, $ff
	ld [hld], a
	ld [hli], a

.count_fainted
	inc hl
	push hl
	ld b, $0
	ld c, $0
.party_fainted
	ld hl, wPartyMon1HP
	ld a, b
	push bc
	call GetPartyLocation
	pop bc
	ld a, [hli]
	or [hl]
	jr nz, .next_mon
	inc c

.next_mon
	inc b
	ld a, b
	cp BATTLETOWER_PARTY_LENGTH
	jr c, .party_fainted
	pop hl
	ld a, [hl]
	add c
	ld [hl], a
	call CloseSRAM
	ret

BattleTower_InvertRecordStats:
; Complement the turn, HP-loss and faint counts; leave the win count intact.
	ld hl, wBattleTowerRecordTurns
	ld b, BATTLETOWER_RECORD_STATS_LENGTH - 1
.invert
	ld a, [hl]
	xor $ff
	ld [hli], a
	dec b
	jr nz, .invert
	ret

