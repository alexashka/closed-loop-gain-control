; include <../headers/comp.inc>

constant	HERE=3
#define		_v3_COMP	_v3_COMP
#define		THIS	_v3_COMP
#include <../headers/user_modes.inc>
#include <../headers/board/BoardSpecificFile.inc>

;// States
;// была ли комманда установки усиление аттенюатора?
;State_setGainAtt 	res 	1
#define OBTAINED 	0x01
#define NO_OBTAINED 0x00
