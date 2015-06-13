; закомментир блок исключения показаний T=85
#include <../headers/hot.inc>
#define HOT
#define HOT_INNER
#ifdef HOT
	hot defined
	hot defined
	hot defined
#ifndef HOT_INNER
	no hotInner
#else
	hotInner
#endif
#else
	hot not defined
	hot not defined
	hot not defined
#endif