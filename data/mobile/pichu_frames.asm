MobilePichuFrames:
	table_width 2
	dw MobilePichuFrame_Left1
	dw MobilePichuFrame_Left2
	dw MobilePichuFrame_Left3
	dw MobilePichuFrame_Left4
	dw MobilePichuFrame_Right1
	dw MobilePichuFrame_Right2
	dw MobilePichuFrame_Right3
	dw MobilePichuFrame_Right4
	dw MobilePichuFrame_AppearUpper1
	dw MobilePichuFrame_AppearUpper2
	dw MobilePichuFrame_AppearUpper3
	dw MobilePichuFrame_AppearUpper4
	dw MobilePichuFrame_AppearUpper5
	dw MobilePichuFrame_AppearUpper6
	dw MobilePichuFrame_AppearLower1
	dw MobilePichuFrame_AppearLower2
	dw MobilePichuFrame_AppearLower3
	dw MobilePichuFrame_AppearLower4
	dw MobilePichuFrame_AppearLower5
	dw MobilePichuFrame_AppearLower6
	dw MobilePichuFrame_Up1
	dw MobilePichuFrame_Up2
	dw MobilePichuFrame_Up3
	dw MobilePichuFrame_Down1
	dw MobilePichuFrame_Down2
	dw MobilePichuFrame_Down3
	dw MobilePichuFrame_Down4
	dw MobilePichuFrame_Down5
	dw MobilePichuFrame_Finish1
	dw MobilePichuFrame_Finish2
	dw MobilePichuFrame_Finish3
	dw MobilePichuFrame_Finish4
	dw MobilePichuFrame_Finish5
	dw MobilePichuFrame_Finish6
	dw MobilePichuFrame_Finish7
	dw MobilePichuFrame_Finish8
	dw MobilePichuFrame_Ball1
	dw MobilePichuFrame_Ball2
	dw MobilePichuFrame_Ball3
	dw MobilePichuFrame_Ball4
	dw MobilePichuFrame_Ball5
	dw MobilePichuFrame_Ball6
	dw MobilePichuFrame_Ball7
	dw MobilePichuFrame_Ball8
	dw MobilePichuFrame_Ball9
	dw MobilePichuFrame_Ball10
	dw MobilePichuFrame_Ball11
	assert_table_length NUM_MOBILE_PICHU_FRAMES

MobilePichuFrame_Left1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $01, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $02, OAM_BANK1 | 5
	dbsprite  2,  0, 0, 0, $03, OAM_BANK1 | 5
	dbsprite  3,  0, 0, 0, $04, OAM_BANK1 | 5
	dbsprite  0,  1, 0, 0, $11, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $12, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $13, OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $14, OAM_BANK1 | 5
	dbsprite  0,  2, 0, 0, $21, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $22, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $23, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $24, OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $31, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $32, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $33, OAM_BANK1 | 2
.End:

MobilePichuFrame_Left2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 1, $01, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 1, $02, OAM_BANK1 | 5
	dbsprite  2,  0, 0, 1, $03, OAM_BANK1 | 5
	dbsprite  3,  0, 0, 1, $04, OAM_BANK1 | 5
	dbsprite  0,  1, 0, 1, $11, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 1, $12, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 1, $13, OAM_BANK1 | 2
	dbsprite  3,  1, 0, 1, $14, OAM_BANK1 | 5
	dbsprite  0,  2, 0, 1, $05, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 1, $06, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 1, $07, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 1, $34, OAM_BANK1 | 2
	dbsprite  0,  3, 0, 1, $15, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 1, $16, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 1, $17, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 1, $35, OAM_BANK1 | 2
.End:

MobilePichuFrame_Left3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 1, $01, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 1, $02, OAM_BANK1 | 5
	dbsprite  2,  0, 0, 1, $03, OAM_BANK1 | 5
	dbsprite  3,  0, 0, 1, $04, OAM_BANK1 | 5
	dbsprite  0,  1, 0, 1, $11, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 1, $12, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 1, $13, OAM_BANK1 | 2
	dbsprite  3,  1, 0, 1, $14, OAM_BANK1 | 5
	dbsprite  0,  2, 0, 1, $25, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 1, $26, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 1, $27, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 1, $34, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 1, $36, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 1, $37, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 1, $35, OAM_BANK1 | 2
