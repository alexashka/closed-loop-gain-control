; #include <../headers/pio.inc>
constant	HERE=2
#define		THIS	_v2_PIO
#define		_v2_PIO	_v2_PIO
#include <../headers/user_modes.inc>
#include <../headers/board/BoardSpecificFile.inc>
#define		bBumMip	 2
#define		bBumWork 3

#ifndef _I2CMInt_DEF
	#define _I2CMInt_DEF
	#ifndef CLOCK_FREQ
		#define CLOCK_FREQ      .20000
	#endif
	#define I2CM_BUS_FREQUENCY	.100
	#define I2CM_BUFFER_LENGTH	.20
;	#define I2CM_SINGLE_MASTER
	#define I2CM_MULTI_MASTER
	#define I2CM_NO_CONTROLED_SLEW_RATE
	#define I2CM_NO_SMBUS
#endif

;***********************************************;
; Baud Rate Genarator Reload value              ;
;***********************************************;    
_QUOTIENT    EQU    CLOCK_FREQ / (4 * I2CM_BUS_FREQUENCY)-1	;to convert the freq in 400KHz            
_REMAINDER   EQU    CLOCK_FREQ % (4 * I2CM_BUS_FREQUENCY)

        #if     _REMAINDER != 0
_I2CM_BAUD_COUNT    EQU     _QUOTIENT + 1						;_I2CMBAUDCOUNT is nearest to ((fosc/4)/I2CMSPEED)-1,
																; which has to be written in SSPADD.
        #else
_I2CM_BAUD_COUNT    EQU    _QUOTIENT							;_I2CMBAUDCOUNT = ((fosc/4)/I2CMSPEED)-1, which has to be written in SSPADD.
																;which has to be written in SSPADD.
        #endif
;-----------------------------------------------;
        #if     _I2CM_BAUD_COUNT > 127
        ERROR "At this System frequency, the given I2C frequency is not at tainable."
        #endif
        #if     _I2CM_BAUD_COUNT < 2 
        ERROR "At this System frequency, the given I2C frequency is not at tainable."
        #endif
		
;***********************************************************************;
; Macro:        mSetI2CMIntHighPriority                                 ;
; Overview:     Sets high priority for MSSP interrupt.                  ;
; Input:        None                                                    ;
; Output:       None                                                    ;
; Side Effects: None                                                    ;
;***********************************************************************;
mSetI2CMIntHighPriority MACRO
    bsf    IPR1,SSP1IP       ; High Priority for MSSP Int.
    bsf    IPR2,BCL1IP       ; High Priority for BusCollision Int.
						ENDM 
						
						
;***********************************************************************;
; Macro:        mSetI2CMIntLowPriority                                  ;
; Overview:     Sets low priority for MSSP interrupt.                   ;
; Input:        None                                                    ;
; Output:       None                                                    ;
; Side Effects: None                                                    ;
;***********************************************************************;
mSetI2CMIntLowPriority  MACRO 
	bcf    IPR1,SSP1IP                           ;Low Priority for MSSP Int.
	bcf    IPR2,BCL1IP                           ;Low Priority for BusCollision Int.
	ENDM



;***********************************************;
;I2CMIntState register bits                     ;
;***********************************************;
constant    I2CMTRANSMITSTATE   =	0
constant    I2CMCHECKACKSTATE   =	1
constant    I2CMRECEIVESTATE    =	2
constant    I2CMRECEIVEENSTATE  =	3
constant    I2CMSTOPSTATE       =	4
constant	I2CMTX				=	5
constant	I2CMRSTRT			=	6
constant	I2CMSTP				=	7

;// именование битов состояния
#define    	bI2CMTransmitState	_vI2CMIntState,I2CMTRANSMITSTATE	;Indicates Transmission has to be done
#define    	bI2CMCheckAckState	_vI2CMIntState,I2CMCHECKACKSTATE	;Indicates Acknowledge has to be checked
#define    	bI2CMReceiveState	_vI2CMIntState,I2CMRECEIVESTATE		;Indicates Reception has to be done
#define    	bI2CMReceiveEnState	_vI2CMIntState,I2CMRECEIVEENSTATE	;Indicates Reception has to be enabled
#define    	bI2CMStopState		_vI2CMIntState,I2CMSTOPSTATE		;Indicates Stop has to be sent
#define		bI2CMTx				_vI2CMIntState,I2CMTX				;1-Transmission is going on, 0-Reception is going on
#define		bI2CMRStrt			_vI2CMIntState,I2CMRSTRT			;Repeated Start bit has to be sent
#define		bI2CMStp			_vI2CMIntState,I2CMSTP				;Stop bit has to be sent

;***********************************************;
;I2CMIntStatus register bits                    ;
;***********************************************;
;// именование битов статуса                                            
constant	I2CMERRBUSCOLLISION =    7                    ;I2C Bus collision occured
constant	I2CMERRBUSBUSY      =    6                    ;I2C Bus is Busy(занята)
constant	I2CMERRNOACK        =    5                    ;Slave didn't acknowledge
constant	I2CMDATAREADY       =    4                    ;I2C Rx Data is ready
constant	I2CMBUSY            =    3                    ;I2CM Communication going on
constant	I2CMBUFOVERFLOW     =    2                    ;I2CM Buffer Over flow
constant	I2CMBUFFULL         =    1                    ;I2CM Buffer Full
constant	I2CMBUFEMPTY        =    0                    ;I2CM Buffer Empty

#define		bI2CMErrBusCollision vI2CMIntStatus,I2CMERRBUSCOLLISION	;I2C Bus collision occured
#define		bI2CMErrBusBusy      vI2CMIntStatus,I2CMERRBUSBUSY		;I2C Bus is Busy
#define		bI2CMErrNoAck        vI2CMIntStatus,I2CMERRNOACK		;Slave did'nt acknowledge
#define		bI2CMDataReady       vI2CMIntStatus,I2CMDATAREADY		;I2C Rx Data is ready
#define		bI2CMBusy            vI2CMIntStatus,I2CMBUSY			;I2CM Communication going on
#define		bI2CMBufOverFlow     vI2CMIntStatus,I2CMBUFOVERFLOW		;I2CM Buffer Over flow
#define		bI2CMBufFull         vI2CMIntStatus,I2CMBUFFULL			;I2CM Buffer Full
#define		bI2CMBufEmpty        vI2CMIntStatus,I2CMBUFEMPTY		;I2CM Buffer Empty
;***********************************************;

;g lobal vI2CMIntBuffer_VAP_out
global	vI2CMIntStatus

