; file : #include <../src_io/pio_return_codes.inc>
; ¬озвращаемые значени€
	; return - 0xFF
	; _BUM_HLTuw_BusCollision - 0x01
#define BUS_COLLISION 0x01
	;_v#v(UP)_BUM_HLTuw_NotRequested;(void/void) - 0x02
#define NOT_REQUESTED 0x02
	; mSlideTo	_v#v(UP)_BUM_HLTuw_ErrorRequested;(void/void) - 0x03
#define ERROR_REQUESTED 0x03
	; если все хорошо то lfsr0 and w = 0x00
#define ALL_RIGHT	0x00