; format - Ok
;
constant	HERE=3
#define		_v3_CLK	_v3_CLK
#define		THIS	_v3_CLK
#include	<../headers/user_modes.inc>

; модули пересчета счетчиков, состояния которых хранятся в памяти
	constant	MIPPUSKWAIT		=	200
	constant	MIPCHWAIT		=	30
	constant	AMPRESWAIT		=	30
	constant	DATAREQWAIT		=	30
	constant	SHIFTONCOMWAIT	=	30;?
	constant	DATAREQ2WAIT	=	30
	constant	ATTLOCKWAIT		=	30
	constant	UMSTOPCOMWAIT	=	30
	constant	AMPREQSTOPWAIT	=	50
	constant	MIPCHOFFWAIT	=	30
	constant	AMPREQ2STOPWAIT	=	30
	constant	BUMUNLOCKWAIT	=	30
;	constant	AMPREQUNLOCKWAIT=	3
	constant	BUMLOCKWAIT		=	30
	constant	AMPREQLOCKWAIT	=	30
	constant	BUMRESETWAIT	=	30
	constant	AMPRESETWAIT	=	30
	constant	DATAREFRESHWAIT	=	5;30
	constant	COMON			=	10
	constant	COMOFF			=	10
	constant	COMUNLOCK		=	10
	constant	COMLOCK			=	10
	constant	COMRES			=	10
	
	constant	FULLOFMIPWAIT	=	120
	constant	DATAREADWAIT	=	30
	constant	DATAREAD2WAIT	=	30
	constant	AMPREADSTOPWAIT	=	30
	constant	AMPREAD2STOPWAIT=	30
	constant	PEEPONWAIT		=	255;600
	constant	PEEPOFFWAIT		=	40
	constant	EXCHLEDWAIT		=	10
	
	constant	ALARMREFRESHWAIT=	5;10
	constant	LOCKALRWAIT		=	10
	constant	RESETALRWAIT	=	10
	constant	REQUEST1ALRWAIT	=	30
	constant	REQUEST2ALRWAIT	=	30
	constant	SHIFTONAFTERALRWAIT	=	10
	constant	REQUEST3ALRWAIT	=	30
	constant	REQUEST4ALRWAIT	=	30
	constant	LOCKALRWAIT		=	10
	constant	UNLOCKALRWAIT	=	10
	constant	TUNEWAIT		=	5
	constant	LEDFLASH		=	20
	constant	LOCKWAITCHANNEL	=	50
	constant	SETCHANNELWAIT	=	30
	constant	SETDETTOCHWAIT	=	50
	constant	TEMPERWAIT		=	150
	constant	ALRINTERWAIT	=	600
	constant	WIRECOMWAIT		=	20

; M acroses
mEventT1_ini	macro	count,time  	;// T1 - timer1
	mObject_sel	THIS
	movlw	low time
	movwf	count
	movlw	high time
	movwf	count+1			
;	goto	_v#v(DOWN)_PIO_SETdw_Timer1Enable;(void/void)
;	return
endm

variable	i=0;
mEventT1_hndl	macro	count,handler
	mObject_sel	THIS
	movf	count,w
	iorwf	count+1,w
	btfss	STATUS,Z
	decfsz	count
	bra		metka#v(i)
	movf	count+1,f
	btfsc	STATUS,Z
	bra		metkaB#v(i)	
	decf	count+1,f
	decf	count,f
	bra		metka#v(i)
metkaB#v(i)	
	call	handler   
metka#v(i):
	call	_Task_Fast
	i++
endm
