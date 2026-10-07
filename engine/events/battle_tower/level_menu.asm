BattleTowerRoomMenu_PickLevelMessage:
	ld a, [wcd38]
	and a
	jr nz, .honor_roll
	ld hl, Text_WhatLevelDoYouWantToChallenge
	jr .set_message

.honor_roll
	ld hl, Text_CheckBattleRoomListByMaxLevel

.set_message
	call Mobile_SetMessage
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_PlacePickLevelMenu:
	ld a, [wMobileMessageJumptableIndex]
	and a
	ret nz
	ld hl, BattleTowerPickLevelMenuHeader
	call LoadMenuHeader
	call MenuBox
	call MenuBoxCoord2Tile
	call ApplyTilemap
	hlcoord 16, 8, wAttrmap
	ld a, BG_YFLIP
	or [hl]
	ld [hl], a
	call WaitBGMap2
	ld a, $1
	ld [wBattleTowerLevelGroup], a
	ld a, $1
	ldh [rWBK], a
	ld a, [wStatusFlags]
	bit STATUSFLAGS_HALL_OF_FAME_F, a
	jr nz, .unlock_all_levels
; Before entering the Hall of Fame, offer levels 10-40 and CANCEL.
	ld hl, BattleTowerLevelMenuStringsBeforeHallOfFame
	ld a, BATTLETOWER_NUM_LEVELS_BEFORE_HOF + 1
	jr .store_menu_data

.unlock_all_levels
; After entering the Hall of Fame, offer levels 10-100 and CANCEL.
	ld hl, BattleTowerLevelMenuStrings
	ld a, BATTLETOWER_NUM_LEVELS + 1

.store_menu_data
	ld [wBattleTowerLevelMenuItemCount], a
	ld a, l
	ld [wBattleTowerLevelMenuStringsPointer], a
	ld a, h
	ld [wBattleTowerLevelMenuStringsPointer + 1], a
	ld a, $3
	ldh [rWBK], a
	call BattleTowerRoomMenu_IncrementJumptable

BattleTowerRoomMenu_UpdatePickLevelMenu:
	hlcoord 13, 8
	ld de, BattleTowerLevelMenuArrowString
	call PlaceString
	hlcoord 13, 10
	ld de, BattleTowerLevelMenuArrowString
	call PlaceString
	ld a, [wBattleTowerLevelMenuStringsPointer]
	ld l, a
	ld a, [wBattleTowerLevelMenuStringsPointer + 1]
	ld h, a
	ld d, $0
	ld a, [wBattleTowerLevelGroup]
	dec a
	assert BATTLETOWER_LEVEL_MENU_ENTRY_LENGTH == 1 << 3
	rlca
	rlca
	rlca
	ld e, a
	add hl, de
	ld a, l
	ld e, a
	ld a, h
	ld d, a
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	ld bc, wStringBuffer3
.copy_level
	ld a, [hli]
	cp "@"
	jr z, .end_level
	cp " "
	jr z, .space
	ld [bc], a
	inc bc
	jr .copy_level

.space
	ld a, "@"

.end_level
	ld [bc], a
	pop af
	ldh [rWBK], a
	hlcoord 13, 9
	call PlaceString
	ld hl, hJoyPressed
	ld a, [hl]
	and PAD_B
	jr nz, .b_button
	ld a, [hl]
	and PAD_A
	jr nz, .a_button
	ld a, [hl]
	and PAD_DOWN
	jr nz, .d_down
	ld a, [hl]
	and PAD_UP
	jr nz, .d_up
.done
	ret

.d_down
	ld hl, wBattleTowerLevelGroup
	dec [hl]
	jr nz, .done
	ld a, [wBattleTowerLevelMenuItemCount]
	ld [hl], a
	jr .done

.d_up
	ld a, [wBattleTowerLevelMenuItemCount]
	ld hl, wBattleTowerLevelGroup
	inc [hl]
	cp [hl]
	jr nc, .done
	ld a, $1
	ld [hl], a
	jr .done

.a_button
	call PlayClickSFX
	ld a, [wBattleTowerLevelGroup]
	ld hl, wBattleTowerLevelMenuItemCount
	cp [hl]
	jr z, .cancel
	dec a
	and $fe
	srl a
	ld [wcf65], a
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	call CloseWindow
	pop af
	ldh [rWBK], a
	ld a, [wcd38]
	and a
	jr nz, .store_level
	call BattleTower_LevelCheck
	ret c
	call BattleTower_UbersCheck
	ret c

.store_level
	ld a, [wBattleTowerLevelGroup]
	ld [w3_d800], a
	jp BattleTowerRoomMenu_IncrementJumptable

.b_button
	call PlayClickSFX

.cancel
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	call CloseWindow
	pop af
	ldh [rWBK], a
	ld a, $7
	ld [wBattleTowerRoomMenuJumptableIndex], a
	ld a, $0
	ld [wMobileDialogResumeState], a
	ret
