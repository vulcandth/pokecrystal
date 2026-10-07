CheckStringForErrors:
; Check up to c bytes at de, stopping at "@". Return carry for an invalid byte.
; Valid character ranges:
; $0, $5 - $13, $19 - $1c, $26 - $34, $3a - $3e, $40 - $48, $4e, $60 - $ff
.loop
	ld a, [de]
	inc de
	and a
	jr z, .next_char
	cp FIRST_REGULAR_TEXT_CHAR
	jr nc, .next_char
	cp '<NEXT>'
	jr z, .next_char
	cp '@'
	jr z, .done
	cp 'ガ'
	jr c, .fail
	cp '<PLAY_G>'
	jr c, .next_char
	cp '<JP_18>' + 1
	jr c, .fail
	cp '<NI>'
	jr c, .next_char
	cp '<NO>' + 1
	jr c, .fail
	cp '<ROUTE>'
	jr c, .next_char
	cp '<GREEN>' + 1
	jr c, .fail
	cp '<ENEMY>'
	jr c, .next_char
	cp '<ENEMY>' + 1
	jr c, .fail
	cp '<MOM>'
	jr c, .next_char

.fail:
	scf
	ret

.next_char:
	dec c
	jr nz, .loop

.done:
	and a
	ret

CheckStringForErrors_IgnoreTerminator:
; Check all c bytes at de, including any "@" terminators.
; Return carry for an invalid byte.
.loop
	ld a, [de]
	inc de
	and a
	jr z, .next
	cp '<DEXEND>' + 1
	jr nc, .next
	cp '<NEXT>'
	jr z, .next
	cp '@'
	jr z, .next

	cp 'ガ'
	jr c, .end
	cp '<PLAY_G>'
	jr c, .next
	cp '<JP_18>' + 1
	jr c, .end
	cp '<NI>'
	jr c, .next
	cp '<NO>' + 1
	jr c, .end
	cp '<ROUTE>'
	jr c, .next
	cp '<GREEN>' + 1
	jr c, .end
	cp '<ENEMY>'
	jr c, .next
	cp '<ENEMY>' + 1
	jr c, .end
	cp '<MOM>'
	jr c, .next

.end
	scf
	ret

.next
	dec c
	jr nz, .loop
	and a
	ret
