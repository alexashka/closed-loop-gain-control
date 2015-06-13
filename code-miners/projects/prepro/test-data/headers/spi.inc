; #include "spi.inc"
#include <../headers/BoardMapping.h>
DAC_A_LSB	equ		0x10
DAC_B_LSB	equ		0x12
DAC_C_LSB	equ		0x14
DAC_D_LSB	equ		0x16
CONTROL1	equ		0x18	
CONTROL2	equ		0x19
CONTROL3	equ		0x1A
DAC_CONFIG	equ		0x1B
LDAC_CONFIG	equ		0x1C
INT_MASK1	equ		0x1D
INT_MASK2	equ		0x1E
constant	WRITECOMMAND	=	0x90
constant	READCOMMAND		=	0x91