.End:

MobilePichuFrame_Left4:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $01, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $02, OAM_BANK1 | 5
	dbsprite  2,  0, 0, 0, $03, OAM_BANK1 | 5
	dbsprite  3,  0, 0, 0, $04, OAM_BANK1 | 5
	dbsprite  0,  1, 0, 0, $11, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $12, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $13, OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $14, OAM_BANK1 | 5
	dbsprite  0,  2, 0, 0, $10, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $20, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $30, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $24, OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $31, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $32, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $33, OAM_BANK1 | 2
.End:

MobilePichuFrame_Right1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $04, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  1,  0, 0, 0, $03, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  2,  0, 0, 0, $02, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  3,  0, 0, 0, $01, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $14, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  1,  1, 0, 0, $13, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $12, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $11, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $24, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $23, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $22, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $21, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $33, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $32, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $31, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_Right2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 1, $04, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  1,  0, 0, 1, $03, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  2,  0, 0, 1, $02, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  3,  0, 0, 1, $01, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 1, $14, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  1,  1, 0, 1, $13, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  1, 0, 1, $12, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 1, $11, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 1, $34, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 1, $07, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 1, $06, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 1, $05, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  3, 0, 1, $35, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 1, $17, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  3, 0, 1, $16, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  3, 0, 1, $15, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_Right3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 1, $04, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  1,  0, 0, 1, $03, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  2,  0, 0, 1, $02, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  3,  0, 0, 1, $01, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 1, $14, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  1,  1, 0, 1, $13, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  1, 0, 1, $12, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 1, $11, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 1, $34, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 1, $27, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 1, $26, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 1, $25, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  3, 0, 1, $35, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 1, $37, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  3, 0, 1, $36, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_Right4:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $04, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  1,  0, 0, 0, $03, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  2,  0, 0, 0, $02, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  3,  0, 0, 0, $01, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $14, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  1,  1, 0, 0, $13, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $12, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $11, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $24, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $30, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $20, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $10, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $33, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $32, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $31, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_Up1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  3, 0, 0, $00, OAM_BANK1 | 3
	dbsprite  1,  3, 0, 0, $08, OAM_BANK1 | 3
	dbsprite  2,  3, 0, 0, $5c, OAM_BANK1 | 3
	dbsprite  3,  3, 0, 0, $00, OAM_BANK1 | 3
	dbsprite  0,  2, 0, 0, $00, OAM_BANK1 | 3
	dbsprite  1,  2, 0, 0, $5d, OAM_BANK1 | 3
	dbsprite  2,  2, 0, 0, $5e, OAM_BANK1 | 3
	dbsprite  3,  2, 0, 0, $00, OAM_BANK1 | 3
	dbsprite  0,  1, 0, 0, $50, OAM_BANK1 | 3
	dbsprite  1,  1, 0, 0, $51, OAM_BANK1 | 3
	dbsprite  2,  1, 0, 0, $52, OAM_BANK1 | 3
	dbsprite  3,  1, 0, 0, $50, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  0,  0, 0, 0, $43, OAM_BANK1 | 3
	dbsprite  1,  0, 0, 0, $44, OAM_BANK1 | 3
	dbsprite  2,  0, 0, 0, $44, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  3,  0, 0, 0, $43, OAM_XFLIP | OAM_BANK1 | 3
.End:

MobilePichuFrame_Up2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  3, 0, 1, $00, OAM_BANK1 | 3
	dbsprite  1,  3, 0, 1, $18, OAM_BANK1 | 3
	dbsprite  2,  3, 0, 1, $0c, OAM_BANK1 | 3
	dbsprite  3,  3, 0, 1, $00, OAM_BANK1 | 3
	dbsprite  0,  2, 0, 1, $42, OAM_BANK1 | 3
	dbsprite  1,  2, 0, 1, $3a, OAM_BANK1 | 3
	dbsprite  2,  2, 0, 1, $3a, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  3,  2, 0, 1, $42, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  0,  1, 0, 1, $58, OAM_BANK1 | 3
	dbsprite  1,  1, 0, 1, $45, OAM_BANK1 | 3
	dbsprite  2,  1, 0, 1, $45, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  3,  1, 0, 1, $58, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  0,  0, 0, 1, $0d, OAM_BANK1 | 3
	dbsprite  1,  0, 0, 1, $44, OAM_BANK1 | 3
	dbsprite  2,  0, 0, 1, $44, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  3,  0, 0, 1, $0d, OAM_XFLIP | OAM_BANK1 | 3
