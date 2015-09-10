#-*- coding: utf-8 -*-
import math
import json

# dev
import uasio.os_io.io_wrapper as iow
import convertors_simple_data_types.xintyy_type_convertors as tc
kSensorCfgMap_ = 'sensors_cfg_names.json'
kSensorCfgMap = 'sensors_cfg_names.json'

# Читаем конфигурация сенсора
def get_sensors_cfg():
    """ Deprecated! """
    sets = { 'name': kSensorCfgMap_, 'howOpen': 'r', 'coding': 'cp1251'}
    readedList = iow.file2list(sets)
    sensor_sets = json.loads(' '.join(readedList))
    print json.dumps(sensor_sets, sort_keys=True, indent=2)
    return sensor_sets
    
def get_sensor_cfg(name):
    """ Deprecated! """
    # читае общую конфигурацию
    
    uni_sensor_sets = get_sensors_cfg()

    # читаем конфигурацию для тока
    sets['name'] = uni_sensor_sets[name]
    sensorSettings = iow.file2list(sets)

    # here we are converting python object to json string
    sensor_sets = json.loads(' '.join(sensorSettings))
    print json.dumps(sensor_sets, sort_keys=True, indent=2)
    return sensor_sets
    
def _json_in_file_to_obj(fname):
    """ Преобразует json-структуру, содержащуюся в файле в python-объект. 
    
    Args: Имя исходного файла.
    
    Returns: 
    
    TODO(zaqwes): Обработка ошибок опущена.
    """
    
    sets = {'name': fname, 'howOpen': 'r', 'coding': 'cp1251'}
    
    readed_list = iow.file2list(sets)
    py_object = json.loads(' '.join(readed_list))
    return py_object
    
def get_sensor_cfg_new(name, global_cfg_file):
    """ Читает общую конфигурацию сенсора. 
    Имя конфигурации задано в глобальной конфигурации.
    """
    uni_sensor_sets = _json_in_file_to_obj(global_cfg_file)
    
    sets = {'name': uni_sensor_sets[name], 
            'howOpen': 'r', 
            'coding': 'cp1251'}
    sensor_settings = iow.file2list(sets)

    sensor_sets = json.loads(' '.join(sensor_settings))
    #print json.dumps(sensor_sets, sort_keys=True, indent=2)
    return sensor_sets
    
class SensorChannal(object):
    """ Базовый класс, описывающий канал сенсора.
    
    Переводит значение некой физической величины в некий код код. 
    Сперва величина переводится в вольты (пропускается через кривую преобразования).
    Затем домножается на коэффциент передачи канала сенсора.
    И в итоге оцифровывается и возможно кодируется.
    
    Может использоваться как в канале измерения, так и в каналах сравнения.
    
    Только для преобразования в код.
    
    TODO(zaqwes): Преобразование кода в величину.
    
    Attributes:
    """
    _sensor_settings_map = None
    
    def init_channal(self, sensor_settings_map):
        """ Загружает настройки канала. 
        Warinig: Необходимо вызвать до начала использования объекта.
        """
        self._sensor_settings_map = sensor_settings_map
    
    def phy_value_to_voltage(self, value):
        """ Переводит измеряемую величину в вольты.        
        Чисто виртуальная функция.
        """
        return 0
        
    def transmit_voltage(self, value_in_volts):
        """ Доводит напряжение до АЦП. 
        По сути домножает на коэффициент передачи напряжения по цепи сенсора.
        Чисто виртуальная функция.
        """
        return 0
        
    def voltage_to_digital(self, value_in_volts):
        """ Оцифровывает напряжение, прищедшее на АЦП, и возможно кодирует его.
        Чисто виртуальная функция.
        """
        return 0

class HallCurrenSensor(SensorChannal):
    """ """
    pass
    
class SensorChannalHall():
    _addac = None
    _splitter_params = None
    _sensor_curve_cb = None
    _sensor_curve_sets = None
    def __init__(self, sensor_sets, addacName, hxName, curve_cb):
        # Параметры делителя напряжения
        self._splitter_params = sensor_sets[hxName]

        # Параметры ADDAC
        self._addac = sensor_sets[addacName]
        
        # кривая сенсора
        self._sensor_curve_cb = curve_cb
        self._sensor_curve_sets = sensor_sets['sensor_curve_params']

    def get_splitter(self):
        R1 = self._splitter_params['R1']
        R2 = self._splitter_params['R2']
        splitter = R2/(R1+R2)
        return splitter
        
    def get_ad_coeff(self):
        dVmax = self._addac['dVmax']    # mV сдвиг ЦАП
        VmaxIdeal = self._addac['VmaxIdeal']

        capacity = self._addac['capacity']
        Vmax = VmaxIdeal-dVmax     # mV - это максимальное значение ЦАП - площадка при выс. сигн.
        resolution = math.pow(2, capacity)

        to_digital = resolution/Vmax
        return to_digital
    
    def get_capacity(self):
        return self._addac['capacity']
        
    def get_da_coeff(self):
        return 1/self.get_ad_coeff()
        
    def sensor_curve(self, value):
        return self._sensor_curve_cb(value, self._sensor_curve_sets)
        
def value_to_voltage_hall(value, curve_params):
    """ Параметры входной кривой. Датчик Холла """
    Kiu = curve_params['Kiu']  # mV/A
    dU = curve_params['dU']  # mV
    U = value * Kiu + dU
    return U
    

def calc_coeff_transform(value, channal):
    """ Ток в код и обратно I, A код не переведен в цифру - предст. с плав. точкой 
        Sample usige:
         Uo = R16*Uerr/(R16+R10) = 10*500/(10+5.11) = 330.907 mV
         2^10 - 5000 mV
         x - Uo ; x = 67.76 ue = 68 ue = 0x44 ue
         
    Args:
    
    Returns:
    
    Raises:
    
    """
    # Получаем описание канала и кривой сенсора
    multer = channal.get_splitter()
    to_digital = channal.get_ad_coeff()
    
    # Обработка
    U = channal.sensor_curve(value)
    
    # Умножаем на коэфф. перед. аналоговой цепи и "оцифровываем"
    Uadc = U * multer * to_digital
    Udig = int(Uadc)
    return tc.byte4strhex(Udig), str(channal.get_capacity())    