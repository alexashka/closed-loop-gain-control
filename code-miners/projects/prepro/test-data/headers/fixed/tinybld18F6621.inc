;#include <../headers/tinybld18F6621.inc>

constant	HERE=0
#include <../headers/user_modes.inc>
#define max_flash 0x20000
	IdTypePIC = 0x4A	; странное какое-то объ€вление
#define first_address max_flash-200		;100 words

SendL macro car
	movlw car
	movwf TXREG2
	endm