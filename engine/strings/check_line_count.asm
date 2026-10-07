CheckStringContainsLessThanBNextCharacters:
; Scan c bytes at de. Return carry if at least b "<NEXT>" bytes are present.
; Continue past "@" terminators.
.loop
	ld a, [de]
	inc de
	cp '<NEXT>'
	jr nz, .next_char
	dec b
	jr z, .done

.next_char
	dec c
	jr nz, .loop
	and a
	ret

.done
	scf
	ret
