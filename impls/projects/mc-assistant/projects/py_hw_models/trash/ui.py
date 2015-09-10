#!/usr/bin/python
#-*- coding: utf-8 -*-
# import ui
import api_convertors.float32_conv as f32_conv
import api_os_wrappers.os_wrapper as os_w

''' '''
def printFormatter(string):
	string = '0x'+string
	return string[:-1].replace(' ',', 0x')

''' 
	Метод отображения результатов и плагины для вывода на комм. строку
	
	notes. : Низший модуль передает полностью всю информацию. Потом можно разбить
	  регулярными выражениями

	rem. : функции обратного вызова можно собрать в кортеж и внизу управлять 
	  действиями по имени
'''
def plotPlugin(string):	# пустой
	None
def plotPluginFull(string):
	print string
# подборка плагинов
pluginList = {"None" : plotPlugin, 'Full':plotPluginFull}
def plot(msg, value):
	print msg+" "+str(value)
	ieee, mchip = f32_conv.run(value, pluginList["Full"])
	mchip = printFormatter(mchip)
	os_w.printStrToFile(msg+' '+mchip+'\n')

''' msg : Lhl Hhl'''
def plotWord(msg, word):
	string = f32_conv.byte2hex(int(word)%256) 	# L
	string += ' '+ f32_conv.byte2hex(int(word)/256)	# H
	print msg+' '+string
	os_w.printStrToFile(msg+' '+string+'\n')
def rout():
	os_w.printStrToFile('\n')
''' ''' ''' '''