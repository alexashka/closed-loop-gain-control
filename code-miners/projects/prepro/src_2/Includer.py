#-*- coding: utf-8 -*-
''' 
	abs. : 
		обрабатывает include директивы
		на входе файл ansii(или и тот и тот)
		на выходе utf8
		! нужно вставить все разом, хотя... если есть циклические засисимости то..
		
	precond :
		заголовочные файлы не содержат циклческих зависимостей 
		
	file : import Includer


 прочитать файл в список
 для всех элементов списка проверить есть ли include кл. слово
   сохранить эту строку - потом возможно она будет целиком заменена сод. файла
 провертть нужно ли на ее место вкл
 Считать исх. файл и целевые в строк и в исх. прямо заменить 
 Пока всякие глупости не учитываю!!

 Проблемы
   1. циклические записимости
   2. закомментированные строки
'''

import sys
import usaio.io_wrapper as iow

_cb_type_reader_src = iow.cp1251file2list
_cb_type_reader_src_it = iow.cp1251file2list
#_cb_type_reader_src_it = iow.utf8file2list
#_wr_enc = 'utf_8'
_wr_enc = 'cp1251'

# [ Iface ]
''' 
	abs. : assemble file 
	Warning! : циклические зависимости не обрабатывает
'''
def AssembleCompileUnit( fname, targetFileName ):
	# Читаем исходный файл - может быть путаница с кодировкий!!
	listLines = _cb_type_reader_src( fname )
	
	# Ищем директивы включения
	occureInd = True
	# файл пишется как юникод на первой итерации
	while _AnalyseContent( listLines, targetFileName, _cb_type_reader_src,  _wr_enc ):
		listLines = _cb_type_reader_src_it( targetFileName )
	
	# если хотя бы один файл не найден ошибка и выдаем сообщение
	
# [ Core ]	
''' '''
def _insertFileContent( file, one_line, cb_type_reader ):
	# да действующая директива
	# Выделяем адрес файла включения
	one_line_tmp = one_line.split()
	path_to_header = one_line_tmp[1]
	path_to_header = path_to_header.replace('>','')	# можно в цикл свернуть!
	path_to_header = path_to_header.replace('<','')
	path_to_header = path_to_header.replace('"','')
	path_to_header = path_to_header.replace('/','\\')

	# Закомменчиваем что включили
	file.write(';'+path_to_header+'\n')
	
	# Получае содержимое вкл. файла
	linesFromInc = cb_type_reader( path_to_header )
	
	# Лучше выделить новыми строками
	file.write( '\n' )
	
	
	# пишем в целевой файл
	if linesFromInc != None:
		for jat in linesFromInc:
			file.write( jat )
	
	# чтобы ошибки в стыковке файлов не было
	file.write( u'\n' )
	
''' '''
def _AnalyseContent( listLines, targetFname, cb_type_reader, _wr_encoding ):
	fixModuleNameYes = False
	occureInc = False
	sets = { 'name' :  targetFname, 'howOpen' : 'wb',  'coding' : _wr_encoding }
	file = iow.FabricOpen( sets )
	
	# Проверяем есть ли файл для записи
	if file != None and listLines != None:
		for at in listLines:
			# есть ли директива включения
			if 'include' in at:
				# проверка незакомментированности
				if at[0] != ';':
					# вставлем содержимое файла
					_insertFileContent( file, at, cb_type_reader )
						
					# Нашлись включения
					occureInc = True
			else :	# просто пишем в файл
				if 'THIS' in at:
					if not fixModuleNameYes:
						fixModuleNameYes = True
				file.write(at)
		file.write('\n')
	else:
		occureInc = False
	
	# выходим
	return occureInc 	# конец рекурсии







