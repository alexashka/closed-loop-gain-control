;************************************************************
; file : _v2_PIO.asm

; abs. : Модуль обслуживания аппаратного обеспечения контроллера. Интерфейсы
;   к железу и управление переферией

;************************************************************
#include <headers/pio.inc>
#include <headers/pio_return_codes.inc>
mObject_var	_v2_PIO
	; в обработчиках событий должно быть
	;
; Danger!!!
	  Adc_Temp	res		2	; No/Yes
	RCSTA_Temp	res		1	; pio
	RCREG_Temp	res		1	; pio
	      Temp	res		1	; No/Yes
	  SPI_Temp	res		1	; Yes
	  Com_Temp	res		2	; pio
	 Tmr0_Temp	res		2	; pio
      Led_temp	res		1	; pio
; Danger!!!

	;// ячейки памяти обеспечение работы I2C
	vI2CMIntStatus			res	1	;I2C Mas Communication Status/Error Register
	_vI2CMIntState			res	1	;I2C Mas Communication Status Register
	_vI2CMIntTxDataCount	res	1	;Space to store number of bytes to be received
	_vI2CMIntRxDataCount	res	1	;Space to store number of bytes to be transmitted
	_vI2CMIntRSPnt			res	1	;Space to store number of bytes to be transmitted before sending Repeated start
	_vI2CMIntBufRdPtr		res	1	;I2CM Buffer Read Pointer
	_vI2CMIntBufWrPtr		res	1	;I2CM Buffer Write Pointer
	_vI2CMIntTempReg		res	1	;For temporary use
	_vI2CMIntDupFSR			res	1	;Storage for FSR/FSR0L
	_vI2CMIntDupFSRH		res	1	;Storage for FSR0H

	;// сюда приходят данные от больших усилителей
	; 20 разрядный буффер
	vI2CMIntBuffer			res	I2CM_BUFFER_LENGTH  ;I2CM Buffer нумер. данных с 2
#ifdef VUM
	vI2CMIntBuffer_VAP_in	res		29	;I2CM Buffer
	vI2CMIntBuffer_VAP_out	res		I2CM_BUFFER_LENGTH  ;I2CM Buffer нумерация данных с 0
#else
	Mock0	res		29  ;I2CM Buffer
	Mock1	res		I2CM_BUFFER_LENGTH  ;I2CM Buffer нумерация данных с 0
#endif

	
object	code

;/// /// ///
;///
;///
#include <io_spi.code>
;/// I2C iface
#include <io_i2c_zone.code>
;///
;///
;/// /// ///

;/// /// ///
;///
;/// инициализация нижней аппаратной структуры
_v#v(HERE)_PIO_INI:
	mObject_sel	THIS

	; Feature=Oscillator - Oscillator configuration
	clrf OSCTUNE

	; Feature=Reset - Reset configuration
	movlw	0x83
	movwf	RCON

	; Конфигурирует PORTs
	mCall	pio_priv_configPORTSx;()

	; Инициализировать USARTы
	mCall	pio_priv_initUSARTs;()

	; сконфигурировать Analog 2 Dig? настройка преобразования
	mCall	pio_priv_configADConvertors;()

	; Настройка внешнего АЦП
	mCall	pio_priv_confExternADC;()

	; Разрешить прерывания?
	mSetI2CMIntLowPriority
	mSlideTo	_I2CMIntInit  ; просто goto
;/// end init()
;///
;/// /// ///

; похоже что конфигурирует внутренние порты ацп
pio_priv_configADConvertors;()
; Feature=A2D - A2D configuration
	movlw 	b'00000001'                       ; GO bit1 to 0
	movwf 	ADCON0
	movlw 	b'00000110'
	movwf 	ADCON1
	movlw 	b'10010101'
	movwf 	ADCON2
; Feature=required - Interrupt flags cleared and interrupt configuration
	movlw 	b'11111110'	;hp all uart1+adc_hi
	movwf 	IPR1
	movlw 	b'00110000'	;hp all uart2
	movwf 	IPR3
	movlw 	b'11000000'
	movwf 	INTCON
	movlw 	b'01100100'
	movwf 	INTCON2
	movlw 	b'11000000'
	movwf 	INTCON3
; Feature=Interrupts - enable interrupts
	movlw 	b'01100000'
	movwf 	PIE1
	movlw 	b'00100000'
	movwf 	PIE3
	mRETURN

; Настраивает PORTs
pio_priv_configPORTSx;()
; Feature=IOPortA - IO Ports configuration
	movlw 	0xFF; 150811 0xBF
	movwf 	PORTA
	movlw 	0xAF	;	0xBF
	movwf 	TRISA

; Feature=IOPortB - IO Ports configuration
	movf	PORTB,w
	movlw 	0x39; 150811  0x19
;	movwf	LATB
	movwf	PORTB
	movlw 	0xD4; PORTB,5 output 150811 0xF4	;	091110 0xE4		;PORTB,5 input
	movwf 	TRISB

; Feature=IOPortC - IO Ports configuration
	movlw 	0x18
	movwf 	PORTC
	movlw 	0xBE
	movwf 	TRISC

; Feature=IOPortD - IO Ports configuration
	movlw 	0x0C
	movwf 	PORTD
	movlw 	0xA2
	movwf 	TRISD

; Feature=IOPortE - IO Ports configuration
	movlw 	0x23 ; ///включил dc3
	movwf 	LATE;, PORTE
	movlw 	0x8C
	movwf 	TRISE

; Feature=IOPortF - IO Ports configuration
	movlw 	0xEF
	movwf 	TRISF

; Feature=IOPortG - IO Ports configuration
; K порту G подключен блок ввода вывода на ПК
; RG1 - TX2
; RG2 - RX2
	movlw	b'00000000'
	movwf	PORTG
	movlw 	0x1F  ; 0001_1111
	movwf 	TRISG
	movlw 	0xE5	;	091110 0xF4  ; 1110_0101
	movwf 	TRISG

