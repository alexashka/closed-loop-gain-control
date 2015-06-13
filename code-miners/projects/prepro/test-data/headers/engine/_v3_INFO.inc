;/**
; format - ... возможно Ok
;  Есть функции обертки для математических
;  ФОрмат плавающей точки exp xxxx_xxxx s!hhh_hhhh mmmm_mmmm llll_llll
;*/

	constant	EMPTY = 0;
	constant	STATUS_IDLE 	= 0		;режим ожидания(МИП выключен, БУМ готов к приему команд)
	constant	STATUS_ON 		= 1		;режим включен(МИП включен,  БУМ готов к приему команд)
	constant	STATUS_BUSY		= 2		;режим занят (состояния перехода из одного режима в другой)
	constant	STATUS_ALARM 	= 3		;режим отказ (МИП выключен, БУМ ожидает команду сброса)

#define		fSTATUS_READY		1<<STATUS_READY
#define		fSTATUS_ON			1<<STATUS_ON
#define		fSTATUS_UNLOCK		1<<STATUS_UNLOCK
#define		fSTATUS_ALARM		1<<STATUS_ALARM

#define		bSTATUS_READY		Statuses,STATUS_READY
#define		bSTATUS_ON			Statuses,STATUS_ON
#define		bSTATUS_UNLOCK		Statuses,STATUS_UNLOCK
#define		bSTATUS_ALARM		Statuses,STATUS_ALARM
;---------------------------------------------------------------------------

	constant		STAGE_BUM_COMONACCEPT	=	0	; принята команда включения
	constant		STAGE_BUM_MIPPUSKED		=	1	; запущен мип
	constant		STAGE_BUM_MIPREADY		=	2	; мип готов
	constant		STAGE_BUM_UMSTART		=	3	; запуск усилителей
;substage inserted
	constant		STAGE_BUM_BUMONED		=	4	; бум включен
	constant		STAGE_BUM_COMOFFACCEPT	=	5	; принята команда выключения
	constant		STAGE_BUM_UMFINISH		=	6	; отключение усилителей
;substage inserted
	constant		STAGE_BUM_MIPSTOPED		=	7	; мип остановлен
	constant		STAGE_BUM_BUMOFFED		=	8	; бум выключен

#define		fStage_BUM_COMONACCEPT		1<<STAGE_BUM_COMONACCEPT
#define		fStage_BUM_MIPPUSKED		1<<STAGE_BUM_MIPPUSKED
#define		fStage_BUM_MIPREADY			1<<STAGE_BUM_MIPREADY
#define		fStage_BUM_UMSTART			1<<STAGE_BUM_UMSTART
#define		fStage_BUM_BUMONED			1<<STAGE_BUM_BUMONED
#define		fStage_BUM_COMOFFACCEPT		1<<STAGE_BUM_COMOFFACCEPT
#define		fStage_BUM_UMFINISH			1<<STAGE_BUM_UMFINISH
#define		fStage_BUM_MIPSTOPED		1<<STAGE_BUM_MIPSTOPED
#define		fStage_BUM_BUMOFFED			1<<STAGE_BUM_BUMOFFED

#define		bStage_BUM_COMONACCEPT		StagesBum,STAGE_BUM_COMONACCEPT
#define		bStage_BUM_MIPPUSKED		StagesBum,STAGE_BUM_MIPPUSKED
#define		bStage_BUM_MIPREADY			StagesBum,STAGE_BUM_MIPREADY
#define		bStage_BUM_UMSTART			StagesBum,STAGE_BUM_UMSTART
#define		bStage_BUM_BUMONED			StagesBum,STAGE_BUM_BUMONED
#define		bStage_BUM_COMOFFACCEPT		StagesBum,STAGE_BUM_COMOFFACCEPT
#define		bStage_BUM_UMFINISH			StagesBum,STAGE_BUM_UMFINISH
#define		bStage_BUM_MIPSTOPED		StagesBum,STAGE_BUM_MIPSTOPED
#define		bStage_BUM_BUMOFFED			StagesBum+1,STAGE_BUM_BUMOFFED - 8
;----------------------------------------------------------------------------

	constant		SUBSTAGE_UM_ON_CURMIPCHONED		=	0	;текущий канал МИП включен
	constant		SUBSTAGE_UM_ON_CURMIPCHREADY	=	1	;МИП в норме
	constant		SUBSTAGE_UM_ON_RESETSEND		=	2	; 
	constant		SUBSTAGE_UM_ON_RESETSENDOK		=	3	;успешно отправлена команда сброса 
	constant		SUBSTAGE_UM_ON_REQUESTSENDOK	=	4	;успешно отправлена команда запроса 
	constant		SUBSTAGE_UM_ON_SHIFTONSENDOK	=	5	;успешно отправлена команда включения смещения 
	constant		SUBSTAGE_UM_ON_REQUEST2SENDOK	=	6	;успешно отправлен второй запрос состояния 

