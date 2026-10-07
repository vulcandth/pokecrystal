MobilePichu_Init:
	xor a
	ld [wMobilePichuEnabled], a
	ld [wMobilePichuJumptableIndex], a
	ld [wMobilePichuFrame], a
	ld [wMobilePichuAnimation], a
	ld [wMobilePichuAnimationStep], a
	ld [wMobilePichuFrameDuration], a
	ld [wMobilePichuMovementIndex], a
	ld [wMobilePichuMovementCommand], a
	ld [wMobilePichuClippedObjects], a
	ld [wMobilePichuBallAnimationStep], a
	ld [wMobilePichuBallClippedObjects], a
	ld [wMobilePichuBallXFraction], a
	ld [wMobilePichuBallYFraction], a
	ld a, MOBILE_PICHU_BALL_FIRST_FRAME
	ld [wMobilePichuBallFrame], a
	ld a, MOBILE_PICHU_BALL_INITIAL_DELAY
	ld [wMobilePichuBallFrameDuration], a
	ld a, MOBILE_PICHU_INITIAL_X
	ld [wMobilePichuX], a
	ld [wMobilePichuBallX], a
	ld a, MOBILE_PICHU_INITIAL_Y
	ld [wMobilePichuY], a
	ld [wMobilePichuBallY], a
	ret

MobilePichu_Update:
	ld a, [wMobilePichuEnabled]
	and a
	ret z
	ld a, [wMobilePichuJumptableIndex]
	cp MOBILE_PICHU_LOAD_SPRITES
	jr c, .run_state
	ld a, OAM_YCOORD_HIDDEN
	ld hl, wShadowOAM
	ld bc, (MOBILE_PICHU_MAX_OBJECTS + MOBILE_PICHU_BALL_OBJECTS) * OBJ_SIZE
	call ByteFill

.run_state
	call MobilePichu_RunState
	ret

MobilePichu_RunState:
	jumptable .Jumptable, wMobilePichuJumptableIndex

.Jumptable:
	table_width 2
	dw MobilePichu_LoadTilemap
	dw MobilePichu_LoadBorder
	dw MobilePichu_LoadSprites
	dw MobilePichu_Animate
	dw MobilePichu_RestoreOverworld
	dw MobilePichu_RestoreStadium
	dw MobilePichu_RestoreNews
	assert_table_length NUM_MOBILE_PICHU_STATES

MobilePichu_LoadTilemap:
	ldh a, [rWBK]
	push af

	ld a, BANK(wDecompressScratch)
	ldh [rWBK], a

	ld hl, PichuBorderMobileTilemapAttrmap
	ld de, wDecompressScratch
	ld bc, TILEMAP_WIDTH * MOBILE_PICHU_BORDER_ROWS * 2
	call CopyBytes

	di

