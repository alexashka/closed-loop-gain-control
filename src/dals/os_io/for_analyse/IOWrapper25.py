#-*- coding: utf-8 -*-
''' 
	file : import 
	
				# За раз читамем весь файл
			# в 2.5 нет такой функции!

			f = open("hello.txt")
try:
    for line in f:
        print line
finally:
    f.close()'''

from AbastractionIOWrapper import *
import re
import sys
import codecs
#sys.setdefaultencoding('utf-8')
def to_unicode_or_bust(
	obj, encoding='utf-8'):
	if isinstance(obj, basestring):
		if not isinstance(obj, unicode):
			obj = unicode(obj, encoding)
	return obj
#import unicodedata

''' '''
class FileWrpprPC(IFileWrppr):
	_fileDiscriptor = None
	_unicode = False
	''' Абстрактный выход '''
	def Close( self ):
		self._fileDiscriptor.close()
	
	''' Читать в список '''
	def ReadLines( self ):
		try:
			listLines = list('')
			tmpStirng = self.ReadAll()
			
			# no run!
			try:
				listLines = tmpStirng.split(u'\n')
			except UnicodeEncodeError:
				listLines = tmpStirng.split('\n')
				
			return listLines
		except IOError:
			print 'IOError'
			return None
	''' '''
	def Write( self, str ):
		try:
			self._fileDiscriptor.write( str )
		except IOError:
			print 'Write IOError'
			
	''' Прочитать все '''
	def ReadAll(self):
		fileContent = self._fileDiscriptor.read()
		return fileContent

''' Выдает файловые объекты '''
def FabricOpenPC25( dictOfSettings ):
	fname = dictOfSettings['name']
	typeOnenning = dictOfSettings['rwtb']
	xcoding = dictOfSettings['xcoding']
	# создаем реальный файловый объект
	try:
		f = codecs.open( fname, typeOnenning, xcoding )
	except IOError:
		print 'Open() error'
		return None
	fwrapper = FileWrpprPC()
	# В java может не сработать, т.к. перед. по знач.
	fwrapper.init(f)
	# Возвращаем абстрактный класс
	return fwrapper

# Назначаем фабрику
FabricOpen = FabricOpenPC25

''' получить содержимое файла в список 
	file coding - 1251
'''
def fileToList( targetFname ):
	dictOfSettings = { 
		'name' :  targetFname, 
		'rwtb' : 'r', 
		'xcoding' : 'cp1251' }

	# Сгенерить
	listLines = list('')
	File = FabricOpenPC25( dictOfSettings )
	if File != None:
		# читаем все 
		listLines = File.ReadLines()
		File.Close()
	return listLines

# Run()
if __name__ == '__main__':
	targetFname = 'src/src.asm'
	dictOfSettings = { 
		'name' :  targetFname, 
		'rwtb' : 'r', 
		'xcoding' : 'cp1251' }
	
	# Сгенерить
	File = FabricOpenPC( dictOfSettings )
	if File != None:
		# читаем все 
		listLines = File.ReadLines()
		print listLines
		File.Close()
	
	# Пишем
	targetFname = 'tmp5.py'
	dictOfSettings = { 
		'name' :  targetFname, 
		'rwtb' : 'wt', 
		'xcoding' : 'utf-8' }
	File = FabricOpenPC( dictOfSettings )
	if File != None:
		for at in listLines:
			File.Write( at+'\n' )
		File.Close()
	
