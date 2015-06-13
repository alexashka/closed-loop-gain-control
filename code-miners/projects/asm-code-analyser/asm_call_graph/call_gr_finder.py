#!/usr/bin/python
#-*- coding: utf-8 -*-
""" 
  file : import CallGrFinder

  abs. :
  
  target : 
	1. Межмодульный анализатор(из модуля форм. ужатые графы)
		сделать вид для модели в виде кода - из кода качать разноплановую
		информацию
		интерфейсная функция - по ней определяем кого вызывает.
		Главное граф составить, а потом можно двигаться произвольно
		Можно пользоваться поисковыми алгоритмами
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
	хорошо бы подсветить основной путь
	Случайные имена вставляемых узлов, важно для итоговой фильтрации
	jpg -> pdf для возм. копирования сод. узлов
		
  
  Ref. targets :
    удаление im. xx from * 
	Lib стал сложен
	глобальные переменные
	изолировать паттерны поиска и константы поиска
	складировать неискльзуемый код. не выкидывать, просто кидать в один файл
	ускорения поисков разных строк (по крайней мере их сокр. их числа)
"""
# std
import re
import sys
sys.path.append('D:\\github\\text-processors\\pkgs')

# own
from usaio.io_wrapper import *
import LabelFindEngine 

# add libs
from GrClasses import gr

def printList( lst ):
	for at in lst:
		print at

def deleteEndlList(lst):
	result = list('')
	for at in lst:
		atToSave = at
		atToSave = atToSave.replace('\r','')
		atToSave = atToSave.replace('\n','')
		result.append(atToSave)
	return result
		
		
""" return no ended lines! """
def deleteCom( lst ):
	result = list('')
	for at in lst:
		atCopy = at
		atCopy = atCopy.replace('\t', '')
		atCopy = atCopy.replace(' ', '')
		if len(atCopy) > 0:
			# удалим и пустые строки, тут может быть платформозависимый вариант
			#   из-за символа конца строки
			if atCopy[0] != ';' and atCopy[0] != '\r':
				atToSave = at.split(';')[0]
				atToSave = atToSave.replace('\r','')
				atToSave = atToSave.replace('\n','')
				
				# TEST
				atToSave = atToSave.replace('mSlideTo','goto')
				# TEST
				
				result.append(atToSave)
	return result

""" Предполагается что секций кода одна """
def extractCode( strList ):
	patternCode = 'code.*?end$'	# выделение блока только кода
	result = list('')
	string = '\r\n'.join(strList)
	# Переводим в единую строку. Без переносов. Если не сд. буд. проб. с regex
	string = string.replace('\n', 'eLine')
	
	# сам поиск
	resultSearch = re.findall( patternCode, string, re.M | re.S | re.X )
	if len(resultSearch) == 1:
		# Перевод обратно в размеченный код
		result =  resultSearch[0].replace('eLine', '\r\n')
		result = result.split('\n')
		result = deleteEndlList(result)
	else:
		result = None
	# удаляем обрамление
	return result[1:-1]

""" """
def find( strList ):
	# Поиск карты меток - главной (_xxx:)
	# Нужно подумать как быть, если отличий между метками нет - т.е. нужно
	#   найти !все метки. Как будет выглядеть последующий алгоритм?
	# По идее не должно ничего изменится, но все же
	[ headers, positions ] = LabelFindEngine.findArrMainLabels( strList )
	pureCodeStr = '\r\n'.join(strList)
	#print headers, positions

	
	# Добавляем главные узлы
	gr.addMainNodes( headers )
	
	# Обрабатываем главные метку за меткой 
	#   _MainL1 !_L1 _L2 ... _LN! _MainL2 _L1...
	j = 0 # номера ретурнов и ответвителей
	
	headersNum = len(headers)
	axisHeaders = range(headersNum)
	for k in axisHeaders:	# по карте меток
		# Ищем распределение вызовов по шаблонам
		#   все метки по запросу -> raw labels
		[resStr, j] = LabelFindEngine.bypassAndRetFinder(pureCodeStr[positions[k]:positions[k+1]], j)

		# обрабатываем результаты поиска
		purgeLocalLabelList = list('')
		i = 0
		for at in resStr:
			purgeLocalLabelList.append( LabelFindEngine.purgeBypassAndRetLabels( at ) )
			i += 1

		# Вспомогательные метки найдены, теперь соединяем в общую сеть
		if k+1 != headersNum:
			retNodeConnect(purgeLocalLabelList, headers[k], headers[k+1], headers)
		else : 
			retNodeConnect(purgeLocalLabelList, headers[k], 'NoNext', headers)

	# нужны главные метки для присков
	return headers