.wait_for_vblank
; Wait until a vblank would occur had interrupts not just been disabled.
	ldh a, [rLY]
	cp LY_VBLANK + 1
	jr nz, .wait_for_vblank

	ld a, HIGH(wDecompressScratch)
	ldh [rVDMA_SRC_HIGH], a
	ld a, LOW(wDecompressScratch)
	ldh [rVDMA_SRC_LOW], a
	ld a, HIGH(vBGMap1) & $1f
	ldh [rVDMA_DEST_HIGH], a
	xor a
	ldh [rVDMA_DEST_LOW], a
	ld a, MOBILE_PICHU_DMA_LENGTH
	ldh [rVDMA_LEN], a

	ld a, HIGH(wDecompressScratch + 4 * TILEMAP_WIDTH)
	ldh [rVDMA_SRC_HIGH], a
	ld a, LOW(wDecompressScratch + 4 * TILEMAP_WIDTH)
	ldh [rVDMA_SRC_LOW], a
	ld a, HIGH(vBGMap1 + 4 * TILEMAP_WIDTH) & $1f
	ldh [rVDMA_DEST_HIGH], a
	ld a, LOW(vBGMap1 + 4 * TILEMAP_WIDTH)
	ldh [rVDMA_DEST_LOW], a
	ld a, MOBILE_PICHU_DMA_LENGTH
	ldh [rVDMA_LEN], a

	ld a, HIGH(wDecompressScratch + 8 * TILEMAP_WIDTH)
	ldh [rVDMA_SRC_HIGH], a
	ld a, LOW(wDecompressScratch + 8 * TILEMAP_WIDTH)
	ldh [rVDMA_SRC_LOW], a
	ld a, HIGH(vBGMap1 + 8 * TILEMAP_WIDTH) & $1f
	ldh [rVDMA_DEST_HIGH], a
	xor a
	ldh [rVDMA_DEST_LOW], a
	ld a, MOBILE_PICHU_DMA_LENGTH
	ldh [rVDMA_LEN], a

	ld a, $1
	ldh [rVBK], a

	ld a, HIGH(wDecompressScratch + 12 * TILEMAP_WIDTH)
	ldh [rVDMA_SRC_HIGH], a
	ld a, LOW(wDecompressScratch + 12 * TILEMAP_WIDTH)
	ldh [rVDMA_SRC_LOW], a
	ld a, HIGH(vBGMap3) & $1f
	ldh [rVDMA_DEST_HIGH], a
	xor a
	ldh [rVDMA_DEST_LOW], a
	ld a, MOBILE_PICHU_DMA_LENGTH
	ldh [rVDMA_LEN], a

	ld a, HIGH(wDecompressScratch + 16 * TILEMAP_WIDTH)
	ldh [rVDMA_SRC_HIGH], a
	ld a, LOW(wDecompressScratch + 16 * TILEMAP_WIDTH)
	ldh [rVDMA_SRC_LOW], a
	ld a, HIGH(vBGMap3 + 4 * TILEMAP_WIDTH) & $1f
	ldh [rVDMA_DEST_HIGH], a
	ld a, LOW(vBGMap3 + 4 * TILEMAP_WIDTH)
	ldh [rVDMA_DEST_LOW], a
	ld a, MOBILE_PICHU_DMA_LENGTH
	ldh [rVDMA_LEN], a

	ld a, HIGH(wDecompressScratch + 20 * TILEMAP_WIDTH)
	ldh [rVDMA_SRC_HIGH], a
	ld a, LOW(wDecompressScratch + 20 * TILEMAP_WIDTH)
	ldh [rVDMA_SRC_LOW], a
	ld a, HIGH(vBGMap3 + 8 * TILEMAP_WIDTH) & $1f
	ldh [rVDMA_DEST_HIGH], a
	xor a
	ldh [rVDMA_DEST_LOW], a
	ld a, MOBILE_PICHU_DMA_LENGTH
	ldh [rVDMA_LEN], a

	xor a
	ldh [rVBK], a

	ei

	pop af
	ldh [rWBK], a

	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, MOBILE_PICHU_MUSIC_FADE
	ld [wMusicFade], a
	ld de, MUSIC_MOBILE_ADAPTER
	ld a, e
	ld [wMusicFadeID], a
	ld a, d
	ld [wMusicFadeID + 1], a
	ld a, [wMobilePichuJumptableIndex]
	inc a
	ld [wMobilePichuJumptableIndex], a
	ret

MobilePichuMenuHeader: ; unreferenced
	db MENU_BACKUP_TILES ; flags
	menu_coords 0, 6, SCREEN_WIDTH - 1, SCREEN_HEIGHT - 1
	dw NULL
	db 0 ; default option

MobilePichu_LoadBorder:
	farcall MobilePichu_LoadBorderGFX
	ld a, [wMobilePichuJumptableIndex]
	inc a
	ld [wMobilePichuJumptableIndex], a
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, wBGPals1 palette 6
	ld de, wMobilePichuPaletteBackup
	ld bc, 2 palettes
	call CopyBytes
	ld hl, PichuBorderMobileBGPalettes
	ld de, wBGPals1 palette 7
	ld bc, 1 palettes
	call CopyBytes
	call SetDefaultBGPAndOBP
	pop af
	ldh [rWBK], a
	ld a, MOBILE_PICHU_WINDOW_Y
	ldh [hWY], a
	ret

MobilePichu_LoadSprites:
	farcall MobilePichu_LoadSpriteGFX
	ld a, [wMobilePichuJumptableIndex]
	inc a
	ld [wMobilePichuJumptableIndex], a
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, PichuBorderMobileOBPalettes
	ld de, wOBPals1 palette 2
	ld bc, 6 palettes
	call CopyBytes
	call SetDefaultBGPAndOBP
	pop af
	ldh [rWBK], a
	ret

MobilePichu_Animate:
	call Function11659d
	call Function116758
	call Function1167a6
	ld a, [wMobilePichuFrame]
	cp MOBILE_PICHU_FRAME_HIDDEN
	ret z
	sla a
	ld c, a
	ld b, 0
	ld hl, Unknown_1168c5
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	push de
	pop hl
	ld a, [wMobilePichuX]
	ld c, a
	ld a, [wMobilePichuY]
	ld b, a
	ld a, [wMobilePichuClippedObjects]
	ld e, a
	ld a, [hli]
	sub e
	ld de, wShadowOAMSprite09