#define		fSubStage_UM_ON_CURMIPCHONED		1<<SUBSTAGE_UM_ON_CURMIPCHONED
#define		fSubStage_UM_ON_CURMIPCHREADY		1<<SUBSTAGE_UM_ON_CURMIPCHREADY
#define		fSubStage_UM_ON_RESETSEND			1<<SUBSTAGE_UM_ON_RESETSEND
#define		fSubStage_UM_ON_RESETSENDOK			1<<SUBSTAGE_UM_ON_RESETSENDOK
#define		fSubStage_UM_ON_REQUESTSENDOK		1<<SUBSTAGE_UM_ON_REQUESTSENDOK
#define		fSubStage_UM_ON_SHIFTONSENDOK		1<<SUBSTAGE_UM_ON_SHIFTONSENDOK
#define		fSubStage_UM_ON_REQUEST2SENDOK		1<<SUBSTAGE_UM_ON_REQUEST2SENDOK

#define		bSubStage_UM_ON_CURMIPCHONED		SubStagesUmOn,SUBSTAGE_UM_ON_CURMIPCHONED
#define		bSubStage_UM_ON_CURMIPCHREADY		SubStagesUmOn,SUBSTAGE_UM_ON_CURMIPCHREADY
#define		bSubStage_UM_ON_RESETSEND			SubStagesUmOn,SUBSTAGE_UM_ON_RESETSEND
#define		bSubStage_UM_ON_RESETSENDOK			SubStagesUmOn,SUBSTAGE_UM_ON_RESETSENDOK
#define		bSubStage_UM_ON_REQUESTSENDOK		SubStagesUmOn,SUBSTAGE_UM_ON_REQUESTSENDOK
#define		bSubStage_UM_ON_SHIFTONSENDOK		SubStagesUmOn,SUBSTAGE_UM_ON_SHIFTONSENDOK
#define		bSubStage_UM_ON_REQUEST2SENDOK		SubStagesUmOn,SUBSTAGE_UM_ON_REQUEST2SENDOK
;----------------------------------------------------------------------------

	constant		SUBSTAGE_UM_OFF_SHIFTOFFSEND	=	0	;отправлена команда отключения смещения 
	constant		SUBSTAGE_UM_OFF_SHIFTOFFSENDOK	=	1	;команда снятия смещения прошла успешно 
	constant		SUBSTAGE_UM_OFF_REQSENDAFTEROFF	=	2	;успешно отослан запрос состояния 
	constant		SUBSTAGE_UM_OFF_SHIFTOFFED		=	3	;отключение смещения подтверждено 
	constant		SUBSTAGE_UM_OFF_REQ2SENDOFF		=	4	;успешный второй запрос состояния  

#define		fSubStage_UM_OFF_SHIFTOFFSEND		1<<SUBSTAGE_UM_OFF_SHIFTOFFSEND
#define		fSubStage_UM_OFF_SHIFTOFFSENDOK		1<<SUBSTAGE_UM_OFF_SHIFTOFFSENDOK
#define		fSubStage_UM_OFF_REQSENDAFTEROFF	1<<SUBSTAGE_UM_OFF_REQSENDAFTEROFF
#define		fSubStage_UM_OFF_SHIFTOFFED			1<<SUBSTAGE_UM_OFF_SHIFTOFFED
#define		fSubStage_UM_OFF_REQ2SENDOFF		1<<SUBSTAGE_UM_OFF_REQ2SENDOFF

#define		bSubStage_UM_OFF_SHIFTOFFSEND		SubStagesUmOff,SUBSTAGE_UM_OFF_SHIFTOFFSEND
#define		bSubStage_UM_OFF_SHIFTOFFSENDOK		SubStagesUmOff,SUBSTAGE_UM_OFF_SHIFTOFFSENDOK
#define		bSubStage_UM_OFF_REQSENDAFTEROFF	SubStagesUmOff,SUBSTAGE_UM_OFF_REQSENDAFTEROFF
#define		bSubStage_UM_OFF_SHIFTOFFED			SubStagesUmOff,SUBSTAGE_UM_OFF_SHIFTOFFED
#define		bSubStage_UM_OFF_REQ2SENDOFF		SubStagesUmOff,SUBSTAGE_UM_OFF_REQ2SENDOFF

	constant		STATE_CURUMEXCHOK	=	0	; переход в измерения
	constant		STATE_UM1STARTED	=	1	;
	constant		STATE_UM2STARTED	=	2
	constant		STATE_UM3STARTED	=	3
	constant		STATE_UM4STARTED	=	4
	constant		STATE_UM5STARTED	=	5
	constant		STATE_BUMUNLOCKED	=	6
	constant		STATE_COMUNLOCK		=	7
	constant		STATE_UM0STARTED	=	8
	constant		STATE_WASUNLOCKED	=	9

; Какие-то константы с отказами
	constant		STATE_CH0FIXALR		=	10
	constant		STATE_CH1FIXALR		=	11
	constant		STATE_CH2FIXALR		=	12
	constant		STATE_CH3FIXALR		=	13
	constant		STATE_CH4FIXALR		=	14
	constant		STATE_CH5FIXALR		=	15
	constant		STATE_AlrInter		=	16	; внутри чего
