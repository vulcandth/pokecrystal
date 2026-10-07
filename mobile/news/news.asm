; Built-in Japanese Pokémon News samples. Each has a destination, additive
; checksum, payload length, and screen/script/text data. The scripts retain
; their original Japanese RAM addresses; these differ from English WRAM.
; Reference: https://github.com/gb-mobile/pokecrystal-news-en
; https://archives.glitchcity.info/forums/board-76/thread-7509/page-1.html#msg206449
; https://web.archive.org/web/20200414101940/https://forums.glitchcity.info/index.php?topic=7509.msg206449#msg206449

	dab PlayersHouseDoll1Script ; related to "My Room" in Stadium 2?

LoadPokemonNews1: ; unreferenced
	ld a, BANK(sPokemonNews)
	call OpenSRAM
	ld hl, PokemonNews1
	ld de, sPokemonNews
	ld bc, $1000
	call CopyBytes
	call CloseSRAM
	ret

INCLUDE "mobile/news/news_1.asm"

LoadPokemonNews2: ; unreferenced
	ld a, BANK(sPokemonNews)
	call OpenSRAM
	ld hl, PokemonNews2
	ld de, sPokemonNews
	ld bc, $1000
	call CopyBytes
	call CloseSRAM
	ret

INCLUDE "mobile/news/news_2.asm"

LoadPokemonNews3: ; unreferenced
	ld a, BANK(sPokemonNews)
	call OpenSRAM
	ld hl, PokemonNews3
	ld de, sPokemonNews
	ld bc, $1000
	call CopyBytes
	call CloseSRAM
	ret

INCLUDE "mobile/news/news_3.asm"
