PokemonNewsSetBitMasks:
for x, 8
	db 1 << x
endr

PokemonNewsResetBitMasks:
for x, 8
	db ~(1 << x)
endr
