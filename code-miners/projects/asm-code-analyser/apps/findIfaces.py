#-*- coding: utf-8 -*-
''' 
  file : import findIfaces
'''
import sys
import os
import str_finder_ifaces as sf

''' '''
def findExt( string, listExt ):
	for k in listExt:
		if '.'+k in string:
			return True
	return False

# индивидуальные файлы
listForFind = [
#'_v\#.*?\\n', #	1	;D4 Pin-Value
'\\n_v\#.*?\\n', #	1	;D4 Pin-Value
#'D4B', #	1	;D4 Pout-Value	Uos
#'D9AL', #	1	;D9 Usm1
]
fileList = [
	"../src/kpup_low_lewel.asm",
]

summaryList = list()
summaryDict = list()
for file in fileList:
	tmpList = list('')
	tmpList.append( file )
	retList, dictNew = sf.Main( listForFind, tmpList, None )

setIfaces = retList[0]

try:
	fw = open('ifaces.log', 'w')
	for i in setIfaces:
		i = i.replace('\n','')
		i = i.replace('_v#v(HERE)','_v2')
		string = 'mEXTENDS\tKPUP_LOW_LEWEL,\ttargetX,\t'+i
		try:
			fw.write(string+'\n')
		except IOError:
			print 'wr. err.'
finally:
	fw.close()
	
# поиск по всем модулям
listForFind = list()
for any in setIfaces:
	any = any.replace('\n','')
	any = any.replace('_v#v(HERE)','')
	any = any.split(';')
	any = any[0]
	listForFind.append( any )
	
dirForFound = ["../src/", "../headers/"]
listExt = ['asm', 'inc', 'h']
fileList = list()
for dir in dirForFound:
	files = os.listdir( dir )
	for p in files :
		if findExt( p, listExt ):
			p = dir+p
			fileList.append( p )
#for k in fileList:
retList, listAdd = sf.Main( listForFind, fileList, None )
for at in listAdd:
	print at
