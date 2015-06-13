#!/usr/bin/python
#-*- coding: utf-8 -*-
''' 
  abs. : попытка сделать граф вызовов, 
    пусть с промахами, но лучше чем ничего
	1. bottom -> top
	2. top -> bottom
  
  file : import call_graph as cg

  1. ищем в файле все умоминания исходной функции
  2. как-то находим функцию которая делает вызов

file 1 :
_v#v.....\n
	вызовы
_v#v.....\n
	вызовы
_v#v.....\n
	вызовы
	
file N :

  !! хорошо бы разработать конвеции кодирования - так проще будет
    и проще анализировать
'''

import re
import os

#
#import str_finder as sf

# parse string
def findAndFill( xxl, positions, srcStr, pattern ):
  result = re.finditer(pattern , srcStr)
  for match in result :
	# результаты поиска
	s = match.group()

	# итоговая строка
	xxl.append(s)
	
	# и ее расположение
	pair = match.span()
	positions.append( pair[0] )
  
  # число совпадений
  return len(xxl)
  
file = "_v3_COMP.asm"

# поиск распределения
pattern = '\n_v#v.*?\n'

# поиск конкретной строки
patt_call = '_TASK_HLTuw_DataReq2Wait'

# открываем файл и разбираем строку
try:
	f = open( file, "r" )
	try:
		# Read the entire contents of a file at once.
		string = f.read() 

		# Поиск распеределения функций
		headers = list( "" )
		positions = list( "" )
		enlen = findAndFill( headers, positions, string, pattern )
		enlen = len( headers )
		if enlen != 0:
			print file+" : "+str(enlen)
		print positions

		# Поиск распределения вызовов
		xx = list( "" )
		positions_call = list( "" )
		enlen = findAndFill( xx, positions_call, string, patt_call )
		enlen = len( xx )
		
		if enlen != 0:
			print file+" : "+str(enlen)
			
		print positions_call

	finally:
		f.close()
		#fwr.close()
		#fwr.write(sWr) # Write a string to a file
		#fwr = open(ofile, "w")
except IOError:
	print 'error'