; ///

	constant		STATE_COMLOCK		=	17
	constant		STATE_COMRES		=	18

#define			fSTATE_CURUMEXCHOK	1<<STATE_CURUMEXCHOK
#define			fSTATE_UM1STARTED	1<<STATE_UM1STARTED
#define			fSTATE_UM2STARTED	1<<STATE_UM2STARTED
#define			fSTATE_UM3STARTED	1<<STATE_UM3STARTED
#define			fSTATE_UM4STARTED	1<<STATE_UM4STARTED
#define			fSTATE_UM5STARTED	1<<STATE_UM5STARTED
#define			fSTATE_BUMUNLOCKED	1<<STATE_BUMUNLOCKED
#define			fSTATE_COMUNLOCK	1<<STATE_COMUNLOCK
#define			fSTATE_UM0STARTED	1<<STATE_UM0STARTED
#define			fSTATE_WASUNLOCKED	1<<STATE_WASUNLOCKED
#define			fSTATE_CH0FIXALR	1<<STATE_CH0FIXALR
#define			fSTATE_CH1FIXALR	1<<STATE_CH1FIXALR
#define			fSTATE_CH2FIXALR	1<<STATE_CH2FIXALR
#define			fSTATE_CH3FIXALR	1<<STATE_CH3FIXALR
#define			fSTATE_CH4FIXALR	1<<STATE_CH4FIXALR
#define			fSTATE_CH5FIXALR	1<<STATE_CH5FIXALR
#define			fSTATE_AlrInter		1<<STATE_AlrInter
#define			fSTATE_COMLOCK		1<<STATE_COMLOCK
#define			fSTATE_COMRES		1<<STATE_COMRES

#define			bSTATE_CURUMEXCHOK	States, STATE_CURUMEXCHOK
#define			bSTATE_UM1STARTED	States, STATE_UM1STARTED
#define			bSTATE_UM2STARTED	States, STATE_UM2STARTED
#define			bSTATE_UM3STARTED	States, STATE_UM3STARTED
#define			bSTATE_UM4STARTED	States, STATE_UM4STARTED
#define			bSTATE_UM5STARTED	States, STATE_UM5STARTED
#define			bSTATE_BUMUNLOCKED	States, STATE_BUMUNLOCKED
#define			bSTATE_COMUNLOCK	States, STATE_COMUNLOCK
#define			bSTATE_UM0STARTED	States+1,STATE_UM0STARTED-8
#define			bSTATE_WASUNLOCKED	States+1,STATE_WASUNLOCKED-8
#define			bSTATE_CH0FIXALR	States+1,STATE_CH0FIXALR-8
#define			bSTATE_CH1FIXALR	States+1,STATE_CH1FIXALR-8
#define			bSTATE_CH2FIXALR	States+1,STATE_CH2FIXALR-8
#define			bSTATE_CH3FIXALR	States+1,STATE_CH3FIXALR-8
#define			bSTATE_CH4FIXALR	States+1,STATE_CH4FIXALR-8
#define			bSTATE_CH5FIXALR	States+1,STATE_CH5FIXALR-8
#define			bSTATE_AlrInter		States+2,STATE_AlrInter-16
#define			bSTATE_COMLOCK		States+2,STATE_COMLOCK-16
#define			bSTATE_COMRES		States+2,STATE_COMRES-16
;----------------------------------------------------------------------------
mStage_BUM_Up		macro	field
	banksel	StagesBum
	movlw	low (field)
	iorwf	StagesBum,f
	movlw	high(field)
	iorwf	StagesBum+1,f
endm

mStage_BUM_Set		macro	field
	banksel	StagesBum
	movlw	low (field)
	andwf	StagesBum,f
	iorwf	StagesBum,f
	movlw	high(field)
	andwf	StagesBum+1,f
	iorwf	StagesBum+1,f
endm

mStage_UM_ON_Up		macro	field
	banksel	SubStagesUmOn
	movlw	low (field)
	iorwf	SubStagesUmOn,f
endm

mStage_UM_ON_Set		macro	field
	banksel	SubStagesUmOn
	movlw	low(field)
	andwf	SubStagesUmOn,f
	iorwf	SubStagesUmOn,f
endm

mStage_UM_OFF_Up	macro	field
	banksel	SubStagesUmOff
	movlw	low (field)
	iorwf	SubStagesUmOff,f
endm


mStage_UM_OFF_Set	macro	field
	banksel	SubStagesUmOff
	movlw	low(field)
	andwf	SubStagesUmOff,f
	iorwf	SubStagesUmOff,f
endm

mStateSet	macro	field
	banksel	States
	movlw	low(field)
	andwf	States,f
	iorwf	States,f
	movlw	high(field)
	andwf	States+1,f
	iorwf	States+1,f
endm

;// Не очень понятная, использует ли математическую библиотеку или нет?
mLogIn	macro	name
	movlw 	upper name
	movwf 	TBLPTRU ; address of the word
	movlw 	high name
	movwf 	TBLPTRH
	movlw 	low name
	movwf 	TBLPTRL	
endm