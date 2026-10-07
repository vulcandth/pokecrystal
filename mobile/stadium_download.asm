MobileStadium_ParseIndex:
	ld a, [wMobileDownloadFlags]
	and MOBILE_DOWNLOAD_OVERFLOW
	jr z, .read_date
	ld a, MOBILE_ERROR_INVALID_DOWNLOAD
	jp SetMobileErrorCode
.read_date
	xor a
	ld [wMobileStadiumHasActiveEntry], a
	call Mobile_GetHTTPDateWeekday
	ld a, b
	ld [wMobileHTTPDateWeekday], a
	call Mobile_GetHTTPDateTime
	ld a, [wMobileReceiveBufferData]
	ld hl, wMobileReceiveBufferData + 1

MobileStadium_ParseIndexEntry:
; Each entry has start/end weekdays, start hour/minute, end hour/minute,
; a 16-byte ID, two signature bytes, a checksum, and a length-prefixed URL.
	push af
	ld a, [hli]
	ld [wMobileStadiumStartWeekday], a
	ld a, [hli]
	ld [wMobileStadiumEndWeekday], a
	ld a, [hli]
	ld [wMobileStadiumStartHour], a
	ld a, [hli]
	ld [wMobileStadiumStartMinute], a
	ld a, [hli]
	ld [wMobileStadiumEndHour], a
	ld a, [hli]
	ld [wMobileStadiumEndMinute], a
	push hl
	ld a, [wMobileStadiumStartWeekday]
	cp MOBILE_STADIUM_TIME_WILDCARD
	jr z, .compare_window_bounds
	ld a, [wMobileStadiumStartMinute]
	cp MOBILE_STADIUM_TIME_WILDCARD
	jr z, .compare_window_bounds
	ld a, [wMobileStadiumStartHour]
	cp MOBILE_STADIUM_TIME_WILDCARD
	jr nz, .compare_window_bounds
	call MobileStadium_CheckWeekdayMinuteWindow
	jr c, .active_entry
	jr .inactive_entry
.compare_window_bounds
	ld hl, wMobileStadiumStartWeekday
	ld de, wMobileStadiumEndWeekday
	ld c, MOBILE_STADIUM_TIME_FIELDS
.compare_bounds
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr c, .wrapping_window
	jr z, .next_bound_field
	jr nc, .check_start
.next_bound_field
	dec c
	jr nz, .compare_bounds
.check_start
	ld c, MOBILE_STADIUM_TIME_FIELDS
	ld hl, wMobileHTTPDateWeekday
	ld de, wMobileStadiumStartWeekday
.compare_start
	ld a, [de]
	inc de
	cp MOBILE_STADIUM_TIME_WILDCARD
	jr z, .next_start_field
	cp [hl]
	jr z, .next_start_field
	jr c, .check_end
	jr nc, .inactive_entry
.next_start_field
	inc hl
	dec c
	jr nz, .compare_start
.check_end
	ld c, MOBILE_STADIUM_TIME_FIELDS
	ld hl, wMobileHTTPDateWeekday
	ld de, wMobileStadiumEndWeekday
.compare_end
	ld a, [de]
	inc de
	cp MOBILE_STADIUM_TIME_WILDCARD
	jr z, .next_end_field
	cp [hl]
	jr c, .inactive_entry
	jr z, .next_end_field
	jr nc, .active_entry
.next_end_field
	inc hl
	dec c
	jr nz, .compare_end
	jr .active_entry
.inactive_entry
	pop hl
	jr .skip_metadata
.wrapping_window
	ld c, MOBILE_STADIUM_TIME_FIELDS
	ld hl, wMobileHTTPDateWeekday
	ld de, wMobileStadiumStartWeekday
.compare_wrapping_start
	ld a, [de]
	inc de
	cp MOBILE_STADIUM_TIME_WILDCARD
	jr z, .next_wrapping_field
	cp [hl]
	jr c, .active_entry
	jr z, .next_wrapping_field
	jr nc, .check_end
.next_wrapping_field
	inc hl
	dec c
	jr nz, .compare_wrapping_start
