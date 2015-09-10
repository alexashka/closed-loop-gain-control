#-*- coding: utf-8 -*-
# core
# utils
from pyDbg.doColoredConsole import co
nprint = co.printN
wprint = co.printW
eprint = co.printE
def eprintValue( name, value ):
	eprint( name+' : '+str(value)+'\n')
def wprintValue( name, value ):
	wprint( name+' : '+str(value)+'\n')
def nprintValue( name, value ):
	nprint( name+' : '+str(value)+'\n')
	
import simpleDataTypesConvertors.Float32Convertors as f32cnv
import simpleDataTypesConvertors.IntTypeConvertors as tc

# Читаем конфигурация сенсора
import json

# Общая читалка
from sensors_uni import *
class SensorChannalVoltage(SensorChannalHall):
	def __init__(self, *args):
		SensorChannalHall.__init__( self, *args )
		
	def getSplitter( self ):
		R1 = self._splitter_params['R1']
		R2 = self._splitter_params['R2']
		R3 = self._splitter_params['R3']
		R4 = self._splitter_params['R4']

		# расчет коэффицниента передачи
		U0 = 1.0
		U2 = U0*R2/(R1+R2)
		U4 = U2*R4/(R4+R3)
		splitter = U4/U0
		return splitter
		
SensorChannal = SensorChannalHall	# Для измерителя

value2voltage = value2voltageHall	# кривая

# читае конфигурация сенсора
sensor_sets = get_sensor_cfg('U')

# Настройки прочитаны, можно разбирать их
metroChannal = SensorChannal( sensor_sets,'adc_metro','splitter_metro_parems', value2voltage )
thresholdChannal_max = SensorChannalHall( sensor_sets,'dac_threshes','splitter_threshold_parems_max', value2voltage )
thresholdChannal_min = SensorChannalHall( sensor_sets,'dac_threshes','splitter_threshold_parems_min', value2voltage )

# Run 
if __name__ == '__main__':
	lstForWrite = list('')
	sets = { 'name': 'voltage_header.h', 'howOpen': 'w', 'coding': 'cp1251'}
	
	# смещение нуля при обратоной обработке
	U = 0
	Udig_zero, capacity = calcCoeffTransf( U, metroChannal ) 
	# Записать в файл шаблон
	lstForWrite = list('')
	lstForWrite.append('#define ZERO_VOLTAGE_CORRECT '+Udig_zero+"\t;"+str(U)+" V; bits - "+capacity )
	
	# Порог
	U_nom = 48.0
	U_min = U_nom-U_nom/100*15
	U_max = U_nom+U_nom/100*13
	print U_min, U_max
	U_min_d, capacity = calcCoeffTransf( U_min, thresholdChannal_min ) 
	U_max_d, capacity = calcCoeffTransf( U_max, thresholdChannal_max ) 
	print U_min_d, U_max_d
	lstForWrite.append('\t#define VOLTAGE_THR_MIN '+U_min_d+"\t; -15% V  bits - "+capacity)
	lstForWrite.append('\t#define VOLTAGE_THR_MAX '+U_max_d+"\t; +13% V  bits - "+capacity)
			
	# Находим коэффициент пересчета
	U = 48.0
	Udig_value, capacity = calcCoeffTransf( U, metroChannal ) 
	lstForWrite.append('#define TEST_MOCK_VOLTAGE '+Udig_value+"\t;"+str(U)+" V; bits - "+capacity )
	
	realCodeVoltage = tc.hex_word_to_uint(Udig_value)-tc.hex_word_to_uint(Udig_zero)
	k = U/realCodeVoltage
	wprintValue('K code to V :', k)
	
	lstForWrite.append(';const double TA_VOLTAGE_MUL = '+str(k)+';')

	# Закрываем запись
	iow.list2file( sets=sets, lst=lstForWrite )

