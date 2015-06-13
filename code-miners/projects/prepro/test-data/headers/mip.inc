; #include <../headers/mip.inc>

	constant	HERE=3
#define		THIS	_v3_MIP
#define		_v3_MIP		_v3_MIP
#include	<../headers/user_modes.inc>

#ifdef	_3Ublock
	
;;bu3u_FM
;	fMipPusk	equ		b'00100000'
;	fMipCh1		equ		b'00000101';20v+ch3
;	fMipCh2		equ		b'00010010';ch1&ch2
;	fMipCh3		equ		b'00000100'
;	fMipCh4		equ		b'00001000'
;	fMipCh5		equ		b'00010000'
;
;

;
;	fMipPusk		equ		b'00100000'
;	fMipCh1		equ		b'01000001'
;	fMipCh2		equ		b'00001000'	;b'00000010'
;	fMipCh3		equ		b'00000010' ;b'00000100'
;	fMipCh4		equ		b'00000100' ;b'00001000'
;	fMipCh5		equ		b'00010000'
;

;bum2u_FM
	fMipPusk	equ		b'00100000'
	fMipCh1		equ		b'01010110';20v+ch1
	fMipCh2		equ		b'00000110';ch2&ch3
	fMipCh3		equ		b'00000000'
	fMipCh4		equ		b'00000000'
	fMipCh5		equ		b'00000000'

#endif


;#ifdef	_2Ublock
;	fMipPusk	equ		b'00100000'
;	fMipCh1		equ		b'01000001'
;	fMipCh2		equ		b'00010010'
;	fMipCh3		equ		b'00000000'
;	fMipCh4		equ		b'00000000'
;	fMipCh5		equ		b'00000000'
;#endif
#ifdef	_2Ublock

;	fMipPusk	equ		b'00100000'
;	fMipCh1		equ		b'01010000'
;	fMipCh2		equ		b'00000110'
;	fMipCh3		equ		b'00000000'
;	fMipCh4		equ		b'00000000'
;	fMipCh5		equ		b'00000000'

;bum2u_FM
	fMipPusk	equ		b'00100000'
	fMipCh1		equ		b'01010110';20v+ch1 H - 
;	fMipCh1		equ		b'00000101';20v+ch3

;	fMipCh2		equ		b'00010010';ch1&ch2
	fMipCh2		equ		b'00000000';ch2&ch3
	fMipCh3		equ		b'00000000'
	fMipCh4		equ		b'00000000'
	fMipCh5		equ		b'00000000'


#endif
	fAlarm		equ		b'10000000'