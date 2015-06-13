#-*- coding: utf-8 -*-
""" 
	iss0 : не видит return macro and var
"""
#from MacroPurger import *	# разворачивает макросы и обрабатывает
#import DefinePurger as defPurger
import Includer as inc

# Run()
if __name__=="__main__":
	# Чтаем исходный файл - единицу компиляции
	fname = '_v2_HOT.asm'
	ftarget = 'pp_'+fname	# файл с резултьтатом
	fpath = '../../test-data'
	fullName = fpath+'/'+fname
	fname = fname.replace('/', '\\\\')
	
	# ! могут быть инглуды задефайнены!!
	# нужно очистить от дефайнов заголовочные файлы, а потом уже блок кода!
	
	# собрать один файл
	inc.assembleCompileUnit( fullName, ftarget )
	
	"""
	# удаляем комментарии
	print '\nRemoving commints...'
	inc.purgeFromComments( targetFileName )
	
	# пропускаем через макросы - если внутри есть дефайны, то отфильтруем потом
	print '\nRemoving macroses...'
	run( targetFileName )
	
	# пропускаем через definer ! один раз но весь исходник! и все готово, 
	print '\nPurge from ifdefs...'
	inc.ConditionCompile( targetFileName ) 
	# В итоге чистый файл - чистый код, котовый к графическом анализу
	"""