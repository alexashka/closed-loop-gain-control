#-*- coding: utf-8 -*-
""" _graph_former

"""

# App
from _graph_classes import OneGrPyGr
from _graph_classes import OneGrPyDot
import _labels_find_engine 
from _label_purgers import purge_bypass_and_return_labels

_graph_instance = OneGrPyDot()  # ����� ��� ������ � ������
def get_call_graph(code_lines):
    """ ����� ����� ����� - ������� (_xxx:)
        ����� �������� ��� ����, ���� ������� ����� ������� ��� - �.�. �����
          ����� !��� �����. ��� ����� ��������� ����������� ��������?
        �� ���� �� ������ ������ ���������, �� ��� ��
    """
    headers, positions = _labels_find_engine.find_array_all_labels(code_lines)
    pureCodeStr = '\r\n'.join(code_lines)

    # ��������� ������� ����
    _graph_instance.addMainNodes(headers)
    
    # ������������ ������� ����� �� ������ 
    #   _MainL1 !_L1 _L2 ... _LN! _MainL2 _L1...
    j = 0 # ������ �������� � ������������
    
    headersNum = len(headers)
    axisHeaders = range(headersNum)
    for k in axisHeaders:    # �� ����� �����
        # ���� ������������� ������� �� ��������
        #   ��� ����� �� ������� -> raw labels
        [resStr, j] = _labels_find_engine.bypassAndRetFinder(pureCodeStr[positions[k]:positions[k+1]], j)

        # ������������ ���������� ������
        purgeLocalLabelList = list('')
        i = 0
        for at in resStr:
            purgeLocalLabelList.append(purge_bypass_and_return_labels(at))
            i += 1

        # ��������������� ����� �������, ������ ��������� � ����� ����
        if k+1 != headersNum:
            retNodeConnect(purgeLocalLabelList, headers[k], headers[k+1], headers)
        else : 
            retNodeConnect(purgeLocalLabelList, headers[k], 'NoNext', headers)

    return _graph_instance


def purgeAvailableNodes(availableNodes, headers):
    purgedAvailableNodes = list('')
    for item in availableNodes:
        # !! ����� ������ �������� �� ret!! ����� ret �������� ������� ����. ������
        noContRet = not strContSubStrItTrue(item, 'ret') 
        noContXYZ = not strContSubStrItTrue(item, 'xyz') 
        noContZXY = not strContSubStrItTrue(item, 'zxy') 
        externCall = findExternLink(headers, item)
        """ �������� ���������� �������� ����� �������� ������������� ������ """

        if noContRet and noContXYZ and noContZXY and externCall:
            purgedAvailableNodes.append(item)

    # ����������, ��� ��������
    return purgedAvailableNodes


def findExternLink(headers, localsMinusOne):
    for i in headers:
        if i == localsMinusOne:
            return False
    return True


""" 
  ������� ���������� ����� 
����� ����� ����� �������� � ����� ���
"""
def retNodeConnect(locals, header, header_next, headers):
    # ��������� ��� ���� � ��������� �� ���������� � �������� �����
    _graph_instance.addSecondNodes(locals, headers)

    # ��������� 
    _jump_true_branch(header, header_next, headers, locals)

def jumpFalseBr(header, header_next, headers, numItemsAxis,locals):
    """ ������� ����� �������� ������� �� ���� """
    for k in numItemsAxis:  
        # ��������� ��������� ����
        _graph_instance.addEdge( header, locals[k]) 
        # ������
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
        # ��������� �����
        if not strContSubStrItTrue(saveNode, 'zxy'):
            _graph_instance.addEdge(saveNode, locals[k])

        # ��������� ����� ��� ��������
        if strContSubStrItTrue(locals[k], 'xyz'):
            # ��������� ��������� ����
            saveNode = locals[k]

        # ��������� ����������
        if strContSubStrItTrue(locals[k], 'zxy'):
            _graph_instance.addEdge(locals[k], locals[k+1])
            saveNode = locals[k]

    # ��������� � ����������� �������
    if not strContSubStrItTrue(saveNode, 'zxy'):
        _graph_instance.addEdge(saveNode, header_next) 