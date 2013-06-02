#-*- coding: utf-8 -*-
""" Нужно получить все
    
    thinks : walk and regex
"""
import os
slash = '\\'
 

def _check_extension(string, listOfExtension, listOfIgnoreExtention):
    """ может быть ошибка, хотя маловероятна. Точка вероятность повышает """
    for k in listOfExtension:
        if '.'+k == string[-len(k)-1:].lower():
            return True
    return False

def find_files_down_tree_PC(head, listOfExtension, ignoreDictOfLists):
    """ Получить список файлов заданных типов с полными путями
        
        thinks : сделать бы фильтрацию
        
        ignoreList
            1. пути - папки
            2. расширения, которые похожи на разрешенные
            3. целые файлы (с путем(1 шт) и без(может быть много))
            4. регулярные выражения - подстроки
            
        troubles testing :
            разные типы данных - возвр. знач. и сообщение - но нужно 
                принимать из функции два значения
                
        Simple local host 
    """
    
    def onErrorWalkPC(err):
        """ Error handler """
        print err
        
        # TODO: сделать свой класс обработки ошибок
        raise OSError
    
    resultList = list('')
    msg = ''
    # получаем объект для обхода
    # Если корня нет исключение генерируется при доступе
    try:
        gettedList = os.walk(head, onerror = onErrorWalkPC)
        for root, dirs, files in gettedList:
            for name in files:
                if _check_extension(name, listOfExtension, ignoreDictOfLists[ 'Extentions' ]):
                    bResult = True
                    if ignoreDictOfLists['Dirs']:
                        for it in ignoreDictOfLists['Dirs']:
                            if it in root:
                                bResult = False
                        
                    if bResult:
                        resultList.append(root+slash+name)
    except OSError:
        msg = 'OSError on dir walk.'
        return None, msg

    # возвращаем что насобирали
    return resultList, msg    # может в питоне и нече, но вообеще-то...?
        # вобщем нужно подумать над обработкой ошибок

""" Mapping """
find_files_down_tree_ = find_files_down_tree_PC    # поиск по обычному компьютеру

""" How use it """
if __name__ == '__main__':
    head = 'tmp'
    listOfExtension = ['py']
    
    # Ignore
    listOfIgnoreExtention = [ 'pyc' ]
    listOfIgnoreDirectories = list('')
    ignoreDictOfLists = {}
    ignoreDictOfLists[ 'Extentions' ] = listOfIgnoreExtention
    ignoreDictOfLists[ 'Dirs' ] = listOfIgnoreDirectories
    
    # поиск
    resultList, msg = find_files_down_tree_(head, listOfExtension, ignoreDictOfLists)
    
    # список получен, можно его обработать
    # в принципе можно передать указатель на функцию обработки
    for at in resultList:
        print at



