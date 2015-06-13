;/*
;  IEEE 754 Compliant Floating Point Routines MICROCHIP
;*/
#include <headers/math_18.inc>
mObject_var	THIS

	AEXP		res	0	;// первая байт float
	EXP			res	1
	SIGN		res	1

	ACCB0		res	0
	AARGB0		res	0	;// второй
	AARG		res	0
	ACC			res	1

	ACCB1		res	0
	AARGB1		res	1	;// третий

	ACCB2		res	0
	AARGB2		res	1	;// четвертый

	ACCB3		res	0
	AARGB3		res	1

	ACCB4		res	0
	AARGB4		res	0
	REMB0		res	1

	ACCB5		res	0
	AARGB5		res	0
	REMB1		res	1

	TEMP		res	1

	FPFLAGS		res	1

	BARGB3		res	1
	BARGB2		res	1
	BARGB1		res	1
	BARGB0		res	0

	BARG		res	1

	BEXP		res	1

	LOOPCOUNT	res	1
	TEMPB1		res	1

object code
;-----------------------------------
_v#v(HERE)_MATH_INI:
	
			mRETURN
;-----------------------------------
;**********************************************************************************************
;       Integer to float conversion
;       Input:  24 bit 2's complement integer right justified in AARGB0, AARGB1, AARGB2
;       Use:    CALL    FLO2432 or      CALL    FLO32
;       Output: 32 bit floating point number in AEXP, AARGB0, AARGB1, AARGB2
;       Result: AARG  <--  FLOAT( AARG )
;       Max Timing:     14+90 = 104 clks                SAT = 0
;                       14+96 = 110 clks                SAT = 1
;       Min Timing:     6+28 = 34 clks                  AARG = 0
;                       6+18 = 24 clks
;       PM: 14+38 = 52                                  DM: 7
;----------------------------------------------------------------------------------------------

;FP32			code
_v#v(HERE)_MATH_SETdw_FLO32;(void/void)
			mObject_sel	THIS
FLO2432:
FLO32:          movlw           D'23'+EXPBIAS			; initialize exponent and add bias
                movwf           EXP
                clrf            SIGN
                btfss           AARGB0,MSB				; test sign
                goto            NRM3232
                comf            AARGB2,f                ; i f  < 0, negate and set MSB in SIGN
                comf            AARGB1,f
                comf            AARGB0,f
                incf            AARGB2,f
                btfsc           _Z
                incf            AARGB1,f
                btfsc           _Z
                incf            AARGB0,f
                bsf             SIGN,MSB

;**********************************************************************************************
;       Normalization routine
;       Input:  32 bit unnormalized floating point number in AEXP, AARGB0, AARGB1,
;               AARGB2, with sign in SIGN,MSB
;       Use:    CALL    NRM3232 or      CALL    NRM32
;       Output: 32 bit normalized floating point number in AEXP, AARGB0, AARGB1, AARGB2
;       Result: AARG  <--  NORMALIZE( AARG )
;       Max Timing:     21+6+7*8+7 = 90 clks            SAT = 0
;                       21+6+7*8+1+12 = 96 clks SAT = 1
;       Min Timing:     22+6 = 28 clks                  AARG = 0
;                       5+9+4 = 18 clks
;       PM: 38                                          DM: 7
;----------------------------------------------------------------------------------------------
NRM3232:
NRM32:          CLRF            TEMP					; clear exponent decrement
                MOVF            AARGB0,W				; test i f  highbyte=0
                BTFSS           _Z
                GOTO            NORM3232
                MOVF            AARGB1,W				; i f  so, shift 8 bits by move
                MOVWF           AARGB0
                MOVF            AARGB2,W
                MOVWF           AARGB1
                CLRF            AARGB2
                BSF             TEMP,3                  ; increase decrement by 8

                MOVF            AARGB0,W				; test i f  highbyte=0
                BTFSS           _Z
                GOTO            NORM3232
                MOVF            AARGB1,W				; i f  so, shift 8 bits by move
                MOVWF           AARGB0
                CLRF            AARGB1
                BCF             TEMP,3                  ; increase decrement by 8
                BSF             TEMP,4
        
                MOVF            AARGB0,W				; i f  highbyte=0, result=0
                BTFSC           _Z
                GOTO            RES032

NORM3232        MOVF            TEMP,W
                SUBWF           EXP,F
                BTFSS           _Z
                BTFSS           _C
                GOTO            SETFUN32

                BCF             _C                      ; clear carry bit

