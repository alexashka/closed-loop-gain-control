#-*- coding: utf-8 -*-
""" file : import CallGrFinder

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

# Other
import uasio.os_io.io_wrapper as iow

# App
from _code_processors import delete_endlines_in_list
from _code_processors import delete_comments
from _code_processors import extract_code
from _graph_former import get_call_graph

def run(ifile, ofile):
    """ Запускае поиск для одной единицы компиляции
        Данные передаются в виде списков строк без переносов строки 
    """
    # Пропускаем через препроцессор
    # @todo: доделать препроцессор
    pass
    
    # Получаем содержимое единицы компиляции
    settings = {'name':  ifile, 'howOpen': 'r', 'coding': 'cp1251'}
    list_lines = iow.file2list(settings)
    
    # Удаляем все комментарии
    no_commented_code = delete_comments(list_lines)

    # Выделяем только код
    pure_code_list_lines = extract_code(delete_endlines_in_list(no_commented_code))
    settings = { 'name':  'tmp/pure_code.asm', 'howOpen': 'w', 'coding': 'utf_8' }
    iow.list2file(settings, pure_code_list_lines)
    
    # Ищем граф вызовов для одной ед. компил.
    print 'finding graph in file ', ifile, '...'
    graph_instance = get_call_graph(pure_code_list_lines)

    # Рисуем картинку графа одной ед. компил.
    print 'plotting graph to file ', ofile, '...'
    graph_instance.write_graph(ofile)
    
    '''
    # ! это уже обработка !
    """ только для python-graph type' ''
    print 'finding...'
    root = "_v#v(HERE)_COMP_SETuw_wByteIn"
    availableNodes = _graph_instance.searchNodes(root)
    
    # Удаляем ненужные узлы
    purgedAvailableNodes = purgeAvailableNodes(availableNodes, headers)
    for item in purgedAvailableNodes:
        print item"""'''




