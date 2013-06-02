#-*- coding: utf-8 -*-
#!/usr/bin/env python
''' '''
from usaio import PCFileOperatons
import unittest

''' Dropbox '''
class TestDropboxFileOperatons(unittest.TestCase):
	pass
''' PC '''
class TestPCFileOperatons(unittest.TestCase):
	''' '''
	def testOpenClose(self):
		pcfile = PCFileOperatons()
		
		# должно выкидывать исклчение, теперь это код ошибки
		#with self.assertRaises(IOError):
		self.assertEqual( pcfile.Open('\asdf\log.log', list('at')), -1 )
		
		# Файл открыт. Если не сущ., будет создан
		self.assertEqual( pcfile.Open('log.log', list('at')), 0 )

''' Run() '''
if __name__ == '__main__':
	# Тест класса работы с файлами на ПК
	suite = unittest.TestLoader().loadTestsFromTestCase( TestPCFileOperatons )
	unittest.TextTestRunner(verbosity=2).run(suite)