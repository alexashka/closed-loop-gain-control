# coding: utf-8

# Sys
import json

# Other
import uasio.os_io.io_wrapper as iow
import _list_parser as list_parser

               
def _all_symbols_is_spaces(line):
    for at in line:
        if at != ' ':
            return False
    return True

def _one_call(src_list, result_map):
    save_index_header = ''
    # Схлопываем спислок
    fold_list = '###'.join(src_list)
    
    # 
    list_next_call = []
    if src_list:
        for at in src_list:
            if at[0] != '@':
                print 'Marker >', at
                result_map[at] = {}
                # Пока не нейдем следующий
                save_index_header = at
                _one_call(list_next_call, result_map[at])
                list_next_call = []
            else:
                print '\t', at[1:]
                list_next_call.append(at[1:]) 
                
    else:
        return
    
def _tree_walker(tree, i):
    if not tree or 'list' in str(type(tree)):
        return
        
    # Выводим заголовки
    for key in tree:
        step = ''
        for at in range(i):
            step += '\t'
        print step+key
        _tree_walker(tree[key], i+1)
       

if __name__ == '__main__':
    sets = iow.get_utf8_template()
    sets['name'] = 'D:/home/lugansky-igor/web-pc-mc-chain-framework/mkts/system_settings.mkt'
    
    readed_list = iow.file2list(sets)
    folded_list = []
    for at in readed_list:
        if at and not _all_symbols_is_spaces(at):
            if at[0] != '#':
                # Чистые данные
                if at[0] != ' ':
                    at = 'LEVEL0 '+at
                else:
                    at = at.replace('    ', '@')
                folded_list.append(at)
    
    
    joined_list = '^^^'.join(folded_list)
    
    # TODO(zaqwes): Оценка уровня вложенности
    max_levels = 0
    print joined_list.find('@@@@')
    
    joined_list = joined_list.replace('@@@', 'LEVEL3 ')
    joined_list = joined_list.replace('@@', 'LEVEL2 ')
    joined_list = joined_list.replace('@', 'LEVEL1 ')
    
    folded_list = joined_list.split('^^^')
    
    
    # Пакуем в реальную структуру данных
    levels = ['LEVEL0', 'LEVEL1', 'LEVEL2', 'LEVEL3']
    result_map = {}
    list_parser._fill_tree_dict(folded_list, levels, 0, result_map, 'root')
    
    # Plot result
    json_result = json.dumps(result_map['root'], sort_keys=True, indent=2)
    print
    print json_result
    result_map = result_map['root']
    
    #for at in folded_list:
     #   print at
    
    # Создаем структуру           
    
    #_one_call(folded_list, result_map)

    # Plot
    _tree_walker(result_map, 0)
      
      
    # Сохранение в файл
    json_string = json.dumps(result_map, sort_keys=True, indent=2)
    to_file = [json_string]
    
    settings = {
        'name':  'extracted_words.json', 
        'howOpen': 'w', 
        'coding': 'cp866' }
        
    iow.list2file(settings, to_file)       
