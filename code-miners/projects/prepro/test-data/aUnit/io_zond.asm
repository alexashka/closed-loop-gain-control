#include <../headers/io/io_zond.inc>

mObject_var	IO_ZOND
	Zond	res		8  ; переменные для проверки выполнения веток кода

object code
; SET
setZFSR00;(FSR0(+0)/void)
	movff	INDF0, Zond+0
	return
setZFSR01;(FSR0(+0)/void)
	movff	INDF0,	Zond+1
	return
	
; целые слова
setZFSR0W0;(FSR0(+0)/void)
	movff	POSTINC0,	Zond+0
	movff	POSTDEC0,	Zond+1
	return
	
setZFSR0W1;(FSR0(+0)/void)
	movff	POSTINC0,	Zond+2
	movff	POSTDEC0,	Zond+3
	return
	
setZfsr07z0;(FSR0(+0-+11)/void)
	movff	POSTINC0,	Zond+0
	movff	POSTINC0,	Zond+1
	movff	POSTINC0,	Zond+2
	movff	POSTINC0,	Zond+3
	movff	POSTINC0,	Zond+4
	movff	POSTINC0,	Zond+5
	; обратно
	movff	POSTDEC0,	Zond+6
	movff	POSTDEC0,	Zond+7
	movff	POSTDEC0,	Zond+8
	movff	POSTDEC0,	Zond+9
	movff	POSTDEC0,	Zond+10
	movff	POSTDEC0,	Zond+11
	return
	
setZfsr07z0_tmp;(FSR0(+0-+11)/void)
	movff	POSTINC0,	Zond+0
	movff	POSTINC0,	Zond+1
	movff	POSTINC0,	Zond+2
	; обратно
	movff	POSTDEC0,	Zond+3
	movff	POSTDEC0,	Zond+4
	movff	POSTDEC0,	Zond+5
	return
	
setZFSR0W2;(FSR0(+0)/void)
	movff	POSTINC0,	Zond+4
	movff	POSTDEC0,	Zond+5
	return

setZFSR0W3;(FSR0(+0)/void)
	movff	POSTINC0,	Zond+6
	movff	POSTDEC0,	Zond+7
	return
; целые слова
	
; отдельно
setZ0;(void/W)
	movff	WREG,	Zond+0
	return
setZ1;(void/W)
	movff	WREG,	Zond+1
	return
setZ2;(void/W)
	movff	WREG,	Zond+2
	return
setZ3;(void/W)
	movff	WREG,	Zond+3
	return

; GET
getZ0;(void/W)
	movff	Zond+0,	WREG
	return
getZ1;(void/W)
	movff	Zond+1,	WREG
	return
getZ2;(void/W)
	movff	Zond+2,	WREG
	return
getZ3;(void/W)
	movff	Zond+3,	WREG
	return
	
;;;
; GET
getZ4;(void/W)
	movff	Zond+4,	WREG
	return
getZ5;(void/W)
	movff	Zond+5,	WREG
	return
getZ6;(void/W)
	movff	Zond+6,	WREG
	return
getZ7;(void/W)
	movff	Zond+7,	WREG
	return

end
