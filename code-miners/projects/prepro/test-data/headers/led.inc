; #include <../headers/led.inc>
	constant	HERE=3
#define		THIS	_v3_LED
#define		_v3_LED		_v3_LED
#include	<../headers/user_modes.inc>

#define		bComSend	LedByte,0
#define		bReqSend	LedByte,1
#define		bBumLocking	LedByte,6
#define		bBumAlarm	LedByte,5  ; alarm - тревога
#define		bBumExch	LedByte,7

#define		bBumMip		LedByte,2  ; мощный? источник питания
#define		bBumWork	LedByte,3
#define		bBumFault	LedByte,4