.active_entry
	pop hl
	ld a, $1
	ld [wMobileStadiumHasActiveEntry], a
	ld a, l
	ld [wMobileStadiumEntryIDPointer], a
	ld a, h
	ld [wMobileStadiumEntryIDPointer + 1], a
	ld de, wMobileStadiumDataID
	ld c, MOBILE_STADIUM_ID_LENGTH
	ld b, $0
.compare_id
	ld a, [de]
	inc de
	cp [hl]
	inc hl
	jr nz, .next_id_byte
	inc b
.next_id_byte
	dec c
	jr nz, .compare_id
	ld a, MOBILE_STADIUM_ID_LENGTH
	cp b
	jr z, .check_signature
rept MOBILE_STADIUM_CHECKSUM_FIELD_LENGTH
	inc hl
endr
	jr .new_data
.check_signature
	ld a, [hli]
	cp LOW(MOBILE_STADIUM_CHECKSUM_SIGNATURE)
	jr nz, .skip_signature_byte
	ld a, [hli]
	cp HIGH(MOBILE_STADIUM_CHECKSUM_SIGNATURE)
	jr nz, .skip_checksum
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [wMobileStadiumChecksum]
	cp c
	jr nz, .previous_data
	ld a, [wMobileStadiumChecksum + 1]
	cp b
	jr nz, .previous_data
	jr .skip_url
.skip_signature_byte
	inc hl
.skip_checksum
	inc hl
	inc hl
	jr .skip_url
.skip_metadata
	ld de, MOBILE_STADIUM_ID_LENGTH + MOBILE_STADIUM_CHECKSUM_FIELD_LENGTH
	add hl, de
.skip_url
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	add hl, de
	pop af
	dec a
	jp nz, MobileStadium_ParseIndexEntry
	ld a, [wMobileStadiumHasActiveEntry]
	and a
	jr z, .no_active_entries
	ld a, MOBILE_STADIUM_DOWNLOAD_NO_NEW_DATA
	ld [wMobileConnectionJumptableIndex], a
	ret
.no_active_entries
	ld a, MOBILE_ERROR_STADIUM_INDEX
	jp SetMobileErrorCode
.previous_data
	ld a, MOBILE_STADIUM_DOWNLOAD_PREVIOUS_DATA
	jr .select_entry
.new_data
	ld a, MOBILE_STADIUM_DOWNLOAD_NEW_DATA
.select_entry
	ld [wMobileConnectionJumptableIndex], a
	pop af
	call MobileStadium_CopyDownloadURLAndID
	ret

MobileStadium_CheckWeekdayMinuteWindow:
; The start weekday/minute are specified, but the start hour is a wildcard.
; Test the weekday and minute ranges separately, including wraparound.
; Return carry if both ranges include the current HTTP date.
	ld a, [wMobileStadiumStartWeekday]
	ld b, a
	ld a, [wMobileStadiumEndWeekday]
	ld c, a
	cp b
	jr c, .wrapping_weekdays
	ld a, [wMobileHTTPDateWeekday]
	cp b
	jr c, .inactive
.check_end_weekday
	cp c
	jr c, .check_minutes
	jr z, .check_minutes
	jr .inactive
.wrapping_weekdays
	ld a, [wMobileHTTPDateWeekday]
	cp b
	jr c, .check_end_weekday
.check_minutes
	ld a, [wMobileStadiumStartMinute]
	ld b, a
	ld a, [wMobileStadiumEndMinute]
	ld c, a
	cp b
	jr c, .wrapping_minutes
	ld a, [wMobileHTTPDateMinute]
	cp b
	jr c, .inactive
.check_end_minute
	cp c
	jr c, .active
	jr z, .active
	jr .inactive
.wrapping_minutes
	ld a, [wMobileHTTPDateMinute]
	cp b
	jr c, .check_end_minute
.active
	scf
	ret
.inactive
	and a
	ret

MobileStadium_CopyDownloadURLAndID:
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld de, MOBILE_URL_MAX_LENGTH
	ld a, b
	cp d
	jr c, .copy_url
	jr z, .check_length_low
	jr nc, .url_too_long
.check_length_low
	ld a, c
	cp e
	jr z, .copy_url
	jr nc, .url_too_long
