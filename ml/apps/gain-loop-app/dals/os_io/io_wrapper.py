#-*- coding: utf-8 -*-
""" 
    tested :
        python2.7
        jython2.5
            читает и пишет правильно, но тип текущей локали определят
                не правильно, поэтому выводит на консоль неправильно
    connect : import usaio.io_wrapper
"""
import codecs

""" 
    Класс для работы с файлами на компьютере
"""
class FilePC():
    _fhandle = None
    
    """ Инициализация дискриптора. Передача по ссылке! """
    def __init__(self, fhandle):

        self._fhandle = fhandle
    def __del__(self):
        self._fhandle.close()
    
    def toList(self):
        try:
            list_lines = self._fhandle.readlines() 
             
            # Удалить переводы строк
            result = []
            for at in list_lines:
                result.append(at.replace('\r', '').replace('\n', ''))
            return result
        
        except UnicodeDecodeError, e:
            print 'UnicodeDecodeError', e
            return None
            
        except IOError, e:
            print 'IOError : ', e
            return None
    
    def write(self, str):
        try:
            try : 
                self._fhandle.write(str)
            except UnicodeEncodeError, e:
                print 'UnicodeEncodingError:', e
        except IOError, e:
            print 'IOError : ', e
        
""" Выдает файловые объекты """
def FabricOpenTestRead(settings):
    fname = settings['name']
    howOpen = settings['howOpen']
    xcoding = settings['coding']
    try:
        # создаем реальный файловый объект и передаем его обертке
        f = codecs.open(fname, howOpen, encoding=xcoding)
        wrapper = FilePC(f)

        return wrapper
    
    # Скорее всего путь не тот
    except IOError, e:
        print 'IOError : ', e
        return None

# распиновка
FabricOpen = FabricOpenTestRead

""" 
    Запись в файл ну формате 1251 c windews end line(\r\n)
    на вхоже список строк в unicode endline \n
"""

def writeFileFromList(targetFname, listLines):
    sum = ''
    for at in listLines:
        sum+=at[:-1]+'\r\n'
    import codecs
    f = codecs.open(targetFname, 'wb', encoding='cp1251')
    f.write(sum)
    f.close
    
def get_utf8_template():
    return {'name':  'fname', 'howOpen': 'r', 'coding': 'utf_8'}

def file2list_int(sets):
    readed_list = file2list(sets)
    result = []
    try:
        for at in readed_list:
            result.append(int(at))
    except ValueError as e:
        print 'ValueError', e
        result = None
        
    return result
        
def file2list(sets):
    """ """
    file = FabricOpen(sets)
    listLines = None
    if file != None:
        # читаем все 
        listLines = file.toList()
        #print listLines
        #if listLines != None:
            #for at in listLines:
                #print at
                #.encode('cp866')    # for jython
    return listLines

def list2file(sets, lst):
    file = FabricOpen(sets)
    if file != None and lst != None:
        file.write('\r\n'.join(lst))
    else :
        print "list2file error occure"

def app_str(sets, string):
    file = FabricOpen(sets)
    if file != None:
        file.write(string+'\r\n')
    else :
        print "app_str error occure"
    