; Feature=IOPortH - IO Ports configuration
	movlw 	0x4B	;	091110 0x0B
#ifdef	_duplex
	movlw 	0x4A	;	091110 0x0A
#endif
	movwf 	PORTH

#ifdef	_Uniplex
	movlw	0x25
#else
	movlw	0x24	;	091110 0xF4
#endif
	movwf 	TRISH

; Feature=IOPortJ - IO Ports configuration
	movlw 	0x1F
	movwf 	TRISJ
	mRETURN

; Инициализация усарторв
pio_priv_initUSARTs;()
; Feature=USART1 - EUSART configuration
	movlw 	b'01001000'		; set up receive options
	movwf 	BAUDCON1
	movlw 	b'10010000'		; set up receive options
	movwf 	RCSTA1
	movlw 	b'00100110'     ; set up transmit options
	movwf 	TXSTA1
	movlw 	low d'520'	    ; set up baud 20MHz 9600
	movwf	SPBRG1
	movlw 	high d'520'	    ; set up baud 20MHz 9600
	movwf	SPBRGH1
	movf 	RCREG1, W       ; flush receive buffer
	movf 	RCREG1, W

; Feature=USART2 - EUSART configuration
	movlw 	b'01001000'		; set up receive options
	movwf 	BAUDCON2
	movlw 	b'10010000'		; set up receive options
	movwf 	RCSTA2
	movlw 	b'10100110'		; set up transmit options
	movwf 	TXSTA2
	movlw 	low d'42'		; set up baud 20MHz 115200
	movwf	SPBRG2
	movlw 	high d'42'		; set up baud 20MHz 115200
	movwf	SPBRGH2
	movf 	RCREG2, W		; flush receive buffer
	movf 	RCREG2, W
	mRETURN

; ? Почему заголовочные файлы в конце
;// похоже из-за такого подключения видны переменные в inc-файлах
;/// /// ///
;///
;/// #include	<headers\_v2_PIO_UP.inc> UPwards methodes
;  Похоже на обработчики прерываний по портам и т.п.
; все процедуры с обычным выходом, а не выходом из прерывания

;обработчик прерывания по таймеру 0
_v#v(HERE)_PIO_SETuw_Timer0Int;(void/void)
	bcf		T0CON,TMR0ON
	mRETURN

;обработчик прерывания по таймеру 1
_v#v(HERE)_PIO_SETuw_Timer1Int;(void/void)
	mSlideTo	_v#v(UP)_CLK_HLTuw_Tick;(void/void)
	mRETURN

;/// /// ///
;///
;/// USART's - куча макросов
;обработчик прерывания по приему байта UART1
_v#v(HERE)_PIO_SETuw_Uart1RxInt;(void/void)
	mObject_sel	THIS
	movff	RCSTA1,	RCSTA_Temp  ; RCSTA_Temp - ? где объявлен
	movff	RCREG1,	RCREG_Temp
	btfsc	RCSTA_Temp,	FERR
	mSlideTo	_v#v(UP)_BUPR_SETuw_ByteError;(void/void)
	btfsc	RCSTA_Temp,	OERR
	mSlideTo	_v#v(UP)_BUPR_SETuw_BufFull;(void/void)
	movf	RCREG_Temp,w
	mSlideTo	_v#v(UP)_BUPR_SETuw_wByteIn;(byte W/void)
	mRETURN

;обработчик прерывания по передаче байта UART1
_v#v(HERE)_PIO_SETuw_Uart1TxInt;(void/void)
	mSlideTo	_v#v(UP)_BUPR_SETuw_ByteOut;(void/void)
	mRETURN

;// UART2 - RS-232
; Обработчик прерывания по приему байта UART2
_v#v(HERE)_PIO_SETuw_Uart2RxInt;(void/void)
	mObject_sel	THIS
	movff	RCSTA2,	RCSTA_Temp  ; Receive Status and Control
	movff	RCREG2,	RCREG_Temp  ; movff -> s2d ; RSREG2 - вот они полученные данные
	btfsc	RCSTA_Temp,	FERR
	mSlideTo	_v#v(UP)_COMP_SETuw_ByteError;(void/void)
	btfsc	RCSTA_Temp,	OERR
	mSlideTo	_v#v(UP)_COMP_SETuw_BufFull;(void/void)
	movf	RCREG_Temp,w	; ! комманда делает что-то странное
		; байт, !бит, !бит
	;// обрабатывавем полученные данные
	mSlideTo	_v#v(UP)_COMP_SETuw_wByteIn;(byte W/void)
	mRETURN

; Обработчик прерывания по передаче байта UART2
; ?вычисляет контрольную сумму и отправляет что-то из
; аккамулятора
_v#v(HERE)_PIO_SETuw_Uart2TxInt;(void/void)
	mSlideTo	_v#v(UP)_COMP_SETuw_ByteOut;(void/void)
	mRETURN

;/// end USART's
;///
;/// /// ///

;/// /// ///
;///
;/// Функции работы с модулями
;запуск таймера 0
_v#v(HERE)_PIO_SETdw_Timer0Enable;(VOID/VOID)
	constant	f=20/4
	variable	n=0
	variable	e=0
	variable	q=2
	e=10000;микросекунд
	n=0
	while ((e/q)>=65535/f) && (n<=7)
		q=q*2
		n++
	endw

	bcf		INTCON,TMR0IF
	movlw	high(65535-(e*f/q))
	movwf	TMR0H
	movlw	low (65535-(e*f/q))
	movwf	TMR0L
	movlw	low (128 + n)
	movwf	T0CON
	bsf		INTCON,TMR0IE
	mRETURN

