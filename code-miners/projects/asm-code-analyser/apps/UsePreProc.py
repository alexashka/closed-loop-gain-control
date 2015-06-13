#!/usr/bin/python
#-*- coding: utf-8 -*-
# file : import UsePreProc
import io
import os
import IOOperations

dirForFound = ["../headers/"]
  
# поис и среди исходных файлов
for dir in dirForFound:
	files = os.listdir( dir )

# И обрабатываем его
fileList = list()
for p in files :
	if p.find('.inc') != -1:
		fileList.append( dirForFound[0]+p )

import PreProc 
PreProc.getMacroFile( fileList )
import mFu

# Обрабатываем файл с кодом
ifile = '../src/_v1_IRQ.asm'
# читаем
string = IOOperations.getFileContent( ifile )
commFree = PreProc.delCom( string )
 
commFreeList = commFree.split('\n')

# замена в файлах
i = 0
f = io.open('mFu.asm', 'w', encoding='utf-8')
f.write(u'#-*- coding: utf-8 -*-\n')
for item in commFreeList:
	itemSplit = item.split()
	if len( itemSplit ) > 0:
		args = list('')
		if itemSplit[0] in mFu.macDictFu:	# поиск имени макроса
			# получаем аргументы
			args = PreProc.getArgs( item, i )
			print args
			f.write( unicode( mFu.macDictFu[itemSplit[0]]( args ))+u'\n' )
			i += 1
		else :
			# просто пишем
			f.write( unicode( item )+u'\n' )
f.close()
i = 0

