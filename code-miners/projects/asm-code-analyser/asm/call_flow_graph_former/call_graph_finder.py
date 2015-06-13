#-*- coding: utf-8 -*-
""" 
  file : import CallGrFinder

  abs. :
  
  target : 
    1. Межмодульный анализатор(из модуля форм. ужатые графы)
        сделать вид для модели в виде кода - из кода качать разноплановую
        информацию
        интерфейсная функция - по ней определяем кого вызывает.
        Главное граф составить, а потом можно двигаться произвольно
        Можно пользоваться поисковыми алгоритмами
    2. Внутримодульный анализатор. Проверка на соответствие(private and public parts)
  
  steps :
  1. хотя все и макаронно, но retxxx есть при любом расклада
  2. пока ищем в одном файле и одну функцию
    выделение блока кода(только кода)

; формат входных данных
_метка ; вплотную к краю строки и с нижнего подчеркивания
    код
_метка
  код
  
_цикл_Ж - поиск циклов

если при поиске не утыкается в интерфейс, то смысл то?
    поток комманд проходит сразу по ней
    
запись в файл идет странновато - появляются похожие узлы

Цель :
  one Module.IFun -> allMod.IFun - вызовы всех модулей
  registry.inc - только суммарно по мудулям
  
add feat. : 
    Подкраска интерфейсов модуля
    хорошо бы подсветить основной путь
    Случайные имена вставляемых узлов, важно для итоговой фильтрации
    jpg -> pdf для возм. копирования сод. узлов
        
  
  Ref. targets :
    удаление im. xx from * 
    Lib стал сложен
    глобальные переменные
    изолировать паттерны поиска и константы поиска
    складировать неискльзуемый код. не выкидывать, просто кидать в один файл
    ускорения поисков разных строк (по крайней мере их сокр. их числа)
"""
# std
import re

# add libs
from _graph_classes import OneGrPyGr
from _graph_classes import OneGrPyDot

# own
import uasio.os_io.io_wrapper as iow
import _labels_find_engine 
from _label_purgers import purge_bypass_and_return_labels

""" Класс для работы с графом """
_gr = OneGrPyDot()

# const
_PATTERN_CODE = 'code.*?end'
_JOIN_CODE = '@@@'
_COMMENTS_PATTERN = ';.*?\r\n'

def _delete_endlines_in_list(list_lines):
    result = list('')
    for at in list_lines:
        at_result = at
        at_result = at_result.replace('\r','')
        at_result = at_result.replace('\n','')
        result.append(at_result)
    return result
 
def _delete_comments(list_lines):
    """ Есть ограничение по платформе - конец строки = \r\n"""
    result = list('')
    for at in list_lines:
        at_result = re.sub(_COMMENTS_PATTERN, '', at)
        if at_result:
            result.append(at_result)
    return result

def _extract_code(list_lines):
    """ Предполагается что секций кода одна """
    result = list('')
    string = _JOIN_CODE.join(list_lines)

    search_result = re.findall(_PATTERN_CODE, string, re.M | re.S | re.X)
    # только одна секция кода
    if len(search_result) == 1:
        result = search_result[0].replace(_JOIN_CODE, '\r\n')
        result = result.split('\r\n')
        result = _delete_endlines_in_list(result)
    else:
        result = None
    # удаляем code-end обрамление
    return result[1:-1]

def _find_call_graph(code_lines):
    """ Поиск карты меток - главной (_xxx:)
        Нужно подумать как быть, если отличий между метками нет - т.е. нужно
          найти !все метки. Как будет выглядеть последующий алгоритм?
        По идее не должно ничего изменится, но все же
    """
    headers, positions = _labels_find_engine.find_array_all_labels(code_lines)
    print headers, positions
    pureCodeStr = '\r\n'.join(code_lines)


    # Добавляем главные узлы
    _gr.addMainNodes(headers)
    
    # Обрабатываем главные метку за меткой 
    #   _MainL1 !_L1 _L2 ... _LN! _MainL2 _L1...
    j = 0 # номера ретурнов и ответвителей
    
    headersNum = len(headers)
    axisHeaders = range(headersNum)
    for k in axisHeaders:    # по карте меток
        # Ищем распределение вызовов по шаблонам
        #   все метки по запросу -> raw labels
        [resStr, j] = _labels_find_engine.bypassAndRetFinder(pureCodeStr[positions[k]:positions[k+1]], j)

        # обрабатываем результаты поиска
        purgeLocalLabelList = list('')
        i = 0
        for at in resStr:
            purgeLocalLabelList.append(purge_bypass_and_return_labels(at))
            i += 1

        # Вспомогательные метки найдены, теперь соединяем в общую сеть
        if k+1 != headersNum:
            retNodeConnect(purgeLocalLabelList, headers[k], headers[k+1], headers)
        else : 
            retNodeConnect(purgeLocalLabelList, headers[k], 'NoNext', headers)

    # нужны главные метки для присков
    return headers

