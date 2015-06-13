#-*- coding: utf-8 -*-
""" 
    file : import LabelPurgers

    abs. : пакет содержит функции обработки излов графа
    Набор функция очистки узла
"""

def purge_node(label_name):
    """ Очистка меток 
        Precond.: все комментакии удалены
    """
    result = label_name
    result = result.replace(':', '')
    result = result.replace(' ', '')
    result = result.replace('\t', '')
    return result

def purge_jamps_label(s):
    """ Очистка вспомогательных меток 
    !! нужно уметь определать закомменценные
    """
    # форматирование
    label = s.split()
    label[1] = label[1].replace('\t', '')
    label[1] = label[1].replace(':', '')
    sumLabel = label[1].split(';')
    return sumLabel[0]

""" берет комманду """
def purge_bypass_and_return_labels(node):
    # форматирование
    splitList = node.split(';')
    label = splitList[0].split()
    sumLabel = label[0].split()
    return sumLabel[0]
    
""" Пока берем только код операции """
def purge_line(line):
    resSplitting = line.split()
    if len(resSplitting) > 0:
        return resSplitting[0]
    else:
        return ""