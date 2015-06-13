#-*- coding: utf-8 -*-
''' 
	abs. : 
	
	precond :
		заголовочные файлы не содержат циклческих зависимостей 
		
	file : import Includer
	
	troubles:
	    1. циклические записимости вызывают зацикливание, причем define использовать нельзя()
			это второй шаг обработки. Можно сохранять имена вкл. файлов и потом отслеживать включение
'''
 
import sys
import usaio.io_wrapper as iow

file2list = iow.cp1251file2list
file2list_in_iterate = iow.cp1251file2list
WR_ENCODING = 'cp1251'
ENTER = u'\n'

# [ Iface ]
''' 
	abs. : assemble file 
	Warning! : циклические зависимости не обрабатывает
'''
def ProcessCompileUnit( fname, targetFileName ):
	# Читаем исходный файл - может быть путаница с кодировкий!!
	lines = file2list( fname )
	
	# Ищем директивы включения
	while _AnalyseContentIteration( lines, targetFileName, file2list,  WR_ENCODING ):
		lines = file2list_in_iterate( targetFileName )
		# если хотя бы один файл не найден ошибка и выдаем сообщение
		#   нет ошибку выдаем но продолжаем
	
# [ Core ]
def _GetFullNameIncFile( line ):
	result = ''
	tmp_list = line.split()
	result = tmp_list[1]
	result = result.replace('>','')	# можно в цикл свернуть!
	result = result.replace('<','')
	result = result.replace('"','')
	result = result.replace('/','\\')
	return result
	
''' '''
def _InsertFileContent( file, line, file2list_aciton ):
	incFullFileName = _GetFullNameIncFile( line )
	to_file = file.write

	# Закомменчиваем что включили
	to_file( ';>>'+incFullFileName )	# не переносимо
	file.write( ENTER )
	lines = file2list_aciton( incFullFileName )
	file.write( ENTER )
	
	
	# пишем в целевой файл
	if lines != None:
		for line in lines:
			file.write( line )
	
	# чтобы ошибки в стыковке файлов не было
	file.write( ENTER )
	file.write( ';<<'+incFullFileName )	# не переносимо
	file.write( ENTER )
	
''' One iteration '''
def _AnalyseContentIteration( lines, target_fname, file2list_aciton, wr_encoding ):
	result = False	# есть ли в файле включения - изначально ставит нет
	sets = { 'name' :  target_fname, 'how_open' : 'wb',  'coding' : wr_encoding }
	target_file = iow.FabricOpen( sets )
	
	# Проверяем есть ли файл для записи - может быть логическая ошибка!
	if target_file != None and lines != None:
		for line in lines:
			if _LineIsContentIncludeCmd( line ) :
				if not _LineIsCommented( line ):
					_InsertFileContent( target_file, line, file2list_aciton )
					result = True
			# copy lines direct
			else :
				target_file.write(line)
		target_file.write( ENTER )
	else:
		result = False
	
	# выходим
	return result
	
''' Poly '''
#
def _LineIsCommented( line ):
	tmp = line.replace('\t', '')
	tmp = tmp.replace(' ', '')
	result = (tmp[0] == ';')
	return result 
	
def _LineIsContentIncludeCmd( line ):
	result = 'include' in line
	return result







