; file : #include <../headers/delay_lib.inc>
;********************
;  WaitLib										
;********************
variable	i=0;
DelayUs	macro	T_us
	movlw	low	T_us
Delay20MHzUs#v(i):
	clrwdt
	addlw	0xFF
	btfss	STATUS,Z
	goto	Delay20MHzUs#v(i)
	i++	
endm
;********************************************************************************
;variable	j=0;
;DELAY_US	macro	T_us
;	movlw	low	T_us
;Delay20MHzUS#v(j):;
;	clrwdt
;	addlw	0xFF
;	btfss	STATUS,Z
;	goto	Delay20MHzUs#v(j)
;	j++	
;endm