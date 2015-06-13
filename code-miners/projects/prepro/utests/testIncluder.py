#-*- coding: utf-8 -*-
''' 
	abs. : обрабатывает include директивы
		на входе файл ansii(или и тот и тот)
		на выходе utf8
	file : import testIncluder
'''
import os
import unittest
import Includer as inc
# Run()
if __name__=="__main__":
	# переходим в директорию с файлом
	os.chdir('src')
	
	# Чтаем исходный файл - единицу компиляции
	fname = '_v2_HOT.asm'
	fname = 'src.asm'
	targetFileName = 'pp_'+fname
	
	# собрать один файл
	modelName = ''
	inc.assembleCompileUnit( fname, targetFileName )

