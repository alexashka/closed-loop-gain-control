; #include <../headers/math.inc>
	constant	HERE=2
#define		_v2_MATH	_v2_MATH
#define		THIS	_v2_MATH
#include	<../headers/user_modes.inc>
#define 	EXPBIAS D'127'
#define		MSB		7
#define		LSB		0
#define		_Z		STATUS,Z
#define		_C		STATUS,C
#define		RND     6       	; bit6 = floating point rounding flag, 0 = truncation
                                ; 1 = unbiased rounding to nearest LSB
#define		FOV  	1       	; bit1 = floating point overflow flag
#define		SAT     7       	; bit7 = floating point saturate flag, 0 = terminate on
                                ; exception without saturation, 1 = terminate on
                                ; exception with saturation to appropriate value
#define		FUN    	2       	; bit2 = floating point underflow flag
#define		IOV     0      		; bit0 = integer overflow flag
#define		FDZ     3       	; bit3 = floating point divide by zero flag
;****************************************************************************************
;*подпрограмма преобразования числа в ASCII код						*
;****************************************************************************************
UDIV3216L       macro

;       Max Timing:     16+6*22+21+21+6*22+21+21+6*22+21+21+6*22+21+8 = 699 clks

;       Min Timing:     16+6*21+20+20+6*21+20+20+6*21+20+20+6*21+20+3 = 663 clks

;       PM: 240                                 DM: 9

                CLRF            TEMP

                RLCF            ACCB0,W
                RLCF            REMB1, F
                MOVF            BARGB1,W
                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
               	MOVLW 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                RLCF            ACCB0, F

                MOVLW           7
                MOVWF           LOOPCOUNT

LOOPU3216A      RLCF            ACCB0,W
                RLCF            REMB1, F
                RLCF            REMB0, F
                RLCF            TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB0,LSB
                GOTO            UADD26LA

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
               	MOVLW 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26LA

UADD26LA        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
               	MOVLW 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26LA 		RLCF            ACCB0, F

                DECFSZ          LOOPCOUNT, F
                GOTO            LOOPU3216A

                RLCF            ACCB1,W
                RLCF            REMB1, F
                RLCF            REMB0, F
                RLCF            TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB0,LSB
                GOTO            UADD26L8

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
               	MOVLW 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26L8

UADD26L8        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
               	MOVLW 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26L8 		RLCF            ACCB1, F

                MOVLW           7
                MOVWF           LOOPCOUNT

LOOPU3216B      RLCF            ACCB1,W
                RLCF            REMB1, F
                RLCF            REMB0, F
                RLCF            TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB1,LSB
                GOTO            UADD26LB

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
               	MOVLW 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26LB

UADD26LB        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
               	MOVLW 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26LB 		RLCF            ACCB1, F

 
               	DECFSZ          LOOPCOUNT, F
                GOTO            LOOPU3216B

                RLCF            ACCB2,W
                RLCF            REMB1, F
                RLCF            REMB0, F
                RLCF            TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB1,LSB
                GOTO            UADD26L16

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
               	MOVLW 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26L16

UADD26L16       ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
               	MOVLW 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26L16        RLCF             ACCB2, F

                MOVLW           7
                MOVWF           LOOPCOUNT

LOOPU3216C      RLCF            ACCB2,W
                RLCF            REMB1, F
                RLCF            REMB0, F
                RLCF            TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB2,LSB
                GOTO            UADD26LC

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
               	MOVLW 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26LC

UADD26LC        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
               	MOVLW 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26LC 		RLCF            ACCB2, F

                DECFSZ          LOOPCOUNT, F
                GOTO            LOOPU3216C

                RLCF            ACCB3,W
                RLCF            REMB1, F
                RLCF            REMB0, F
                RLCF            TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB2,LSB
                GOTO            UADD26L24

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
               	MOVLW 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26L24

UADD26L24       ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
              	MOVLW 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26L24        RLCF            ACCB3, F

                MOVLW           7
                MOVWF           LOOPCOUNT

LOOPU3216D      RLCF            ACCB3,W
                RLCF            REMB1, F
                RLCF            REMB0, F
                RLCF            TEMP, F
                MOVF            BARGB1,W
                BTFSS           ACCB3,LSB
                GOTO            UADD26LD

                SUBWF           REMB1, F
                MOVF            BARGB0,W
                BTFSS           _C
                INCFSZ          BARGB0,W
                SUBWF           REMB0, F
               	MOVLW 0
                BTFSS           _C
                MOVLW           1
                SUBWF           TEMP, F
                GOTO            UOK26LD

UADD26LD        ADDWF           REMB1, F
                MOVF            BARGB0,W
                BTFSC           _C
                INCFSZ          BARGB0,W
                ADDWF           REMB0, F
           	    MOVLW 0
                BTFSC           _C
                MOVLW           1
                ADDWF           TEMP, F
        
UOK26LD 		RLCF             ACCB3, F

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