MobilePhone_Init:
	ld de, MobileDialingGFX
	ld hl, vTiles0 tile MOBILE_PHONE_TILE
	lb bc, BANK(MobileDialingGFX), (MobileDialingGFX.End - MobileDialingGFX) / TILE_SIZE
	call Get2bpp
	xor a
	ld [wMobilePhoneEnabled], a
	ld [wc306], a
	ld [wMobilePhoneFrame], a
	ld [wMobilePhoneAnimation], a
	ld [wMobilePhoneAnimationStep], a
	ld [wMobilePhoneFrameDuration], a
	ld a, 1 * TILE_WIDTH + OAM_X_OFS
	ld [wMobilePhoneX], a
	ld a, 1 * TILE_WIDTH + OAM_Y_OFS
	ld [wMobilePhoneY], a
	ret

MobilePhone_Hide:
	xor a
	ld [wMobilePhoneEnabled], a
	ld a, OAM_YCOORD_HIDDEN
	ld hl, wShadowOAMSprite31
	ld bc, MOBILE_PHONE_OAM_COUNT * OBJ_SIZE
	call ByteFill
	ret

MobilePhone_Update:
	ld a, [wMobilePhoneEnabled]
	and a
	ret z
	ld a, OAM_YCOORD_HIDDEN
	ld hl, wShadowOAMSprite31
	ld bc, MOBILE_PHONE_OAM_COUNT * OBJ_SIZE
	call ByteFill
	call MobilePhone_UpdateAnimation
	ld a, [wMobilePhoneFrame]
	sla a
	ld c, a
	ld b, 0
	ld hl, MobilePhoneFrames
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	push de
	pop hl
	ld de, wShadowOAMSprite31
	ld a, [wMobilePhoneX]
	ld c, a
	ld a, [wMobilePhoneY]
	ld b, a
	ld a, [hli]
.copy_oam
	push af
	ld a, [hli]
	add b
	ld [de], a
	inc de
	ld a, [hli]
	add c
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	pop af
	dec a
	jr nz, .copy_oam
	ret

MobilePhone_SetAnimation:
; c selects an entry in MobilePhoneAnimations.
	ld a, c
	ld [wMobilePhoneAnimation], a
	xor a
	ld [wMobilePhoneAnimationStep], a
	jr MobilePhone_LoadFrame

MobilePhone_UpdateAnimation:
	ld hl, wMobilePhoneFrameDuration
	dec [hl]
	ret nz
	ld hl, wMobilePhoneAnimationStep
	inc [hl]

MobilePhone_LoadFrame:
; Each step supplies a frame index and duration; the terminator loops.
	ld a, [wMobilePhoneAnimation]
	sla a
	ld c, a
	ld b, 0
	ld hl, MobilePhoneAnimations
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push de
	pop hl
	ld a, [wMobilePhoneAnimationStep]
	sla a
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [hli]
	cp MOBILE_PHONE_ANIM_END
	jr nz, .not_end
	xor a
	ld [wMobilePhoneAnimationStep], a
	jr MobilePhone_LoadFrame

.not_end
	ld [wMobilePhoneFrame], a
	ld a, [hl]
	ld [wMobilePhoneFrameDuration], a
	ret

INCLUDE "data/mobile/phone_animation.asm"
