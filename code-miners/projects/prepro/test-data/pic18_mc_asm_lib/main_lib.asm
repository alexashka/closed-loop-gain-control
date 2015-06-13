 	#include	<p18f2520.inc>

;****************************************************************************************
;*  MathLib										*
;****************************************************************************************

;       IMP ORTANT NOTE: The math library routines can be used in a dedicated application on
;       an individual basis and memory allocation may be modified with the stipulation that
;       on the PIC17, P type registers must remain so since P type specific instructions
;	were used to realize some performance improvements.

;*********************************************************************************************
;
;       GENERAL MATH LIBRARY DEFINITIONS
;
;	general literal constants

;	define assembler constants

B0		equ	0
B1		equ	1
B2		equ	2
B3		equ	3
B4		equ	4
B5		equ	5
B6		equ	6
B7		equ	7

MSB		equ	7
LSB		equ	0


;     define commonly used bits
;     STATUS bit definitions

		#define	_C		STATUS,0
		#define	_Z		STATUS,2

;
;       general register variables
;
;

MathDate	udata;	0x101



ACCB7		res	0
AARGB7		res	0
REMB3		res	1

ACCB6		res	0
AARGB6		res	0
REMB2		res	1

ACCB5		res	0
AARGB5		res	0
REMB1		res	1

ACCB4		res	0
AARGB4		res	0
REMB0		res	1

ACCB3		res	0
AARGB3		res	1

ACCB2		res	0
AARGB2		res	1

ACCB1		res	0
AARGB1		res	1

ACCB0		res	0
AARGB0		res	0
AARG		res	0
ACC		res	1




AEXP		res	0			; 8 bit biased exponent for argument A
EXP		res	1

SIGN		res	1			; save location for sign in MSB 0x29




FPFLAGS		res	1			; floating point library exception flags 0x2A


BARGB3		res	1
BARGB2		res	1          
BARGB1		res	1          
BARGB0		res	0
BARG		res	1
BEXP		res	1

TEMPB3		res	1
TEMPB2		res	1
TEMPB1		res	1
TEMPB0		res	0
TEMP		res	1

LOOPCOUNT	res	1		; loop counter


XEXP		res	1
XARGB0		res	1
XARGB1		res	1
XARGB2		res	1
YEXP		res	1
YARGB0		res	1
YARGB1		res	1
YARGB2		res	1


;	ELEMENTARY FUNCTION MEMORY

CEXP		res	1
CARGB0		res	1
CARGB1		res	1
CARGB2		res	1
CARGB3		res	1


DEXP		res	1
DARGB0		res	1
DARGB1		res	1
DARGB2		res	1
DARGB3		res	1


EEXP		res	1
EARGB0		res	1
EARGB1		res	1
EARGB2		res	1
EARGB3		res	1


ZARGB0		res	1
ZARGB1		res	1
ZARGB2		res	1
ZARGB3		res	1


RANDB0		res	1
RANDB1		res	1
RANDB2		res	1
RANDB3		res	1



TempA0		res	1
TempA1		res	1
TempA2		res	1
TempAEXP	res	1


TempB0		res	1
TempB1		res	1
TempB2		res	1
TempBEXP	res	1


CountLoop	res	1






;********************************************************************



EXPBIAS         equ     D'127'

;       floating point library exception flags                
IOV             equ     0       ; bit0 = integer overflow flag

FOV             equ     1       ; bit1 = floating point overflow flag

FUN             equ     2       ; bit2 = floating point underflow flag

FDZ             equ     3       ; bit3 = floating point divide by zero flag

NAN		equ	4	; bit4 = not-a-number exception flag

DOM		equ	5	; bit5 = domain error exception flag

RND             equ     6       ; bit6 = floating point rounding flag, 0 = truncation
                                ; 1 = unbiased rounding to nearest LSB

SAT             equ     7       ; bit7 = floating point saturate flag, 0 = terminate on
                                ; exception without saturation, 1 = terminate on
                                ; exception with saturation to appropriate value




;**************************************************************








	

;**********************************************************************************************

;	24 BIT FLOATING POINT CONSTANTS
;	Machine precision

MACHEP24EXP	equ	0x6F		; 1.52587890625e-5 = 2**-16

MACHEP24B0	equ	0x00

MACHEP24B1	equ	0x00

;	Maximum argument to EXP24

MAXLOG24EXP	equ	0x85		; 88.7228391117 = log(2**128)

MAXLOG24B0	equ	0x31

MAXLOG24B1	equ	0x72

;	Minimum argument to EXP24

MINLOG24EXP	equ	0x85		; -87.3365447506 = log(2**-126)

MINLOG24B0	equ	0xAE

MINLOG24B1	equ	0xAC

;	Maximum argument to EXP1024

MAXLOG1024EXP	equ	0x84		; 38.531839445 = log10(2**128)

MAXLOG1024B0	equ	0x1A

MAXLOG1024B1	equ	0x21

;	Minimum argument to EXP1024

MINLOG1024EXP	equ	0x84		; -37.9297794537 = log10(2**-126)

MINLOG1024B0	equ	0x97

MINLOG1024B1	equ	0xB8

;	Maximum representable number before overflow

MAXNUM24EXP	equ	0xFF		; 6.80554349248E38 = (2**128) * (2 - 2**-15)

MAXNUM24B0	equ	0x7F

MAXNUM24B1	equ	0xFF

;	Minimum representable number before underflow

MINNUM24EXP	equ	0x01		; 1.17549435082E-38 = (2**-126) * 1

MINNUM24B0	equ	0x00

MINNUM24B1	equ	0x00

;	Loss threshhold for argument to SIN24 and COS24

LOSSTHR24EXP	equ	0x8B		; 4096 = sqrt(2**24)

LOSSTHR24B0	equ	0x00

LOSSTHR24B1	equ	0x00

;**********************************************************************************************

;	32 BIT FLOATING POINT CONSTANTS

;	Machine precision

MACHEP32EXP	equ	0x67		; 5.96046447754E-8 = 2**-24

MACHEP32B0	equ	0x00

MACHEP32B1	equ	0x00

MACHEP32B2	equ	0x00

;	Maximum argument to EXP32

MAXLOG32EXP	equ	0x85		; 88.7228391117 = log(2**128)

