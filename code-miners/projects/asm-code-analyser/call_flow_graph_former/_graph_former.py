#-*- coding: utf-8 -*-
""" _graph_former

"""

# App
from _graph_classes import OneGrPyGr
from _graph_classes import OneGrPyDot
import _labels_find_engine 
from _label_purgers import purge_bypass_and_return_labels

_graph_instance = OneGrPyDot()  # Класс для работы с графом
def get_call_graph(code_lines):
    """ Поиск карты меток - главной (_xxx:)
        Нужно подумать как быть, если отличий между метками нет - т.е. нужно
          найти !все метки. Как будет выглядеть последующий алгоритм?
        По идее не должно ничего изменится, но все же
    """
    headers, positions = _labels_find_engine.find_array_all_labels(code_lines)
    pureCodeStr = '\r\n'.join(code_lines)

    # Добавляем главные узлы
    _graph_instance.addMainNodes(headers)
    
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

    return _graph_instance


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
    _graph_instance.addSecondNodes(locals, headers)

    # Соединяем 
    _jump_true_branch(header, header_next, headers, locals)

def jumpFalseBr(header, header_next, headers, numItemsAxis,locals):
    """ Обходов между главными метками не было """
    for k in numItemsAxis:  
        # сохраняем последний узел
        _graph_instance.addEdge( header, locals[k]) 
        # Прочие
        outLayer = locals[k].find('zxy') != -1
        if outLayer:
            _graph_instance.addEdge(locals[k], locals[k+1])

def strContSubStrItTrue(string, substr):
    """ Deprecated.
        @todo: replace standart test include
    """
    if string.find(substr) != -1:
        return True
    else:
        return False

def _jump_true_branch(header, header_next, headers, locals):
    numItems = len(locals)
    numItemsAxis = range(numItems)
    dummyRetNum = 0
    dummyNodeName = ''
    saveNode = header
    for k in numItemsAxis:  
        # добавляем ребро
        if not strContSubStrItTrue(saveNode, 'zxy'):
            _graph_instance.addEdge(saveNode, locals[k])

        # сохраняем метку для привязки
        if strContSubStrItTrue(locals[k], 'xyz'):
            # сохраняем последний узел
            saveNode = locals[k]

        # оконечные соединения
        if strContSubStrItTrue(locals[k], 'zxy'):
            _graph_instance.addEdge(locals[k], locals[k+1])
            saveNode = locals[k]

    # Соединяем с последующей главной
    if not strContSubStrItTrue(saveNode, 'zxy'):
        _graph_instance.addEdge(saveNode, header_next) 