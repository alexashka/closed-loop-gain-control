#-*- coding: utf-8 -*-
import io
import os
import IOOperations
import PreProc 

''' CallBacks '''
def cbIncCondition( item ):
	return 'define' in item
def cbAsmCondition( item ):
	return 'ifdef' in item or 'ifndef' in item
	
''' CallBacks '''
def cbIncGetFileList( dirForFound, typeInFile ):
	# поис и среди исходных файлов
	for dir in dirForFound:
		files = os.listdir( dir )
		
	# конкретные названия
	fileList = list()
	definedList = list('')
	for p in files :
		if '.'+typeInFile in p:
			fileList.append( dirForFound[0]+p )
	return fileList
def cbAsmGetFileList( dirForFound, ifile ):
	fileList = list()
	fileList.append( ifile )
	print fileList
	return fileList

''' '''
def getDefsList( dirForFound, cbFindCond, cbGetFileList, typeInFile, ofile ):
	# Создаем список найденных файлов
	fileList = cbGetFileList( dirForFound, typeInFile )
	
	# читаем файл и выбираем из него директивы
	f = io.open( ofile+'.h', 'w', encoding='utf-8')
	f.write(u'#-*- coding: utf-8 -*-\n')
	definedList = list('') # сюда складываем все
	for at in fileList:
		# содержимое
		string = IOOperations.getFileContent( at )
		
		# удаляем закомменченное
		strPure = PreProc.delCom( string )
		
		# Дробим на строки
		
		stringSplit = strPure.split('\n')
		for item in stringSplit:
			if cbFindCond( item ):
				f.write(item+'\n')
				newItem = item.split()[1]
				definedList.append( newItem )
	f.close()
	
	# сохраняем результаты поиска
	f = io.open( ofile+'.py', 'w', encoding='utf-8')
	f.write(u'#-*- coding: utf-8 -*-\n')
	f.write( ofile.split('/')[-1]+'List'+u' = [\n' )
	for at in definedList:
		f.write(u'\''+at+u'\','+u'\n')
	f.write(u']\n')
	f.close()

''' получить пересечение '''
dirForFound = ["../headers/"]
typeInFile = 'inc'
ofile = 'odata/defs'
getDefsList( dirForFound, cbIncCondition, cbIncGetFileList, typeInFile, ofile )

# поиск используемых! иначе объем вычислений очень сильно растет
dirForFound = ["../src/"]
typeInFile = '../src/_v1_IRQ.asm'#'asm'
typeInFile = '../src/_v3_BUM.asm'#'asm'
ofile = 'odata/defsUse'
getDefsList( dirForFound, cbAsmCondition, cbAsmGetFileList, typeInFile, ofile )

# поиск пересечения
import sys
sys.path.append('odata')
import defsUse
import defs
defsUseList = set(defsUse.defsUseList)
defsList = set(defs.defsList)
cross = list( defsUseList&defsList)

f = io.open( 'odata/Cross.py', 'w', encoding='utf-8')
f.write(u'#-*- coding: utf-8 -*-\n')
f.write( u'CrossList = [\n' )
for at in cross:
	f.write(u'\''+at+u'\','+u'\n')
f.write(u']\n')
f.close()