NORM3232A       BTFSC           AARGB0,MSB				; i f  MSB=1, normalization done
                GOTO            FIXSIGN32
                RLCF            AARGB2,F                ; otherwise, shift left and 
                RLCF            AARGB1,F                ; decrement EXP
                RLCF            AARGB0,F
                DECFSZ          EXP,F
                GOTO            NORM3232A

                GOTO            SETFUN32                ; underflow i f  EXP=0

FIXSIGN32       BTFSS           SIGN,MSB
                BCF             AARGB0,MSB              ; clear explicit MSB i f  positive
                RETLW           0

RES032          CLRF            AARGB0                  ; result equals zero
                CLRF            AARGB1
                CLRF            AARGB2
				CLRF			AARGB3
                CLRF            EXP
                RETLW           0

;**********************************************************************************************
;       Float to integer conversion
;       Input:  32 bit floating point number in AEXP, AARGB0, AARGB1, AARGB2
;       Use:    CALL    INT3224         or      CALL    INT32
;       Output: 24 bit 2's complement integer right justified in AARGB0, AARGB1, AARGB2
;       Result: AARG  <--  INT( AARG )
;       Max Timing:     40+6*7+6+16 = 104 clks		RND = 0
;                       40+6*7+6+24 = 112 clks		RND = 1, SAT = 0
;                       40+6*7+6+26 = 114 clks  	RND = 1, SAT = 1
;       Min Timing:     4 clks
;       PM: 82                                          DM: 6
;----------------------------------------------------------------------------------------------
_v#v(HERE)_MATH_SETdw_INT32;(void/void)
			mObject_sel	THIS
INT3224
INT32
				MOVF			EXP,W					; test for zero argument
				BTFSC			_Z
				RETLW			0x00

				MOVF            AARGB0,W				; save sign in SIGN
                MOVWF           SIGN
                BSF             AARGB0,MSB				; make MSB explicit

                MOVLW           EXPBIAS+D'23'			; remove bias from EXP
                SUBWF           EXP,F
                BTFSS           EXP,MSB
                GOTO            SETIOV3224
				COMF			EXP,F
				INCF			EXP,F

                MOVLW           8                       ; do byte shift i f EXP >= 8
                SUBWF           EXP,W
                BTFSS           _C
                GOTO            TSHIFT3224
                MOVWF           EXP
                RLCF             AARGB2,F                ; rotate next bit for rounding
                MOVF            AARGB1,W
                MOVWF           AARGB2
                MOVF            AARGB0,W
                MOVWF           AARGB1
                CLRF            AARGB0

                MOVLW           8                       ; do another byte shift i f EXP >= 8
                SUBWF           EXP,W
                BTFSS           _C
                GOTO            TSHIFT3224
                MOVWF           EXP
                RLCF             AARGB2,F				; rotate next bit for rounding
                MOVF            AARGB1,W
                MOVWF           AARGB2
                CLRF            AARGB1

                MOVLW           8                       ; do another byte shift i f EXP >= 8
                SUBWF           EXP,W
                BTFSS           _C
                GOTO            TSHIFT3224
                MOVWF           EXP
                RLCF             AARGB2,F                ; rotate next bit for rounding
                CLRF            AARGB2
				MOVF			EXP,W
				BTFSS			_Z
				BCF				_C
				GOTO			SHIFT3224OK

TSHIFT3224      MOVF            EXP,W                   ; shift completed i f EXP = 0
                BTFSC           _Z
                GOTO            SHIFT3224OK

SHIFT3224       BCF             _C
                RRCF             AARGB0,F                ; right shift by EXP
                RRCF             AARGB1,F
                RRCF             AARGB2,F
                DECFSZ          EXP,F
                GOTO            SHIFT3224

SHIFT3224OK     BTFSC           FPFLAGS,RND
                BTFSS           AARGB2,LSB
                GOTO            INT3224OK
                BTFSS           _C
                GOTO            INT3224OK
                INCF            AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F
                BTFSC           AARGB0,MSB				; test for overflow
                GOTO            SETIOV3224

INT3224OK       BTFSS           SIGN,MSB                ; i f sign bit set, negate               
                RETLW           0
                COMF            AARGB0,F
                COMF            AARGB1,F
                COMF            AARGB2,F
                INCF            AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F
                RETLW           0

IRES03224		CLRF            AARGB0					; integer result equals zero
                CLRF            AARGB1
                CLRF            AARGB2
                RETLW           0

