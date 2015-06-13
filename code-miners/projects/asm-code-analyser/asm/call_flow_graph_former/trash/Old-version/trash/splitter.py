#!/usr/bin/python
#-*- coding: utf-8 -*-
''' 
  abs. :
  
  target : 
	1. Межмодульный анализатор
		сделать вид для модели в виде кода - из кода качать разноплановую
		информацию
		интерфейсная функция - по ней определяем кого вызывает.
		Главное граф составить, а потом можно двигаться произвольно
	2. Внутримодульный анализатор. Проверка на соответствие(private and public parts)
  
  steps :
  1. хотя все и макаронно, но retxxx есть при любом расклада
  2. пока ищем в одном файле и одну функцию
	выделение блока кода(только кода)

; формат входных данных
_метка ; вплотную к краю строки и с нижнего подчеркивания
	код
_метка
  код
  
_цикл_Ж - поиск циклов

если при поиске не утыкается в интерфейс, то смысл то?
	поток комманд проходит сразу по ней
	
запись в файл идет странновато - появляются похожие узлы

Цель :
  one Module.IFun -> allMod.IFun - вызовы всех модулей
  registry.inc - только суммарно по мудулям
  
	add feat. : 
		Подкраска интерфейсов модуля
		
граф хорошо бы увидеть - так проще отлаживать

cсделать так, чтобы вспомогательные операции незахломляли логику

не отлавливает естестенные переходы
'''

# sys
import re, os, io
import sys

# own
from constants import *

# add libs
# Import the module and instantiate a graph object
from pygraph.classes.graph import graph
from pygraph.algorithms.searching import depth_first_search
from pygraph.readwrite.dot import write

# Import graphviz
sys.path.append('C:\opt\Python27\Lib\site-packages\pygraphviz')
import graphviz as gv
from pygraph.classes.exceptions import AdditionError

# создаем сразу заготовку для графа
gr = graph()

''' Класс для работы с вводом-высодом'''
class IOController:
	_fwr = None
	_fwr_ic = None
	def __init__(self):
		# Вычислительная часть
		try:
			self._fwr = io.open('code.log', 'w', encoding='utf-8')
			self._fwr_ic = io.open('iconn.log', 'w', encoding='utf-8')
		except IOError:
			print 'IOError open()'
			
	''' деструктор'''
	def __del__(self):
		self._fwr.close()
		self._fwr_ic.close()
			
	''' Функция записи с инк. обраб. искл.'''
	def writeCode(self, string):
		try:
			self._fwr.write(string)
		except IOError:
			print 'write() IOError'
	def writeIconn(self, string):
		try:
			self._fwr_ic.write(string)
		except IOError:
			print 'write() IOError'
		

# еще есть перепрыжки
def jumpsFinder( string ):
	splitString = string.split('\n')
	resStr = list('')
	resInt = list()
	for line in splitString:
		# Поиск входов-выходов и переходов
		for at in jumpsCommands:
			patt = at+'.*?$'
			patt = unicode(patt, encoding='utf-8')
			result = re.finditer(patt , line, re.M | re.S | re.X)
			for match in result :
				# результаты поиска
				s = match.group()
				
				# форматирование
				label = s.split()
				# пишем в файл
				
				label[1] = label[1].replace('\t', '')
				label[1] = label[1].replace(':', '')
				sumLabel = label[1].split(';')
			
				# добавление
				resStr.append(sumLabel[0])
				# и ее расположение
				pair = match.span()
				resInt.append( pair[0] )
	return resStr, resInt

''' 
	создает карту главных меток
	эталонная метка
	_xxx<:><;()/t< >;русские буквы>
	
	Форматирование можно сделать как callback
'''
def findArrMainLabels( xxl, positions, srcStr, pattern ):
	result = re.finditer( pattern , srcStr, re.M | re.S | re.X )
	for match in result :
		# результаты поиска
		s = match.group()
		
		# форматирование
		s = s.replace('\t', '')
		s = s.replace(':', '')

		# итоговая строка
		xxl.append(s)

		# и ее расположение
		pair = match.span()
		positions.append( pair[0] )
  
	# добавляем конечную позицию
	positions.append( len(srcStr)-1 )
	# число совпадений
	return len(xxl)
	
