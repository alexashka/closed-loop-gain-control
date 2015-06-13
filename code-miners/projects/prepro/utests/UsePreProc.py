#!/usr/bin/python
#-*- coding: utf-8 -*-
# file : import UsePreProc
import io
import IOOperations
import PreProc 
PreProc.getMacroFile()
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
			f.write( unicode( mFu.macDictFu[itemSplit[0]]( args )) )
			i += 1
f.close()
i = 0

