MobilePichu_AdvanceBallFrame:
	ld hl, wMobilePichuBallFrameDuration
	dec [hl]
	ret nz
	ld hl, wMobilePichuBallAnimationStep
	inc [hl]
.load_frame
	ld a, MOBILE_PICHU_ANIM_BALL
	sla a
	ld c, a
	ld b, 0
	ld hl, MobilePichuAnimations
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push de
	pop hl
	ld a, [wMobilePichuBallAnimationStep]
	sla a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	cp MOBILE_PICHU_ANIM_LOOP
	jr nz, .set_frame
	xor a
	ld [wMobilePichuBallAnimationStep], a
	jr .load_frame

.set_frame
	ld [wMobilePichuBallFrame], a
	ld a, [hl]
	ld [wMobilePichuBallFrameDuration], a
	ret

MobilePichu_RunMovement:
	ld a, [wMobilePichuMovementIndex]
	cp MOBILE_PICHU_MOVE_UNUSED_FINISH
	ret nc
	ld e, a
	ld d, 0
	ld hl, MobilePichuMovementPointers
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

MobilePichuMovementPointers:
	table_width 2
	dw MobilePichu_Idle
	dw MobilePichu_InitHorizontal
	dw MobilePichu_StartLeft
	dw MobilePichu_MoveLeft
	dw MobilePichu_StartRight
	dw MobilePichu_MoveRight
	dw MobilePichu_InitVertical
	dw MobilePichu_StartDown
	dw MobilePichu_MoveDown
	dw MobilePichu_StartUp
	dw MobilePichu_MoveUp
	dw MobilePichu_InitAppear
	dw MobilePichu_Appear
	dw MobilePichu_WaitAppear
	dw MobilePichu_InitFinish
	dw MobilePichu_StartFinish
	dw MobilePichu_MoveToFinish
	dw MobilePichu_Finish
; The movement-index check excludes this last entry.
	dw MobilePichu_Finish
	assert_table_length NUM_MOBILE_PICHU_MOVEMENTS

MobilePichu_InitHorizontal:
	call MobilePichu_BeginMovement

MobilePichu_StartLeft:
	ld a, MOBILE_PICHU_ANIM_LEFT
	ld c, a
	ld a, -1
	ld b, a
	ld a, MOBILE_PICHU_RIGHT_EDGE
	call MobilePichu_InitHorizontalPosition

MobilePichu_MoveLeft:
	call MobilePichu_Move
	ld a, [wMobilePichuX]
	cp MOBILE_PICHU_LEFT_EDGE
	ret nz
	ld a, MOBILE_PICHU_MOVE_INIT_HORIZONTAL
	call MobilePichu_CheckMovementCommand
	ret c
	jp MobilePichu_IncrementMovement

MobilePichu_StartRight:
	ld a, MOBILE_PICHU_ANIM_RIGHT
	ld c, a
	ld a, $1
	ld b, a
	ld a, MOBILE_PICHU_LEFT_EDGE
	call MobilePichu_InitHorizontalPosition

MobilePichu_MoveRight:
	call MobilePichu_Move
	ld a, [wMobilePichuX]
	cp MOBILE_PICHU_RIGHT_EDGE
	ret nz
	ld a, MOBILE_PICHU_MOVE_INIT_HORIZONTAL
	call MobilePichu_CheckMovementCommand
	ret c
	ld a, MOBILE_PICHU_MOVE_START_LEFT
	ld [wMobilePichuMovementIndex], a
	ret

MobilePichu_InitVertical:
	call MobilePichu_BeginMovement

MobilePichu_StartDown:
	ld a, MOBILE_PICHU_ANIM_DOWN
	ld c, a
	ld a, $1
	ld b, a
	ld a, MOBILE_PICHU_TOP_EDGE
	call MobilePichu_InitVerticalPosition

MobilePichu_MoveDown:
	call MobilePichu_Move
	ld a, [wMobilePichuY]
	cp MOBILE_PICHU_BOTTOM_EDGE
	ret nz
	ld a, MOBILE_PICHU_MOVE_INIT_VERTICAL
	call MobilePichu_CheckMovementCommand
	ret c
	jp MobilePichu_IncrementMovement