SETIOV3224		BSF             FPFLAGS,IOV             ; set integer overflow flag
                BTFSS           FPFLAGS,SAT             ; test for saturation
                RETLW           0xFF                    ; return error code in WREG

                CLRF            AARGB0					; saturate to largest two's
                BTFSS           SIGN,MSB                ; complement 24 bit integer
                MOVLW           0xFF
                MOVWF           AARGB0					; SIGN = 0, 0x 7F FF FF
                MOVWF           AARGB1					; SIGN = 1, 0x 80 00 00
                MOVWF           AARGB2
                RLCF             SIGN,F
                RRCF             AARGB0,F
                RETLW           0xFF                    ; return error code in WREG
;**********************************************************************************************
;       Floating Point Multiply
;       Input:  32 bit floating point number in AEXP, AARGB0, AARGB1, AARGB2
;               32 bit floating point number in BEXP, BARGB0, BARGB1, BARGB2
;       Use:    CALL    FPM32
;       Output: 32 bit floating point product in AEXP, AARGB0, AARGB1, AARGB2
;       Result: AARG  <--  AARG * BARG
;       Max Timing:     26+23*22+21+21 = 574 clks       RND = 0
;                       26+23*22+21+35 = 588 clks       RND = 1, SAT = 0
;                       26+23*22+21+38 = 591 clks       RND = 1, SAT = 1
;       Min Timing:     6+6 = 12 clks                   AARG * BARG = 0
;                       24+23*11+21+17 = 315 clks
;       PM: 94                                          DM: 14
;----------------------------------------------------------------------------------------------
_v#v(HERE)_MATH_SETdw_FPM32;(void/void)
			mObject_sel	THIS
FPM32           MOVF            AEXP,W                  ; test for zero arguments
                BTFSS           _Z
                MOVF            BEXP,W
                BTFSC           _Z
                GOTO            RES032

M32BNE0         MOVF            AARGB0,W
                XORWF           BARGB0,W
                MOVWF           SIGN                    ; save sign in SIGN

                MOVF            BEXP,W
                ADDWF           EXP,F
                MOVLW           EXPBIAS-1
                BTFSS           _C
                GOTO            MTUN32

                SUBWF           EXP,F
                BTFSC           _C
                GOTO            SETFOV32                ; set multiply overflow flag
                GOTO            MOK32

MTUN32          SUBWF           EXP,F
                BTFSS           _C
                GOTO            SETFUN32

MOK32			MOVF			AARGB0,W
				MOVWF			AARGB3
				MOVF			AARGB1,W
				MOVWF			AARGB4
				MOVF			AARGB2,W
				MOVWF			AARGB5
				BSF             AARGB3,MSB              ; make argument MSB's explicit
                BSF             BARGB0,MSB
                BCF             _C
                CLRF            AARGB0			; clear initial partial product
                CLRF            AARGB1
                CLRF            AARGB2
                MOVLW           D'24'
                MOVWF           TEMP                    ; initialize counter

MLOOP32         BTFSS           AARGB5,LSB              ; test next bit
                GOTO            MNOADD32

MADD32          MOVF            BARGB2,W
                ADDWF           AARGB2,F
                MOVF            BARGB1,W
                BTFSC           _C
                INCFSZ          BARGB1,W
                ADDWF           AARGB1,F

                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           AARGB0,F

MNOADD32        RRCF            AARGB0,F
                RRCF            AARGB1,F
                RRCF            AARGB2,F
                RRCF            AARGB3,F
                RRCF            AARGB4,F
                RRCF            AARGB5,F
                BCF             _C
                DECFSZ          TEMP,F
                GOTO            MLOOP32

                BTFSC           AARGB0,MSB               ; check for postnormalization
                GOTO            MROUND32
                RLCF            AARGB3,F
                RLCF            AARGB2,F
                RLCF            AARGB1,F
                RLCF            AARGB0,F
                DECF            EXP,F

MROUND32        BTFSC           FPFLAGS,RND
                BTFSS           AARGB2,LSB
                GOTO            MUL32OK
				BTFSS			AARGB3,MSB
                GOTO            MUL32OK
				INCF			AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F

                BTFSS           _Z                      ; has rounding caused carryout?
                GOTO            MUL32OK
                RRCF            AARGB0,F                ; i f so, right shift
                RRCF            AARGB1,F
                RRCF            AARGB2,F
                INCF            EXP,F
                BTFSC           _Z                      ; check for overflow
                GOTO            SETFOV32

MUL32OK         BTFSS           SIGN,MSB
                BCF             AARGB0,MSB		; clear explicit MSB i f positive

                RETLW           0  

