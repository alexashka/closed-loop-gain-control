#-*- coding: utf-8 -*-
''' 
	iss0 : не видит return macro and var
'''
#from MacroPurger import *	# разворачивает макросы и обрабатывает
import Includer as includer
import define_purger as dpurger

# Run()
if __name__=="__main__":
	# Чтаем исходный файл - единицу компиляции
	fname = 'eeprom.asm'
	ftarget = 'cu_'+fname	# файл с резултьтатом
	fname = fname.replace('/', '\\\\')
	fullName = fname
	
	# ! могут быть инглуды задефайнены!!
	# нужно очистить от дефайнов заголовочные файлы, а потом уже блок кода! нет! сперва все включить
	#   а потом фильтровать - может быть неэфф. но наверняка
	
	# собрать один файл
	includer.AssembleCompileUnit( fullName, ftarget )
	
	'''
	# удаляем комментарии
	print '\nRemoving commints...'
	inc.purgeFromComments( ftarget )
	
	# пропускаем через макросы - если внутри есть дефайны, то отфильтруем потом
	print '\nRemoving macroses...'
	run( ftarget )
	'''
	# пропускаем через definer ! один раз но весь исходник! и все готово, 
	print '\nPurge from ifdefs...'
	dpurger.ConditionCompile( ftarget ) 
	# В итоге чистый файл - чистый код, котовый к графическом анализу
