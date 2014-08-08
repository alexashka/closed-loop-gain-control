#-*- coding: utf-8 -*-
#!/usr/bin/env python
''' 
	file : import usaio
	
	абстракция для работы с вводом выводом
	1. os filesystem
	2. clouds (dropbox, docs.google.com)
	
	Do :
	1. File operation
		Create()
			Read()
			Write()
			Close()
		Delete()
		Move()
		Copy()
	2. Directorys operaton
		Create()
		Delete()
		Walk()	// прогулка по дереву каталогов
'''
import os
#import io # Были проблемы с unicode. Нужно будет скорее всего это вставить
import CrossOs	# платформозависимые вызовы(между операц. сист.)

''' 
	Abs. : базовые класс для работы с файлами 
	Think : интерфейс корее для порядка. В питоне все плавающее
		поэтому наследование ^не очень то нужно
	Think : какие ошибки возвращает, или исключениения генерирует
		может свелосипедить новый класс исключений - общий
	gThink : параметризуются ли вызовы вообще?
'''
def ifaceFileOperatonsFabric():
	return IFileOperatons()
# вот это будет задавать тип операций
FileOperatonsFabric = ifaceFileOperatonsFabric
class IFileOperatons():
	''' Для облак будет нужна '''
	# Think : кстати делать ее для одного файла все же глупо
	def Authentication(self):	
		pass

	''' Открытие. На входе имя файла и атрибуты '''
	def Open(self, fname, attributesList):
		pass
		
	# Операции с открытым файлом
		
	''' Закрытие '''
	def Close(self):
		pass
	
''' базовый класс для работы с директориями '''
class IDirsOperations():
	pass
	
''' Dropbox '''
class DropboxFileOperatons(IFileOperatons):
	pass 

''' Simple PC
	Nfo : Повторое использование экземпляра на свой страх и риск
''' 
class PCFileOperatons(IFileOperatons):
	_opened = False # пусть будет - признак открытости
	_fname = None	#
	
	''' Отакрываем просто как файл файловой системы '''
	def Open( self, fname, attributesList ):
		try:
			self._fname = open(fname,attributesList[0])
		except IOError:
			self._opened = False
			return -1	# 'Файл не найден, либо ошибка в атрибутах'
		# если открыли, то нужно отчитаться
		self._opened = True
		return 0	# все ок
	
	# Операции с открытым файлом
	''' Запись '''
	''' Чтение '''
	
	''' Закрываем '''
	def Close(self):
		if self._opened :
			self._fname.close()
		self._opened = False

	''' Деструктор, для реализации RIA '''
	def __del__(self):
		self.Close()	# отпускаем файл

''' Получение текущего пути '''
def getPwd():
  cwd = os.getcwd()
  return cwd
  
''' ignore - путь игнорируется целиком если есть вхождение этой строки '''
def cp(N, K, ignore):  
    if os.path.isdir(N):
        if not os.path.exists(K): os.mkdir(K)
        for x in os.listdir(N):
            if os.path.isdir(os.path.join(N,x)):
                if not os.path.exists(os.path.join(K,x)): os.mkdir(os.path.join(K,x))
                cp(os.path.join(N,x),os.path.join(K,x), ignore)
            else: cp(os.path.join(N,x),os.path.join(K,x), ignore)
    elif N.find(ignore) == -1 :
        file = open(N,"rb"); data = file.read(); file.close()
        file = open(K,"wb"); file.write(data); file.close()

''' '''
def cpFull(N, K):  
    if os.path.isdir(N):
        if not os.path.exists(K): os.mkdir(K)
        for x in os.listdir(N):
            if os.path.isdir(os.path.join(N,x)):
                if not os.path.exists(os.path.join(K,x)): os.mkdir(os.path.join(K,x))
                cp(os.path.join(N,x),os.path.join(K,x))
            else: cp(os.path.join(N,x),os.path.join(K,x))
    else  :
        file = open(N,"rb"); data = file.read(); file.close()
        file = open(K,"wb"); file.write(data); file.close()
		
''' Run() '''
if __name__ == '__main__':
	file = IFileOperatons('log.log')