;/// запуск таймера 0
;// Tmr0_Temp - 2x8
_v#v(HERE)_PIO_GETdw_Timer0ReadF;(VOID/mass FSR0)
	movff	TMR0L,Tmr0_Temp
	movff	TMR0H,Tmr0_Temp+1
	lfsr	0,Tmr0_Temp		; отправляем указатель в FSR0
	mRETURN


;// остановка таймера 0
_v#v(HERE)_PIO_SETdw_Timer0Disable;(VOID/VOID)
	bcf		T0CON,TMR0ON
	bcf		INTCON,TMR0IE
	bcf		INTCON,TMR0IF
	mRETURN

;/// запуск таймера 1 - только запуск - похоже он мониторящий
;// по нему очень много что вызывается
_v#v(HERE)_PIO_SETdw_Timer1Enable;(VOID/VOID)
	e=4993;	45000;микросекунд
	n=0
	q=1
	while ((e/q)>=65535/f) && (n<=3)
		q=q*2
		n++
	endw	;// end while?

	; похоже на запрет прерываний
	bcf		PIR1,TMR1IF 	;// Bit Clear f ? TMR1IF - регистр переполнен
	; настройка таймера
	movlw	high (65535-(e*f/q))
	movwf	TMR1H
	movlw	low (65535-(e*f/q))
	movwf	TMR1L
	movlw	low ((n<<4) + 1)
	movwf	T1CON
	;//
	bsf		PIE1,TMR1IE	;// Bit Set f
	mRETURN

;/// Настройки таймеров
;///
;/// /// ///

;/// /// ///
;///
;/// USART's
; Передает первый байт из W через UART2
_v#v(HERE)_PIO_SETdw_wUart2StartTx;(byte W/VOID)
	bsf		TXSTA2,	TXEN
	movwf	TXREG2
	bsf		PIE3, TX2IE
	mRETURN

;bit 5 RC2IF: EUSART2 Receive Interrupt Flag bit
;  1 = The EUSART2 receive buffer, RCREG2, is full (cleared when RCREG2 is read)
;  0 = The EUSART2 receive buffer is empty
;bit 4 TX2IF: EUSART2 Transmit Interrupt Flag bit
;  1 = The EUSART2 transmit buffer, TXREG2, is empty (cleared when TXREG2 is written)
;  0 = The EUSART2 transmit buffer is ful

; Передача очередного байта, находящегося в W через UART2
_v#v(HERE)_PIO_SETdw_wUart2NextTx;(byte W/VOID)
	movwf	TXREG2  ; все отправка, но как сгенерировать прерывание на отправку?
			; ! при передачи стартового байта разрашеются прерывания
	mRETURN	 ; выход уже включен

;отключение прерывания по передаче.
_v#v(HERE)_PIO_SETdw_Uart2StopTx;(VOID/VOID)
	bcf		PIE3,TX2IE
	mRETURN

;/// UART1
; Передача первого байта W через UART1
; включает прерывания для пакета данных
_v#v(HERE)_PIO_SETdw_wUart1StartTx;(byte W/VOID)
#ifndef	_duplex
	bcf		RCSTA1,	CREN
#endif
	bsf		bDE
	nop
	movlw	0xAA	;// опять это магическое число
	bsf		TXSTA1,	TXEN	;andr
	movwf	TXREG1
	nop
	bsf		PIE1, TX1IE
	mRETURN

; Передача очередного байта W через UART1.
; прерываения включены при старте. Это нужно для передачи на
; максимальной скорости
_v#v(HERE)_PIO_SETdw_wUart1NextTx;(byte W/VOID)
	movwf	TXREG1
	mRETURN

; Отключение прерывания по передаче.
_v#v(HERE)_PIO_SETdw_Uart1StopTx;(VOID/VOID)
	bcf		PIE1,TX1IE
	bcf		TXSTA1,	TXEN

#ifdef	manyBUM_OFF_bDE	;откл передатчика485 производим, если в прд >1-го БУМа
	bcf		bDE
#endif
	nop
#ifndef	_duplex
	bsf		RCSTA1,	CREN
#endif
	mRETURN

;/// end USART's
;///
;/// /// ///


;/// /// ///
;///
;///
_v#v(HERE)_PIO_ASKdw_MipNormaW;(VOID/bool W)
	btfss	bALMP
	retlw	NORMA
	retlw	SLOMAN
	mRETURN

_v#v(HERE)_PIO_SETdw_wMipControl;(byte W/VOID)
	movwf	PORTJ	;save file to port
	clrf	TRISJ	;DATA BUS to output
	bsf		bLENREGD24		;unlock register
	bcf		bLENREGD24		;lock register
	bcf		bSELREGD24		;reg select
	setf		PORTJ
	mRETURN

;// ! ее вызывают все функции из LED
_v#v(HERE)_PIO_SETdw_wLedControl;(byte W/VOID)
	mObject_sel	THIS

	movwf	Led_temp	; перенос содержимого аккамулятора в регистровый файл
		; ! но Le.. Отображает куда переносится, а где она объявлена?

	btfss	Led_temp,bBumMip	;	ON wire
	bcf		PORTB,5	;	это новые строки добавленные Славой 150811
	btfsc	Led_temp,bBumMip
	bsf		PORTB,5

	btfss	Led_temp,bBumWork		;	LR wire
	bcf		PORTA,6	;	это новые строки добавленные Славой 150811
	btfsc	Led_temp,bBumWork
	bsf		PORTA,6
	return
	mRETURN



;// ! Интерфейс передачи не указан

; Function:отпирание аттенюатора БУМ                 
; Input: 'W' Register
; Output: Buffer
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_SetUnlock;(VOID/VOID)
	bsf		bZP
	mRETURN

; Function:запирание аттенюатора БУМ         
; Input: 'W' Register
; Output: Buffer
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_Setlock;(VOID/VOID)
	bcf		bZP
	mRETURN

