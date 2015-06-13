#-*- coding: utf-8 -*-
import unittest
import define_purger as purge
from usaio.io_wrapper import *

def file2list( sets ):
	file = FabricOpen( sets )
	listLines = None
	if file != None:
		# читаем все 
		listLines = file.toList()
	return listLines
	
class TestSequenceFunctions(unittest.TestCase):
	""" """
	def setUp(self):
		pass
		
	""" """
	def testOneStep(self):
		sets = { 'name':  'test-data/purge-head.inc', 'howOpen': 'r', 'coding': 'cp1251' }
		srcList = file2list(sets)	# Проблемы
		result = purge.purgeList( srcList )
		
		sets['name'] = 'test-data/purge-head-compare.inc'
		compareList = file2list(sets)	# Проблемы
		
		self.assertListEqual( compareList, result )

if __name__=='__main__':
	suite = unittest.TestLoader().loadTestsFromTestCase( TestSequenceFunctions )
	unittest.TextTestRunner(verbosity=2).run(suite)







