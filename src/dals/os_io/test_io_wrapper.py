#-*- coding: utf-8 -*-
""" 
иногда нужно
listForWrite = list(u'')
   for at in resultList:
      #print type(at[0].decode('cp1251'))#.encode('cp1251') 
      for it in at:
         listForWrite.append(it.decode('cp1251'))
"""
from io_wrapper import *
def testRead( sets ):
   file = FabricOpen( sets )
   listLines = None
   if file != None:
      # читаем все 
      listLines = file.toList()
      print listLines
      if listLines != None:
         for at in listLines:
            print at
            #.encode('cp866')   # for jython
   return listLines
   
""" Run() """
if __name__=='__main__':
   import sys
   print sys.stdout.encoding   # jython не правильно определяет кодировку
   
   path = 'statistic/'
   srcfile = path+'test'
   settings = { 'name':  srcfile+'-cp866.txt', 'howOpen': 'r', 'coding': 'cp866' }
   cp866 = testRead(settings)   # Проблемы
   settings = { 'name':  srcfile+'-cp1251.txt', 'howOpen': 'r', 'coding': 'cp1251' }
   cp1251 = testRead(settings)
   settings = { 'name':  srcfile+'-ascii.txt', 'howOpen': 'r', 'coding': 'cp1251' }   
   ascii = testRead(settings)
   settings = { 'name':  srcfile+'-utf8.txt', 'howOpen': 'r', 'coding': 'utf_8' }
   utf8 = testRead(settings)
   
   settings['name'] = 'output/wr_'+settings['name'].split('/')[1]
   settings['howOpen'] = 'wb'
   settings['coding'] = 'utf_8'
   file = FabricOpen( settings )
   if file != None and utf8 != None:
      file.write( '-'.join(utf8) )
      
   # Write