MAXLOG32B0	equ	0x31

MAXLOG32B1	equ	0x72

MAXLOG32B2	equ	0x18

;	Minimum argument to EXP32

MINLOG32EXP	equ	0x85		; -87.3365447506 = log(2**-126)

MINLOG32B0	equ	0xAE

MINLOG32B1	equ	0xAC

MINLOG32B2	equ	0x50

;	Maximum argument to EXP1032

MAXLOG1032EXP	equ	0x84		; 38.531839445 = log10(2**128)

MAXLOG1032B0	equ	0x1A

MAXLOG1032B1	equ	0x20

MAXLOG1032B2	equ	0x9B

;	Minimum argument to EXP1032

MINLOG1032EXP	equ	0x84		; -37.9297794537 = log10(2**-126)

MINLOG1032B0	equ	0x97

MINLOG1032B1	equ	0xB8

MINLOG1032B2	equ	0x18

;	Maximum representable number before overflow

MAXNUM32EXP	equ	0xFF		; 6.80564774407E38 = (2**128) * (2 - 2**-23)

MAXNUM32B0	equ	0x7F

MAXNUM32B1	equ	0xFF

MAXNUM32B2	equ	0xFF

;	Minimum representable number before underflow

MINNUM32EXP	equ	0x01		; 1.17549435082E-38 = (2**-126) * 1

MINNUM32B0	equ	0x00

MINNUM32B1	equ	0x00

MINNUM32B2	equ	0x00

;	Loss threshhold for argument to SIN32 and COS32

LOSSTHR32EXP	equ	0x8B		; 4096 = sqrt(2**24)

LOSSTHR32B0	equ	0x00

LOSSTHR32B1	equ	0x00

LOSSTHR32B2	equ	0x00


;    ENDIF









;	RCS Header $Id: fp32.a16 2.8 1996/10/07 13:50:59 F.J.Testa Exp $

;	$Revision: 2.8 $

;       PIC16 32 BIT FLOATING POINT LIBRARY
;
;       Unary operations: both input and output are in AEXP,AARG
;
;       Binary operations: input in AEXP,AARG and BEXP,BARG with output in AEXP,AARG
;
;       All routines return WREG = 0x00 for successful completion, and WREG = 0xFF
;       for an error condition specified in FPFLAGS.
;
;       All timings are worst case cycle counts
;
;         Routine               Function
;
;       FLO2432         24 bit integer to 32 bit floating point conversion
;       FLO32
;
;               Timing:            RND
;                               0       1
;
;                       0       104     104
;                  SAT
;                       1       110     110
;
;       NRM3232   32 bit normalization of unnormalized 32 bit floating point numbers
;       NRM32
;
;               Timing:            RND
;                               0       1
;
;                       0       90      90
;                  SAT
;                       1       96      96
;
;
;       INT3224         32 bit floating point to 24 bit integer conversion
;       INT32
;
;
;               Timing:            RND
;                               0       1
;
;                       0       104      112
;                  SAT
;                       1       104      114
;
;       FLO3232 32 bit integer to 32 bit floating point conversion
;
;               Timing:            RND
;                               0       1
;
;                       0       129     145
;                  SAT
;                       1       129     152
;
;       NRM4032 32 bit normalization of unnormalized 40 bit floating point numbers
;
;               Timing:            RND
;                               0       1
;
;                       0       112     128
;                  SAT
;                       1       112     135
;
;
;       INT3232         32 bit floating point to 32 bit integer conversion
;
;
;               Timing:            RND
;                               0       1
;
;                       0       130     137
;                  SAT
;                       1       130     137
;
;       FPA32           32 bit floating point add
;
;               Timing:            RND
;                               0       1
;
;                       0       251     265
;                  SAT
;                       1       251     271
;
;       FPS32           32 bit floating point subtract
;
;               Timing:            RND
;                               0       1
;
;                       0       253     267
;                  SAT
;                       1       253     273
;
;       FPM32           32 bit floating point multiply
;
;               Timing:            RND
;                               0       1
;
;                       0       574     588
;                  SAT
;                       1       574     591
;
;       FPD32           32 bit floating point divide
;
;               Timing:            RND
;                               0       1
;
;                       0       932     968
;                  SAT
;                       1       932     971
;
;
;**********************************************************************************************
;**********************************************************************************************
;
;       32 bit floating point representation
;
;       EXPONENT        8 bit biased exponent
;
;                       It is important to note that the use of biased exponents produces
;                       a unique representation of a floating point 0, given by
;                       EXP = HIGHBYTE = MIDBYTE = LOWBYTE = 0x00, with 0 being
;                       the only number with EXP = 0.
;
;       HIGHBYTE        8 bit most significant byte of fraction in sign-magnitude representation,
;                       with SIGN = MSB, implicit MSB = 1 and radix point to the right of MSB
;
;       MIDBYTE         8 bit middle significant byte of sign-magnitude fraction
;
;       LOWBYTE         8 bit least significant byte of sign-magnitude fraction
;
;       EXPONENT        HIGHBYTE        MIDBYTE         LOWBYTE
;
;       xxxxxxxx        S.xxxxxxx       xxxxxxxx        xxxxxxxx
;
;                        |
;                      RADIX
;                      POINT
;
;
;**********************************************************************************************
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

FP32:	code
FLO2432
FLO32           MOVLW           D'23'+EXPBIAS		; initialize exponent and add bias
                MOVWF           EXP
                CLRF            SIGN
                BTFSS           AARGB0,MSB		; test sign
                GOTO            NRM3232
                COMF            AARGB2,F                ; if < 0, negate and set MSB in SIGN
                COMF            AARGB1,F
                COMF            AARGB0,F
                INCF            AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F
                BSF             SIGN,MSB

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

NRM3232

NRM32           CLRF            TEMP			; clear exponent decrement
                MOVF            AARGB0,W		; test if highbyte=0
                BTFSS           _Z
                GOTO            NORM3232
                MOVF            AARGB1,W		; if so, shift 8 bits by move
                MOVWF           AARGB0
                MOVF            AARGB2,W
                MOVWF           AARGB1
                CLRF            AARGB2
                BSF             TEMP,3                  ; increase decrement by 8

                MOVF            AARGB0,W		; test if highbyte=0
                BTFSS           _Z
                GOTO            NORM3232
                MOVF            AARGB1,W		; if so, shift 8 bits by move
                MOVWF           AARGB0
                CLRF            AARGB1
                BCF             TEMP,3                  ; increase decrement by 8
                BSF             TEMP,4
        
                MOVF            AARGB0,W		; if highbyte=0, result=0
                BTFSC           _Z
                GOTO            RES032

NORM3232        MOVF            TEMP,W
                SUBWF           EXP,F
                BTFSS           _Z
                BTFSS           _C
                GOTO            SETFUN32

                BCF             _C                      ; clear carry bit

NORM3232A       BTFSC           AARGB0,MSB		; if MSB=1, normalization done
                GOTO            FIXSIGN32
                rlcf             AARGB2,F                ; otherwise, shift left and 
                rlcf             AARGB1,F                ; decrement EXP
                rlcf             AARGB0,F
                DECFSZ          EXP,F
                GOTO            NORM3232A

                GOTO            SETFUN32                ; underflow if EXP=0

FIXSIGN32       BTFSS           SIGN,MSB
                BCF             AARGB0,MSB              ; clear explicit MSB if positive
                RETLW           0

RES032          CLRF            AARGB0                  ; result equals zero
                CLRF            AARGB1
                CLRF            AARGB2
		CLRF		AARGB3
                CLRF            EXP
                RETLW           0

;**********************************************************************************************
;**********************************************************************************************

;       Integer to float conversion

;       Input:  32 bit 2's complement integer right justified in AARGB0, AARGB1, AARGB2,
;               AARGB3

;       Use:    CALL    FLO3232

;       Output: 32 bit floating point number in AEXP, AARGB0, AARGB1, AARGB2

;       Result: AARG  <--  FLOAT( AARG )

;       Max Timing:     17+112 = 129 clks               RND = 0
;                       17+128 = 145 clks               RND = 1, SAT = 0
;                       17+135 = 152 clks               RND = 1, SAT = 1

;       Min Timing:     6+39 = 45 clks                  AARG = 0
;                       6+22 = 28 clks

;       PM: 17+66 = 83                                  DM: 8

;----------------------------------------------------------------------------------------------

FLO3232         MOVLW           D'31'+EXPBIAS		; initialize exponent and add bias
                MOVWF           EXP
                CLRF            SIGN
                BTFSS           AARGB0,MSB		; test sign
                GOTO            NRM4032
                COMF            AARGB3,F                ; if < 0, negate and set MSB in SIGN
                COMF            AARGB2,F
                COMF            AARGB1,F
                COMF            AARGB0,F
                INCF            AARGB3,F
                BTFSC           _Z
                INCF            AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F
                BSF             SIGN,MSB

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
                MOVF            AARGB0,W		; test if highbyte=0
                BTFSS           _Z
                GOTO            NORM4032
                MOVF            AARGB1,W		; if so, shift 8 bits by move
                MOVWF           AARGB0
                MOVF            AARGB2,W
                MOVWF           AARGB1
                MOVF            AARGB3,W
                MOVWF           AARGB2
                CLRF            AARGB3
                BSF             TEMP,3                  ; increase decrement by 8

                MOVF            AARGB0,W		; test if highbyte=0
                BTFSS           _Z
                GOTO            NORM4032
                MOVF            AARGB1,W		; if so, shift 8 bits by move
                MOVWF           AARGB0
                MOVF            AARGB2,W
                MOVWF           AARGB1
                CLRF            AARGB2
                BCF             TEMP,3                  ; increase decrement by 8
                BSF             TEMP,4
        
                MOVF            AARGB0,W		; test if highbyte=0
                BTFSS           _Z
                GOTO            NORM4032
                MOVF            AARGB1,W		; if so, shift 8 bits by move
                MOVWF           AARGB0
                CLRF            AARGB1
                BSF             TEMP,3                  ; increase decrement by 8
        
                MOVF            AARGB0,W		; if highbyte=0, result=0
                BTFSC           _Z
                GOTO            RES032

NORM4032        MOVF            TEMP,W
                SUBWF           EXP,F
                BTFSS           _Z
                BTFSS           _C
                GOTO            SETFUN32

                BCF             _C                      ; clear carry bit

NORM4032A       BTFSC           AARGB0,MSB		; if MSB=1, normalization done
                GOTO            NRMRND4032
                rlcf             AARGB3,F                ; otherwise, shift left and 
                rlcf             AARGB2,F                ; decrement EXP
                rlcf             AARGB1,F
                rlcf             AARGB0,F
                DECFSZ          EXP,F
                GOTO            NORM4032A

                GOTO            SETFUN32                ; underflow if EXP=0

NRMRND4032      BTFSC           FPFLAGS,RND
                BTFSS           AARGB2,LSB
                GOTO            FIXSIGN32
		BTFSS		AARGB3,MSB		; round if next bit is set
                GOTO            FIXSIGN32
		INCF		AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F

                BTFSS           _Z                      ; has rounding caused carryout?
                GOTO            FIXSIGN32
                rrcf             AARGB0,F                ; if so, right shift
                rrcf             AARGB1,F
                rrcf             AARGB2,F
                INCF            EXP,F
                BTFSC           _Z                      ; check for overflow
                GOTO            SETFOV32
                GOTO            FIXSIGN32

;**********************************************************************************************
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

INT3224
INT32
		MOVF		EXP,W			; test for zero argument
		BTFSC		_Z
		RETLW		0x00

		MOVF            AARGB0,W		; save sign in SIGN
                MOVWF           SIGN
                BSF             AARGB0,MSB		; make MSB explicit

                MOVLW           EXPBIAS+D'23'		; remove bias from EXP
                SUBWF           EXP,F
                BTFSS           EXP,MSB
                GOTO            SETIOV3224
		COMF		EXP,F
		INCF		EXP,F

                MOVLW           8                       ; do byte shift if EXP >= 8
                SUBWF           EXP,W
                BTFSS           _C
                GOTO            TSHIFT3224
                MOVWF           EXP
                rlcf             AARGB2,F                ; rotate next bit for rounding
                MOVF            AARGB1,W
                MOVWF           AARGB2
                MOVF            AARGB0,W
                MOVWF           AARGB1
                CLRF            AARGB0

                MOVLW           8                       ; do another byte shift if EXP >= 8
                SUBWF           EXP,W
                BTFSS           _C
                GOTO            TSHIFT3224
                MOVWF           EXP
                rlcf             AARGB2,F		; rotate next bit for rounding
                MOVF            AARGB1,W
                MOVWF           AARGB2
                CLRF            AARGB1

                MOVLW           8                       ; do another byte shift if EXP >= 8
                SUBWF           EXP,W
                BTFSS           _C
                GOTO            TSHIFT3224
                MOVWF           EXP
                rlcf             AARGB2,F                ; rotate next bit for rounding
                CLRF            AARGB2
		MOVF		EXP,W
		BTFSS		_Z
		BCF		_C
		GOTO		SHIFT3224OK

TSHIFT3224      MOVF            EXP,W                   ; shift completed if EXP = 0
                BTFSC           _Z
                GOTO            SHIFT3224OK

SHIFT3224       BCF             _C
                rrcf             AARGB0,F                ; right shift by EXP
                rrcf             AARGB1,F
                rrcf             AARGB2,F
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
                BTFSC           AARGB0,MSB		; test for overflow
                GOTO            SETIOV3224

INT3224OK       BTFSS           SIGN,MSB                ; if sign bit set, negate               
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

IRES03224	CLRF            AARGB0			; integer result equals zero
                CLRF            AARGB1
                CLRF            AARGB2
                RETLW           0

SETIOV3224	BSF             FPFLAGS,IOV             ; set integer overflow flag
                BTFSS           FPFLAGS,SAT             ; test for saturation
                RETLW           0xFF                    ; return error code in WREG

                CLRF            AARGB0			; saturate to largest two's
                BTFSS           SIGN,MSB                ; complement 24 bit integer
                MOVLW           0xFF
                MOVWF           AARGB0			; SIGN = 0, 0x 7F FF FF
                MOVWF           AARGB1			; SIGN = 1, 0x 80 00 00
                MOVWF           AARGB2
                rlcf             SIGN,F
                rrcf             AARGB0,F
                RETLW           0xFF                    ; return error code in WREG

;**********************************************************************************************
;**********************************************************************************************

;       Float to integer conversion

;       Input:  32 bit floating point number in AEXP, AARGB0, AARGB1, AARGB2

;       Use:    CALL    INT3232

;       Output: 32 bit 2's complement integer right justified in AARGB0, AARGB1, AARGB2,
;               AARGB3

;       Result: AARG  <--  INT( AARG )

;       Max Timing:     54+6*8+7+21 = 130 clks          RND = 0
;                       54+6*8+7+29 = 137 clks          RND = 1, SAT = 0
;                       54+6*8+7+29 = 137 clks          RND = 1, SAT = 1

;       Min Timing:     5 clks

;       PM: 102                                                 DM: 7

;----------------------------------------------------------------------------------------------

INT3232			
                CLRF            AARGB3
		MOVF		EXP,W			; test for zero argument
		BTFSC		_Z
		RETLW		0x00

		MOVF            AARGB0,W		; save sign in SIGN
                MOVWF           SIGN
                BSF             AARGB0,MSB		; make MSB explicit

                MOVLW           EXPBIAS+D'31'		; remove bias from EXP
                SUBWF           EXP,F
                BTFSS           EXP,MSB
                GOTO            SETIOV32
		COMF		EXP,F
		INCF		EXP,F        

                MOVLW           8                       ; do byte shift if EXP >= 8
                SUBWF           EXP,W
                BTFSS           _C
                GOTO            TSHIFT3232
                MOVWF           EXP
                rlcf             AARGB3,F                ; rotate next bit for rounding
                MOVF            AARGB2,W
                MOVWF           AARGB3
                MOVF            AARGB1,W
                MOVWF           AARGB2
                MOVF            AARGB0,W
                MOVWF           AARGB1
                CLRF            AARGB0

                MOVLW           8                       ; do another byte shift if EXP >= 8
                SUBWF           EXP,W
                BTFSS           _C
                GOTO            TSHIFT3232
                MOVWF           EXP
                rlcf             AARGB3,F                ; rotate next bit for rounding
                MOVF            AARGB2,W
                MOVWF           AARGB3
                MOVF            AARGB1,W
                MOVWF           AARGB2
                CLRF            AARGB1

                MOVLW           8                       ; do another byte shift if EXP >= 8
                SUBWF           EXP,W
                BTFSS           _C
                GOTO            TSHIFT3232
                MOVWF           EXP
                rlcf             AARGB3,F                ; rotate next bit for rounding
                MOVF            AARGB2,W
                MOVWF           AARGB3
                CLRF            AARGB2

                MOVLW           8                       ; do another byte shift if EXP >= 8
                SUBWF           EXP,W
                BTFSS           _C
                GOTO            TSHIFT3232
                MOVWF           EXP
                rlcf             AARGB3,F                ; rotate next bit for rounding
                CLRF            AARGB3
		MOVF		EXP,W
		BTFSS		_Z
		BCF		_C
		GOTO		SHIFT3232OK

TSHIFT3232      MOVF            EXP,W                   ; shift completed if EXP = 0
                BTFSC           _Z
                GOTO            SHIFT3232OK

SHIFT3232       BCF             _C
                rrcf             AARGB0,F                ; right shift by EXP
                rrcf             AARGB1,F
                rrcf             AARGB2,F
                rrcf             AARGB3,F
                DECFSZ          EXP,F
                GOTO            SHIFT3232

SHIFT3232OK     BTFSC           FPFLAGS,RND
                BTFSS           AARGB3,LSB
                GOTO            INT3232OK
                BTFSS           _C
                GOTO            INT3232OK
                INCF            AARGB3,F
                BTFSC           _Z
                INCF            AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F
                BTFSC           AARGB0,MSB		; test for overflow
                GOTO            SETIOV3224

INT3232OK       BTFSS           SIGN,MSB                ; if sign bit set, negate               
                RETLW           0
                COMF            AARGB0,F
                COMF            AARGB1,F
                COMF            AARGB2,F
                COMF            AARGB3,F
                INCF            AARGB3,F
                BTFSC           _Z
                INCF            AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F
                RETLW           0

IRES032         CLRF            AARGB0			; integer result equals zero
                CLRF            AARGB1
                CLRF            AARGB2
                CLRF            AARGB3
                RETLW           0

SETIOV32        BSF             FPFLAGS,IOV             ; set integer overflow flag
                BTFSS           FPFLAGS,SAT             ; test for saturation
                RETLW           0xFF                    ; return error code in WREG

                CLRF            AARGB0			; saturate to largest two's
                BTFSS           SIGN,MSB                ; complement 32 bit integer
                MOVLW           0xFF
                MOVWF           AARGB0			; SIGN = 0, 0x 7F FF FF FF
                MOVWF           AARGB1			; SIGN = 1, 0x 80 00 00 00
                MOVWF           AARGB2
                MOVWF           AARGB3
                rlcf             SIGN,F
                rrcf             AARGB0,F
                RETLW           0xFF                    ; return error code in WREG

;**********************************************************************************************
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

MOK32		MOVF		AARGB0,W
		MOVWF		AARGB3
		MOVF		AARGB1,W
		MOVWF		AARGB4
		MOVF		AARGB2,W
		MOVWF		AARGB5
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

MNOADD32        rrcf             AARGB0,F
                rrcf             AARGB1,F
                rrcf             AARGB2,F
                rrcf             AARGB3,F
                rrcf             AARGB4,F
                rrcf             AARGB5,F
                BCF             _C
                DECFSZ          TEMP,F
                GOTO            MLOOP32

                BTFSC           AARGB0,MSB               ; check for postnormalization
                GOTO            MROUND32
                rlcf             AARGB3,F
                rlcf             AARGB2,F
                rlcf             AARGB1,F
                rlcf             AARGB0,F
                DECF            EXP,F

MROUND32        BTFSC           FPFLAGS,RND
                BTFSS           AARGB2,LSB
                GOTO            MUL32OK
		BTFSS		AARGB3,MSB
                GOTO            MUL32OK
		INCF		AARGB2,F
                BTFSC           _Z
                INCF            AARGB1,F
                BTFSC           _Z
                INCF            AARGB0,F

                BTFSS           _Z                      ; has rounding caused carryout?
                GOTO            MUL32OK
                rrcf             AARGB0,F                ; if so, right shift
                rrcf             AARGB1,F
                rrcf             AARGB2,F
                INCF            EXP,F
                BTFSC           _Z                      ; check for overflow
                GOTO            SETFOV32

MUL32OK         BTFSS           SIGN,MSB
                BCF             AARGB0,MSB		; clear explicit MSB if positive

                RETLW           0  

SETFOV32        BSF             FPFLAGS,FOV             ; set floating point underflag
                BTFSS           FPFLAGS,SAT             ; test for saturation
                RETLW           0xFF                    ; return error code in WREG

                MOVLW           0xFF
                MOVWF           AEXP                    ; saturate to largest floating
                MOVWF           AARGB0                  ; point number = 0x FF 7F FF FF
                MOVWF           AARGB1                  ; modulo the appropriate sign bit
                MOVWF           AARGB2
                rlcf             SIGN,F
                rrcf             AARGB0,F
                RETLW           0xFF                    ; return error code in WREG

;**********************************************************************************************
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

                BCF             _C                      ; align if necessary
                rrcf             AARGB0,F
                rrcf             AARGB1,F
                rrcf             AARGB2,F
                rrcf             AARGB3,F
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

DLOOP32         rlcf             AARGB5,F                ; left shift
                rlcf             AARGB4,F
                rlcf             AARGB3,F
                rlcf             AARGB2,F
                rlcf             AARGB1,F
                rlcf             AARGB0,F
                rlcf             TEMP,F

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

                rlcf             BARGB0,W
                IORWF           TEMP,F
                
                BTFSS           TEMP,LSB                ; test for restore
                GOTO            DREST32

                BSF             AARGB5,LSB
                GOTO            DOK32

DREST32         MOVF            BARGB2,W                ; restore if necessary
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
                rlcf             AARGB2,F               ; compute next significant bit
                rlcf             AARGB1,F               ; for rounding
                rlcf             AARGB0,F
                rlcf             TEMP,F

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

                rlcf             BARGB0,W
                IORWF           TEMP,W
                ANDLW           0x01            

                ADDWF           AARGB5,F
                BTFSC           _C
                INCF            AARGB4,F
                BTFSC           _Z
                INCF            AARGB3,F

                BTFSS           _Z                      ; test if rounding caused carryout
                GOTO            DIV32OK
                rrcf             AARGB3,F
                rrcf             AARGB4,F
                rrcf             AARGB5,F
                INCF            EXP,F
                BTFSC           _Z                      ; test for overflow
                GOTO            SETFOV32


DIV32OK         BTFSS           SIGN,MSB
                BCF             AARGB3,MSB		; clear explicit MSB if positive

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
                rlcf             SIGN,F
                rrcf             AARGB0,F
                RETLW           0xFF                    ; return error code in WREG

SETFDZ32        BSF             FPFLAGS,FDZ             ; set divide by zero flag
                RETLW           0xFF

;**********************************************************************************************
;**********************************************************************************************

;       Floating Point Subtract

;       Input:  32 bit floating point number in AEXP, AARGB0, AARGB1, AARGB2
;               32 bit floating point number in BEXP, BARGB0, BARGB1, BARGB2

;       Use:    CALL FPS32

;       Output: 32 bit floating point sum in AEXP, AARGB0, AARGB1, AARGB2

;       Result: AARG  <--  AARG - BARG

;       Max Timing:     2+251 = 253 clks                RND = 0
;                       2+265 = 267 clks                RND = 1, SAT = 0
;                       2+271 = 273 clks                RND = 1, SAT = 1

;       Min Timing:     2+12 = 14 clks

;       PM: 2+146 = 148                         DM: 14

;----------------------------------------------------------------------------------------------

FPS32           MOVLW           0x80
                XORWF           BARGB0,F

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

FPA32           MOVF            AARGB0,W                ; exclusive or of signs in TEMP
                XORWF           BARGB0,W
                MOVWF           TEMP

		CLRF		AARGB3			; clear extended byte
		CLRF		BARGB3

                MOVF            AEXP,W                  ; use AARG if AEXP >= BEXP
                SUBWF           BEXP,W
                BTFSS           _C
                GOTO            USEA32

                MOVF            BEXP,W                  ; use BARG if AEXP < BEXP
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

USEA32          MOVF            BEXP,W                  ; return AARG if BARG = 0
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
                BTFSS           _C                      ; if BEXP >= 8, do byte shift
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
                BTFSS           _C                      ; if BEXP >= 8, do byte shift
                GOTO            ALIGNB32
                MOVWF           BEXP
                MOVF            BARGB2,W		; keep for postnormalization
		MOVWF		BARGB3
                MOVF            BARGB1,W
		MOVWF		BARGB2
                CLRF            BARGB1

                MOVLW           8
                SUBWF           BEXP,W
                BTFSS           _C                      ; if BEXP >= 8, BARG = 0 relative to AARG
                GOTO            ALIGNB32
                MOVF            SIGN,W
                MOVWF           AARGB0
                RETLW           0x00

ALIGNB32        MOVF            BEXP,W                  ; already aligned if BEXP = 0
                BTFSC           _Z
                GOTO            ALIGNED32

ALOOPB32        BCF             _C                      ; right shift by BEXP
                rrcf             BARGB0,F
                rrcf             BARGB1,F
		rrcf		BARGB2,F
		rrcf		BARGB3,F
                DECFSZ          BEXP,F
                GOTO            ALOOPB32

ALIGNED32       BTFSS           TEMP,MSB                ; negate if signs opposite
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

                rrcf             AARGB0,F               ; shift right and increment EXP
                rrcf             AARGB1,F
                rrcf             AARGB2,F
		rrcf		AARGB3,F
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




mov_A_B
	movf	AARGB2,w
	movwf	BARGB2
	movf	AARGB1,w
	movwf	BARGB1
	movf	AARGB0,w
	movwf	BARGB0
	movf	AEXP,w
	movwf	BEXP
	return


mov_A_TempA
	movf	AARGB2,w
	movwf	TempA2
	movf	AARGB1,w
	movwf	TempA1
	movf	AARGB0,w
	movwf	TempA0
	movf	AEXP,w
	movwf	TempAEXP
	return


mov_A_TempB
	movf	AARGB2,w
	movwf	TempB2
	movf	AARGB1,w
	movwf	TempB1
	movf	AARGB0,w
	movwf	TempB0
	movf	AEXP,w
	movwf	TempBEXP
	return

mov_TempA_A
	movf	TempA2,w
	movwf	AARGB2
	movf	TempA1,w
	movwf	AARGB1
	movf	TempA0,w
	movwf	AARGB0
	movf	TempAEXP,w
	movwf	AEXP
	return

mov_TempB_A
	movf	TempB2,w
	movwf	AARGB2
	movf	TempB1,w
	movwf	AARGB1
	movf	TempB0,w
	movwf	AARGB0
	movf	TempBEXP,w
	movwf	AEXP
	return

mov_TempA_B
	movf	TempA2,w
	movwf	BARGB2
	movf	TempA1,w
	movwf	BARGB1
	movf	TempA0,w
	movwf	BARGB0
	movf	TempAEXP,w
	movwf	BEXP
	return

mov_TempB_B
	movf	TempB2,w
	movwf	BARGB2
	movf	TempB1,w
	movwf	BARGB1
	movf	TempB0,w
	movwf	BARGB0
	movf	TempBEXP,w
	movwf	BEXP
	return


	global	mov_TempA_A, mov_TempA_B, mov_TempB_A, mov_TempB_B, mov_A_TempA, mov_A_TempB, mov_A_B


	global	INT32, FLO32, FPS32, FPA32, FPM32, FPD32		, FLO2432, INT3232
	global	AARGB3, AARGB2, AARGB1, AARGB0, AEXP
	global	BARGB3, BARGB2, BARGB1, BARGB0, BEXP


;****************************************************************************************
;*подпрограмма преобразования числа в ASCII код						*
;****************************************************************************************
UDIV3216L       macro

;       Max Timing:     16+6*22+21+21+6*22+21+21+6*22+21+21+6*22+21+8 = 699 clks

;       Min Timing:     16+6*21+20+20+6*21+20+20+6*21+20+20+6*21+20+3 = 663 clks

;       PM: 240                                 DM: 9

                CLRF            TEMP

                rlcf             ACCB0,W
                rlcf             REMB1, F
                MOVF            BARGB1,W
                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
                movlw 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                rlcf             ACCB0, F

                MOVLW           7
                MOVWF           LOOPCOUNT

LOOPU3216A      rlcf             ACCB0,W
                rlcf             REMB1, F
                rlcf             REMB0, F
                rlcf             TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB0,LSB
                GOTO            UADD26LA

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
                movlw 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26LA

UADD26LA        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
                movlw 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26LA 		rlcf             ACCB0, F

                DECFSZ          LOOPCOUNT, F
                GOTO            LOOPU3216A

                rlcf             ACCB1,W
                rlcf             REMB1, F
                rlcf             REMB0, F
                rlcf             TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB0,LSB
                GOTO            UADD26L8

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
                movlw 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26L8

UADD26L8        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
                movlw 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26L8 		rlcf             ACCB1, F

                MOVLW           7
                MOVWF           LOOPCOUNT

LOOPU3216B      rlcf             ACCB1,W
                rlcf             REMB1, F
                rlcf             REMB0, F
                rlcf             TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB1,LSB
                GOTO            UADD26LB

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
                movlw 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26LB

UADD26LB        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
                movlw 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26LB 		rlcf             ACCB1, F

                DECFSZ          LOOPCOUNT, F
                GOTO            LOOPU3216B

                rlcf             ACCB2,W
                rlcf             REMB1, F
                rlcf             REMB0, F
                rlcf             TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB1,LSB
                GOTO            UADD26L16

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
                movlw 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26L16

UADD26L16       ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
                movlw 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26L16        rlcf             ACCB2, F

                MOVLW           7
                MOVWF           LOOPCOUNT

LOOPU3216C      rlcf             ACCB2,W
                rlcf             REMB1, F
                rlcf             REMB0, F
                rlcf             TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB2,LSB
                GOTO            UADD26LC

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
                movlw 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26LC

UADD26LC        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
                movlw 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26LC 		rlcf             ACCB2, F

                DECFSZ          LOOPCOUNT, F
                GOTO            LOOPU3216C

                rlcf             ACCB3,W
                rlcf             REMB1, F
                rlcf             REMB0, F
                rlcf             TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB2,LSB
                GOTO            UADD26L24

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
                movlw 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26L24

UADD26L24       ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
                movlw 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26L24        rlcf             ACCB3, F

                MOVLW           7
                MOVWF           LOOPCOUNT

LOOPU3216D      rlcf             ACCB3,W
                rlcf             REMB1, F
                rlcf             REMB0, F
                rlcf             TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB3,LSB
                GOTO            UADD26LD

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
                movlw 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26LD

UADD26LD        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
                movlw 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26LD 		rlcf             ACCB3, F

                DECFSZ          LOOPCOUNT, F
                GOTO            LOOPU3216D

                BTFSC           ACCB3,LSB
                GOTO            UOK26L
                MOVF            BARGB1,W
	        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
UOK26L

                endm

        
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

FXD3216U        CLRF            REMB0
                CLRF            REMB1

                UDIV3216L

                RETLW           0x00



;в FSR1 - поинтер на выводимую строку 
;в W - количество цифр
;в A - аргумент


int_ASCII:
	movwf	CountLoop
	addwf	FSR1L,f


int_ASCII_loop:
	decf	FSR1L,f

;	clrf	AARGB3
	clrf	BARGB0
	movlw	10
	movwf	BARGB1

	call	FXD3216U

	movf	REMB1,w
	addlw	0x30
	movwf	INDF1

	

	decfsz	CountLoop,f
	goto	int_ASCII_loop
	return


	global	int_ASCII

;*****************************************************************************************


;****************************************************************************************
;*  WaitLib										*
;****************************************************************************************



	#define		DefMacroDelay

#include	<headers/DELAY14.INC>

WaitCode	code
;подпрограмма задержки
;значение в мкС помещается в рабочий регистр
DelayUs20MHz:
	clrwdt
	addlw	0xFF
	btfss	STATUS,Z,0
	goto	DelayUs20MHz
	return

;подпрограмма задержки
;значение в мС помещается в рабочий регистр
DelayMs20MHz:
	clrf	FSR1L
DelayMs20MHz_1:
	clrwdt
	nop
	nop
	nop
	nop

	nop
	nop
	nop
	nop
	nop
	nop
	nop

	nop
	nop
	nop
	nop
	nop

	decfsz	FSR1L,f
	goto	DelayMs20MHz_1

	addlw	0xFF
	btfss	STATUS,Z,0
	goto	DelayMs20MHz
	return


delay1s:
	DelayMs	250
	DelayMs	250
	DelayMs	250
	DelayMs	250
	return


delay10s:
	call	delay1s
	call	delay1s
	call	delay1s
	call	delay1s
	call	delay1s
	call	delay1s
	call	delay1s
	call	delay1s
	call	delay1s
	return


	

	global	DelayUs20MHz, DelayMs20MHz, delay10s, delay1s


;********************************************************************************
ProtocolData	udata
InBuff		res	8
OutBuffRS232	res	0
OutBuff		res	32
IndexInBuff	res	1
IndexOutBuff	res	1
CheckSumm	res	1

TempIIC		res	1

TempProtData	res	1
BaseAdr		res	1
CheckCode	res	1


;ProtocolData1	udata
RS485Data	res	0
IndexInBuff1	res	1	;0
FlagInBuff1	res	1	;1
OldByte1	res	1	;2
InBuff1		res	32	;3


	#define		DataRedy1	0
	#define		FlagAA55_1	1




;OutBuff1	res	16
;IndexOutBuff1	res	1
WaitCounter	res	1

	global	RS485Data, FlagInBuff1, InBuff1, IndexOutBuff, OutBuffRS232

;********************************************************************************
CodeIIC	code

;********************************************************************************
;*	обработка данных по UART						*
;*	В WREG принятый байт							*
;*	В FSR1 указатель на структуру						*
;********************************************************************************
RS_485:
	banksel	TempProtData
	movwf	TempProtData 
	
;проверка предшествующего байта на равенство AA
	movlw	2
	addwf	FSR1L,f,0
	movlw	0xAA
	xorwf	INDF1,w,0
	btfss	STATUS,Z,0
	goto	RByte

;загрузка переменной предшествующего байта  
	banksel	TempProtData
	movf	TempProtData,w
	movwf	INDF1,0

;проверка байта на равенство 55
	xorlw	0x55
	btfss	STATUS,Z,0
	return

;обнуление влагов
	decf	FSR1L,f,0
	movlw	b'10'
	movwf	INDF1,0

;обнуление индекса
	decf	FSR1L,f,0
	clrf	INDF1,0

	return


RByte:	
;загрузка переменной предшествующего байта  
	banksel	TempProtData
	movf	TempProtData,w
;	clrf		BSR
	movwf	INDF1,0

;проверка флага АА55
	decf	FSR1L,f,0
	btfss	INDF1,FlagAA55_1	,0
	return

;запись байта в буфер
	decf	FSR1L,w,0
	movwf	FSR1L,0
	banksel	BaseAdr
	movwf	BaseAdr

	movf	INDF1,w,0
	addlw	0x3
	addwf	FSR1L,f,0

	banksel	TempProtData
	movf	TempProtData,w
	movwf	INDF1,0

;инкремент указателя
	banksel	TempProtData
	movf	BaseAdr,w
	clrf	BSR
	movwf	FSR1L

	incf	INDF1,w
	andlw	0x01F			;????????????????????????????????????
	movwf	INDF1

;проверка принятых байт
	incf	FSR1L,f
	incf	FSR1L,f
	incf	FSR1L,f

	xorwf	INDF1,w
	btfss	STATUS,Z
	return	