.copy_url
	ld de, wMobileHTTPURL
	call CopyBytes
	xor a
	ld [de], a
	ld a, [wMobileStadiumEntryIDPointer]
	ld l, a
	ld a, [wMobileStadiumEntryIDPointer + 1]
	ld h, a
	ld de, wMobileStadiumDataID
	ld bc, MOBILE_STADIUM_ID_LENGTH
	call CopyBytes
	ret
.url_too_long
	ld a, MOBILE_ERROR_STADIUM_INDEX
	jp SetMobileErrorCode

MobileStadium_NewDataMessage:
	ld a, MOBILE_DIALOG_NEW_DATA
	ld [wMobileDialogJumptableIndex], a
	ld a, MOBILE_STADIUM_DOWNLOAD_CANCEL
	ld [wMobileDialogCancelState], a
	ld a, MOBILE_STADIUM_DOWNLOAD_NEW_DATA
	ld [wMobileDialogResumeState], a
	ld a, MOBILE_STADIUM_DOWNLOAD_LOGOUT
	ld [wMobileDialogCancelConfirmState], a
	call Mobile_IncrementConnectionState
	jp Mobile_IncrementConnectionState

MobileStadium_PreviousDataMessage:
	ld a, MOBILE_DIALOG_PREVIOUSLY_DOWNLOADED
	ld [wMobileDialogJumptableIndex], a
	ld a, MOBILE_STADIUM_DOWNLOAD_CANCEL
	ld [wMobileDialogCancelState], a
	ld a, MOBILE_STADIUM_DOWNLOAD_PREVIOUS_DATA
	ld [wMobileDialogResumeState], a
	ld a, MOBILE_STADIUM_DOWNLOAD_LOGOUT
	ld [wMobileDialogCancelConfirmState], a
	jp Mobile_IncrementConnectionState

MobileStadium_ConfirmDownload:
	call MobileConnectionDialog
	ret c
	ld a, LOW(wMobileHTTPURL)
	ld l, a
	ld a, HIGH(wMobileHTTPURL)
	ld h, a
	call Mobile_ParseDownloadFee
	ld a, MOBILE_DIALOG_DOWNLOAD_FEE_INTRO
	ld [wMobileDialogJumptableIndex], a
	ld a, MOBILE_STADIUM_DOWNLOAD_CANCEL
	ld [wMobileDialogCancelState], a
	ld a, MOBILE_STADIUM_DOWNLOAD_LOGOUT
	ld [wMobileDialogCancelConfirmState], a
	call Mobile_IncrementConnectionState

MobileStadium_HTTPGetData:
	call MobileConnectionDialog
	ret c
	call DelayFrame
	ld a, MOBILE_DIALOG_COMMUNICATING
	ld [wMobileDialogJumptableIndex], a
	call MobileConnectionDialog
	call Mobile_BuildHTTPGetParameters
	ld de, wMobileReceiveBuffer
	ld bc, MOBILE_RECEIVE_BUFFER_SIZE
	ld a, MOBILEAPI_HTTPGET
	jp Mobile_CallAPIAndAdvanceState

MobileStadium_CancelDownloadMessage:
	ld a, MOBILE_DIALOG_CANCEL_DOWNLOAD
	ld [wMobileDialogJumptableIndex], a
	call Mobile_IncrementConnectionState

MobileStadium_WaitCancelDownload:
	call MobileConnectionDialog
	ret c
	ld a, [wMobileDialogCancelConfirmState]
	ld [wMobileConnectionJumptableIndex], a
	ld a, MOBILE_RESULT_CANCELED
	ld [wMobileErrorCodeBuffer], a
	ret

MobileStadium_NoNewDataMessage:
	ld a, MOBILE_DIALOG_NO_NEW_DATA
	ld [wMobileDialogJumptableIndex], a
	call Mobile_IncrementConnectionState

MobileStadium_WaitNoNewData:
	call MobileConnectionDialog
	ret c
	ld a, MOBILE_STADIUM_DOWNLOAD_LOGOUT
	ld [wMobileConnectionJumptableIndex], a
	ld a, MOBILE_RESULT_CANCELED
	ld [wMobileErrorCodeBuffer], a
	ret
