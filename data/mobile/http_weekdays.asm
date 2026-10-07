MobileHTTPWeekdays:
	table_width 3
pushc ascii
	db "Mon"
	db "Tue"
	db "Wed"
	db "Thu"
	db "Fri"
	db "Sat"
	db "Sun"
popc
	assert_table_length 7
.End:
