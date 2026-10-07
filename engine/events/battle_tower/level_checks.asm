BattleTower_LevelCheck:
	ldh a, [rWBK]
	push af
	ld a, BANK(wPartyMons)
	ldh [rWBK], a
	ld a, [wBattleTowerLevelGroup]
	ld c, BATTLETOWER_LEVEL_INTERVAL
	call SimpleMultiply
	ld hl, wBattleTowerLevelCap
	ld [hl], a
	ld bc, PARTYMON_STRUCT_LENGTH
	ld de, wPartyMon1Level
	ld a, [wPartyCount]
.party_loop
	push af
	ld a, [de]
	push hl
	push de
	pop hl
	add hl, bc
	push hl
	pop de
	pop hl
	cp [hl]
	jr z, .equal
	jr nc, .exceeds
.equal
	pop af
	dec a
	jr nz, .party_loop
	pop af
	ldh [rWBK], a
	and a
	ret

.exceeds
	pop af
	ld a, $4
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	ldh [rWBK], a
	scf
	ret

BattleTower_UbersCheck:
	ldh a, [rWBK]
	push af
	ld a, [wBattleTowerLevelGroup]
	cp BATTLETOWER_UBER_MIN_LEVEL / BATTLETOWER_LEVEL_INTERVAL
	jr nc, .level_70_or_more
	ld a, BANK(wPartyMons)
	ldh [rWBK], a
	ld hl, wPartyMon1Level
	ld bc, PARTYMON_STRUCT_LENGTH
	ld de, wPartySpecies
	ld a, [wPartyCount]
.loop
	push af
	ld a, [de]
	cp MEWTWO
	jr z, .uber
	cp MEW
	jr z, .uber
	cp LUGIA
	jr c, .next
	cp NUM_POKEMON + 1
	jr nc, .next
.uber
	ld a, [hl]
	cp BATTLETOWER_UBER_MIN_LEVEL
	jr c, .uber_under_70
.next
	add hl, bc
	inc de
	pop af
	dec a
	jr nz, .loop
.level_70_or_more
	pop af
	ldh [rWBK], a
	and a
	ret

.uber_under_70
	pop af
	ld a, [de]
	ld [wNamedObjectIndex], a
	call GetPokemonName
	ld hl, wStringBuffer1
	ld de, wcd49
	ld bc, MON_NAME_LENGTH
	call CopyBytes
	ld a, $a
	ld [wBattleTowerRoomMenuJumptableIndex], a
	pop af
	ldh [rWBK], a
	scf
	ret
