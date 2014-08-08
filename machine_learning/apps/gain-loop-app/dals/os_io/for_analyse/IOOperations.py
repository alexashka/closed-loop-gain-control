#!/usr/bin/python
#-*- coding: utf-8 -*-
''' 
  file : import IOOperations
'''
import io

''' Класс для работы с вводом-высодом'''
class IOController:
	_fwr = None
	_fwr_ic = None
	def __init__(self):
		# Вычислительная часть
		try:
			#self._fwr = io.open('logs/code.log', 'w', encoding='utf-8')
			#self._fwr_ic = io.open('logs/iconn.log', 'w', encoding='utf-8')
			pass
		except IOError:
			print 'IOError open()'
			
	''' деструктор'''
	def __del__(self):
		#self._fwr.close()
		#self._fwr_ic.close()
		pass
			
	''' Функция записи с инк. обраб. искл.'''
	def writeCode(self, string):
		try:
			self._fwr.write(string)
		except IOError:
			print 'write() IOError'
	def writeIconn(self, string):
		try:
			self._fwr_ic.write(string)
		except IOError:
			print 'write() IOError'

''' запись распеределения в файл '''
''' Главые метки '''
def wrMainLabel( position, header ):
	step = ''
	if header.find('_v#v') == -1:	# не интерфейс
		step = '\n  '
	else:
		step = '\nI '
	string = (step+str(position)+' : '+header+'\n')
	ioc.writeCode(string)
	
def wrSecondLabel( secLabel ) :
	if secLabel.find('_v#v') == -1:	# не интерфейс
		step = '    P> '
	else:	# еще бы проверить внутренний Public-вызов
		step = '    I> '
	# Делаем запись в файле
	ioc.writeCode(step+secLabel+'\n')
	
# Получить содержимое файла
def getFileContent( ifile ):
	string = ''
	try:
		f = io.open( ifile, "r" )	# пусть так и остается
		try:
			# За раз читамем весь файл
			string = f.read() 
		finally:
			f.close()
	except IOError:
		print 'error'
	
	# 
	return string

#try:
ioc = IOController()
#except AttributeError:
#	print "AttributeError"
