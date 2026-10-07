MobilePichu_LoadSpriteGFX:
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
	lb bc, BANK(wDecompressScratch), MOBILE_PICHU_NUM_TILES
	call Get2bpp
	xor a
	ldh [rVBK], a
	ld hl, ElectroBallMobileGFX
	ld de, wDecompressScratch
	call Decompress
	ld de, wDecompressScratch
	ld hl, vTiles0
	lb bc, BANK(wDecompressScratch), 83
	call Get2bpp
	pop af
	ldh [rWBK], a
	ret

MobilePichu_LoadBorderGFX:
	ld a, $1
	ldh [rVBK], a
	ld de, PichuBorderMobileGFX
	ld hl, vTiles3 tile MOBILE_PICHU_NUM_TILES
	lb bc, BANK(PichuBorderMobileGFX), 24
	call Get2bpp
	xor a
	ldh [rVBK], a
	ret

INCLUDE "data/mobile/pichu_gfx.asm"
