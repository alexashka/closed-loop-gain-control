#include P18F8722.inc
;*********************************************************************
;**    PIC18Cxx MPASM Initialized Data Startup File, Version 0.01   **
;**    (c) Copyright 1997 Microchip Technology                      **
;**    (c) Copyright 2007 S'L ava				                    **
;*********************************************************************

;----------------External variables and labels--------------;
  EXTERN  _cinit     ;Start of const. data table
  
  GLOBAL   copy_init_data

;***********************************************************;
VARIABLES   UDATA
;-----------------------------------------------------------;
; Data used for copying const. data into RAM
;
; NOTE:  ALL THE LOCATIONS IN THIS SECTION CAN BE REUSED
;        BY USER PROGRAMS. THIS CAN BE DONE BY DECLARING
;        A SECTION WITH THE SAME NAME AND ATTRIBUTE,
;        i.e.
;             VARIABLES  UDATA_OVER          (in MPASM)
;        or
;            #pragma udata overlay VARIABLES (in MPLAB-C)
;-----------------------------------------------------------;
num_init             RES   2  ;Number of entries in init table
init_entry_from_addr RES   3  ;ROM address to copy const. data from
init_entry_to_addr   RES   2  ;RAM address to copy const. data to
init_entry_size      RES   2  ;Number of bytes in each init.section
save_tblptrl         RES   1  ;These two variables preserve
save_tblptrh         RES   1  ;the position of TBLTRL within the entry table
save_tblptru         RES   1
;-----------------------------------------------------------;

; ****************************************************************
_copy_idata_sec    CODE    

; ****************************************************************
; * Copy initialized data from ROM to RAM                        *
; ****************************************************************
;   The values to be stored in initialized data are stored in
; program memory sections. The ac tual initialized variables are
; stored in data memory in a section defined by the IDATA directive
; in MPASM or automatically defined by MPLAB-C. There are 'num_init'
; such sections in a program. The table below has an entry for each
; section. Each entry contains the starting address in program memory
; where the data is to be copied from, the starting address in data
; memory where the data is to be copied, and the number of bytes to copy.
;   The startup code below walks the table, reading those starting
; addresses and counts, and copies the data from program to data memory.
;
;
;             +============================+
;  _cinit     | num_init (low)             |
;             +----------------------------+
;             | num_init (high)            |
;             +============================+
;             | init_entry_from_addr (low) |       IDATA (0)
;             +----------------------------+
;             | init_entry_from_addr (high)|
;             +----------------------------+
;             | 		0x00			   |
;             +----------------------------+
;             | 		0x00			   |
;             +----------------------------+
;             | init_entry_to_addr (low)   |
;             +----------------------------+
;             | init_entry_to_addr (high)  |
;             +----------------------------+
;             | 		0x00			   |
;             +----------------------------+
;             | 		0x00			   |
;             +----------------------------+
;             | init_entry_size   (low)    |
;             +----------------------------+
;             | init_entry_size   (high)   |
;             +============================+
;             |            .               |           .
;                          .                           .
;             |                            |
;             +============================+
;             | init_entry_from_addr (low) |       IDATA (num_init - 1)
;             +----------------------------+
;             | init_entry_from_addr (high)|
;             +----------------------------+
;             | 		0x00			   |
;             +----------------------------+
;             | 		0x00			   |
;             +----------------------------+
;             | init_entry_to_addr (low)   |
;             +----------------------------+
;             | init_entry_to_addr (high)  |
;             +----------------------------+
;             | 		0x00			   |
;             +----------------------------+
;             | 		0x00			   |
;             +----------------------------+
;             | init_entry_size   (low)    |
;             +----------------------------+
;             | init_entry_size   (high)   |
;             +============================+

;   Start of code that copies initialization
; data from program to data memory
copy_init_data:
;   First read the count of entries (_cinit)
		movlw UPPER _cinit ; Load TBLPTR with the base
		movwf TBLPTRU ; address of the word
		movlw HIGH _cinit
		movwf TBLPTRH
		movlw LOW _cinit
		movwf TBLPTRL
		TBLRD*+
		movff	TABLAT,num_init
		TBLRD*+
		movff	TABLAT,num_init+1

;   For (num_init) do copy data for each initialization
; entry. Decrement 'num_init' every time and when it
; reaches 0 we are done copying initialization data
;
_loop_num_init:
        BANKSEL num_init
        movf    num_init, W
        iorwf   num_init+1, w
		bz		_end_copy_init_data 
;   If num_init is not down to 0,
; then we have more sections to copy,
; otherwise, we're done copying data.

;   For a single initialization section, read the
; starting addresses in both program and data memory,
; as well as the number of bytes to copy.
;
_copy_init_sec:
;  Read 'from' address in program memory
		TBLRD*+
		movff	TABLAT,init_entry_from_addr
		TBLRD*+
		movff	TABLAT,init_entry_from_addr+1
		TBLRD*+
		movff	TABLAT,init_entry_from_addr+2	;my correction
		TBLRD*+
;  Read 'to' address in data memory
		TBLRD*+
		movff	TABLAT,init_entry_to_addr
		TBLRD*+
		movff	TABLAT,init_entry_to_addr+1
		TBLRD*+
		TBLRD*+
;  Read 'size' of data to be copied in BYTES
		TBLRD*+
		movff	TABLAT,init_entry_size
		TBLRD*+
		movff	TABLAT,init_entry_size+1
		TBLRD*+
		TBLRD*+

;  We must save the position of TBLPTR since TBLPTR
;is used in copying the data as well.
        movff   TBLPTRL, save_tblptrl
        movff   TBLPTRH, save_tblptrh
      movff   	TBLPTRU, save_tblptru	;my correction	

; Setup TBLPTRH:TBLPTRL to point to the ROM section
;where the initialization values of the data are stored.
        movff   init_entry_from_addr, TBLPTRL
        movff   init_entry_from_addr+1,TBLPTRH
        movff   init_entry_from_addr+2,TBLPTRU		;my correction	

        movff   init_entry_to_addr, FSR0L
	    movff   init_entry_to_addr+1, FSR0H

;Loop for # of bytes to be copied

;   Since on 17Cxx we store two bytes per word we must be careful
;i f the number of bytes to be copied is odd. We cannot copy word by
;word or we may end up overwriting a byte in RAM that doesn't belong
;to the initialized data section. We therefore must decrement and
;check the size for every low and high byte read from program memory.
;
_start_copying_data:
;***  Test ****
        movf    init_entry_size,w
        iorwf   init_entry_size+1,w
		bz		_dec_num_init
;***** Copy low byte ****
		TBLRD*+
        movff   TABLAT, POSTINC0   ; byte stored in RAM location
;*** Decrement ***
        decf    init_entry_size,f
        bc   	_start_copying_data
        decf    init_entry_size+1,f
		bra 	_start_copying_data

; Decrement the counter for the outermost loop (no. of init.secs.)
;
_dec_num_init:
        decf    num_init,f
        btfss   STATUS,C
        decf    num_init+1,f

;Now restore TBLPTRH:TBLPTRL to point to table
        movff  save_tblptrl, TBLPTRL
        movff  save_tblptrh, TBLPTRH
		movff  save_tblptru, TBLPTRU
;Then go back to the top to do the next section, i f any
        bra  _loop_num_init

;We're done copying initialized data
_end_copy_init_data:

        return

;Must declare it as GLOBAL to be able to call it from other assembly modules

   END

