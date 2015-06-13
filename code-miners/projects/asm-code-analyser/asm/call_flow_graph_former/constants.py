#!/usr/bin/python
#-*- coding: utf-8 -*-
# file : from constants import *
''' 
может сделать перпроцессор - заменить макросы на значения
абстаркции мешают. макросы нужно заменять - типа предпроцессора сделать
они же могут заменяться, a набор комм. асма постоянен
'''
''' все переводы управления в краницах двух меток '''
retCommands = [
'retfie', 'retlw', 'return',	# прерывает ход программы
'bc',
'bov', 
'bra',	# прерывает ход программы
'bz',
'bn',
'call',
'goto'	# прерывает ход программы
]

bypassCmds = [
# перескоки - меток не содержат так же они условные, а значит
#   потенциальном может выполнится то, что они позв. обойти
'cpfseq', 'cpfsgt', 'cpfslt', 'decfsz', 'dcfsnz', 'incfsz',
'infsnz', 'tstfsz', 'btfsc', 'btfss' ]

markedJumps = retCommands


''' паттерны поиска '''
# ключи верхнего поиска очень тонкая вещь - сделано пока не очень хорошо
pattern = '^_.*?$'
pattern = '^\S.*?$'	# нужно исключить табы

KEY_RET = 'IuyTREQ'
KEY_BYPASS_RET = 'ZXCVBN'
KEY_BYPASS_GOTO_AND_BRA = 'MNbVCX'

''' 
addwf
addwfc
andwf
clrf
comf
cpfseq
cpfsgt
cpfslt
decf
decfsz
dcfsnz
incf
incfsz
infsnz
iorwf
movf
movff
movwf
mulwf
negf
rlcf
rlncf
rrcf
rrncf
setf
subfwb
subwf
subwfb
swapf
tstfsz
xorwf
bcf	!!!!
bsf
btfsc
btfss
btg
bc	!!!!
bn
bnc
bnn
bnov
bnz
bov
bra
bz
call
clrwdt
daw
goto
nop
nop
pop
push
rcall
reset
retfie
retlw
return
sleep
addlw
andlw
iorlw
lfsr
movlb
movlw
mullw
retlw
sublw
xorlw
tblrd*
tblrd*+
tblrd*-
tblrd+*
tblwt*
tblwt*+
tblwt*-
tblwt+*

'''
