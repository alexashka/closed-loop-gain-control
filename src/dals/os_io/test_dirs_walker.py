#-*- coding: utf-8 -*-
#!/usr/bin/env python
''' 
	нужно получить все
	
	thinks : walk and regex
'''
import os
from DirsWalker import *
from CrossOs  import *
import unittest
import random
''' проверяет нет ли ненужных расширений 
  можно сделать подругому
'''
def testResultWithExtFilter( resultList, listOfIgnoreExtention ):
	for at in resultList:
		for j in listOfIgnoreExtention:
			if '.'+j in at:
				return True
	return False

class TestSequenceFunctions(unittest.TestCase):
	# хорошо бы сделать, что-то типа инициализации
	def setUp(self):
		self.head = 'tmp'
		self.listOfExtension = ['py']
		self.listOfIgnoreExtention = [ 'pyc' ]
		self.listOfIgnoreDirectories = list('')
		self.ignoreDictOfLists = { 'Extentions' : self.listOfIgnoreExtention }
		self.ignoreDictOfLists[ 'Dirs' ] = self.listOfIgnoreDirectories

	''' Проверка ошибочного пути '''
	def testErroredPath(self):
		# Корректируем входные данные
		self.head = 'asfd..\tmp'
		
		# запускае поиск
		result, msg = findFilesDownTree( self.head, self.listOfExtension, self.ignoreDictOfLists)
		
		# сама ошибка
		self.assertEqual( result, None )
		
		# код ошибки
		self.assertEqual( msg, "OSError: show root path.pyc" )
	
	''' Проерка нормальных путей - не воспр. как ненормальные'''
	def testNoErroredPath(self):
		self.head = 'tmp'

		# сам запуск
		result, msg = findFilesDownTree( self.head, self.listOfExtension, self.ignoreDictOfLists)
		
		# сама ошибка
		self.assertEqual( isinstance(result, list), True )
		
		# проверка
		self.assertNotEqual( msg, "OSError: show root path.pyc" )

	''' test extentions filter '''
	'''def testExtentionsFilter(self):
		# IData
		self.head = '..\tmp'
		
		# поиск
		# Warning! в ответе могут быть расширения
		result, msg = findFilesDownTree( self.head, self.listOfExtension, self.ignoreDictOfLists)
		

		# тест - результат проверяем фильтром
		self.assertEqual(False, testResultWithExtFilter( result, self.listOfIgnoreExtention ))'''

if __name__ == '__main__':
	suite = unittest.TestLoader().loadTestsFromTestCase( TestSequenceFunctions )
	unittest.TextTestRunner(verbosity=2).run(suite)