SETFOV32        BSF             FPFLAGS,FOV             ; set floating point underflag
                BTFSS           FPFLAGS,SAT             ; test for saturation
                RETLW           0xFF                    ; return error code in WREG

                MOVLW           0xFF
                MOVWF           AEXP                    ; saturate to largest floating
                MOVWF           AARGB0                  ; point number = 0x FF 7F FF FF
                MOVWF           AARGB1                  ; modulo the appropriate sign bit
                MOVWF           AARGB2
                RLCF            SIGN,F
                RRCF            AARGB0,F
                RETLW           0xFF                    ; return error code in WREG

;**********************************************************************************************
;       Floating Point Divide
;       Input:  32 bit floating point dividend in AEXP, AARGB0, AARGB1, AARGB2
;               32 bit floating point divisor in BEXP, BARGB0, BARGB1, BARGB2
;       Use:    CALL    FPD32
;       Output: 32 bit floating point quotient in AEXP, AARGB0, AARGB1, AARGB2
;       Result: AARG  <--  AARG / BARG
;       Max Timing:     43+12+23*36+35+14 = 932 clks            RND = 0
;                       43+12+23*36+35+50 = 968 clks            RND = 1, SAT = 0
;                       43+12+23*36+35+53 = 971 clks            RND = 1, SAT = 1
;       Min Timing:     7+6 = 13 clks
;       PM: 155                                                 DM: 14
;----------------------------------------------------------------------------------------------
_v#v(HERE)_MATH_SETdw_FPD32;(void/void)
			mObject_sel	THIS
FPD32           MOVF            BEXP,W                  ; test for divide by zero
                BTFSC           _Z
                GOTO            SETFDZ32

                MOVF            AEXP,W
                BTFSC           _Z
                GOTO            RES032

D32BNE0         MOVF            AARGB0,W
                XORWF           BARGB0,W
                MOVWF           SIGN                    ; save sign in SIGN
                BSF             AARGB0,MSB              ; make argument MSB's explicit
                BSF             BARGB0,MSB

TALIGN32        CLRF            TEMP                    ; clear align increment
                MOVF            AARGB0,W
                MOVWF           AARGB3			; test for alignment
                MOVF            AARGB1,W
                MOVWF           AARGB4
                MOVF            AARGB2,W
                MOVWF           AARGB5

                MOVF            BARGB2,W
                SUBWF           AARGB5,F
                MOVF            BARGB1,W
                BTFSS           _C
                INCFSZ          BARGB1,W

TS1ALIGN32      SUBWF           AARGB4,F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W

TS2ALIGN32      SUBWF           AARGB3,F

                CLRF            AARGB3
                CLRF            AARGB4
                CLRF            AARGB5

                BTFSS           _C
                GOTO            DALIGN32OK

                BCF             _C                      ; align i f necessary
                RRCF            AARGB0,F
                RRCF            AARGB1,F
                RRCF            AARGB2,F
                RRCF            AARGB3,F
                MOVLW           0x01
                MOVWF           TEMP                    ; save align increment          

DALIGN32OK      MOVF            BEXP,W                  ; compare AEXP and BEXP
                SUBWF           EXP,F
                BTFSS           _C
                GOTO            ALTB32
        
AGEB32          MOVLW           EXPBIAS-1
                ADDWF           TEMP,W
                ADDWF           EXP,F
                BTFSC           _C
                GOTO            SETFOV32
                GOTO            DARGOK32                ; set overflow flag

ALTB32          MOVLW           EXPBIAS-1
                ADDWF           TEMP,W
                ADDWF           EXP,F
                BTFSS           _C
                GOTO            SETFUN32                ; set underflow flag

DARGOK32        MOVLW           D'24'			; initialize counter
                MOVWF           TEMPB1

DLOOP32         RLCF            AARGB5,F                ; left shift
                RLCF            AARGB4,F
                RLCF            AARGB3,F
                RLCF            AARGB2,F
                RLCF            AARGB1,F
                RLCF            AARGB0,F
                RLCF            TEMP,F

                MOVF            BARGB2,W                ; subtract
                SUBWF           AARGB2,F
                MOVF            BARGB1,W
                BTFSS           _C
                INCFSZ          BARGB1,W
DS132           SUBWF           AARGB1,F

                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
DS232           SUBWF           AARGB0,F

                RLCF            BARGB0,W
                IORWF           TEMP,F
                
                BTFSS           TEMP,LSB                ; test for restore
                GOTO            DREST32

                BSF             AARGB5,LSB
                GOTO            DOK32

DREST32         MOVF            BARGB2,W                ; restore i f necessary
                ADDWF           AARGB2,F
                MOVF            BARGB1,W
                BTFSC           _C
                INCFSZ          BARGB1,W
DAREST32        ADDWF           AARGB1,F

                MOVF            BARGB0,W
                BTFSC           _C
                INCF            BARGB0,W
                ADDWF           AARGB0,F

                BCF             AARGB5,LSB

DOK32           DECFSZ          TEMPB1,F
                GOTO            DLOOP32

DROUND32        BTFSC           FPFLAGS,RND
                BTFSS           AARGB5,LSB
                GOTO            DIV32OK
                BCF             _C
                RLCF            AARGB2,F               ; compute next significant bit
                RLCF            AARGB1,F               ; for rounding
                RLCF            AARGB0,F
                RLCF            TEMP,F

                MOVF            BARGB2,W               ; subtract
                SUBWF           AARGB2,F
                MOVF            BARGB1,W
                BTFSS           _C
                INCFSZ          BARGB1,W
				SUBWF           AARGB1,F

                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
				SUBWF           AARGB0,F

                RLCF            BARGB0,W
                IORWF           TEMP,W
                ANDLW           0x01            

                ADDWF           AARGB5,F
                BTFSC           _C
                INCF            AARGB4,F
                BTFSC           _Z
                INCF            AARGB3,F

                BTFSS           _Z                      ; test i f rounding caused carryout
                GOTO            DIV32OK
                RRCF            AARGB3,F
                RRCF            AARGB4,F
                RRCF            AARGB5,F
                INCF            EXP,F
                BTFSC           _Z                      ; test for overflow
                GOTO            SETFOV32


DIV32OK         BTFSS           SIGN,MSB
                BCF             AARGB3,MSB		; clear explicit MSB i f positive

                MOVF            AARGB3,W
                MOVWF           AARGB0                  ; move result to AARG
                MOVF            AARGB4,W
                MOVWF           AARGB1
                MOVF            AARGB5,W
                MOVWF           AARGB2

                RETLW           0

SETFUN32        BSF             FPFLAGS,FUN             ; set floating point underflag
                BTFSS           FPFLAGS,SAT             ; test for saturation
                RETLW           0xFF                    ; return error code in WREG

                MOVLW           0x01                    ; saturate to smallest floating
                MOVWF           AEXP                    ; point number = 0x 01 00 00 00
                CLRF            AARGB0                  ; modulo the appropriate sign bit
                CLRF            AARGB1
                CLRF            AARGB2
                RLCF            SIGN,F
                RRCF            AARGB0,F
                RETLW           0xFF                    ; return error code in WREG

SETFDZ32        BSF             FPFLAGS,FDZ             ; set divide by zero flag
                RETLW           0xFF



;************************************************************************************        
;       32/16 Bit Unsigned Fixed Point Divide 32/16 -> 32.16
;       Input:  32 bit unsigned fixed point dividend in AARGB0, AARGB1,AARGB2,AARGB3
;               16 bit unsigned fixed point divisor in BARGB0, BARGB1
;       Use:    CALL    FXD3216U
;       Output: 32 bit unsigned fixed point quotient in AARGB0, AARGB1,AARGB2,AARGB3
;               16 bit unsigned fixed point remainder in REMB0, REMB1
;       Result: AARG, REM  <--  AARG / BARG
;       Max Timing:     2+699+2 = 703 clks
;       Max Timing:     2+663+2 = 667 clks
;       PM: 2+240+1 = 243               DM: 9
;************************************************************************************
_v#v(HERE)_MATH_SETdw_FXD3216U;(void/void)
			mObject_sel	THIS
FXD3216U        CLRF            REMB0
                CLRF            REMB1

                UDIV3216L

                RETLW           0x00


;-----------------------------------
_v#v(HERE)_MATH_SETdw_mov_A_B;(void/void)
			mObject_sel	THIS
mov_A_B:
				movff			AARGB2,BARGB2
				movff			AARGB1,BARGB1
				movff			AARGB0,BARGB0
				movff			AEXP,BEXP
	mRETURN

;// Загрузка А-оперенда - загрузка только 3 ячеек??
_v#v(HERE)_MATH_SETdw_wByte_to_Aarg;(byte/void)
	mObject_sel	THIS
	movwf	AARGB2
	clrf	AARGB1
	clrf	AARGB0
	mRETURN
_v#v(HERE)_MATH_SETdw_fWord_to_Aarg;(*FSR0/void)
	mObject_sel	THIS
	movff	POSTINC0,	AARGB2
	movff	POSTINC0,	AARGB1
	clrf	AARGB0
	mRETURN