MobilePichu_StartUp:
	ld a, MOBILE_PICHU_ANIM_UP
	ld c, a
	ld a, -1
	ld b, a
	ld a, MOBILE_PICHU_BOTTOM_EDGE
	call MobilePichu_InitVerticalPosition

MobilePichu_MoveUp:
	call MobilePichu_Move
	ld a, [wMobilePichuY]
	cp MOBILE_PICHU_TOP_EDGE
	ret nz
	ld a, MOBILE_PICHU_MOVE_INIT_VERTICAL
	call MobilePichu_CheckMovementCommand
	ret c
	ld a, MOBILE_PICHU_MOVE_START_DOWN
	ld [wMobilePichuMovementIndex], a
	ret

MobilePichu_InitAppear:
	xor a
	ld [wMobilePichuAppearRow], a
	call MobilePichu_BeginMovement

MobilePichu_Appear:
	ld hl, wMobilePichuAppearRow
	ld a, $1
	xor [hl]
	ld [hl], a
	add MOBILE_PICHU_ANIM_APPEAR_UPPER
	ld c, a
	call MobilePichu_SetAnimation
	ld a, [wMobilePichuAppearRow]
	and a
	jr nz, .lower_row
	ld a, 9 * TILE_WIDTH
	jr .set_y

.lower_row
	ld a, 15 * TILE_WIDTH

.set_y
	ld [wMobilePichuY], a
	call Random
	ldh a, [hRandomAdd]
	and %111
	sla a
	sla a
	sla a
	add 6 * TILE_WIDTH
	ld [wMobilePichuX], a
	call MobilePichu_IncrementMovement

MobilePichu_WaitAppear:
	ld a, [wMobilePichuAnimation]
	cp MOBILE_PICHU_ANIM_END
	ret nz
	ld a, MOBILE_PICHU_MOVE_INIT_APPEAR
	call MobilePichu_CheckMovementCommand
	ret c
	ld a, MOBILE_PICHU_MOVE_APPEAR
	ld [wMobilePichuMovementIndex], a
	ret

MobilePichu_InitFinish:
	call MobilePichu_BeginMovement

MobilePichu_StartFinish:
	ld a, MOBILE_PICHU_RIGHT_EDGE
	ld [wMobilePichuX], a
	ld [wMobilePichuBallX], a
	ld a, 12 * TILE_WIDTH
	ld [wMobilePichuY], a
	ld [wMobilePichuBallY], a
	ld a, -1
	ld [wMobilePichuXSpeed], a
	xor a
	ld [wMobilePichuYSpeed], a
	ld a, MOBILE_PICHU_ANIM_LEFT
	ld c, a
	call MobilePichu_SetAnimation
	call MobilePichu_IncrementMovement

MobilePichu_MoveToFinish:
	call MobilePichu_Move
	ld a, [wMobilePichuX]
	cp 11 * TILE_WIDTH
	ret nz
	ld a, MOBILE_PICHU_ANIM_FINISH
	ld c, a
	call MobilePichu_SetAnimation
	call MobilePichu_IncrementMovement

MobilePichu_Finish:
	call MobilePichu_Move
	ld a, [wMobilePichuX]
	cp 9 * TILE_WIDTH
	jr nz, .wait_animation
	xor a
	ld [wMobilePichuXSpeed], a

.wait_animation
	ld a, [wMobilePichuAnimation]
	cp MOBILE_PICHU_ANIM_END
	ret nz
	ld a, MOBILE_PICHU_RESTORE_OVERWORLD
	ld [wMobilePichuJumptableIndex], a
	xor a
	ld [wMobilePichuMovementIndex], a
	ret

MobilePichu_InitHorizontalPosition:
	ld [wMobilePichuX], a
	ld a, b
	ld [wMobilePichuXSpeed], a
	xor a
	ld [wMobilePichuYSpeed], a
	ld hl, wMobilePichuY
.random_y
	call Random
	ldh a, [hRandomAdd]
	and %111
	jr z, .scale_y
	dec a