.End:

MobilePichuFrame_Up3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  3, 0, 0, $00, OAM_BANK1 | 3
	dbsprite  1,  3, 0, 0, $5c, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  2,  3, 0, 0, $08, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  3,  3, 0, 0, $00, OAM_BANK1 | 3
	dbsprite  0,  2, 0, 0, $00, OAM_BANK1 | 3
	dbsprite  1,  2, 0, 0, $5e, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  2,  2, 0, 0, $5d, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  3,  2, 0, 0, $00, OAM_BANK1 | 3
	dbsprite  0,  1, 0, 0, $50, OAM_BANK1 | 3
	dbsprite  1,  1, 0, 0, $52, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  2,  1, 0, 0, $51, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  3,  1, 0, 0, $50, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  0,  0, 0, 0, $43, OAM_BANK1 | 3
	dbsprite  1,  0, 0, 0, $44, OAM_BANK1 | 3
	dbsprite  2,  0, 0, 0, $44, OAM_XFLIP | OAM_BANK1 | 3
	dbsprite  3,  0, 0, 0, $43, OAM_XFLIP | OAM_BANK1 | 3
.End:

MobilePichuFrame_Down1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  3, 0, 0, $00, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $56, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $57, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $00, OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $64, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $4a, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $4b, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $71, OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $54, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $55, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $55, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $54, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  0, 0, 0, $48, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $49, OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $49, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $48, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_Down2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  3, 0, 1, $00, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 1, $76, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 1, $77, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 1, $00, OAM_BANK1 | 2
	dbsprite  0,  2, 0, 1, $64, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 1, $69, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 1, $6a, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 1, $6b, OAM_BANK1 | 2
	dbsprite  0,  1, 0, 1, $6f, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 1, $70, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 1, $70, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 1, $6f, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  0, 0, 1, $63, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 1, $19, OAM_BANK1 | 2
	dbsprite  2,  0, 0, 1, $19, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 1, $63, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_Down3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  3, 0, 2, $6c, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 2, $6d, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 2, $6e, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 2, $00, OAM_BANK1 | 2
	dbsprite  0,  2, 0, 2, $5f, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 2, $60, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 2, $61, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 2, $62, OAM_BANK1 | 2
	dbsprite  0,  1, 0, 2, $53, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 2, $55, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 2, $55, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 2, $53, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  0, 0, 2, $46, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 2, $47, OAM_BANK1 | 2
	dbsprite  2,  0, 0, 2, $47, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 2, $46, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_Down4:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  3, 0, 1, $00, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 1, $77, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  3, 0, 1, $76, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  3, 0, 1, $00, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 1, $6b, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 1, $6a, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 1, $69, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 1, $64, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 1, $6f, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 1, $70, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 1, $70, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 1, $6f, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  0, 0, 1, $63, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 1, $19, OAM_BANK1 | 2
	dbsprite  2,  0, 0, 1, $19, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 1, $63, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_Down5:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  3, 0, 0, $00, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $57, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $56, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $00, OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $71, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $4b, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $4a, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $64, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $54, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $55, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $55, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $54, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  0, 0, 0, $48, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $49, OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $49, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $48, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_AppearUpper1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $38, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $39, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $39, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $38, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $28, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $29, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $29, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $28, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $09, OAM_YFLIP | OAM_BANK1 | 5
	dbsprite  1,  2, 0, 0, $19, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $19, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $09, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 5
.End:

MobilePichuFrame_AppearUpper2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  1,  0, 0, 0, $3b, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $3b, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $2a, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $2b, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $2b, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $2a, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $1a, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $1b, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $1b, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $1a, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $0a, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $0b, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $0b, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $0a, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_AppearUpper3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $35, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $3c, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $3d, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $3e, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $2c, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $2d, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $2e, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $2f, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $1c, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $1d, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $1e, OAM_YFLIP | OAM_BANK1 | 5
	dbsprite  3,  2, 0, 0, $1f, OAM_YFLIP | OAM_BANK1 | 5
	dbsprite  2,  3, 0, 0, $0e, OAM_YFLIP | OAM_BANK1 | 5
	dbsprite  3,  3, 0, 0, $0f, OAM_YFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_AppearUpper4:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $65, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $66, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $67, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $68, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $59, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $5a, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $5b, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $4c, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $4d, OAM_YFLIP | OAM_BANK1 | 5
	dbsprite  2,  2, 0, 0, $4e, OAM_YFLIP | OAM_BANK1 | 5
	dbsprite  3,  2, 0, 0, $4f, OAM_YFLIP | OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $3f, OAM_YFLIP | OAM_BANK1 | 5
	dbsprite  1,  3, 0, 0, $40, OAM_YFLIP | OAM_BANK1 | 5
	dbsprite  2,  3, 0, 0, $41, OAM_YFLIP | OAM_BANK1 | 5
.End:

MobilePichuFrame_AppearUpper5:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $3e, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $3d, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $3c, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $35, OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $2f, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $2e, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $2d, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $2c, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $1f, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  1,  2, 0, 0, $1e, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  2,  2, 0, 0, $1d, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $1c, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $0f, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $0e, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 5
.End:

MobilePichuFrame_AppearUpper6:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $68, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $67, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $66, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $65, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $5b, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $5a, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $59, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $4f, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $4e, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  2,  2, 0, 0, $4d, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  3,  2, 0, 0, $4c, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $41, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  2,  3, 0, 0, $40, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  3,  3, 0, 0, $3f, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 5
.End:

MobilePichuFrame_AppearLower1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  1, 0, 0, $09, OAM_BANK1 | 5
	dbsprite  1,  1, 0, 0, $19, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $19, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $09, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  0,  2, 0, 0, $28, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $29, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $29, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $28, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $38, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $39, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $39, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $38, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_AppearLower2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $0a, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $0b, OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $0b, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $0a, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $1a, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $1b, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $1b, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $1a, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $2a, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $2b, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $2b, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $2a, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $3b, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $3b, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_AppearLower3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  2,  0, 0, 0, $0e, OAM_BANK1 | 5
	dbsprite  3,  0, 0, 0, $0f, OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $1c, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $1d, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $1e, OAM_BANK1 | 5
	dbsprite  3,  1, 0, 0, $1f, OAM_BANK1 | 5
	dbsprite  0,  2, 0, 0, $2c, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $2d, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $2e, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $2f, OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $35, OAM_YFLIP | OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $3c, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $3d, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $3e, OAM_BANK1 | 2
.End:

MobilePichuFrame_AppearLower4:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $3f, OAM_BANK1 | 5
	dbsprite  1,  0, 0, 0, $40, OAM_BANK1 | 5
	dbsprite  2,  0, 0, 0, $41, OAM_BANK1 | 5
	dbsprite  0,  1, 0, 0, $4c, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $4d, OAM_BANK1 | 5
	dbsprite  2,  1, 0, 0, $4e, OAM_BANK1 | 5
	dbsprite  3,  1, 0, 0, $4f, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $59, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $5a, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $5b, OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $65, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $66, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $67, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $68, OAM_BANK1 | 2
.End:

MobilePichuFrame_AppearLower5:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $0f, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $0e, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  0,  1, 0, 0, $1f, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  1,  1, 0, 0, $1e, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  2,  1, 0, 0, $1d, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $1c, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $2f, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $2e, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $2d, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $2c, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $3e, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $3d, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $3c, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $35, OAM_YFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_AppearLower6:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  1,  0, 0, 0, $41, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  2,  0, 0, 0, $40, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  3,  0, 0, 0, $3f, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  0,  1, 0, 0, $4f, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $4e, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  2,  1, 0, 0, $4d, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  3,  1, 0, 0, $4c, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $5b, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $5a, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $59, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $68, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $67, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $66, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $65, OAM_XFLIP | OAM_BANK1 | 2
.End:

MobilePichuFrame_Finish1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0, -1, 0, 2, $72, OAM_BANK1 | 2
	dbsprite  1, -1, 0, 2, $73, OAM_BANK1 | 5
	dbsprite  2, -1, 0, 2, $74, OAM_BANK1 | 5
	dbsprite  3, -1, 0, 2, $75, OAM_BANK1 | 5
	dbsprite  0,  0, 0, 2, $81, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 2, $82, OAM_BANK1 | 2
	dbsprite  2,  0, 0, 2, $83, OAM_BANK1 | 2
	dbsprite  3,  0, 0, 2, $84, OAM_BANK1 | 2
	dbsprite  0,  1, 0, 2, $91, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 2, $92, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 2, $93, OAM_BANK1 | 2
	dbsprite  3,  1, 0, 2, $94, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 2, $a3, OAM_BANK1 | 2
.End:

MobilePichuFrame_Finish2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0, -1, 0, 5, $85, OAM_BANK1 | 5
	dbsprite  1, -1, 0, 5, $86, OAM_BANK1 | 5
	dbsprite  0,  0, 0, 5, $95, OAM_BANK1 | 5
	dbsprite  1,  0, 0, 5, $96, OAM_BANK1 | 2
	dbsprite  2,  0, 0, 5, $97, OAM_BANK1 | 2
	dbsprite  3,  0, 0, 5, $98, OAM_BANK1 | 2
	dbsprite  0,  1, 0, 5, $a5, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 5, $a6, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 5, $a7, OAM_BANK1 | 2
	dbsprite  3,  1, 0, 5, $a8, OAM_BANK1 | 2
	dbsprite  0,  2, 0, 5, $b3, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 5, $b4, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 5, $b5, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 5, $b6, OAM_BANK1 | 2
.End:

MobilePichuFrame_Finish3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  1, 0, 0, $79, OAM_BANK1 | 5
	dbsprite  1,  1, 0, 0, $7a, OAM_BANK1 | 5
	dbsprite  2,  1, 0, 0, $7b, OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $7c, OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $89, OAM_BANK1 | 5
	dbsprite  1,  2, 0, 0, $8a, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $8b, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $8c, OAM_BANK1 | 2
	dbsprite  0,  3, 0, 0, $99, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $9a, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $9b, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $9c, OAM_BANK1 | 2
.End:

MobilePichuFrame_Finish4:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  1, 0, 0, $7d, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $7e, OAM_BANK1 | 5
	dbsprite  2,  1, 0, 0, $7f, OAM_BANK1 | 5
	dbsprite  3,  1, 0, 0, $80, OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $8d, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $8e, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $8f, OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $90, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $9e, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $9f, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $a0, OAM_BANK1 | 2
.End:

MobilePichuFrame_Finish5:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $a1, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $a2, OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $a2, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $a1, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $b1, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $b2, OAM_BANK1 | 5
	dbsprite  2,  1, 0, 0, $b2, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  3,  1, 0, 0, $b1, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $ab, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $ac, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $ac, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $ab, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $a4, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $87, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $88, OAM_BANK1 | 2
.End:

MobilePichuFrame_Finish6:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $a1, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $a2, OAM_BANK1 | 5
	dbsprite  2,  0, 0, 0, $a2, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $a1, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $b1, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $78, OAM_BANK1 | 5
	dbsprite  2,  1, 0, 0, $78, OAM_XFLIP | OAM_BANK1 | 5
	dbsprite  3,  1, 0, 0, $b1, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $ab, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $ac, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $ac, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $ab, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $a4, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $87, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $88, OAM_BANK1 | 2
.End:

MobilePichuFrame_Finish7:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $a9, OAM_BANK1 | 2
	dbsprite  1,  0, 0, 0, $aa, OAM_BANK1 | 2
	dbsprite  2,  0, 0, 0, $aa, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  0, 0, 0, $a9, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  1, 0, 0, $b7, OAM_BANK1 | 2
	dbsprite  1,  1, 0, 0, $b8, OAM_BANK1 | 2
	dbsprite  2,  1, 0, 0, $b8, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  1, 0, 0, $b7, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  0,  2, 0, 0, $ab, OAM_BANK1 | 2
	dbsprite  1,  2, 0, 0, $ac, OAM_BANK1 | 2
	dbsprite  2,  2, 0, 0, $ac, OAM_XFLIP | OAM_BANK1 | 2
	dbsprite  3,  2, 0, 0, $ad, OAM_BANK1 | 2
	dbsprite  1,  3, 0, 0, $a4, OAM_BANK1 | 2
	dbsprite  2,  3, 0, 0, $ba, OAM_BANK1 | 2
	dbsprite  3,  3, 0, 0, $bb, OAM_BANK1 | 2