;сброс флага AA55
	decf	FSR1L,f
	decf	FSR1L,f
	bcf	INDF1,FlagAA55_1	

	banksel	TempProtData
	movf	BaseAdr,w
	clrf		BSR
	movwf	FSR1L
	decf	INDF1,f
	addlw	0x03
	addwf	INDF1,w
	movwf	FSR1L
	comf	INDF1,w
	addlw	0x01
	banksel	TempProtData
	movwf	CheckCode


	movf	BaseAdr,w
	movwf	FSR1L,0
RByteLoop:

	addlw	0x02
	addwf	INDF1,w,0
	movwf	FSR1L,0

	movf	INDF1,w,0

	addwf	CheckCode,f

	movf	BaseAdr,w
	movwf	FSR1L,0
	decfsz	INDF1,f,0
	goto	RByteLoop



	movf	BaseAdr,w
	addlw	0x01
	movwf	FSR1L,0


	movf	CheckCode,f

	btfsc	STATUS,Z,0
	bsf	INDF1,DataRedy1,0

	return

;********************************************************************************
;*	Ожидание приёма блока данных по RS-485					*
;********************************************************************************

waitRS:
	banksel	WaitCounter
	movlw	0x14
	movwf	WaitCounter

waitRS1:
	movlw	0x2
	call	DelayMs20MHz_1

	banksel	TempProtData
	btfsc	FlagInBuff1,DataRedy1
	retlw	0x00

	banksel	WaitCounter
	decfsz	WaitCounter,f
	goto	waitRS1

	retlw	0xFF


;********************************************************************************
;*	передача блока по RS485							*
;*	адрес блока в FSR1, количество байт в W регистре				* ??
;*	Возрат 0 - OK, 0xFF - Error						* 
;********************************************************************************
TrBlockRS485:

	banksel	PIR1

	btfss	PIR1,TXIF
	goto	$ - 2 


	movlw	0xAA
	movwf	TXREG

	btfss	PIR1,TXIF
	goto	$ - 2 
	
	movlw	0x55
	movwf	TXREG

	lfsr		1,OutBuff

;	bankisel	OutBuff
;	movlw	OutBuff
;	movwf	FSR1


TrBlockRS4851:

	banksel	PIR1

	btfss	PIR1,TXIF
	goto	$ - 2 

	movf	INDF1,w
	movwf	TXREG



	banksel IndexOutBuff
	incf	FSR1L,f,0
	movlw	OutBuff + 1
	addwf	IndexOutBuff,w
	xorwf	FSR1L,w,0
	btfss	STATUS,Z,0
	goto	TrBlockRS4851


	retlw	0x00


;********************************************************************************
;*	передача блока по IIC							*
;*	адрес блока в FSR1, количество байт в W регистре				* ??
;*	Возрат 0 - OK, 0xFF - Error						* 
;********************************************************************************
TrBlockIIC:
	banksel	SSPCON2
	bsf	SSPCON2,SEN

	btfsc	SSPCON2,SEN
	goto	$ - 2

	banksel	SSPBUF
	bcf	PIR1,SSPIF
	movlw	0x10
	movwf	SSPBUF


	btfss	PIR1,SSPIF
	goto	$ - 2 


	bcf	PIR1,SSPIF
	movlw	0xAA
	movwf	SSPBUF

	btfss	PIR1,SSPIF
	goto	$ - 2
	

	bcf	PIR1,SSPIF
	movlw	0x55
	movwf	SSPBUF

	btfss	PIR1,SSPIF
	goto	$ - 2

	lfsr		1,OutBuff


TrBlockIIC1:

	banksel	SSPBUF
	bcf	PIR1,SSPIF
	movf	INDF1,w
	movwf	SSPBUF

	btfss	PIR1,SSPIF
	goto	$ - 2

	banksel IndexOutBuff
	incf	FSR1L,f
	movlw	OutBuff + 1
	addwf	IndexOutBuff,w
	xorwf	FSR1L,w
	btfss	STATUS,Z
	goto	TrBlockIIC1


	banksel	SSPCON2

	bsf	SSPCON2,PEN

	btfsc	SSPCON2,PEN
	goto	$ - 2

	retlw	0x00

;********************************************************************************
;*	приём блока по IIC							*
;*	адрес блока в FSR1							*
;*	возврат количество байт в W регистре					*
;********************************************************************************
RsBlockIIC:


	retlw	0x00



;*****************************************************************************************

;ProtocolCode	code

NewBuff:
	banksel	IndexOutBuff
	clrf	IndexOutBuff
	incf	IndexOutBuff,f
	clrf	OutBuff
	incf	OutBuff,f
	return

AddBuff:

	banksel	IndexOutBuff
	movwf	TempIIC

	banksel	IndexOutBuff
	lfsr		1,IndexOutBuff
	movlw	OutBuff
	addwf	IndexOutBuff,w
	movwf	FSR1L,0
	
	movf	TempIIC,w
	movwf	INDF1

	banksel	IndexOutBuff
	incf	IndexOutBuff,f
	incf	OutBuff,f

	xorlw	0xAA
	btfss	STATUS,Z,0
	return

	incf	FSR1L,f,0
	
	movlw	0x00
	movwf	INDF1

	incf	IndexOutBuff,f
;	incf	OutBuff,f

	return
;подсчёт контрольной суммы
PutCheckSumm:
	lfsr		1,IndexOutBuff
	banksel	IndexOutBuff

	
	incf	OutBuff,w
	movwf	CheckSumm
	movwf	OutBuff

	movlw	OutBuff
	addlw	0x01
	movwf	FSR1L,0

;вычисление контрольной суммы
PutCheckSumm1:
	movf	INDF1,w
	addwf	CheckSumm,f

	incf	FSR1L,f,0

	movlw	OutBuff
	addwf	IndexOutBuff,w
;	addwf	OutBuff,w

	xorwf	FSR1L,w,0
	btfss	STATUS,Z,0
	goto	PutCheckSumm1

	movf	CheckSumm,w
	movwf	INDF1
	incf	FSR1L,f,0
	xorlw	0xAA


	btfss	STATUS,Z
	return

	movwf	INDF1
	incf	IndexOutBuff,f
;	incf	IndexOutBuff,f
	return

	global	TrBlockIIC, RsBlockIIC, NewBuff, PutCheckSumm, AddBuff
	global	RS_485, waitRS, TrBlockRS485

;*****************************************************************************************









	end