; Function:отпускание закорачивателя смещения
; Input: 'W' Register
; Output: Buffer
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_ShiftUnlock;(VOID/VOID)
	bcf		bZAP
	mRETURN

; Function:включение закорачивателя смещения  
; Input: 'W' Register
; Output: Buffer
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_Shiftlock;(VOID/VOID)
	bsf		bZAP
	mRETURN

; Function:сброс ЦАП смещения в ноль           
; Input: 'W' Register
; Output: Buffer
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_ShiftReset;(VOID/VOID)
	bsf		bRSB1
	nop
	bcf		bRSB1
	mRETURN

; Function:включение режима Цифра              
; Input: 'W' Register
; Output: Buffer
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_DigiMod;(VOID/VOID)
	bcf		bD_A
	mRETURN

; Function:режим Аналог
; Input: 'W' Register
; Output: Buffer
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_AnaMod;(VOID/VOID)
	bsf		bD_A
	mRETURN



; Function:считывание адреса БУМ
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_AdrLoadW;(VOID/byte W)
#ifdef		otladka
	retlw	0x03
#endif
	bcf		bDC3
	nop
	movff	TRISJ,Com_Temp
	movf	PORTJ,w
	movlw	b'00011111'
	movwf	TRISJ
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
	movf	PORTJ,w
	movff	Com_Temp,TRISJ
	andlw	b'00011111'
	xorlw	b'00011111'
	btfsc	STATUS,Z
	retlw	0x1F
	xorlw	b'00011111'
	addlw	2
	mRETURN

; Function:считывание провод-команд           
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_ComLoadW;(VOID/byte W)
	lfsr	1,Com_Temp+1
	bsf		bDC3
	nop
	movff	TRISJ,Com_Temp
	bcf		bRB
	nop
	bsf		bRB
	movlw	b'00001111'
	movwf	TRISJ
	nop
	movff	PORTJ,INDF1
	bcf		bRB
	nop
	bsf		bRB
	movlw	b'00001111'
	movwf	TRISJ
	nop
	movf	PORTJ,w
	xorwf	INDF1,w
	btfss	STATUS,Z
	retlw	0

	movf	INDF1,w
	andlw	b'00001111'
	movff	Com_Temp,TRISJ
	bcf		bDC3
	mRETURN


; Function:считывание провод-команд           
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_AudioOn;(void/byte W)
	movlw 	0x7F
	movwf	PR4
	movlw	0x7F/4
	movwf	CCPR4L
	bcf		TRISG,3
	movlw	b'00000111'
	iorwf	T4CON
	bsf		T3CON,6
	bsf		T3CON,3
	movlw	b'00001100'
	iorwf	CCP4CON
	mRETURN

; Function:считывание провод-команд
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_AudioOff;(VOID/void)
	bsf		TRISG,3
	mRETURN

; Function:считывание провод-команд
; Stack requirement: 1 level deep
; _BUM_SETdw_wFlowOn ШИМ? программа генерации шин
_v#v(HERE)_PIO_SETdw_wFlowOn;(byte/byte W)
	; в аккамуляторе по идее разультаты вычисления параметров вращения
#ifdef Z_ROLL
	mCall	setZ0
#endif
	movwf	CCPR5L	; куда-то сохраняемся Timer3?
	movlw 	0x7F
	movwf	PR4
	bcf		TRISG,4
	movlw	b'00000111'
	iorwf	T4CON
	bsf		T3CON,6
	bsf		T3CON,3
	movlw	b'00001100'
	iorwf	CCP5CON
	mRETURN

;/// еще кусок uart'a
_v#v(HERE)_PIO_SETdw_Uart1Antifreeze;(void/void)
	bcf		RCSTA1,CREN
	nop
	bsf		RCSTA1,CREN
	mRETURN

; ------------------------------------------------------------
_v#v(HERE)_PIO_SETdw_Uart2Antifreeze;(void/void)
	bcf		RCSTA2,CREN
	nop
	bsf		RCSTA2,CREN
	mRETURN
; ------------------------------------------------------------

#ifdef WITH_HMC542
; что за микросхема? она вообще есть то?
_v#v(HERE)_PIO_SETdw_HMC542_wLoad;(w/void)
	mObject_sel	THIS
	bcf		bCS4
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	call	_SPI_SET_wByteIn
	bsf		bCS4
	nop
	mRETURN
#endif
;///
;///
;/// /// ///

;/// /// ///
;///
;/// A lrms
; сброс триггеров отказов предварительного усилителя.
_v#v(HERE)_PIO_SETdw_UpAlrPinReset;(VOID/VOID)
	bcf		bRSPI
	nop
	bsf		bRSPI
	mRETURN

; считывание провод-команд
_v#v(HERE)_PIO_SETdw_wLedAlrOn;(byte W/VOID)
	bsf		PORTA,6	; на плате используется ли? не видно
	mRETURN

; считывание провод-команд
_v#v(HERE)_PIO_SETdw_wLedAlrOff;(byte W/VOID)
	bcf		PORTA,6
	mRETURN
;///
;///
;/// /// ///

;/// /// ///
;///
;///  Обработчик прерывания по i2c?
; Function: I2CMIntISR
; PreCondition: Must be called from an interrupt handler
; Overview:
;       This is a !Interrupt !Service !Routine for Serial Interrupt.
;       It handles Reception and Transmission of data on interrupt.
;       Call it from Interrupt service routine.
; Side Effects: Bank selection bits and 'W' register are changed
; Stack requirement: 2 level deep
; есть вызовы из _BUM, не из _IRQ! ??? Да ну!
; вызывается как прогр. обраб. прерыв, но как эти прер. генерируются
pio_i2c_request;(void/w, fsr0)
	mObject_sel	THIS
	btfsc   PIR1,SSP1IF	;check has sspi f occurred
		bra     I2CMYes
