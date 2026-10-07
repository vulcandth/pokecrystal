pushc ascii

MobilePasswordLetters:
	table_width MOBILE_PASSWORD_KEYBOARD_COLUMNS
	db "ABCDEFGHIJKLMN"
	db "OPQRSTUVWXYZ  "
	db "abcdefghijklmn"
	db "opqrstuvwxyz  "

	assert_table_length MOBILE_PASSWORD_KEYBOARD_ROWS

MobilePasswordSymbols:
	table_width MOBILE_PASSWORD_KEYBOARD_COLUMNS
	db "0123456789    "
	db "!\"#$%&'()*+   "
	db ",-./:;<=>?@   "
	db "[\\]^_`\{|}~    "
	assert_table_length MOBILE_PASSWORD_KEYBOARD_ROWS

popc