.scale_y
	sla a
	sla a
	sla a
	add 9 * TILE_WIDTH
	cp [hl]
	jr z, .random_y
	ld [hl], a
	call MobilePichu_SetAnimation
	call MobilePichu_IncrementMovement
	ret

MobilePichu_InitVerticalPosition:
	ld [wMobilePichuY], a
	ld a, b
	ld [wMobilePichuYSpeed], a
	xor a
	ld [wMobilePichuXSpeed], a
	ld hl, wMobilePichuX
.random_x
	call Random
	ldh a, [hRandomAdd]
	and %111
	sla a
	sla a
	sla a
	add 6 * TILE_WIDTH
	cp [hl]
	jr z, .random_x
	ld [hl], a
	call MobilePichu_SetAnimation
	call MobilePichu_IncrementMovement
	ret

MobilePichu_Move:
	ld hl, wMobilePichuX
	ld a, [wMobilePichuXSpeed]
	add [hl]
	ld [hl], a
	ld hl, wMobilePichuY
	ld a, [wMobilePichuYSpeed]
	add [hl]
	ld [hl], a
	ret

MobilePichu_ClipObjects:
	ld a, [wMobilePichuY]
	cp MOBILE_PICHU_WINDOW_Y
	jr c, .clip_three_rows
	jr z, .clip_three_rows
	cp MOBILE_PICHU_WINDOW_Y + TILE_WIDTH
	jr c, .clip_two_rows
	jr z, .clip_two_rows
	cp MOBILE_PICHU_WINDOW_Y + 2 * TILE_WIDTH
	jr c, .clip_one_row
	jr z, .clip_one_row
	xor a
	jr .set_clipped_objects

.clip_three_rows
	ld a, 3 * MOBILE_PICHU_OBJECTS_PER_ROW
	jr .set_clipped_objects

.clip_two_rows
	ld a, 2 * MOBILE_PICHU_OBJECTS_PER_ROW
	jr .set_clipped_objects

.clip_one_row
	ld a, MOBILE_PICHU_OBJECTS_PER_ROW

.set_clipped_objects
	ld [wMobilePichuClippedObjects], a
	ret

MobilePichu_Idle:
	ld a, MOBILE_PICHU_MOVE_IDLE

MobilePichu_CheckMovementCommand:
; a: current movement command. Carry if a different command was requested.
	ld hl, wMobilePichuMovementCommand
	cp [hl]
	jr z, .unchanged
	ld a, [hl]
	ld [wMobilePichuMovementIndex], a
	scf
	ret

.unchanged
	and a
	ret

MobilePichu_BeginMovement:
	ld hl, wMobilePichuMovementIndex
	ld a, [hl]
	ld [wMobilePichuMovementCommand], a
	inc [hl]
	ret

MobilePichu_IncrementMovement:
	ld hl, wMobilePichuMovementIndex
	inc [hl]
	ret

MobilePichu_SetAnimation:
; c: animation index.
	ld a, c
	ld [wMobilePichuAnimation], a
	xor a
	ld [wMobilePichuAnimationStep], a
	jr MobilePichu_LoadFrame

MobilePichu_AdvanceFrame:
	ld hl, wMobilePichuFrameDuration
	dec [hl]
	ret nz
	ld hl, wMobilePichuAnimationStep
	inc [hl]

MobilePichu_LoadFrame:
	ld a, [wMobilePichuAnimation]
	cp MOBILE_PICHU_ANIM_END
	ret z
	sla a
	ld c, a
	ld b, 0
	ld hl, MobilePichuAnimations
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push de
	pop hl
	ld a, [wMobilePichuAnimationStep]
	sla a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	cp MOBILE_PICHU_ANIM_END
	jr z, .end
	cp MOBILE_PICHU_ANIM_LOOP
	jr nz, .set_frame
	xor a
	ld [wMobilePichuAnimationStep], a
	jr MobilePichu_LoadFrame

.end
	ld a, MOBILE_PICHU_ANIM_END
	ld [wMobilePichuAnimation], a
	ld a, MOBILE_PICHU_FRAME_HIDDEN

.set_frame
	ld [wMobilePichuFrame], a
	ld a, [hl]
	ld [wMobilePichuFrameDuration], a
	ret
