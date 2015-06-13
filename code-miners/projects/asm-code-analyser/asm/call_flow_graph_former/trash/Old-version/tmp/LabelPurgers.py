#!/usr/bin/python
#-*- coding: utf-8 -*-
''' 
	file : import LabelPurgers

	abs. : пакет содержит функции обработки излов графа
'''
''' 
  Набор функция очистки узла
'''
''' удаление комментариев из главных меток - любых и полезных тоже '''
def pureNode( node ):
	splitList = node.split(';')
	splitListSplTabSpaces = splitList[0].split()
	splitListSplTabSpaces[0] = splitListSplTabSpaces[0].replace(':', '')
	return splitListSplTabSpaces[0]

''' Очистка вспомогательных меток 
!! нужно уметь определать закомменценные

'''
def purgeJampsLabels( s ):
	# форматирование
	label = s.split()
	label[1] = label[1].replace('\t', '')
	label[1] = label[1].replace(':', '')
	sumLabel = label[1].split(';')
	return sumLabel[0]

''' берет комманду '''
def purgeBypassAndRetLabels( node ):
	# форматирование
	splitList = node.split(';')
	label = splitList[0].split()
	sumLabel = label[0].split()
	return sumLabel[0]
	
''' Пока берем только код операции '''
def purgeLine( line ):
	resSplitting = line.split()
	if len(resSplitting) > 0:
		return resSplitting[0]
	else:
		return ""