#-*- coding: utf-8 -*-

import sys
sys.path.append('D:/github-release')

import unittest
import json

# Other
import uasio.os_io.io_wrapper as iow

# App
import _http_requester as http_request

def _split_url(url):
    """ http://www.dessci.com/en/products/mathplayer/ to 
    www.dessci.com /en/products/mathplayer/ - для httplib
    """
    url_copy = url.replace('https://','')
    url_copy = url_copy.replace('http://','')
    
    head = url_copy.split('/')[0]
    path = url_copy[len(head):]
    return head+' '+path

def _purge_key(key_value):
    result_key = ''
    if key_value:
        if key_value[0] == ' ':
            result_key = key_value[1:]
    return result_key
    
    
                
def _fill_tree_dict(lst, levels, level_pos, result_dict, head):
    if level_pos == len(levels)-1:
        return
    
    foldered_list = ('@@@'.join(lst)).split(levels[level_pos])
    if head:
        if head[0] == ' ':
            head = head[1:]
            
    result_dict[head] = {}
    
    for it in foldered_list:
        splitted = it.split('@@@')
        # Текущий заголовок
        current_head = splitted[0]
        
        # Подчищаем ключ
        if current_head:
            if current_head[0] == ' ':
                current_head = current_head[1:]
                
        if current_head:
            result_dict[head][current_head] = {}
            
            if level_pos != len(levels)-2:
                result_dict[head][current_head] = {}
            else:
                # Оконечный лист
                result_dict[head][current_head] = _fill_last_leaf(splitted[1:])
                
                
            _fill_tree_dict(
                splitted[1:], 
                levels, 
                level_pos+1, 
                result_dict[head], current_head)
         
    # Переходим на следующий ярус
    level_pos += 1
    
def _fill_last_leaf(in_list):
    result_list = []
    for at in in_list:
        if at:
            result_list.append(at)
    return result_list

def _tree_walker(tree):
    if 'list' in str(type(tree)):
        for at in tree:
            print '\t\t', at
        return
        
    # Выводим заголовки
    for key in tree:
        print 
        print key
        _tree_walker(tree[key])


def main():
    #fname = 'lessions_names.txt'
    fname = 'lessions_html_code.txt'
    
    sets = iow.get_utf8_template()
    sets['name'] = fname
    
    i = 0
    result_list = []
    readed_list = iow.file2list(sets)
   
    for at in readed_list:
        # Предварительная фильтарция
        at = at.replace('</a>', '')
        
        # Ссылки с содержанием
        if 'pdf' in at or '&format=srt' in at:
            at_copy = at.replace('        <a target="_new" href=', '')
            #result_list.append('link_to_get '+_split_url(at_copy))
            result_list.append(_split_url(at_copy))

        # Темы
        if 'min)' in at and 'div' not in at:
            result_list.append('name_content '+at)
            
        # Части-недели
        if '(Week' in at:
            at_copy_list = at.split('&nbsp;')[1].split('</h3>')[0]
            result_list.append('folder '+at_copy_list)
        i += 1
    
    # теперь нужно запаковать в словарь
    levels = ['folder', 'name_content', 'link_to_get']
    result = {}
    for at in result_list:
        print at
    _fill_tree_dict(result_list, levels, 0, result, 'root')
    
    #_tree_walker(result)
    
    # сохраняем результаты в файл
    to_file = [json.dumps(result, sort_keys=True, indent=2)]
    
    settings = {
        'name':  'extracted_from_html.json', 
        'howOpen': 'w', 
        'coding': 'cp866' }
        
    iow.list2file(settings, to_file)
    
    settings = {
        'name':  'result.list', 
        'howOpen': 'w', 
        'coding': 'cp866' }
    iow.list2file(settings, result_list)
    
    
class TestSequenceFunctions(unittest.TestCase):
    """ Проверка разбиения текста по маркерам """
    def test_shuffle(self):
        sets = iow.get_utf8_template()
        sets['name'] = 'result_test.list'
        
        readed_list = iow.file2list(sets)
        
        # теперь нужно запаковать в словарь
        levels = ['LEVEL0', 'LEVEL1', 'nothing']
        result = {}
        _fill_tree_dict(readed_list, levels, 0, result, 'root')
        
        json_result = json.dumps(result['root'], sort_keys=True, indent=2)
        print
        print json_result
            
if __name__=='__main__':
    #main()
    suite = unittest.TestLoader().loadTestsFromTestCase(TestSequenceFunctions)
    unittest.TextTestRunner(verbosity=2).run(suite)
    
    print 'Done'
