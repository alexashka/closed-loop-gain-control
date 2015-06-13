#-*- coding: utf-8 -*-
#include	<headers\_v1_IRQ.inc>
temps	idata
temp_fsr0L		res 1
temp_fsr0H		res 1
temp_fsr1L		res 1
temp_fsr1H		res 1
temp_fsr2L		res 1
temp_fsr2H		res 1
temp2_fsr0L		res 1
temp2_fsr0H		res 1
temp2_fsr1L		res 1
temp2_fsr1H		res 1
temp2_fsr2L		res 1
temp2_fsr2H		res 1
temp2_WREG		res 1
temp2_BSR		res 1
temp2_STATUS	res 1
object	code
_v#v(HERE)_IRQ_SETuw_ResetInt;(void/void)						
	clrwdt

	call	_v#v(UP)_PIO_INI
	goto	_TASK_INI_RESET

end