#ifdef  I2CM_MULTI_MASTER
	btfss   PIR2,BCLIF	;check has bcli f occurred
		retlw	0xFF
	bcf     PIR2,BCL1IF
	; обработка коллизии нужна
	mSlideTo	_v2_PIO_SETdw_I2CMIntInit;(VOID/VOID) ;BUS_COLLISION
#endif
	retlw	0xFF
I2CMYes:
	movf    SSP1CON1,w
	andlw   00fh
	xorlw   008h
	btfss   STATUS,Z
		retlw	0xFF			;check is Master Mode
	btfsc   bI2CMTransmitState
		bra     I2CMTransmit
	btfsc   bI2CMCheckAckState
		bra     I2CMCheckAck
	btfsc   bI2CMReceiveState
		bra     I2CMReceive
	btfsc   bI2CMReceiveEnState
		bra     I2CMReceiveEn
	btfsc   bI2CMStopState
		bra     I2CMSendStop
	bra     I2CMEnd
;***********************************************
I2CMCheckAck:
	btfss   SSP1CON2,ACKSTAT			;checking for acknowledge from slave.
		bra     I2CMCheckWhatNext
	bsf     bI2CMErrNoAck
	goto    I2CMSendStop
I2CMCheckWhatNext:
	btfss   bI2CMRStrt			;Is repeated Start to be sent
		bra     I2CMTransmit
	movf    _vI2CMIntRSPnt,f			;If yes is this the point where it has to be sent
	btfsc	STATUS,Z
	goto    I2CMSendReStart		;i f yes goto send
;-----------------------------------------------
I2CMTransmit:
	tstfsz  _vI2CMIntTxDataCount,1		;Is transmission of all bytes over
		bra     I2CMRdTxData			;I f not goto read data to be transmitted
	tstfsz  _vI2CMIntRxDataCount,1		;If data to be received
		bra     I2CMReceiveEn			;goto enable receiver
	btfsc   bI2CMStp			;Is Stop has to be sent
		goto    I2CMSendStop
	bcf     bI2CMBusy			;clear busy and retlw	0xFF
	retlw	0xFF
I2CMRdTxData:
	movlw   0e0h
	andwf   _vI2CMIntState,f
	bsf     bI2CMCheckAckState			;Set next state to CheckAckState
	call    _I2CMIntRdBuf				;read a byte from circular buffer

	decf    _vI2CMIntTxDataCount,f		;decrement the Tx Data Count
	decf    _vI2CMIntRSPnt,f
	movwf   SSP1BUF
	bcf     PIR1,SSPIF			;clear serial_sync intrupt flag
	retlw	0xFF
;***********************************************
I2CMReceive:
	movf    SSP1BUF,w
	bcf     PIR1,SSP1IF			;clear serial_sync interrupt
	btfsc   bI2CMBufFull				;checking is buffer empty
		goto    I2CMBufFullErr
	call    _I2CMIntWrBuf				;write the byte into circular buffer
	bsf     bI2CMDataReady				;set Data Ready flag
	decfsz  _vI2CMIntRxDataCount,f		;decrement the to be Rx Data Count
		goto    I2CMAck
	btfsc   bI2CMStp			;Is Stop has to be sent
		goto    I2CMNoAck
	bcf     bI2CMBusy			;clear busy and retlw	0xFF
	retlw	0xFF
I2CMBufFullErr:
	bsf     bI2CMBufOverFlow
	retlw	0xFF
;***********************************************
I2CMAck:
	bcf     PIR1,SSP1IF			;clear serial_sync interrupt
	movlw   0e0h
	andwf   _vI2CMIntState,f
	bsf     bI2CMReceiveEnState			;Set next state to ReceiveEnState
	bcf     SSP1CON2,ACKDT
	bsf     SSP1CON2,ACKEN				;Acknowledge
	retlw	0xFF
;***********************************************
I2CMNoAck:
	bcf     PIR1,SSP1IF			;clear serial_sync interrupt
	movlw   0e0h
	andwf   _vI2CMIntState,f
	bsf     bI2CMStopState		;Set next state to StopState
	bsf     SSP1CON2,ACKDT
	bsf     SSP1CON2,ACKEN		;No_Acknowledge
	retlw	0xFF
;***********************************************
I2CMReceiveEn:
	bcf     PIR1,SSP1IF			;clear serial_sync interrupt
	movlw   0e0h
	andwf   _vI2CMIntState,f
	bsf     bI2CMReceiveState 	;Set next state to ReceiveState
	bsf     SSP1CON2,RCEN		;enable reciever
	retlw	0xFF
;***********************************************
I2CMEnd:
	bcf     PIR1,SSP1IF		;clear serial_sync interrupt
	bcf     PIE1,SSP1IE
	bcf     PIE2,BCL1IE
	bcf     bI2CMBusy		;clear Busy

	movlw	1<<I2CMDATAREADY	; ^ 1<<I2CMBUFFULL
	xorwf	vI2CMIntStatus,w
	btfss	STATUS,Z
		; Ошибка - не отвечает
		retlw	NOT_REQUESTED

	lfsr	0,vI2CMIntBuffer+1
	movf	POSTINC0,w

	; проскак д
	decf	vI2CMIntBuffer+1,f
	decf	vI2CMIntBuffer+1,f
_crc:
	addwf	POSTINC0,w
	decfsz	vI2CMIntBuffer+1
	bra		_crc
	xorwf	POSTINC0,w
	
	; принятие решений
	btfss	STATUS,Z
		; Ошибка - ошибка зпроса
		retlw	ERROR_REQUESTED

	; Данные готовы
	lfsr	0,	vI2CMIntBuffer+2	;load fsr with read pointer address
	
	; все хорошо
	retlw	ALL_RIGHT
	