""" """
def purgeAvailableNodes(availableNodes, headers):
    purgedAvailableNodes = list('')
    for item in availableNodes:
        # !! место тонкое особенно по ret!! лучше ret заменить длинным случ. ключом
        noContRet = not strContSubStrItTrue(item, 'ret') 
        noContXYZ = not strContSubStrItTrue(item, 'xyz') 
        noContZXY = not strContSubStrItTrue(item, 'zxy') 
        externCall = findExternLink(headers, item)
        """ Проверка нахождения конеченй точки перехода интерфейсному методу """

        if noContRet and noContXYZ and noContZXY and externCall:
            purgedAvailableNodes.append(item)

    # Возвращаем, что накопили
    return purgedAvailableNodes

""" """
def findExternLink(headers, localsMinusOne):
    for i in headers:
        if i == localsMinusOne:
            return False
    return True


""" 
  Функции соединения узлов 
знаем какие метки обходные а какие нет
"""
def retNodeConnect(locals, header, header_next, headers):
    # Добавляем все узлы и проверяем на входимость в диапазон меток
    _gr.addSecondNodes(locals, headers)

    # Соединяем 
    jumpTrueBr(header, header_next, headers, locals)

""" Обходов между главными метками не было """
def jumpFalseBr(header, header_next, headers, numItemsAxis,locals):
    for k in numItemsAxis:  
        # сохраняем последний узел
        _gr.addEdge( header, locals[k]) 
        # Прочие
        outLayer = locals[k].find('zxy') != -1
        if outLayer:
            _gr.addEdge(locals[k], locals[k+1])

def strContSubStrItTrue(string, substr):
    if string.find(substr) != -1:
        return True
    else:
        return False

def jumpTrueBr(header, header_next, headers, locals):
    numItems = len(locals)
    numItemsAxis = range(numItems)
    dummyRetNum = 0
    dummyNodeName = ''
    saveNode = header
    for k in numItemsAxis:  
        # добавляем ребро
        if not strContSubStrItTrue(saveNode, 'zxy'):
            _gr.addEdge(saveNode, locals[k])

        # сохраняем метку для привязки
        if strContSubStrItTrue(locals[k], 'xyz'):
            # сохраняем последний узел
            saveNode = locals[k]

        # оконечные соединения
        if strContSubStrItTrue(locals[k], 'zxy'):
            _gr.addEdge(locals[k], locals[k+1])
            saveNode = locals[k]

    # Соединяем с последующей главной
    if not strContSubStrItTrue(saveNode, 'zxy'):
        _gr.addEdge(saveNode, header_next) 

def run(ifile, ofile):
    """ Запускае поиск для одной единицы компиляции
        Данные передаются в виде списков строк без переносов строки 
    """
    # Получаем содержимое файла
    settings = {'name':  ifile, 'howOpen': 'r', 'coding': 'cp1251'}
    list_lines = iow.file2list(settings)

    # Удаляем комментарии - отдельные строки и знаки после end\t\n и прочие
    #   чтобы можно было применить регулярное выражение
    no_commented_code = _delete_comments(list_lines)
   
    settings = { 'name':  'tmp/pure_code.asm', 'howOpen': 'w', 'coding': 'utf_8' }

    # Выделяем только код
    pure_code_list_lines = _extract_code(_delete_endlines_in_list(no_commented_code))
    iow.list2file(settings, pure_code_list_lines)
    
    # Ищем граф вызовов для одного файла
    print 'finding in file ', ifile, '...'
    headers = _find_call_graph(pure_code_list_lines)
    

    # Рисуем картинку графа
    print 'plotting to file ', ofile, '...'
    _gr.write_graph(ofile)
    
    '''
    # ! это уже обработка !
    """ только для python-graph type' ''
    print 'finding...'
    root = "_v#v(HERE)_COMP_SETuw_wByteIn"
    availableNodes = _gr.searchNodes(root)
    
    # Удаляем ненужные узлы
    purgedAvailableNodes = purgeAvailableNodes(availableNodes, headers)
    for item in purgedAvailableNodes:
        print item"""'''