;// загрузка В-операнда - все четко! 4 ячейки
_v#v(HERE)_MATH_SETdw_fK_to_Barg;(*FSR0/void)
			mObject_sel	THIS
			movff	POSTINC0,BEXP
			movff	POSTINC0,BARGB0
			movff	POSTINC0,BARGB1
			movff	POSTINC0,BARGB2
	mRETURN
;// Загрузка операндов

;/// /// ///
;///
;/// Часто вызываются, но творят что-то странное!
;// Что она делает?
;// lfsr	0, адрес массива для заполнения?
_v#v(HERE)_MATH_SETdw_fDig_separL;(*FSR0/void)
			mObject_sel	THIS
			clrf	BARGB0
			movlw	10
			movwf	BARGB1
			
			;// вызов чего?
			call	FXD3216U
			
			;// чиатем входные данные
			movff	INDF0,FSR2L
			
			;// проводим какие-то операции
			movlw	0xF0
			andwf	FSR2L,f
			movf	REMB1,w
			iorwf	FSR2L,f
			movff	FSR2L,	INDF0	;// отправляем в память
	mRETURN

;// Что она делает?
_v#v(HERE)_MATH_SETdw_fDig_separH;(*FSR0/void)
			mObject_sel	THIS
			clrf	BARGB0
			movlw	10
			movwf	BARGB1
			
			;// вот это вызов чего
			call	FXD3216U
			movff	INDF0,	FSR2L
			swapf	FSR2L,	f
			movlw	0xF0
			andwf	FSR2L,	f
			movf	REMB1,	w
			iorwf	FSR2L,	f
			swapf	FSR2L,	f		
			movff	FSR2L,	INDF0	;// output
	mRETURN
;///
;///
;/// /// ///


;// H3 M2 L1 -> M3 L2 01
_v#v(HERE)_MATH_SETdw_shift_A;(void/void) 
			mObject_sel	THIS
			movff	AARGB2,AARGB3
			movff	AARGB1,AARGB2
			movff	AARGB0,AARGB1
			clrf	AARGB0
	mRETURN

_v#v(HERE)_MATH_SETdw_User1;(void/void)
			mObject_sel	THIS
			movlw	100
			movwf	AARGB2
			movf	AARGB3,w
			subwf	AARGB2,w
			movwf	AARGB3
			clrf	AARGB2
	mRETURN

;+andrey
_v#v(HERE)_MATH_SETdw_fAarg_toWord;(*FSR0/void)
	mObject_sel	THIS
	movff	AARGB1,INDF0
	;movff	AARGB2,INDF0
	movf	AARGB2,w
	mRETURN

;+igor
; AEXP, AARGB0, !AARGB1, !AARGB2-мл.?
math_pub_fAarg_toWord;(fsr0/fsr0)
	;mObject_sel	THIS
	movff	AARGB2,POSTINC0	; младший сохр и инкр. указатель
	movff	AARGB1,POSTDEC0	; старший и возвр указатель на начало
	mRETURN

;/// /// ///
;///
;/// процедуры суммирования

;**********************************************************************************************
;       Floating Point Add
;       Input:  32 bit floating point number in AEXP, AARGB0, AARGB1, AARGB2
;               32 bit floating point number in BEXP, BARGB0, BARGB1, BARGB2
;       Use:    CALL FPA32
;       Output: 32 bit floating point sum in AEXP, AARGB0, AARGB1, AARGB2
;       Result: AARG  <--  AARG - BARG
;       Max Timing:     31+41+6*7+6+41+90 = 251 clks            RND = 0
;                       31+41+6*7+6+55+90 = 265 clks            RND = 1, SAT = 0
;                       31+41+6*7+6+55+96 = 271 clks            RND = 1, SAT = 1
;       Min Timing:     8+4 = 12 clks
;       PM: 146                                                 DM: 14
;----------------------------------------------------------------------------------------------
_v#v(HERE)_MATH_FPA32;(void/void)
FPA32           
MOVF            AARGB0,W                ; exclusive or of signs in TEMP
                XORWF           BARGB0,W
                MOVWF           TEMP

		CLRF		AARGB3			; clear extended byte
		CLRF		BARGB3

                MOVF            AEXP,W                  ; use AARG i f AEXP >= BEXP
                SUBWF           BEXP,W
                BTFSS           _C
                GOTO            USEA32

                MOVF            BEXP,W                  ; use BARG i f AEXP < BEXP
                MOVWF           AARGB5			; therefore, swap AARG and BARG
                MOVF            AEXP,W
                MOVWF           BEXP
                MOVF            AARGB5,W
                MOVWF           AEXP

                MOVF            BARGB0,W
                MOVWF           AARGB5
                MOVF            AARGB0,W
                MOVWF           BARGB0
                MOVF            AARGB5,W
                MOVWF           AARGB0

                MOVF            BARGB1,W
                MOVWF           AARGB5
                MOVF            AARGB1,W
                MOVWF           BARGB1
                MOVF            AARGB5,W
                MOVWF           AARGB1

                MOVF            BARGB2,W
                MOVWF           AARGB5
                MOVF            AARGB2,W
                MOVWF           BARGB2
                MOVF            AARGB5,W
                MOVWF           AARGB2