; какие-то первые измерения
pio_pub_metroStep0;(void/fsr0+0+1)
	mObject_sel	THIS
	movff	ADRESL,Adc_Temp+0
	movff	ADRESH,Adc_Temp+1

	; передается буффер для сохранения
	lfsr	0,Adc_Temp
	mRETURN
;/// Обработчик прерывания по окончанию измерения АЦП
;///
;/// /// ///
; #include <../src_io/io_i2c_zone.code>


;/// /// ///
;///
;/// Имитация вызова проц. обр. прер. от i2c, только другой engine
#ifdef VUM;_DBG
pio_pub_getMockBuff;(void/fsr0)
	lfsr	0,	vI2CMIntBuffer_VAP_out
	mRETURN

;/// перераспределяем буффер УП
#define LEN_UP_MAG 28
pio_pub_oneBuff2OKOneBuff;(fsr0[r/w]/void)
	; Копируем буффер УП во временный
	lfsr	1,	vI2CMIntBuffer_VAP_in
	movlw	LEN_UP_MAG	; длина буффера данных УП
_CopyUPBuffLoop:
	movff	POSTINC0,POSTINC1  	; все равно массив затирает
	addlw	-1
	bnz		_CopyUPBuffLoop

	; Распиновка
	; токи
	movff	vI2CMIntBuffer_VAP_in+0,	vI2CMIntBuffer_VAP_out+0
	movff	vI2CMIntBuffer_VAP_in+1,	vI2CMIntBuffer_VAP_out+1
	movff	vI2CMIntBuffer_VAP_in+22,	vI2CMIntBuffer_VAP_out+2
	movff	vI2CMIntBuffer_VAP_in+23,	vI2CMIntBuffer_VAP_out+3
	; напряжение МИП
	movff	vI2CMIntBuffer_VAP_in+2,	vI2CMIntBuffer_VAP_out+4
	movff	vI2CMIntBuffer_VAP_in+3,	vI2CMIntBuffer_VAP_out+5
	; смещения
	movff	vI2CMIntBuffer_VAP_in+14,	vI2CMIntBuffer_VAP_out+6	;a8 pin17 Usm1
	movff	vI2CMIntBuffer_VAP_in+15,	vI2CMIntBuffer_VAP_out+7
	movff	vI2CMIntBuffer_VAP_in+16,	vI2CMIntBuffer_VAP_out+8	;a7 pin18 Usm2
	movff	vI2CMIntBuffer_VAP_in+17,	vI2CMIntBuffer_VAP_out+9
	; отказы! нужно преобразовать
	;	IN:
	;		m_UPalarm & 0x01 	m_Iup1ind
	;		m_UPalarm & 0x02	m_Iup2ind
	;		m_UPalarm & 0x04	m_Umipup_ind
	;	OUT:
	;		m_Ua lr2_4 & 0x01	m_Iuo1ind_4
	;		m_Ua lr2_4 & 0x02	m_Iuo2ind_4
	;		m_Ua lr2_4 & 0x08	m_Umipind_4

	banksel	vI2CMIntBuffer_VAP_in	; !!
	; генерируем отаказ - нужно проверть сколько раз пыт. скинуть
	;movlw	0x02
	;movff	WREG, vI2CMIntBuffer_VAP_in+18
	
	; дальше как обычно
	; банки выбрали и можно считать
	movlw	0x03	;0000_00ii - оба аварийных бита убираем
	andwf	vI2CMIntBuffer_VAP_in+18,	0	; vI2CMIntBuffer_VAP_in+3 = 000t_0uii и сохранилось в акк.
	movff	WREG,	vI2CMIntBuffer_VAP_out+11	; два отказа сохранили	vI2CMIntBuffer_VAP_out+11 = 0000_00ii
	; теперь раб. с кажд. битом отдельно, они идут в разнобой
	; добавляем отказ U
	movlw	0x04	;0000_0u00 - аварийный исходный МИП
	andwf	vI2CMIntBuffer_VAP_in+18,	0	; vI2CMIntBuffer_VAP_in+3 = 0000_0x00 и сохранилось в акк.
	rlncf	WREG	; 0000_u000
	iorwf	vI2CMIntBuffer_VAP_out+11	; vI2CMIntBuffer_VAP_out+11 = 0000_u0ii
	; добавляем отказ температуры
	movlw	0x10	;000t_0000 - аварийный исходный МИП
	andwf	vI2CMIntBuffer_VAP_in+18,	0
	iorwf	vI2CMIntBuffer_VAP_out+11	; vI2CMIntBuffer_VAP_out+11 = 000t_u0ii

	; температура
	movff	vI2CMIntBuffer_VAP_in+20,	vI2CMIntBuffer_VAP_out+12
	return
#endif
;///
;///
;/// /// ///

; Function: I2CMIntInit
; Overview:
;       This routine is used for MSSP/SSP/BSSP Module Initialization
;       It initializes Module according to CLM options and flushes the
;        buffer. It clears all I2C errors
; Input: CLM options
; Side Effects: Bank selection bits and 'W' register are changed
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_I2CMIntInit;(VOID/VOID)
_I2CMIntInit:
	mObject_sel	THIS
	bcf		SSP1CON1,SSPEN
	bsf		TRISC,3
	bsf		TRISC,4
	movlw	24

_loop_freeze:
	btfsc	PORTC,4
	bra		_normi2c
	bcf		PORTC,3
	bcf		TRISC,3
	nop
	bsf		TRISC,3
	addlw	-1
	bnz		_loop_freeze
		bra     _I2CStartErr

_normi2c:
	movlw	d'64';d'49'	;speed
	movwf	SSP1ADD
	movlw	b'10000000'
	movwf	SSP1STAT
	clrf	SSP1CON2
	movlw	b'00111000'	;master
	movwf	SSP1CON1

	;// сборос регисра состояние и статуса
	clrf    vI2CMIntStatus
	clrf    _vI2CMIntState
	mRETURN

