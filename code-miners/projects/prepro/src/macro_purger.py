#!/usr/bin/python
#-*- coding: utf-8 -*-
''' 
	file : import 
	notes : главно макросы развернуть в коде, а не в заголовках
'''

		
import re
import io
import os
import IOOperations
''' создать список аргументов макроса '''
def getArgs( item, i ):
	# чистые параметры метода
	item = item.replace(',', ' ')
	#item = item.replace('\t', ' ')
	itemListSplit =  item.split(';')
	

	itemListSplit = itemListSplit[0].split()
	# порядковый номер метки
	itemListSplit.append( str( i ) )
	
	# выводим итоги
	#print itemListSplit[0],itemListSplit[1:]
	return itemListSplit[1:]

''' генерирует файл замены макросов '''
def getMacroFile( listFiles ):
	# контейнеры
	macDict = {}
	macContent = {}
	macArgsDict = {}
	for ifile in listFiles:
		# читаем
		string = IOOperations.getFileContent( ifile )
		commFree = delCom( string )

		# дробим на отдельные строки (по \n) 
		#   и каждую анализируем отдельно
		listStr = commFree.split('\n')

		mustWrite = False	# начался ли макрос
		currentName = ''	# имя текущего макроса, в который пишем
		contentMacro = '\''
		for item in listStr:
			
			if '#v(i)' in item:
				item = item.replace('#v(i)', '\'+i+\'')

			# Проверка того, заполняем ли мы содержимое макроса
			if mustWrite and not 'endm' in item:
				# удаляем увеличение переменной
				item = item.split(';')[0]#.replace('\'', 'VvV')# '\\\'')
				#if '#v(i)' in item:
				#	item = item.replace('#v(i)', '\'+i+\'')
				# сцепляем
				contentMacro += '\n'+item
				
			# если есть совпадение по macro - выделяем строку и анализируем
			#   еще не факт, что это то, что нужно
			if 'macro' in item:
				# удаляем запятые
				item = item.replace(',', ' ')
				
				# дробим
				listItemSplit = item.split()

				# Проверка на неслучайтость
				if 'macro' in listItemSplit[1]:
					# Сигнатрура макроса, теперь нужно найти его содержимое
					currentName = listItemSplit[0]
					
					# оставляем только параметры
					itemListSplit = item.split(';')[0].split()
					macArgsDict[currentName] = itemListSplit[2:]
					mustWrite = True
			
			# если макрос закончился
			if 'endm' in item:
				listItemSplit = item.split()
				for at in listItemSplit:
					if 'endm' in at:
						# с большой вер. это конец макроса
						mustWrite = False
						
						# проверка контента на важность
						
						# добавление контента в словарь
						macDict[currentName] = '\treturn '+contentMacro+'\''
						contentMacro = '\''

	# Пишем в файл. Он собирается со всех.
	f = io.open('mFu.py', 'w', encoding='utf-8')
	f.write(u'#-*- coding: utf-8 -*-\n')
	for at in macDict.keys():
		# нужно сделать параметры макроса переменными
		#   Gap! name_labelXX тоже заменит!! нужно подумать
		pins = ''
		i = 0
		for argi in macArgsDict[at]:
			macDict[at] = macDict[at].replace(argi,'\'+'+argi+'+\'')
			# распиновка 
			pins += '\t'+argi+' = '+'args['+str(i)+']\n'
			i += 1
		pins += '\ti = '+' args['+str(i)+']\n'
		
		# Перенос строки
		macDict[at] = macDict[at].replace('\n', '\\n\\\n')
		macDict[at] = macDict[at].replace('i++', '')
		
		# Заголовок функции и распиновка
		macDict[at] = 'def '+at.replace('?','')+'( args ): '+'\n'+pins+macDict[at]
		
		# Смотрим что вышло
		f.write(macDict[at]+'\n')

	# Пишем формирователь словаря для доступа
	f.write(u'macDictFu = {\n')
	for it in macDict.keys():
		f.write( '\''+it+'\' : '+it.replace('?', '')+',\n')
	f.write(u'}\nprint len(macDictFu)\n')
	f.close()


''' удаляем комментарии и поселдние вспом. символы '''
def delCom( pureCodeStr ):
	# Удаляем все комментарии
	splitString = pureCodeStr.split('\n')
	splitStringPurge = ''
	for g in range(len(splitString)):
		# Проверка на комментарий
		tmp = splitString[g].split()
		if len(tmp) > 0:
			if tmp[0][0] == ';':
				continue
		splitStringPurge += '\n'+ splitString[g]

	# Удаляем все символы после end\n\t
	i = 1
	if (splitStringPurge[-i] == '\n') or (splitStringPurge[-i] == '\t') or (splitStringPurge[-i] == ' '):
		while (splitStringPurge[-i] == '\n') or (splitStringPurge[-i] == '\t') or (splitStringPurge[-i] == ' '):
			i += 1
		return splitStringPurge[:-i+1]
	else:
		return splitStringPurge
		
