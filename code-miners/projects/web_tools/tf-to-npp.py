#!/usr/bin/python
#-*- coding: utf-8 -*-
import sys
sys.path.append( 'D:/home/lugansky-igor/pyPkgs/py-reuse-pkgs' )
from subprocess import call


import text_finders.DirsWalker as DirsWalker
import text_finders.FindEngine as FindEngine
import time
import sys

# Run()
if __name__=="__main__":
	ticks0 = time.time()
	
	head = '.\\'
	listOfExtension = ['js', 'htm', 'css']
	#listOfExtension = ['inc']
	resultArgv = ''
	for at in listOfExtension:
		listSlice = list()
		listSlice.append(at)
		
		# Ignore
		ignoreLists = {}
		ignoreLists[ 'Extentions' ] = [ '' ]
		ignoreLists[ 'Dirs' ] = ['.\\www\\stopped-branch', '.\\.git', '.\\sbox']
		
		# поиск
		resultList, msg = DirsWalker.findFilesDownTree( head, listSlice, ignoreLists)
		
		# список получен, можно его обработать
		# в принципе можно передать указатель на функцию обработки
		#print at, len(resultList)
		#for at in resultList:
		#	print at#.split('\\')[-1]
		resultArgv += '\n'
			
		resultArgv += '#'.join(resultList)
	
		
	#print resultArgv
	resultArgv = resultArgv.split('#')
	listToOpen = list()
	listToOpen.append("notepad++")
	for at in resultArgv:
		#time.sleep(0.1)
		listToOpen.append(at)
		
		print at
	call(listToOpen)

	# список файлов готов, можно искать текст
	'''retlist, tmp = FindEngine.Main(pattern,resultList, head)
	for at in retlist:
		tmp = at.split('\\')
		print at.replace(tmp[-1],'')
		print '\t'+tmp[-1]'''
	ticks1 = time.time()
	print '\nTimeRun = '+str(ticks1-ticks0)+' sec'