; Function: I2CMIntStart
; PreCondition: I2CMIntInit must have a lready been called.
; Overview:
;       Sends Start bit(первый бит) on I2C Bus.
; Side Effects: Bank selection bits and 'W' register are changed
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_I2CMIntStart;(VOID/VOID)
I2CMIntStart:
	mObject_sel	THIS
	call	_I2CMIntInit		; все-таки call
	btfsc   SSP1STAT,S
	bra     _I2CStartErr		;i f Start bit a lready is set goto StartErr
	bcf     bI2CMErrBusBusy
_I2CSendStart:
	bcf     PIR1,SSP1IF			;clear serial_sync interrupt
	bsf     PIE1,SSP1IE			;enable serial_sync interrupt
#ifdef  I2CM_MULTI_MASTER
	bsf     PIE2,BCLIE			;enable Bus collision interrupt
#endif
	clrf    _vI2CMIntBufWrPtr
	clrf    _vI2CMIntBufRdPtr
	clrf    _vI2CMIntTxDataCount		;clear transmit data count
	clrf    _vI2CMIntRxDataCount		;clear receive data count
	movlw   009h						;Sets buffer empty flag & busy flag
	movwf   vI2CMIntStatus              ;Clears all error flags
	bsf     bI2CMTransmitState	;Set next state to TransmitState
	bsf     SSP1CON2,SEN		;Send START bit
	return

_I2CStartErr:
	bsf     bI2CMErrBusBusy
	mRETURN


; Function: I2CMIntReStart
; PreCondition: I2CMIntStart should have called.
; Overview:
;  Sends RepeatedStart condition on I2C Bus i f its free or sets a flag.
; Side Effects: Bank selection bits are changed
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_I2CMIntReStart;(VOID/VOID)
I2CMIntReStart:
	mObject_sel	THIS
	btfss   bI2CMBusy		;Check is it busy
		bra     I2CMSendReStart		;i f not send RepStart
	bsf     bI2CMRStrt		;Set RepStart to be sent flag
	movff   _vI2CMIntTxDataCount,_vI2CMIntRSPnt;Record present Tx datacount
	return
I2CMSendReStart:
	bcf     PIR1,SSP1IF		;clear serial_sync interrupt
	movlw   0e0h
	andwf   _vI2CMIntState,f
	bsf     bI2CMTransmitState		;Set next state to TransmitState
	bcf     bI2CMRStrt		;Clear RepStart to be sent flag
	bsf     SSP1CON2,RSEN			;Send Repeated START bit
	mRETURN


; Function: I2CMIntStop
; PreCondition: I2CMIntStart should have called.
; Overview:
;       Sends Stop bit on I2C Bus i f its free or sets a flag.
; Side Effects: Bank selection bits and 'W' register are changed
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_I2CMIntStop;(VOID/VOID)
I2CMIntStop:
	mObject_sel	THIS
	btfss   bI2CMBusy		;Check is it busy
		bra     I2CMCheckIsRx		;i f not check is it Reception
	bsf     bI2CMStp		;Set Stop bit to be sent flag
	return
I2CMCheckIsRx:
	bsf     bI2CMBusy
	btfss   bI2CMTx			;Check is it reception
		goto    I2CMNoAck			;If so send NoAck
I2CMSendStop:
	bcf     PIR1,SSPIF		;clear serial_sync interrupt
	movlw   0e0h
	andwf   _vI2CMIntState,f		;Set next state to EndState
	bcf     bI2CMStp		;Clear Stop to be sent flag
	bsf     SSP1CON2,PEN		;Send STOP bit
	mRETURN

;/// /// ///
;///
;/// Программа отсылки байта по i2c
; Function: I2CMIntPut
; PreCondition: I2CMIntStart should have called.
; Overview:
;       Sends data byte over I2C Bus i f Bus is free or store in Buffer.
; Input: 'W' значение для посылки в аккамуляторе
; Side Effects: Bank selection bits and 'W' register are changed
; Stack requirement: 1 level deep        ! переходит на метку ! посел RETURN
_v#v(HERE)_PIO_SETdw_I2CMIntPut;(byte W/VOID)
I2CMIntPut:
	mObject_sel	THIS
	bsf     bI2CMTx
	btfss   bI2CMBusy				;Check is it busy
		bra     I2CDirectTx
	; запрещаем прер.
	bcf     PIE1,SSP1IE
	call    _I2CMIntWrBuf			;If busy
	incf    _vI2CMIntTxDataCount,f	;Save in buffer Increment Tx Data Count
	; разрешаем прерывания
	bsf     PIE1,SSP1IE
	mRETURN
I2CDirectTx:
	bsf		bI2CMBusy
	movlw	0e0h
	andwf	_vI2CMIntState,f
	bsf		bI2CMCheckAckState		;Set next state to CheckAckState
	movwf	SSP1BUF
	bcf		PIR1,SSP1IF				;clear serial_sync intrupt flag
	mRETURN

