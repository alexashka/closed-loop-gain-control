#!/usr/bin/python
#-*- coding: utf-8 -*-
# file : import define_purger as dpurger
''' 
	4.2.1 Control Directives
	#undefine – Delete a Substitution Label........... p. 117 NO!
	
	#define – Define a Text Substitution Label........ p. 68
	#include – Include Additional Source File ........ p. 92
	
	Интресно константы могут быть равны конст., опред. через define
	constant – Declare Symbol Constant ............... p. 60
	end – End Program Block........................... p. 71
	equ – Define an Assembler Constant ............... p. 74
	org – Set Program Origin.......................... p. 100
	processor – Set Processor Type ................... p. 106
	radix – Specify Default Radix .................... p. 106
	set – Define an Assembler Variable ............... p. 109
	variable – Declare Symbol Variable................ p. 118
	
	4.2.2 Conditional Assembly Directives
	while – Perform Loop While Condition is True.................................. p. 119 NO!
	endw – End a while Loop ...................................................... p. 73 NO!
	 
	else – Begin Alternative Assembly Block to if Conditional..................... p. 71
	endif – End Conditional Assembly Block........................................ p. 72
	if – Begin Conditionally Assembled Code Block................................. p. 88
	ifdef – Execute If Symbol has Been Defined.................................... p. 90
	ifndef – Execute If Symbol has not Been Defined............................... p. 91
'''

from collections import deque
import usaio.io_wrapper as iow

''' '''
class Error(Exception):
	pass
	
_cb_type_reader_src = iow.cp1251file2list
_cb_type_reader_src_it = iow.cp1251file2list
#_cb_type_reader_src_it = iow.utf8file2list
#_wr_enc = 'utf_8'
_wr_enc = 'cp1251'

''' фильтрует код, согласно defines '''
def ConditionCompile( fname ) :
	# читаем в список
	list_lines = _cb_type_reader_src( fname )
	#tmp_list = list()
	#for at in list_lines:
	#	tmp = at.replace('\r',' ')
	#	tmp = at.replace(u'\n','')
		#if tmp != u'\r' and tmp != u'' and tmp != u';\r':
	#	tmp_list.append(tmp)
		#print [tmp]
	# пропускаем через препроцессор
	splitter = '#%&'
	purged_list_lines = _purgeList( list_lines )
	string = splitter.join( purged_list_lines )
	string = string.replace(u'\r\n', '')
	#string = string.replace(u'\t\n', '')
	string = string.replace(u'\n', '')
	purged_list_lines = string.split(splitter)
	
	for at in purged_list_lines:
		print [at]
	
	# ищем закомментированные строки и пишем незак. в файл
	sets = { 'name' :  fname, 'howOpen' : 'wb',  'coding' : _wr_enc }
	iow.list2file(sets, purged_list_lines )
		
''' '''
def _AddItem( stack, value ):
	# если стек пустой, добавляем, что бы то нибыло
	if len( stack ) == 0:
		stack.append( value )
	elif stack[-1] == 0:	# макрос верхнего уровня перекрывает
		stack.append( 0 )
	else:
		stack.append( value )

''' '''
def _AddDef(definesList, at):
	at_tmp = ' '+at
	at_tmp = at_tmp.split('define')
	
	# сзади могут еще прицепится и спереди тоже!
	noPureDirective = at_tmp[1]
	pure = ''
	i = 0
	while noPureDirective[i] == ' ' or noPureDirective[i] == '\t':
		i += 1
	noPureDirective = noPureDirective[i:len(noPureDirective)]#.replace(' ','')
	noPureDirective = noPureDirective.replace('\n','')
	noPureDirective = noPureDirective.split(' ')
	noPureDirective = noPureDirective[0]
	noPureDirective = noPureDirective.split('\t')
	noPureDirective = noPureDirective[0]
	noPureDirective = noPureDirective.split(';')
	pure = noPureDirective[0]
	definesList.append(pure)


		
''' 
	программа обработки 
	Iss0 : Не захватывает поля вне директив
	Do : при первом прохождении нужно защитить макросы
'''
def _purgeList( listLines ):
	definesList = list()

	# добавляем для того, чтобы видеть код вне директив
	definesList.append('SFILE')	# добавление контента
	queueInLines = deque( listLines ) 
	queueInLines.appendleft( '#ifdef SFILE\n' )
	queueInLines.append('#endif\n')

	# список диркетив должен форироваться самой прогр. по ходу!
	result = list('')
	stack = list('')
	
	# проходим по списку дальше
	for oneLine in queueInLines:
		def cb_analyseLine() :
			''' все-таки директивы могут начинаться не с начала строки '''
			# добавляем директивы в список
			if '#define' in oneLine and stack[-1] == 1:	# add:	# возможно нужно добавить
				oneLineReplic = oneLine.replace('\r','')
				_AddDef( definesList, oneLineReplic )
				
			# простейший случай
			if '#ifdef' in oneLine:
				if definesList.count( oneLine.split()[1] ) > 0:
					_AddItem( stack, 1 )
				else :
					_AddItem( stack, 0 ) 	# не берем содержимое

			# одиночная отрицательная простейшая
			if '#ifndef' in oneLine:	# обратное утверждение
				if definesList.count( oneLine.split()[1] ) > 0:
					_AddItem( stack, 0 )
				else :
					_AddItem( stack, 1 ) 	# не берем содержимое

			# Была директива ifdef или ifndef
			if '#else' in oneLine:	# обратное утверждение
				saveTop = stack[-1]
				stack.pop()	# заменить вершину нужно
				if saveTop == 0:
					_AddItem( stack, 1 )
				else :
					_AddItem( stack, 0 )
		# вызов замкнутой функции			
		cb_analyseLine()

		# сбор фильтрованного текста
		if len(stack) > 0:
			if stack[-1] == 1:	# add
				if not ('#endif' in oneLine) and \
				  not ('#ifdef' in oneLine) and \
				  not ('#ifndef' in oneLine) and \
				  not ('#else' in oneLine):
					# фильтруем при записи
					result.append( oneLine )
				#else :
				#	result.append( ';'+at )
			else:
				#if not( not('endif' in at) and not ('ifdef' in at) and not ('ifndef' in at) and not ('else' in at)):
				#	result.append( ';'+at )
				pass

		# конец директивы
		# действие директивы может быть отменено!
		if '#endif' in oneLine :
			stack.pop()
	
	# содержимое стека должен быть пустым
	if len(stack) != 0:
		print 'Error : Not all defines closed.'
	return result





