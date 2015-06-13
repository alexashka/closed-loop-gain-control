; #include <../headers/hot.inc>
	constant	HERE=2
#define		_v2_HOT	_v2_HOT
#define		THIS	_v2_HOT
#include <../headers/user_modes.inc>
#include <../headers/engine/events.inc>	; константы событий


							
#define CRC_POLY 0x18
#define	TTX_tris TRISE,2	;++060910
#define TTX_port PORTE,2 	;++060910
global	hot_readOnly_zero	; условная конструкция
#include <../headers/delay_lib.inc>


