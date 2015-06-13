; file #include <../headers/ProtocolExchange.inc>
; abs . : описывает протоколы обмена
; Длины сообщений 
#define PRE_APM_MSG_LEN	10
#define OK_I_MSG_LEN	10

;/// /// ///
;///
;/// I2C -> pca9539 commands
#define IN_TO_PORT0	0x00 	;Output Port 0 Read/write byte 1111 1111
#define IN_TO_PORT1	0x01 	;Output Port 1 Read/write byte 1111 1111
#define OUT_TO_PORT0	0x02 	;Output Port 0 Read/write byte 1111 1111
#define OUT_TO_PORT1 	0x03 	;Output Port 1 Read/write byte 1111 1111
;0x04 ;Polarity Inversion Port 0 Read/write byte 0000 0000
;0x05 ;Polarity Inversion Port 1 Read/write byte 0000 0000
#define CONF_PORT0 		0x06	;Configuration Port 0 Read/write byte 1111 1111 iiii_iiii
#define CONF_PORT1 		0x07	;Configuration Port 1 Read/write byte 1111 1111 iiii_iiii

; I2C exchange addresses b'1110_1[A1][A0][R/~W]'
#define ADD_ATT 		0xE8 ; b'1110_1000'
#define ADDR_DET 		0x68
#define ADDR_DET_RD		0x69
; все адреса на запись xxxx_xxx0
#ifdef	_3Ublock
	constant ADROK1	=	0x76; 0x72	msb nW/R: lsb
	constant ADROK2	=	0x72; 0x74
	constant ADROK3	=	0x74; 0x76
	constant ADROK4	=	0x78
#else
	constant ADROK1	=	0x72; 0x72
	constant ADROK2	=	0x72; 0x74
	constant ADROK3	=	0x72; 0x76
	constant ADROK4	=	0x72
#endif
;#define ADDR_JUMPER 0xE_101x
#define ADDR_JUMPER_WR 	0xEA
#define ADDR_JUMPER_RD 	0xEB

;///
;///
;/// /// ///

;/// /// ///
;///
;/// UART
;// Types Msgs
#define CMD_FROM_PC_GET_12	0x01
#define TYPE_MSG_GET_NFO_ABOUT_MIP	0x02
#define TYPE_MSG_CPUX_LOG	0x05
	;// Формат пакета, приходящего от ПК : 
	;//  0xAA
	;//    0x55
	;//	 // под дальнейшие данные выделен отдельный блок памяти?
	;//      0xXX - длина сообщения
	;//		   0x1F - 
	;//		     0xXX - тип сообщения TYPE_MSG
	;//			   0xXX - дополнительная информация для сообщения
   	;//			     0xXX - СRC
#define TYPE_MSG_VALUE_ATT_GAIN		0x06
		;// ! В коммандном формате передается информация!! 
		;// ! Нужно гарантировать, что не вклинится ни одна другая комманда
		;// Проверка состояния должна быть здесь, сразу, как определили, 
		;//   что получили комманду. И наче значение усиления аттенюатора, может
		;//   быть принято за комманду. 
; все меньше 0x6B
#define TYPE_MSG_CMD 	0x03
#define TYPE_MSG_CMD_SET_ATT_STAGE1	0x40
#define RST_PARAMETERS 	0x37  ;// комманда сброса параметров
#define OPEN_MIP 	0x1E

;/// /// ///
;///
;/// Other
DAC_A_LSB		equ		0x10
DAC_B_LSB		equ		0x12
DAC_C_LSB		equ		0x14
DAC_D_LSB		equ		0x16

;// SPI - адреса регистров 7516 может одной, может двух
CONTROL1		equ		0x18	; Control Configuration 0
CONTROL2		equ		0x19	; Control Configuration 1
CONTROL3		equ		0x1A	; Control Configuration 2
;C4 Selects the ADC reference to be either internal VREF or VDD for analog inputs.
;	0 = internal VREF.
;	1 = VDD.
INT_MASK1		equ		0x1D
DAC_CONFIG		equ		0x1B
LDAC_CONFIG		equ		0x1C
; Токи и выводы 7516_A
; I_1 = N1 - N3 - IF1 - AIN1/D-
; I_2 = N2 - N4 - IF  - AIN2/D+
; AIN1: Analog Input. cоотв. рег. - Должент быть 8+2 и таких 4 шт
;   Single-ended analog input channel. 
;   Input range is 0 V to 2.28 V or 0 V to VDD.
;0x04 External Temp and AIN1 to AIN4 LSBs 0x00
;	D7 D6    D5 D4     D3 D2    D1  D0
;	A4 A4LSB A3 A3LSB  A2 A2LSB T/A T/ALSB
;0x08 External Temp MSBs/AIN1 MSBs 0x00
;0x09 AIN2 MSBs 0x00

; Input range is 0 V to 2.28 V or 0 V to VDD.
; 10 bit - 5 V

constant	WRITECOMMAND	=	0x90
constant	READCOMMAND		=	0x91
;INT_MASK2		equ		0x1E
;ADC_AIN4_MSB	equ		0x0B
;ADC_LSB			equ		0x04

AD8402_CHA	equ		b'00000000'
AD8402_CHB	equ		b'01000000'
AD8522_CHA	equ		b'10100000'
AD8522_CHB	equ		b'11000000'

constant SPEED=10;	; cкоростная прокрутка?