#!/usr/bin/python
#-*- coding: utf-8 -*-
import ui
import api_convertors.float32_conv as f32_conv
import api_convertors.type_conv as tc
import math

def hexWordToInt( hexWord ):
	sum = 0
	for pos in range( 0, len( hexWord ) ):
		oneIt =  tc.hex2int( hexWord[ pos ] )*math.pow( 16, len( hexWord )-pos-1 )
		sum += oneIt
	return sum
	
def intWordToHex( intWord ):
	sum = ''

# Расчет для УКВ ЧМ
T = 26	# Температура 8 бит бит/градус
msg = 'T oC :'
ui.plot(msg, T)

# температурный коэффициент
mult = 4.9/1000*5*4000.0/4.6	# V/oC положительная!
msg = 'mult V/oC :'
ui.plot(msg, mult)

# поправка
delta_U = mult*T	# deltaU V
msg = 'deltaU, ue LH:'
ui.plotWord(msg, delta_U)
msg = 'deltaU ue :'
ui.plot(msg, delta_U)

# конкретное значение смещения
hexWord = '0F99'
Usm_src = hexWordToInt( hexWord ) 
Usm_src -= delta_U	# вычитание вот здесь!
msg = 'Usm src, ue LH:'
ui.plotWord(msg, Usm_src)
msg = 'Usm src, ue float32:'
ui.plot(msg, Usm_src)
ui.rout()

# проверка коэффициентов
I_one = 2.9
ui.plot(msg, I_one)
# перобразование смещения
'''
HL : abstrU_sm
  max =
  4000 -> 4.6 V
  AA    -> x.x V
  x.x = AA*4.6/4000.0 = AA * 0.00115 = AA*Corr
  1/Corr * sum
'''
'''
# Исходное смещение
Usm_src = 4095.0
msg = 'Usm src, ue LH:'
ui.plotWord(msg, Usm_src)
msg = 'Usm src, ue float32:'
ui.plot(msg, Usm_src)
'''
'''
# Корректирующий множитель
Corr = 4.6/4000.0
msg = 'Corr. mul :'
ui.plot(msg, Corr)

# Корректированное смещение
U_sm = Usm_src*Corr
msg = 'Usm src, V :'
ui.plot(msg, U_sm)

# summ
summa = delta_U+U_sm
msg = 'Sum, V:'
ui.plot(msg, summa)

# Обратное преобразование
inv_Corr = 1/Corr
msg = 'Corr_inv. mul :'
ui.plot(msg, inv_Corr)

# сумма готовая к округлению
summa = summa*inv_Corr
msg = 'Sum, ue LH:'
ui.plotWord(msg, int(summa))
msg = 'Sum, ue float32:'
ui.plot(msg, summa)
ui.rout() # перевод в файле на новую строку, чтобы запуски не сливались, файл открывается на добавление
'''
print f32_conv.hexMCHIPfloat32toFloat("80 33 D7 0A")
#f32_conv.hexMCHIPfloat32toFloat("81 0A EC 08")