USEA32          MOVF            BEXP,W                  ; return AARG i f BARG = 0
                BTFSC           _Z
                RETLW           0x00

                MOVF            AARGB0,W
                MOVWF           SIGN                    ; save sign in SIGN
                BSF             AARGB0,MSB              ; make MSB's explicit
                BSF             BARGB0,MSB

                MOVF            BEXP,W                  ; compute shift count in BEXP
                SUBWF           AEXP,W
                MOVWF           BEXP
                BTFSC           _Z
                GOTO            ALIGNED32

                MOVLW           8
                SUBWF           BEXP,W
                BTFSS           _C                      ; i f BEXP >= 8, do byte shift
                GOTO            ALIGNB32
                MOVWF           BEXP
                MOVF            BARGB2,W		; keep for postnormalization
		MOVWF		BARGB3
                MOVF            BARGB1,W
		MOVWF		BARGB2
                MOVF            BARGB0,W
		MOVWF		BARGB1
                CLRF            BARGB0

                MOVLW           8
                SUBWF           BEXP,W
                BTFSS           _C                      ; i f BEXP >= 8, do byte shift
                GOTO            ALIGNB32
                MOVWF           BEXP
                MOVF            BARGB2,W		; keep for postnormalization
		MOVWF		BARGB3
                MOVF            BARGB1,W
		MOVWF		BARGB2
                CLRF            BARGB1

                MOVLW           8
                SUBWF           BEXP,W
                BTFSS           _C                      ; i f BEXP >= 8, BARG = 0 relative to AARG
                GOTO            ALIGNB32
                MOVF            SIGN,W
                MOVWF           AARGB0
                RETLW           0x00

ALIGNB32        MOVF            BEXP,W                  ; a lready aligned i f BEXP = 0
                BTFSC           _Z
                GOTO            ALIGNED32

ALOOPB32        BCF             _C                      ; right shift by BEXP

                ;// error
				RRCF     BARGB0,	F
                RRCF     BARGB1,	F
				RRCF		BARGB2,	F
				RRCF		BARGB3,	F
				;//
				
                DECFSZ          BEXP,F
                GOTO            ALOOPB32

ALIGNED32       BTFSS           TEMP,MSB                ; negate i f signs opposite
                GOTO            AOK32

		COMF		BARGB3,F
		COMF		BARGB2,F
                COMF            BARGB1,F
                COMF            BARGB0,F
                INCF            BARGB3,F
                BTFSC           _Z
                INCF            BARGB2,F
		BTFSC		_Z
		INCF		BARGB1,F
		BTFSC		_Z
		INCF		BARGB0,F

AOK32
                MOVF   		BARGB3,W
                ADDWF   	AARGB3,F
                MOVF            BARGB2,W
                BTFSC           _C
                INCFSZ          BARGB2,W
                ADDWF           AARGB2,F
                MOVF            BARGB1,W
                BTFSC           _C
                INCFSZ          BARGB1,W
                ADDWF           AARGB1,F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           AARGB0,F

                BTFSC           TEMP,MSB
                GOTO            ACOMP32
                BTFSS           _C
                GOTO            NRMRND4032

				;// error
                RRCF     AARGB0,	F        ; shift right and increment EXP
                RRCF     AARGB1,	F
                RRCF     AARGB2,	F
				RRCF		AARGB3,	F
				;//
		
                INCFSZ          AEXP,F
                GOTO            NRMRND4032
                GOTO            SETFOV32

ACOMP32         BTFSC           _C
                GOTO            NRM4032			; normalize and fix sign

		COMF		AARGB3,F
                COMF            AARGB2,F		; negate, toggle sign bit and
                COMF            AARGB1,F		; then normalize
                COMF            AARGB0,F
                INCF            AARGB3,F
                BTFSC           _Z
                INCF            AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F

                MOVLW           0x80
                XORWF           SIGN,F
                GOTO            NRM32
;// depedentes
;**********************************************************************************************

;       Normalization routine