''' '''
def macrosesUnroll( targetFileName ):
	import IOOperations
	ifile = targetFileName

	# читаем
	string = IOOperations.getFileContent( ifile )
	commFree = delCom( string )

	# дробим на отдельные строки (по \n) 
	#   и каждую анализируем отдельно
	listStr = commFree.split('\n')
	macDict = {}
	macContent = {}
	macArgsDict = {}
	mustWrite = False	# начался ли макрос
	currentName = ''	# имя текущего макроса, в который пишем
	contentMacro = '\''
	for item in listStr:
		# удаляем увеличение переменной
		if '#v(i)' in item:
			item = item.replace('#v(i)', '\'+i+\'')

		# Проверка того, заполняем ли мы содержимое макроса
		if mustWrite and not 'endm' in item:
			contentMacro += '\n'+item
			
		# если есть совпадение по macro - выделяем строку и анализируем
		#   еще не факт, что это то, что нужно
		if 'macro' in item:
			# удаляем запятые
			item = item.replace(',', '')
			
			# дробим
			listItemSplit = item.split()
			
			# Проверка на неслучайтость
			if 'macro' in listItemSplit[1]:
				# Сигнатрура макроса, теперь нужно найти его содержимое
				currentName = listItemSplit[0]
				
				# оставляем только параметры
				itemListSplit = item.split()
				macArgsDict[currentName] = itemListSplit[2:]
				mustWrite = True
		
		# если макрос закончился
		if 'endm' in item:
			listItemSplit = item.split()
			for at in listItemSplit:
				if 'endm' in at:
					# с большой вер. это конец макроса
					mustWrite = False
					
					# проверка контента на важность
					
					# добавление контента в словарь
					macDict[currentName] = '\treturn '+contentMacro+'\''
					contentMacro = '\''

	# проверяем что вышло
	f = io.open('mFu.py', 'w', encoding='utf-8')
	f.write(u'#-*- coding: utf-8 -*-\n')
	for at in macDict.keys():
		# нужно сделать параметры макроса переменными
		#   Gap! name_labelXX тоже заменит!! нужно подумать
		pins = ''
		i = 0
		for argi in macArgsDict[at]:
			macDict[at] = macDict[at].replace(argi,'\'+'+argi+'+\'')
			# распиновка 
			pins += '\t'+argi+' = '+'args['+str(i)+']\n'
			i += 1
		pins += '\ti = '+'str( args['+str(i)+'] )\n'
		
		# Перенос строки
		macDict[at] = macDict[at].replace('\n', '\\n \\\n')
		macDict[at] = macDict[at].replace('i++', '')
		
		# Заголовок функции и распиновка
		macDict[at] = 'def '+at+'( args ): '+'\n'+pins+macDict[at]
		
		# Смотрим что вышло
		f.write(macDict[at]+'\n')
	# Пишем формирователь словаря для доступа
	f.write(u'macDictFu = {\n')
	for it in macDict.keys():
		f.write( '\''+it+'\' : '+it+',\n')
	f.write(u'}\n')
	f.close()

''' '''
def testMacro(item, macDictFu):
	finded = False	# если строка обычаня то ничего не изменится
	type = ''
	for at in macDictFu:
		if at in item:	
			itemSplit = item.split()	# просто дробим
			summaryList = list('')
			for iat in itemSplit:
				if iat != '':
					summaryList.append(iat)
			# истинные макросы отметаются
			summaryList.append('')
			if summaryList[1] == 'macro':
				finded = False	# псевдомакрос
			else : 	# макросы которыенужно заменить
				finded = True	# макрос
				type = at
	# возвращаем то что вышло
	return finded, type

			
''' '''
def run( fname ):
	macrosesUnroll( fname )	# изготовит файл исходного кода
	import mFu

	# Обрабатываем файл с кодом
	ifile = fname
	# читаем
	string = IOOperations.getFileContent( ifile )
	commFree = delCom( string )

	# чистый от комментариев код - плоховато, но пусть пока
	commFreeList = commFree.split('\n')

	# замена в файлах
	i = 0
	f = io.open(fname, 'w', encoding='utf-8')
	f.write(u'#include 	P18F8722.inc\n')
	for item in commFreeList:
		fini, type = testMacro(item, mFu.macDictFu)
		if fini:
			itemSplit = item.split()	# просто дробим
			args = getArgs( item, i )
			#print type
			unrollCode = mFu.macDictFu[type]( args )
			unrollCode = unrollCode.replace('THIS', '_v2_HOT')
			f.write(unicode( unrollCode+'\n' ))
			i += 1
		else :
			# просто пишем
			f.write( unicode( item )+u'\n' )
	f.close()
	i = 0
