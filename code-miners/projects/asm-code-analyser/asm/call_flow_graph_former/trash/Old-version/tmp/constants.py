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

KEY_RET = 'IuyTREQ'
KEY_BYPASS_RET = 'ZXCVBN'
KEY_BYPASS_GOTO_AND_BRA = 'MNbVCX'

