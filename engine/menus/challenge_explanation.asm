Menu_ChallengeExplanationCancel:
; wScriptVar = FALSE: Japanese Download News / View News / Explanation / Cancel.
; Otherwise: English Challenge / Explanation / Cancel.
; Return the one-based menu choice in wScriptVar; B returns 4.
	ld a, [wScriptVar]
	and a
	jr nz, .battle_tower_menu
	ld a, $4
	ld [wScriptVar], a
	ld hl, PokemonNewsMenuHeader
	jr .load_menu

.battle_tower_menu:
	ld a, $4
	ld [wScriptVar], a
	ld hl, MenuHeader_ChallengeExplanationCancel

.load_menu:
	call LoadMenuHeader
	call GetChallengeExplanationMenuChoice
	call CloseWindow
	ret

GetChallengeExplanationMenuChoice:
	call VerticalMenu
	jr c, .cancel
	ld a, [wScriptVar]
	cp $5
	jr nz, .use_cursor
	ld a, [wMenuCursorY]
	cp $3
	ret z
	jr c, .use_cursor
	dec a
	jr .store_choice

.use_cursor:
	ld a, [wMenuCursorY]

.store_choice:
	ld [wScriptVar], a
	ret

.cancel:
	ld a, $4
	ld [wScriptVar], a
	ret
