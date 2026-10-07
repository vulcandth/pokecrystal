NewsTextPointers:
	table_width 2
NewsText_RankingNumberCommand:
	dw NewsText_RankingNumber
NewsText_RankingTextCommand:
	dw NewsText_RankingText
NewsText_RankingMessageCommand:
	dw NewsText_RankingMessage
NewsText_RankingPrefectureCommand:
	dw NewsText_RankingPrefecture
NewsText_RankingPokemonCommand:
	dw NewsText_RankingPokemon
NewsText_RankingGenderCommand:
	dw NewsText_RankingGender
NewsText_RankingItemCommand:
	dw NewsText_RankingItem
NewsText_RankingIndicatorCommand:
	dw NewsText_RankingIndicator
NewsText_PlayerNameCommand:
	dw NewsText_PlayerName
NewsText_PlayerPrefectureCommand:
	dw NewsText_PlayerPrefecture
NewsText_PlayerPostalCodeCommand:
	dw NewsText_PlayerPostalCode
NewsText_PlayerMessageCommand:
	dw NewsText_PlayerMessage
NewsText_SwitchCommand:
	dw NewsText_Switch
NewsText_NextRowCommand:
	dw NewsText_NextRow
NewsText_NumberCommand:
	dw NewsText_Number
	assert_table_length NUM_NEWS_TEXT_COMMANDS

; The dispatcher rejects $10, so this duplicate entry is unreachable.
	dw NewsText_Number