.pichu_oam
	push af
	ld a, [hli]
	add b
	ld [de], a ; y
	inc de
	ld a, [hli]
	add c
	ld [de], a ; x
	inc de
	ld a, [hli]
	ld [de], a ; tile id
	inc de
	ld a, [hli]
	ld [de], a ; attributes
	inc de
	pop af
	dec a
	jr nz, .pichu_oam
	call MobilePichu_UpdateBallPosition
	ld a, [wMobilePichuBallFrame]
	sla a
	ld c, a
	ld b, 0
	ld hl, Unknown_1168c5
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	push de
	pop hl
	ld a, [wMobilePichuBallX]
	ld c, a
	ld a, [wMobilePichuBallY]
	ld b, a
	ld a, [wMobilePichuBallClippedObjects]
	ld e, a
	ld a, [hli]
	sub e
	ld de, wShadowOAMSprite00
.ball_oam
	push af
	ld a, [hli]
	add b
	ld [de], a ; y
	inc de
	ld a, [hli]
	add c
	ld [de], a ; x
	inc de
	ld a, [hli]
	ld [de], a ; tile id
	inc de
	ld a, [hli]
	ld [de], a ; attributes
	inc de
	pop af
	dec a
	jr nz, .ball_oam
	ret

MobilePichu_RestoreStadium:
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, wBGPals2
	ld de, wBGPals1
	ld bc, 8 palettes
	call CopyBytes
	pop af
	ldh [rWBK], a
	call SetDefaultBGPAndOBP
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	ld a, OAM_YCOORD_HIDDEN
	ld hl, wShadowOAM
	ld bc, MOBILE_PICHU_MAX_OBJECTS * OBJ_SIZE
	call ByteFill
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	call UpdateSprites
	pop af
	ldh [rWBK], a
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, MOBILE_PICHU_MUSIC_FADE
	ld [wMusicFade], a
	ld a, [wMapMusic]
	ld [wMusicFadeID], a
	xor a
	ld [wMusicFadeID + 1], a
	xor a
	ld [wMobilePichuJumptableIndex], a
	ld [wMobilePichuEnabled], a
	ret

MobilePichu_RestoreOverworld:
	ldh a, [rWBK]
	push af
	ld a, $1
	ldh [rWBK], a
	ld a, OAM_YCOORD_HIDDEN
	ld hl, wShadowOAM
	ld bc, MOBILE_PICHU_MAX_OBJECTS * OBJ_SIZE
	call ByteFill
	call DelayFrame
	farcall LoadStandingSpritesGFX
	ld b, SCGB_MAPPALS
	call GetSGBLayout
	ldh a, [rWBK]
	push af
	ld a, BANK(wBGPals1)
	ldh [rWBK], a
	ld hl, wMobilePichuPaletteBackup
	ld de, wBGPals1 palette 6
	ld bc, 2 palettes
	call CopyBytes
	pop af
	ldh [rWBK], a
	call SetDefaultBGPAndOBP
	call DelayFrame
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	call UpdateSprites
	farcall LoadWalkingSpritesGFX
	pop af
	ldh [rWBK], a
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, [wLinkMode]
	cp LINK_MOBILE
	jr z, .stop_music
	ld a, MOBILE_PICHU_MUSIC_FADE
	ld [wMusicFade], a
	ld a, [wMapMusic]
	ld [wMusicFadeID], a
	xor a
	ld [wMusicFadeID + 1], a
	jr .disable

.stop_music
	ld a, MOBILE_PICHU_MUSIC_FADE
	ld [wMusicFade], a
	ld a, LOW(MUSIC_NONE)
	ld [wMusicFadeID], a
	ld a, HIGH(MUSIC_NONE)
	ld [wMusicFadeID + 1], a

.disable
	xor a
	ld [wMobilePichuJumptableIndex], a
	ld [wMobilePichuEnabled], a
	ret

MobilePichu_RestoreNews:
	farcall PokemonNews_LoadGraphics
	ld a, SCREEN_HEIGHT_PX
	ldh [hWY], a
	farcall HDMATransferTilemapAndAttrmap_Overworld
	ld a, MOBILE_PICHU_MUSIC_FADE
	ld [wMusicFade], a
	ld a, [wMapMusic]
	ld [wMusicFadeID], a
	xor a
	ld [wMusicFadeID + 1], a
	xor a
	ld [wMobilePichuJumptableIndex], a
	ld [wMobilePichuEnabled], a
	ret

MobilePichu_UpdateBallPosition:
; Follow Pichu with 8.8 fixed-point coordinates and velocities.
; The appearance sequence mirrors Pichu around the center instead.
	call Function116567
	ld a, [wMobilePichuMovementIndex]
	cp $d
	jr nz, .follow_pichu
	ld hl, wMobilePichuX
	ld a, [hl]
	cp MOBILE_PICHU_MIRROR_X
	jr nc, .mirror_right
	ld a, MOBILE_PICHU_MIRROR_X
	sub [hl]
	add MOBILE_PICHU_MIRROR_X
	ld [wMobilePichuBallX], a
	jr .mirror_y

.mirror_right
	sub MOBILE_PICHU_MIRROR_X
	ld c, a
	ld a, MOBILE_PICHU_MIRROR_X
	sub c
	ld [wMobilePichuBallX], a

.mirror_y
	ld hl, wMobilePichuY
	ld a, [hl]
	cp MOBILE_PICHU_MIRROR_Y
	jr nc, .mirror_below
	ld a, MOBILE_PICHU_MIRROR_Y
	sub [hl]
	add MOBILE_PICHU_MIRROR_Y
	ld [wMobilePichuBallY], a
	ret

.mirror_below
	sub MOBILE_PICHU_MIRROR_Y
	ld c, a
	ld a, MOBILE_PICHU_MIRROR_Y
	sub c
	ld [wMobilePichuBallY], a
	ret

.follow_pichu
	ld hl, wMobilePichuX
	ld a, MOBILE_PICHU_WRAP_THRESHOLD
	cp [hl]
	jr nc, .get_x_distance
	ld a, [wMobilePichuBallX]
	and a
	jr z, .follow_y
	jr .move_x

.get_x_distance
	ld a, [wMobilePichuBallX]
	sub [hl]
	jr nc, .scale_x_distance
	xor $ff
	inc a

.scale_x_distance
	ld b, a
	ld c, $0
	ld a, MOBILE_PICHU_BALL_FOLLOW_SHIFT
.shift_x
	srl b
	rr c
	dec a
	jr nz, .shift_x
	ld a, c
	ld [wMobilePichuBallXSpeedFraction], a
	ld a, b
	ld [wMobilePichuBallXSpeed], a
	ld a, [wMobilePichuBallX]
	sub [hl]
	jr c, .move_x
	ld c, $0
	ld a, [wMobilePichuBallXSpeedFraction]
	xor $ff
	add $1
	rl c
	ld [wMobilePichuBallXSpeedFraction], a
	ld a, [wMobilePichuBallXSpeed]
	xor $ff
	add c
	ld [wMobilePichuBallXSpeed], a

.move_x
	ld a, [wMobilePichuBallXFraction]
	ld l, a
	ld a, [wMobilePichuBallX]
	ld h, a
	ld a, [wMobilePichuBallXSpeedFraction]
	ld e, a
	ld a, [wMobilePichuBallXSpeed]
	ld d, a
	add hl, de
	ld a, l
	ld [wMobilePichuBallXFraction], a
	ld a, h
	ld [wMobilePichuBallX], a

.follow_y
	ld hl, wMobilePichuY
	ld a, MOBILE_PICHU_WRAP_THRESHOLD
	cp [hl]
	jr c, .move_y
	ld a, [wMobilePichuBallY]
	sub [hl]
	jr nc, .scale_y_distance
	xor $ff
	inc a

.scale_y_distance
	ld b, a
	ld c, $0
	ld a, MOBILE_PICHU_BALL_FOLLOW_SHIFT
.shift_y
	srl b
	rr c
	dec a
	jr nz, .shift_y
	ld a, c
	ld [wMobilePichuBallYSpeedFraction], a
	ld a, b
	ld [wMobilePichuBallYSpeed], a
	ld a, [wMobilePichuBallY]
	sub [hl]
	jr c, .move_y
	ld c, $0
	ld a, [wMobilePichuBallYSpeedFraction]
	xor $ff
	add $1
	rl c
	ld [wMobilePichuBallYSpeedFraction], a
	ld a, [wMobilePichuBallYSpeed]
	xor $ff
	add c
	ld [wMobilePichuBallYSpeed], a

.move_y
	ld a, [wMobilePichuBallYFraction]
	ld l, a
	ld a, [wMobilePichuBallY]
	ld h, a
	ld a, [wMobilePichuBallYSpeedFraction]
	ld e, a
	ld a, [wMobilePichuBallYSpeed]
	ld d, a
	add hl, de
	ld a, l
	ld [wMobilePichuBallYFraction], a
	ld a, h
	ld [wMobilePichuBallY], a
	ret