;       Input:  40 bit unnormalized floating point number in AEXP, AARGB0, AARGB1,
;               AARGB2, AARGB3 with sign in SIGN,MSB

;       Use:    CALL    NRM4032

;       Output: 32 bit normalized floating point number in AEXP, AARGB0, AARGB1, AARGB2,
;               AARGB3

;       Result: AARG  <--  NORMALIZE( AARG )

;       Max Timing:     38+6*9+12+8 = 112 clks  RND = 0
;                       38+6*9+12+24 = 128 clks RND = 1, SAT = 0
;                       38+6*9+12+31 = 135 clks RND = 1, SAT = 1

;       Min Timing:     33+6 = 39 clks                  AARG = 0
;                       5+9+8 = 22 clks

;       PM: 66                                          DM: 8

;----------------------------------------------------------------------------------------------

NRM4032         CLRF            TEMP			; clear exponent decrement
                MOVF            AARGB0,W		; test i f highbyte=0
                BTFSS           _Z
                GOTO            NORM4032
                MOVF            AARGB1,W		; i fso, shift 8 bits by move
                MOVWF           AARGB0
                MOVF            AARGB2,W
                MOVWF           AARGB1
                MOVF            AARGB3,W
                MOVWF           AARGB2
                CLRF            AARGB3
                BSF             TEMP,3                  ; increase decrement by 8

                MOVF            AARGB0,W		; test i fhighbyte=0
                BTFSS           _Z
                GOTO            NORM4032
                MOVF            AARGB1,W		; i fso, shift 8 bits by move
                MOVWF           AARGB0
                MOVF            AARGB2,W
                MOVWF           AARGB1
                CLRF            AARGB2
                BCF             TEMP,3                  ; increase decrement by 8
                BSF             TEMP,4
        
                MOVF            AARGB0,W		; test i fhighbyte=0
                BTFSS           _Z
                GOTO            NORM4032
                MOVF            AARGB1,W		; i fso, shift 8 bits by move
                MOVWF           AARGB0
                CLRF            AARGB1
                BSF             TEMP,3                  ; increase decrement by 8
        
                MOVF            AARGB0,W		; i fhighbyte=0, result=0
                BTFSC           _Z
                GOTO            RES032

NORM4032        MOVF            TEMP,W
                SUBWF           EXP,F
                BTFSS           _Z
                BTFSS           _C
                GOTO            SETFUN32

                BCF             _C                      ; clear carry bit

NORM4032A       BTFSC           AARGB0,MSB		; i fMSB=1, normalization done
                GOTO            NRMRND4032
				
				;/// !!! errors
                ;RLF             AARGB3,	F	; otherwise, shift left and 
                ;RLF             AARGB2,	F   ; decrement EXP
                ;RLF             AARGB1,	F
                ;RLF             AARGB0,	F
				RLCF             AARGB3,	F	; otherwise, shift left and 
                RLCF             AARGB2,	F   ; decrement EXP
                RLCF             AARGB1,	F
                RLCF             AARGB0,	F
				;//
				
                DECFSZ          EXP,F
                GOTO            NORM4032A

                GOTO            SETFUN32                ; underflow i fEXP=0

NRMRND4032      BTFSC           FPFLAGS,RND
                BTFSS           AARGB2,LSB
                GOTO            FIXSIGN32
		BTFSS		AARGB3,MSB		; round i fnext bit is set
                GOTO            FIXSIGN32
		INCF		AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F

                BTFSS           _Z                      ; has rounding caused carryout?
                GOTO            FIXSIGN32
				
				; P16
                ;RRF             AARGB0,F                ; i fso, right shift
                ;RRF             AARGB1,F
                ;RRF             AARGB2,F
				;
				; P18
                RRCF             AARGB0,F                ; i f so, right shift
                RRCF             AARGB1,F
                RRCF             AARGB2,F
				;
				
                INCF            EXP,F
                BTFSC           _Z                      ; check for overflow
                GOTO            SETFOV32
                GOTO            FIXSIGN32
	
;// доступ к состоянию модуля
; Доступ к А операнду - полныей доступ
getFullA_MATH:	;(io - FSR0 4 byte/)
	movff	AEXP,	POSTINC0
	movff	AARGB0,	POSTINC0
	movff	AARGB1,	POSTINC0
	movff	AARGB2,	POSTINC0
	return

; младшая пара байтов
get2LowBytesA_MATH:	;(io - FSR0 2 byte/)
	movff	AARGB2,	POSTINC0
	movff	AARGB1,	POSTINC0
	return

end
;-----------------------------------
