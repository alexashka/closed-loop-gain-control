
; Initialization Code for PIC18F8722, Family: GP control, Package: 80-Pin TQFP 80pins

#include P18F8722.inc



; Filter Controls used to Generate Code:

; POR Match Filter ON

; Provisioned Feature Filter ON

; Masks are Ignored and uses UnMasked Register Writes

; Feature=fuses - fuses (DCR) configuration
CONFIG1H=0x05

VI_CODE	CODE

VisualInitialization:

; Feature=Reset - Check for reset errors

; Feature=Interrupts - Disable Interrupts during configuration

; Feature=Oscillator - Oscillator configuration
	clrf OSCTUNE

; Feature=Reset - Reset configuration
	clrf RCON

; Feature=IOPortA - IO Ports configuration
	movlw 0x7F
	movwf TRISA
	movlw 0xBF
	movwf TRISA

; Feature=IOPortB - IO Ports configuration
	movlw 0x18
	movwf PORTB
	movlw 0xC0
	movwf TRISB

; Feature=IOPortC - IO Ports configuration
	movlw 0x18
	movwf PORTC
	movlw 0xA6
	movwf TRISC

; Feature=IOPortD - IO Ports configuration
	movlw 0x0C
	movwf PORTD
	movlw 0xA2
	movwf TRISD

; Feature=IOPortE - IO Ports configuration
	movlw 0x23
	movwf PORTE
	movlw 0x8C
	movwf TRISE

; Feature=IOPortF - IO Ports configuration
	movlw 0xEF
	movwf TRISF

; Feature=IOPortG - IO Ports configuration
	movlw 0x1F
	movwf TRISG
	movlw 0xF4
	movwf TRISG

; Feature=IOPortH - IO Ports configuration
	movlw 0x0B
	movwf PORTH
	movlw 0xF4
	movwf TRISH

; Feature=IOPortJ - IO Ports configuration
	movlw 0x1F
	movwf TRISJ

; Feature=USART1 - EUSART configuration
	movf RCREG1, W                         ; flush receive buffer
	movf RCREG1, W

; Feature=USART2 - EUSART configuration
	movf RCREG2, W                         ; flush receive buffer
	movf RCREG2, W

; Feature=required - Interrupt flags cleared and interrupt configuration

; Feature=CPU - CPU register configuration

; Feature=Interrupts - enable interrupts

	return

; Feature=Reset - Reset Error Handlers

	GLOBAL VisualInitialization

	END