.End:

MobilePichuFrame_Finish8:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  0, 0, 0, $ae, OAM_BANK1 | 4
	dbsprite  1,  0, 0, 0, $af, OAM_BANK1 | 4
	dbsprite  2,  0, 0, 0, $af, OAM_XFLIP | OAM_BANK1 | 4
	dbsprite  3,  0, 0, 0, $ae, OAM_XFLIP | OAM_BANK1 | 4
	dbsprite  0,  1, 0, 0, $bc, OAM_BANK1 | 4
	dbsprite  1,  1, 0, 0, $bd, OAM_BANK1 | 4
	dbsprite  2,  1, 0, 0, $bd, OAM_XFLIP | OAM_BANK1 | 4
	dbsprite  3,  1, 0, 0, $bc, OAM_XFLIP | OAM_BANK1 | 4
	dbsprite  0,  2, 0, 0, $bf, OAM_BANK1 | 4
	dbsprite  1,  2, 0, 0, $9d, OAM_BANK1 | 4
	dbsprite  2,  2, 0, 0, $9d, OAM_XFLIP | OAM_BANK1 | 4
	dbsprite  3,  2, 0, 0, $b0, OAM_BANK1 | 4
	dbsprite  1,  3, 0, 0, $b9, OAM_BANK1 | 4
	dbsprite  2,  3, 0, 0, $c0, OAM_BANK1 | 4
	dbsprite  3,  3, 0, 0, $be, OAM_BANK1 | 4
.End:

MobilePichuFrame_Ball1:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 4, $1f, 6
	dbsprite  1,  2, 0, 4, $20, 6
	dbsprite  2,  2, 0, 4, $21, 6
	dbsprite  0,  1, 0, 4, $10, 6
	dbsprite  1,  1, 0, 4, $11, 6
	dbsprite  2,  1, 0, 4, $12, 6
	dbsprite  0,  0, 0, 4, $01, 6
	dbsprite  1,  0, 0, 4, $02, 6
	dbsprite  2,  0, 0, 4, $03, 6
.End:

MobilePichuFrame_Ball2:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 4, $22, 6
	dbsprite  1,  2, 0, 4, $23, 6
	dbsprite  2,  2, 0, 4, $24, 6
	dbsprite  0,  1, 0, 4, $13, 6
	dbsprite  1,  1, 0, 4, $14, 6
	dbsprite  2,  1, 0, 4, $15, 6
	dbsprite  0,  0, 0, 4, $04, 6
	dbsprite  1,  0, 0, 4, $05, 6
	dbsprite  2,  0, 0, 4, $06, 6
.End:

MobilePichuFrame_Ball3:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 4, $25, 6
	dbsprite  1,  2, 0, 4, $26, 6
	dbsprite  2,  2, 0, 4, $27, 6
	dbsprite  0,  1, 0, 4, $16, 6
	dbsprite  1,  1, 0, 4, $17, 6
	dbsprite  2,  1, 0, 4, $18, 6
	dbsprite  0,  0, 0, 4, $07, 6
	dbsprite  1,  0, 0, 4, $08, 6
	dbsprite  2,  0, 0, 4, $09, 6
.End:

MobilePichuFrame_Ball4:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 4, $28, 6
	dbsprite  1,  2, 0, 4, $29, 6
	dbsprite  2,  2, 0, 4, $2a, 6
	dbsprite  0,  1, 0, 4, $19, 6
	dbsprite  1,  1, 0, 4, $1a, 6
	dbsprite  2,  1, 0, 4, $1b, 6
	dbsprite  0,  0, 0, 4, $0a, 6
	dbsprite  1,  0, 0, 4, $0b, 6
	dbsprite  2,  0, 0, 4, $0c, 6
.End:

MobilePichuFrame_Ball5:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 4, $2b, 6
	dbsprite  1,  2, 0, 4, $2c, 6
	dbsprite  2,  2, 0, 4, $2d, 6
	dbsprite  0,  1, 0, 4, $1c, 6
	dbsprite  1,  1, 0, 4, $1d, 6
	dbsprite  2,  1, 0, 4, $1e, 6
	dbsprite  0,  0, 0, 4, $0d, 6
	dbsprite  1,  0, 0, 4, $0e, 6
	dbsprite  2,  0, 0, 4, $0f, 6
.End:

MobilePichuFrame_Ball6:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 4, $47, 6
	dbsprite  1,  2, 0, 4, $48, 6
	dbsprite  2,  2, 0, 4, $49, 6
	dbsprite  0,  1, 0, 4, $3b, 6
	dbsprite  1,  1, 0, 4, $3c, 6
	dbsprite  2,  1, 0, 4, $3b, OAM_XFLIP | 6
	dbsprite  0,  0, 0, 4, $2e, 6
	dbsprite  1,  0, 0, 4, $2f, 6
	dbsprite  2,  0, 0, 4, $30, 6
.End:

MobilePichuFrame_Ball7:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 4, $35, 6
	dbsprite  1,  2, 0, 4, $4a, 6
	dbsprite  2,  2, 0, 4, $35, 6
	dbsprite  0,  1, 0, 4, $3d, 6
	dbsprite  1,  1, 0, 4, $35, 6
	dbsprite  2,  1, 0, 4, $3d, OAM_XFLIP | 6
	dbsprite  0,  0, 0, 4, $31, 6
	dbsprite  1,  0, 0, 4, $32, 6
	dbsprite  2,  0, 0, 4, $31, OAM_XFLIP | 6
.End:

MobilePichuFrame_Ball8:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 4, $4b, 6
	dbsprite  1,  2, 0, 4, $4c, 6
	dbsprite  2,  2, 0, 4, $4d, 6
	dbsprite  0,  1, 0, 4, $3e, 6
	dbsprite  1,  1, 0, 4, $3f, 6
	dbsprite  2,  1, 0, 4, $40, 6
	dbsprite  0,  0, 0, 4, $33, 6
	dbsprite  1,  0, 0, 4, $34, 6
	dbsprite  2,  0, 0, 4, $35, 6
.End:

MobilePichuFrame_Ball9:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 4, $4e, 6
	dbsprite  1,  2, 0, 4, $4f, 6
	dbsprite  2,  2, 0, 4, $50, 6
	dbsprite  0,  1, 0, 4, $41, 6
	dbsprite  1,  1, 0, 4, $42, 6
	dbsprite  2,  1, 0, 4, $43, 6
	dbsprite  0,  0, 0, 4, $35, 6
	dbsprite  1,  0, 0, 4, $36, 6
	dbsprite  2,  0, 0, 4, $37, 6
.End:

MobilePichuFrame_Ball10:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 4, $51, 6
	dbsprite  1,  2, 0, 4, $52, 6
	dbsprite  2,  2, 0, 4, $35, 6
	dbsprite  0,  1, 0, 4, $44, 6
	dbsprite  1,  1, 0, 4, $45, 6
	dbsprite  2,  1, 0, 4, $46, 6
	dbsprite  0,  0, 0, 4, $38, 6
	dbsprite  1,  0, 0, 4, $39, 6
	dbsprite  2,  0, 0, 4, $3a, 6
.End:

MobilePichuFrame_Ball11:
	db (.End - .OAM) / OBJ_SIZE
.OAM:
	dbsprite  0,  2, 0, 0, $00, 2
	dbsprite  1,  2, 0, 0, $00, 2
	dbsprite  2,  2, 0, 0, $00, 2
	dbsprite  0,  1, 0, 0, $00, 2
	dbsprite  1,  1, 0, 0, $00, 2
	dbsprite  2,  1, 0, 4, $1f, 6
	dbsprite  0,  0, 0, 0, $00, 2
	dbsprite  1,  0, 0, 0, $00, 2
	dbsprite  2,  0, 0, 4, $10, 6
.End:
