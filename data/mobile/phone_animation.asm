MobilePhoneAnimations:
	table_width 2
	dw MobilePhoneAnimation_Dialing
	dw MobilePhoneAnimation_Signal
	dw MobilePhoneAnimation_Idle
	dw MobilePhoneAnimation_SignalReverse
	assert_table_length NUM_MOBILE_PHONE_ANIMS

; Frame index (see MobilePhoneFrames), duration in frames
MobilePhoneAnimation_Dialing:
	db MOBILE_PHONE_FRAME_DIALING_1, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_DIALING_2, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_DIALING_3, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_DIALING_4, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_DIALING_5, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_ANIM_END

MobilePhoneAnimation_Signal:
	db MOBILE_PHONE_FRAME_SIGNAL_1, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_SIGNAL_2, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_SIGNAL_3, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_SIGNAL_4, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_SIGNAL_5, MOBILE_PHONE_FRAME_DURATION
; The signal animation falls through to this idle frame.
MobilePhoneAnimation_Idle:
	db MOBILE_PHONE_FRAME_IDLE, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_ANIM_END

MobilePhoneAnimation_SignalReverse:
	db MOBILE_PHONE_FRAME_SIGNAL_REVERSE_1, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_SIGNAL_REVERSE_2, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_SIGNAL_REVERSE_3, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_SIGNAL_REVERSE_4, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_SIGNAL_REVERSE_5, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_FRAME_IDLE, MOBILE_PHONE_FRAME_DURATION
	db MOBILE_PHONE_ANIM_END

MobilePhoneFrames:
	table_width 2
	dw MobilePhoneFrame_Idle
	dw MobilePhoneFrame_Signal1
	dw MobilePhoneFrame_Signal2
	dw MobilePhoneFrame_Signal3
	dw MobilePhoneFrame_Dialing1
	dw MobilePhoneFrame_Dialing2
	dw MobilePhoneFrame_Dialing3
	dw MobilePhoneFrame_Dialing4
	dw MobilePhoneFrame_Dialing5
	dw MobilePhoneFrame_Signal4
	dw MobilePhoneFrame_Signal5
	dw MobilePhoneFrame_SignalReverse1
	dw MobilePhoneFrame_SignalReverse2
	dw MobilePhoneFrame_SignalReverse3
	dw MobilePhoneFrame_SignalReverse4
	dw MobilePhoneFrame_SignalReverse5
	assert_table_length NUM_MOBILE_PHONE_FRAMES

MobilePhoneFrame_Idle:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobilePhoneFrame_Signal1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   1,   0, 0, 0, MOBILE_PHONE_TILE + 4, $00
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobilePhoneFrame_Signal2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   1,   0, 0, 0, MOBILE_PHONE_TILE + 5, $00
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobilePhoneFrame_Signal3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   1,   0, 0, 0, MOBILE_PHONE_TILE + 6, $00
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobilePhoneFrame_Dialing1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   0,   0, 0, 0, MOBILE_PHONE_TILE + 7, $01
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 8, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 13, $00
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 9, $00
	dbsprite   2,   2, 0, 0, MOBILE_PHONE_TILE + 10, $00
	dbsprite   1,   3, 0, 0, MOBILE_PHONE_TILE + 11, $00
	dbsprite   2,   3, 0, 0, MOBILE_PHONE_TILE + 12, $00
.End:

MobilePhoneFrame_Dialing2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   0,   0, 0, 0, MOBILE_PHONE_TILE + 7, $01
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 8, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 14, $00
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 9, $00
	dbsprite   2,   2, 0, 0, MOBILE_PHONE_TILE + 10, $00
	dbsprite   1,   3, 0, 0, MOBILE_PHONE_TILE + 11, $00
	dbsprite   2,   3, 0, 0, MOBILE_PHONE_TILE + 12, $00
.End:

MobilePhoneFrame_Dialing3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   0,   0, 0, 0, MOBILE_PHONE_TILE + 7, $01
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 8, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 15, $00
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 9, $00
	dbsprite   2,   2, 0, 0, MOBILE_PHONE_TILE + 10, $00
	dbsprite   1,   3, 0, 0, MOBILE_PHONE_TILE + 11, $00
	dbsprite   2,   3, 0, 0, MOBILE_PHONE_TILE + 12, $00
.End:

MobilePhoneFrame_Dialing4:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   0,   0, 0, 0, MOBILE_PHONE_TILE + 7, $01
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 8, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 16, $00
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 9, $00
	dbsprite   2,   2, 0, 0, MOBILE_PHONE_TILE + 10, $00
	dbsprite   1,   3, 0, 0, MOBILE_PHONE_TILE + 11, $00
	dbsprite   2,   3, 0, 0, MOBILE_PHONE_TILE + 12, $00
.End:

MobilePhoneFrame_Dialing5:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   0,   0, 0, 0, MOBILE_PHONE_TILE + 7, $01
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 8, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 17, $00
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 9, $00
	dbsprite   2,   2, 0, 0, MOBILE_PHONE_TILE + 10, $00
	dbsprite   1,   3, 0, 0, MOBILE_PHONE_TILE + 11, $00
	dbsprite   2,   3, 0, 0, MOBILE_PHONE_TILE + 12, $00
.End:

MobilePhoneFrame_Signal4:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   1,   0, 0, 0, MOBILE_PHONE_TILE + 18, $00
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobilePhoneFrame_Signal5:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   1,   0, 0, 0, MOBILE_PHONE_TILE + 19, $00
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobilePhoneFrame_SignalReverse1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   1,   0, 0, 1, MOBILE_PHONE_TILE + 4, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobilePhoneFrame_SignalReverse2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   1,   0, 0, 1, MOBILE_PHONE_TILE + 5, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobilePhoneFrame_SignalReverse3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   1,   0, 0, 1, MOBILE_PHONE_TILE + 6, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobilePhoneFrame_SignalReverse4:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   1,   0, 0, 1, MOBILE_PHONE_TILE + 18, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobilePhoneFrame_SignalReverse5:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite   1,   0, 0, 1, MOBILE_PHONE_TILE + 19, OAM_XFLIP | OAM_YFLIP
	dbsprite   0,   1, 0, 0, MOBILE_PHONE_TILE + 0, $01
	dbsprite   1,   1, 0, 0, MOBILE_PHONE_TILE + 1, $01
	dbsprite   0,   2, 0, 0, MOBILE_PHONE_TILE + 2, $01
	dbsprite   1,   2, 0, 0, MOBILE_PHONE_TILE + 3, $01
.End:

MobileDialingGFX::
INCBIN "gfx/mobile/dialing.2bpp"
.End:
