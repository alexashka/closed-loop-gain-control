; #include <../headers/registry_i2c.inc>
; функция потока
mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntInit

mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntReStart

mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntStart
mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntStop
mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntPut
mEXTENDS 	_v2_PIO		,	PRE_AMPLIFIER,	_v2_PIO_SETdw_I2CMIntStart
mEXTENDS 	_v2_PIO		,	PRE_AMPLIFIER,	_v2_PIO_SETdw_I2CMIntStop
mEXTENDS 	_v2_PIO		,	PRE_AMPLIFIER,	_v2_PIO_SETdw_I2CMIntPut
mEXTENDS	PRE_AMPLIFIER,	_v3_BUM,	pA_pub_setGainDigAtt; (W/void)
mEXTENDS	PRE_AMPLIFIER,	_v3_COMP,	pA_pub_setGainDigAtt; (W/void)
mEXTENDS	PRE_AMPLIFIER,	_v3_BUM,	pA_pub_initAttExchange;(void/void)
mEXTENDS	PRE_AMPLIFIER,	_v4_TASK,	pA_pub_setAttOpen;(void/void)

mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntGet
mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntSetGetCount
mEXTENDS 	_v2_PIO		,	IO_I2C		,	_v2_PIO_SETdw_I2CMIntGet
mEXTENDS 	_v2_PIO		,	IO_I2C		,	_v2_PIO_SETdw_I2CMIntSetGetCount


mEXTENDS 	_v2_PIO		,	_v3_BUM		,	_v2_PIO_SETdw_I2CMIntDiscardBuf

mEXTENDS 	_v2_PIO,	_v3_COMP, 	_v2_PIO_SETdw_I2CMIntStart
mEXTENDS 	_v2_PIO,	IO_I2C,	_v2_PIO_SETdw_I2CMIntStart
mEXTENDS 	_v2_PIO,	IO_I2C,	_v2_PIO_SETdw_I2CMIntPut
mEXTENDS 	_v2_PIO,	IO_I2C,	_v2_PIO_SETdw_I2CMIntStop
mEXTENDS 	_v2_PIO,	IO_I2C,	_v2_PIO_SETdw_I2CMIntReStart





; 
mEXTENDS 	IO_I2C,	_v3_BUM,	io_I2C_jumperReadNowBlinkDio;()
mEXTENDS 	IO_I2C,	_v3_BUM,	io_initI2cTxRxInBoard;()