#-*- coding: utf-8 -*-
''' 
	file : import AbstractionIOWrapper

	issues : 
		1. названия методов с большой буквы
		
	! на входе !
		1. ascii файл с некими буквами
		2. encoding='cp1251' 
		3. utf-8 ? (BOM?)
'''

''' Абстракция к ввооду выводу '''
class IFileWrppr:
	''' Инициализация дискриптора '''
	def init( self, fileDiscriptor ):
		self._fileDiscriptor = fileDiscriptor
		print self._fileDiscriptor
	
	''' Абстрактный выход '''
	def Close( self ):
		pass
		
	''' Читать в список - строки utf-8'''
	def ReadLines( self ):
		pass

	''' Запись - строка utf-8'''
	def Write(self, line):
		pass
		
	''' Читать все разом в строку'''
	def ReadAll(self):
		pass

''' Выдает файловые объекты '''
def FabricOpen( dictOfSettings ):
	pass