#-*- coding: utf-8 -*-

# System library
import unittest

# Other
import convertors_simple_data_types.float32_convertors as f32conv

# App
import models.shift_correction_model as shift_calc


class TestSequenceFunctions(unittest.TestCase):
    
    def test_simple_usige(self):
        kCorrectingMult = -4.9*5*1e-3    # Коэффициент перевода величины, V/oC
        T = 10
        
        print 'kCorrectingMult = ', kCorrectingMult
        print 'T = ', T
        
        src_shift_code = '0111'    # Исходное значение EEPROM
        shift_calc.calc_for_ukv(
            kCorrectingMult, T, src_shift_code)
        
if __name__ == '__main__':
    unittest.main()