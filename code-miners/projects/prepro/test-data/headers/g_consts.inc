; #include <../headers/g_consts.inc>

#ifdef		_3U_polovina_block
	constant	MINUMDOPTOON	=	3	
#endif	
#ifdef		_3Ublock
	constant	MINUMDOPTOON	=	2;1;5
#endif
#ifdef		_2Ublock
	constant	MINUMDOPTOON	=	2;1;2
#endif

	constant	DOWN			=	HERE-1;
	constant	UP				=	HERE+1;
	constant	VOID			=	0
	constant	TRUE			=	0x00
	constant	FALSE			=	0xFF
	constant	SLOMAN			=	0xFF
	constant	NORMA			=	0
	constant	YES				=	0
	constant	NO				=	0xFF
	constant	EOF				=	0x55
	constant	MAXNUMBERBYTE	=	88