""" """
def purgeAvailableNodes( availableNodes, headers ):
	purgedAvailableNodes = list('')
	for item in availableNodes:
		# !! место тонкое особенно по ret!! лучше ret заменить длинным случ. ключом
		noContRet = not strContSubStrItTrue( item, 'ret' ) 
		noContXYZ = not strContSubStrItTrue( item, 'xyz' ) 
		noContZXY = not strContSubStrItTrue( item, 'zxy' ) 
		externCall = findExternLink( headers, item )
		""" Проверка нахождения конеченй точки перехода интерфейсному методу """

		if noContRet and noContXYZ and noContZXY and externCall:
			purgedAvailableNodes.append( item )

	# Возвращаем, что накопили
	return purgedAvailableNodes

""" """
def findExternLink( headers, localsMinusOne ):
	for i in headers:
		if i == localsMinusOne:
			return False
	return True


""" 
  Функции соединения узлов 
знаем какие метки обходные а какие нет
"""
def retNodeConnect( locals, header, header_next, headers ):
	# Добавляем все узлы и проверяем на входимость в диапазон меток
	gr.addSecondNodes( locals, headers )

	# Соединяем 
	jumpTrueBr( header, header_next, headers, locals )

""" Обходов между главными метками не было """
def jumpFalseBr( header, header_next, headers, numItemsAxis,locals ):
	for k in numItemsAxis:  
		# сохраняем последний узел
		gr.addEdge(  header, locals[k] ) 
		# Прочие
		outLayer = locals[k].find( 'zxy' ) != -1
		if outLayer:
			gr.addEdge( locals[k], locals[k+1] )

def strContSubStrItTrue( string, substr ):
	if string.find( substr ) != -1:
		return True
	else:
		return False

def jumpTrueBr( header, header_next, headers, locals ):
	numItems = len( locals )
	numItemsAxis = range( numItems )
	dummyRetNum = 0
	dummyNodeName = ''
	saveNode = header
	for k in numItemsAxis:  
		# добавляем ребро
		if not strContSubStrItTrue( saveNode, 'zxy' ):
			gr.addEdge( saveNode, locals[k] )

		# сохраняем метку для привязки
		if strContSubStrItTrue( locals[k], 'xyz' ):
			# сохраняем последний узел
			saveNode = locals[k]

		# оконечные соединения
		if strContSubStrItTrue( locals[k], 'zxy' ):
			gr.addEdge( locals[k], locals[k+1] )
			saveNode = locals[k]

	# Соединяем с последующей главной
	if not strContSubStrItTrue( saveNode, 'zxy' ):
		gr.addEdge( saveNode, header_next ) 
		
""" Main(){}
	Запускае поиск по одному файлу(=модулю) 
"""
def Run( ifile, ofile ):
	""" Данные передаются в виде списков строк без переносов строки """
	# Получаем содержимое файла
	sets = { 'name':  ifile, 'howOpen': 'r', 'coding': 'cp1251' }
	strList = file2list(sets)
		
	# Удаляем комментарии - отдельные строки и знаки после end\t\n и прочие
	#   чтобы можно было применить регулярное выражение
	noCommentCode = deleteCom( strList )
	sets = { 'name':  'tmp.asm', 'howOpen': 'w', 'coding': 'utf_8' }
	

	# Выделяем только код
	pureCodeStrList = extractCode( noCommentCode )
	list2file(sets, pureCodeStrList)
	
	# Ищем граф вызовов для одного файла
	print 'finding...'
	headers = find( pureCodeStrList )
	print gr

	# Рисуем картинку графа
	print 'plotting...'
	print ofile
	gr.wrGr( ofile )
	
	""" только для python-graph type' ''
	print 'finding...'
	root = "_v#v(HERE)_COMP_SETuw_wByteIn"
	availableNodes = gr.searchNodes( root )
	
	# Удаляем ненужные узлы
	purgedAvailableNodes = purgeAvailableNodes( availableNodes, headers )
	for item in purgedAvailableNodes:
		print item"""





