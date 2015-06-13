#!/usr/bin/python
#-*- coding: utf-8 -*-
# file : from code_trash import *
''' Обработка переходов в предалах Диапазона главных меток 
	header - начальная метка блока
	resStr - массив вызовов меток до следующего
	header->resStr[0]->resStr[1]->...->resStr[-1]
'''
''' Обработка переходов в предалах диапазона главных меток 
по сути как соединяем метки
'''

def labelOperation( resStr, header ):
	# разбираем результаты
	for k in range(len(resStr)):  
		
		# Пишем в файл метку
		IOOperations.wrSecondLabel( resStr[k] )
		
		# Заполняем выходной массив логальных вызовов
		innerLabels.append(resStr[k])
		node_c = pydot.Node(resStr[k])
		grDot.add_node(node_c)	# добавляем узлы
		grDot.add_edge(pydot.Edge(header, resStr[k]))