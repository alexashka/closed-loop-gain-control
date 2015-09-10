#-*- coding: utf-8 -*-
import unittest
import ModelADDAC as adda
import api_convertors.type_conv as tc

''' Просто заглушка '''
def printRpt( value, valueDisplacemented, valueScaled, valueCode, Kda ):
	#print '\nvalueDisplacemented : '+str(valueDisplacemented)
	pass
	
''' Класс тестов '''
class TestCaseModelADDAC(unittest.TestCase):
	_valueDict = { 'value' : 0, 'zeroDisplacement' : 0, 'converter' : 0, 
		'scale' : 0, 'capacity' : 0, 'Vmax' : 0 }
		
	def setUp
	
	''' АЦП '''
	def testADC( self ):
		self._valueDict[ 'value' ] = 2.5
		self._valueDict['displacement'] = 0
		self._valueDict['converter' ] = 1
		self._valueDict['scale'] = 1
		self._valueDict['capacity'] = 8
		self._valueDict['Vmax'] = 5.0	# V
		code, Kda = adda.modelADC( self._valueDict, printRpt, adda.calcZeroDisplacmentY )
		
		# Проерка цифрового кода 8 бит!!, но разрядность может быть и больше0
		self.assertEqual( tc.byte2strhex( code ), '0x80' )
		
		# проверка коэфф. передачи
		#self.assertEqual( Kda, 51.2 )	#? как сравнивать доубле! просто выражение посчитать
	
	''' Проверка расчета по току, со смещением '''
	def testCurrADCZeroX( self ):
		# Constants and coeff.
		R1 = 5.11
		R2 = 10.0
		Splitter = R2/(R1+R2)

		Vmax = 5000.0 	#mV
		capacity = 10

		Kiu = 188.0		# mV/A
		I = 10	# A
		dI = -1.0	# A  положение нуля на Х
		
		# проверяем
		self._valueDict[ 'value' ] = I
		self._valueDict['displacement'] = dI
		self._valueDict['converter' ] = Kiu
		self._valueDict['scale'] = Splitter
		self._valueDict['capacity'] = capacity
		self._valueDict['Vmax'] = Vmax 
		code, Kda = adda.modelADC( self._valueDict, printRpt, adda.calcZeroDisplacmentX )

		# Проверка кода числ
		self.assertEqual( tc.byte4strhex( code ), '0x00E5' )
	
	''' Проверка расчета по току, без смещения '''
	def testCurrADCZeroXZ0( self ):
		# Constants and coeff.
		R1 = 5.11
		R2 = 10.0
		Splitter = R2/(R1+R2)

		Vmax = 5000.0 	#mV
		capacity = 10

		Kiu = 188.0		# mV/A
		dI = 0.0	# A
		I = 10	# A
		
		# проверяем
		self._valueDict[ 'value' ] = I
		self._valueDict['displacement'] = dI
		self._valueDict['converter' ] = Kiu
		self._valueDict['scale'] = Splitter
		self._valueDict['capacity'] = capacity
		self._valueDict['Vmax'] = Vmax 
		
		code, Kda = adda.modelADC( self._valueDict, printRpt, adda.calcZeroDisplacmentX )
		
		# Проверка кода числ
		self.assertEqual( tc.byte4strhex( code ), '0x00FE' )
		
	''' Проверка расчета по току, со смещением по напряжению'''
	def testCurrADCZeroY( self ):
		# Constants and coeff.
		R1 = 5.11
		R2 = 10.0
		Splitter = R2/(R1+R2)

		Vmax = 5000.0 	#mV
		capacity = 10

		Kiu = 188.0		# mV/A
		dU = 500.0	# mV
		I = 10	# A
		
		# проверяем
		self._valueDict[ 'value' ] = I
		self._valueDict['displacement'] = dU
		self._valueDict['converter' ] = Kiu
		self._valueDict['scale'] = Splitter
		self._valueDict['capacity'] = capacity
		self._valueDict['Vmax'] = Vmax 
		code, Kda = adda.modelADC( self._valueDict, printRpt, adda.calcZeroDisplacmentY )

		# Проверка кода числ
		self.assertEqual( tc.byte4strhex( code ), '0x0142' )
		
	''' Проверка расчета по току, со смещением '''
	def testCurrADCZeroYZ0( self ):
		# Constants and coeff.
		R1 = 5.11		# Om
		R2 = 10.0		# Om
		Splitter = R2/(R1+R2)
		Vmax = 5000.0 	# mV
		capacity = 10	# bits
		Kiu = 188.0		# mV/A
		dU = 0.0		# mV
		I = 10			# A
		
		# проверяем
		self._valueDict[ 'value' ] = I
		self._valueDict['displacement'] = dU
		self._valueDict['converter' ] = Kiu
		self._valueDict['scale'] = Splitter
		self._valueDict['capacity'] = capacity
		self._valueDict['Vmax'] = Vmax 
		code, Kda = adda.modelADC( self._valueDict, printRpt, adda.calcZeroDisplacmentY )

		# Проверка кода числ
		self.assertEqual( tc.byte4strhex( code ), '0x00FE' )
		
		# Проверка множителя
		
	''' Проверка ЦАП '''
	def testDAC( self ):
		# Constants and coeff.
		R1 = 5.11		# Om
		R2 = 10.0		# Om
		Splitter = R2/(R1+R2)
		Vmax = 5000.0 	# mV
		capacity = 10	# bits
		Kiu = 188.0		# mV/A
		Udig = 322		# V ue
		
		# проверяем
		self._valueDict[ 'value' ] = 0
		self._valueDict['displacement'] = 500
		self._valueDict['converter' ] = Kiu
		self._valueDict['scale'] = Splitter
		self._valueDict['capacity'] = capacity
		self._valueDict['Vmax'] = Vmax 
		
		# сперва получаем поправочный код
		code, Kda = adda.modelADC( self._valueDict, printRpt, adda.calcZeroDisplacmentY )
		
		# Запускаем
		self._valueDict[ 'value' ] = Udig-code
		self._valueDict['displacement'] = None
		analog = adda.modelDAC( self._valueDict, printRpt )
		
		# проверка значения! float трудно сравнить, пока округляем
		self.assertEqual( int( analog ), 10 )

	
# Run tests
if __name__ == '__main__':
	suite = unittest.TestLoader().loadTestsFromTestCase( TestCaseModelADDAC )
	unittest.TextTestRunner(verbosity=2).run(suite)