; Function: _I2CMIntWrBuf
; Overview:
;       This writes data into buffer.                                   
; Input: 'W' Register
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_I2CMIntWrBuf;(byte W/VOID)
_I2CMIntWrBuf:
	mObject_sel	THIS
	btfsc   bI2CMBufFull
		return
	movff   WREG,_vI2CMIntTempReg	;save the wreg content (data) in temflg
	movff   FSR0H,_vI2CMIntDupFSRH
	movff   FSR0L,_vI2CMIntDupFSR	;Save FSR
		#ifdef  _DONT_USE_LFSR
	movlw   HIGH(vI2CMIntBuffer)
	movwf   FSR0H
	movlw   LOW(vI2CMIntBuffer)		;load wreg with write pointer address
	addwf   _vI2CMIntBufWrPtr,w
	movwf   FSR0L
		#else
	lfsr    FSR0,vI2CMIntBuffer		;load fsr with read pointer address
	movf    _vI2CMIntBufWrPtr,w
	addwf   FSR0L
		#endif
	btfsc   STATUS,C
		incf    FSR0H,f
	movff    _vI2CMIntTempReg,INDF0	;write the content to write pointer pointing location
	movff   _vI2CMIntDupFSR,FSR0L
	movff   _vI2CMIntDupFSRH,FSR0H	;Retrive FSR
	incf    _vI2CMIntBufWrPtr,f		;increment write pointer
	movlw   I2CM_BUFFER_LENGTH
	xorwf   _vI2CMIntBufWrPtr,w
	btfsc   STATUS,Z
		clrf    _vI2CMIntBufWrPtr
	movf    _vI2CMIntBufWrPtr,w
	xorwf   _vI2CMIntBufRdPtr,w		;Check is buffer full
	btfsc   STATUS,Z
		bsf     bI2CMBufFull
	bcf     bI2CMBufEmpty
	mRETURN

; Function: I2CMIntDiscardBuf
; Overview:
;       This flushes the buffer.                                        
; Input: 'W' Register
; Output: Buffer
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_I2CMIntDiscardBuf;(byte W/VOID)
I2CMIntDiscardBuf:
	mObject_sel	THIS
	clrf    _vI2CMIntBufRdPtr
	clrf    _vI2CMIntBufWrPtr
	bsf     bI2CMBufEmpty
	bcf     bI2CMBufFull
	bcf     bI2CMBufOverFlow
	mRETURN
;/// Write
;///
;/// /// ///
	
;/// /// ///
;///
;/// операции чтения
; Function: I2CMIntSetGetCount
; PreCondition: I2CMIntPut should have called.
; Overview:
;      Enables Master receiver, notes the no. of bytes to be received.
; Input: 'W' Reg
; Side Effects: Bank selection bits and 'W' register are changed
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_I2CMIntSetGetCount;(byte W/VOID)
I2CMIntSetGetCount:
	mObject_sel	THIS
	addwf   _vI2CMIntRxDataCount,f
	btfsc   bI2CMBusy		;Check is it busy
		return
	bsf     bI2CMBusy
	btfss   bI2CMTx			;If not busy and Ack is due
		mSlideTo    I2CMAck		;Goto send Ack
	bcf     bI2CMTx
	mSlideTo    I2CMReceiveEn	;Enable receiver


;Function I2CMIntGet
;Pre-conditions The function ‘I2CMIntSetGetCount’ should have been called and the
;bit ‘vI2CMIntStatus<I2CMDataReady>’ should read ‘1’.

;Overview This function reads the byte received.

;Input None
;Output ‘W’ Register will have the read byte.
;The bit ‘vI2CMIntStatus<I2CMBufFull>’ is cleared.
;If the buffer gets empty then, the bit ‘vI2CMIntStatus<I2CMBufEmpty>’ is
;set and the bit ‘vI2CMIntStatus<I2CMDataReady>’ is cleared.
;Side Effects Bank selection bits and ‘W’ register are changed
;Stack Requirement 1 level deep
;Maximum T-Cycles
;taken
;49 Cycles by the PIC16 family
;42 Cycles by the PIC18 family
_v#v(HERE)_PIO_SETdw_I2CMIntGet;(VOID/byte W)
I2CMIntGet:
	mObject_sel	THIS
	bcf		PIE1,SSP1IE
	call	_I2CMIntRdBuf	;Read the byte from buffer
	bsf		PIE1,SSP1IE
	mRETURN

; Function: _I2CMIntRdBuf
; PreCondition: I2CMIntPut or I2CMIntGet should have called.
; Overview:
;       This reads data from buffer.                                    
; Output: 'W' Register
; Side Effects: Bank selection bits and 'W' register are changed
; Stack requirement: 1 level deep
_v#v(HERE)_PIO_SETdw_I2CMIntRdBuf;(VOID/byte W)
_I2CMIntRdBuf:
	mObject_sel	THIS
	btfsc   bI2CMBufEmpty
		return
	movff   FSR0H,_vI2CMIntDupFSRH
	movff   FSR0L,_vI2CMIntDupFSR	;Save FSR
#ifdef  _DONT_USE_LFSR
	movlw   HIGH(vI2CMIntBuffer)	;load wreg with read pointer address
	movwf   FSR0H
	movlw   LOW(vI2CMIntBuffer)
	addwf   _vI2CMIntBufRdPtr,w		;load fsr with read pointer address
	movwf   FSR0L
#else
	lfsr    FSR0,vI2CMIntBuffer		;load fsr with read pointer address
	movf    _vI2CMIntBufRdPtr,w
	addwf   FSR0L
#endif
	btfsc   STATUS,C
		incf    FSR0H,f
	incf    _vI2CMIntBufRdPtr,f		;increment read pointer
	movlw   I2CM_BUFFER_LENGTH
	xorwf   _vI2CMIntBufRdPtr,w
	btfsc   STATUS,Z
		clrf    _vI2CMIntBufRdPtr
	movf    _vI2CMIntBufRdPtr,w
	xorwf   _vI2CMIntBufWrPtr,w		;Check is buffer empty
	btfss   STATUS,Z
		bra     I2CBufNotEmt
	bcf     bI2CMDataReady
	bsf     bI2CMBufEmpty
I2CBufNotEmt:
	movf    INDF0,w			;move the content of read pointer address to W
	movff   _vI2CMIntDupFSR,FSR0L
	movff   _vI2CMIntDupFSRH,FSR0H	;Retrive FSR
	bcf     bI2CMBufFull
	bcf     bI2CMBufOverFlow
	mRETURN
;///
;///
;/// /// ///

end