''' удаление комментариев из меток - любых и полезных тоже '''
def pureNode( node ):
	splitList = node.split(';')
	return splitList[0]
	
''' выделенная функция добавления узла в граф и связи в файл'''
def addEdge(header, resStr, ioc):
	try:
		ioc.writeIconn(header+'\n')# label[1]
		ioc.writeIconn('  >> '+resStr+'\n\n')# 
	except IOError:
		print 'IOError'
	try:
		gr.add_edge( (resStr, header) )
	except AdditionError:
		print 'edge exist'

''' Обработка переходов в предалах Диапазона главных меток '''
def labelOperation(resStr, header, ioc):
	# разбираем результаты
	for kk in range(len(resStr)):  
		if resStr[kk].find('_v#v') == -1:	# не интерфейс
			step = '    P> '
		else:	# еще бы проверить внутренний Public-вызов
			step = '    I> '
		# Делаем запись в файле
		ioc.writeCode(step+resStr[kk]+'\n')
		
		# Заполняем выходной массив логальных вызовов
		innerLabels.append(resStr[kk])
		try:
			# Добавляем узел. Если существует уходим в обр. искл.
			gr.add_node( resStr[kk] )
			# Заполняем граф - соединяем ребра. Ориентация безразлична.
			#   Если досюда дошли, то ислючений не было.
			addEdge(header, resStr[kk], ioc)
		except AdditionError:
			# Метка может вызываться неоднажды. Поэтому хоть узел и есть в гр.
			#   соединение нужно провести
			addEdge(header, resStr[kk], ioc)

''' '''
def processing( headers, positions, resultStr ):
	innerLabels = list()
	# главные метки вставляем сразу
	for node in headers:
		try:
			gr.add_node( node )	# метки добавили
		except AdditionError:
			print 'Node Exist'

	# Вычислительная часть
	ioc = IOController()
	# Обрабатываем метку за меткой 
	#   _MainL1 !_L1 _L2 ... _LN! _MainL2 _L1...
	for k in range(len(headers)):	# по карте меток
		# выводим на экран метки. Не интерфейсные  с отсупом
		step = ''
		if headers[k].find('_v#v') == -1:	# не интерфейс
			step = '\n  '
		else:
			step = '\nI '
		string = (step+str(positions[k])+' : '+headers[k]+'\n')
		ioc.writeCode(string)
		
		# разбираемся с подблоками(между метками) headers[k] - топовая
		[resStr, resInt] = jumpsFinder(resultStr[positions[k]:positions[k+1]])
			# многовато получет аргументов!
		labelOperation(resStr, headers[k], ioc)
	#for k in range(len(headers)):	# по карте меток
	
	# внутренние метки - все
	return innerLabels
	
# Главная
#pattern = '^_v.*?$'	# показать только интерфейс
pattern = '^_.*?$'
patternCode = 'code.*?end$'	# выделение блока только кода
# Куда сохраняем результаты
headers = list( '' )
positions = list( '' )	# p^p^...^p на один диапазон меньше
innerLabels = list( '' )
def Run( ifile ):
	try:
		f = io.open( ifile, "r" )	# пусть так и остается
		try:
			# Read the entire contents of a file at once.
			string = f.read() 
			
			# переводим в единую строку
			string = string.replace('\n', '\\n')

			# Выделяем только код
			result = re.findall(patternCode, string, re.M | re.S | re.X )
			if len(result) == 1:
				# Перевод обратно в размеченный код
				resultStr = result[0].replace('\\n', '\n')

			# Поиск карты меток - главной (_xxx:)
			findArrMainLabels( headers, positions, resultStr, pattern )
			headersPurge = list('')
			for node in headers:
				headersPurge.append( pureNode( node ) )
			
			# обрабатываем полученную карту(метки и позиции)
			# совместно со строкой из файла
			innerLabels = processing( headersPurge, positions, resultStr )

		finally:
			f.close()
	except IOError:
		print 'error'
	
	# Делаем картинку
	dot = write(gr)
	with open('test.dot', 'w') as f:
		f.write(dot)
	os.system('dot test.dot -Tjpg -o test.jpg')
		
# Run()
# Файлы со входными модулями
#file = "test_with_err.asm"
#file = "test.asm"
#file = '_v3_COMP.asm'
file = 'ITest.asm'
# поиск распределения
Run( file )


