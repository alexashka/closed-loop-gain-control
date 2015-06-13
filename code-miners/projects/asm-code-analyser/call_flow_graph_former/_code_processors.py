#-*- coding: utf-8 -*-
# std
import re

# const
_PATTERN_CODE = 'code.*?end'
_JOIN_CODE = '@@@'
_COMMENTS_PATTERN = ';.*?\r\n'

def delete_endlines_in_list(list_lines):
    result = list('')
    for at in list_lines:
        at_result = at
        at_result = at_result.replace('\r','')
        at_result = at_result.replace('\n','')
        result.append(at_result)
    return result
 
def delete_comments(list_lines):
    """ Есть ограничение по платформе - конец строки = \r\n"""
    result = list('')
    for at in list_lines:
        at_result = re.sub(_COMMENTS_PATTERN, '', at)
        if at_result:
            result.append(at_result)
    return result

def extract_code(list_lines):
    """ Предполагается что секций кода одна """
    result = list('')
    string = _JOIN_CODE.join(list_lines)

    search_result = re.findall(_PATTERN_CODE, string, re.M | re.S | re.X)
    # только одна секция кода
    if len(search_result) == 1:
        result = search_result[0].replace(_JOIN_CODE, '\r\n')
        result = result.split('\r\n')
        result = delete_endlines_in_list(result)
    else:
        result = None
    # удаляем code-end обрамление
    return result[1:-1]