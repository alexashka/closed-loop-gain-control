# coding: utf-8
# TODO(zaqwes): подумать как быть с невалиным json

# Sys
import json
import sys

# Other
import dals.os_io.io_wrapper as iow
import dals.os_io.to_json as to_json

def save_result(branch_name, what_save):
    sets = iow.get_utf8_template()
    # Перевод в json
    sets['name'] = branch_name+'.json'
    sets['howOpen'] = 'w'
    sets['coding'] = 'utf_8'
    iow.list2file(sets, ['\r# Unrolled:\n'])
    sets['howOpen'] = 'a'
    to_json.save_process_result(what_save, sets, raw=False)
    iow.list2file(sets, ['\r# Packed:\n'])
    to_json.save_process_result(what_save, sets, raw=True)

if __name__ == "__main__":
    sets = iow.get_utf8_template()
    sets['name'] = "D:/home/lugansky-igor/tmitter-web-service-win/page/www/sub-pages/sys-settings-new.htm"
    sets['coding'] = 'cp1251'
    
    #
    branch_name = "settings monitoring system"
    branch_name = branch_name.replace(' ', '_')
    readed_list = iow.file2list(sets)
    
    # Делим на блоки
    joined = '\r\n'.join(readed_list)
    typed_list = joined.split('</h1>')
     
    def _process_one_item(item, result_branchs):
        splitted_lise = item.split('\r\n')
        
        # Ищем заголовок
        item_name = splitted_lise[0].replace('<span style="display:none;">', '').replace('</span>', '')
        item_name = item_name.replace('\r', '')
        result_branchs[item_name] = {}
        
        # Ищем ids
        for at in splitted_lise:
            if 'id="' in at:
                one_words_list = at.split(' ')
                for it in one_words_list:
                    if 'id=' in it and not 'msg_' in it and not 'err_' in it and not 'accept_' in it:
                        it_copy = it.replace('id="','')
                        it_copy = it_copy.replace('"','')
                        one_node = it_copy
                        result_branchs[item_name][one_node] = one_node


    # Обработка      
    result_branchs = {}  
    for at in typed_list[1:-1]: 
        if at:   
            _process_one_item(at, result_branchs)
                   
    save_result('setters', result_branchs)
    
    # Кодогенерация
    code = []
    for branch_name in result_branchs:
        code.append('\n// branch: '+branch_name)
        code.append('// Auto generate by: '+sys.argv[0])
        code.append('function check_'+branch_name+'() {')
        code.append('  var correct = false;')
        branch = result_branchs[branch_name]
        for one_node in branch:
            if one_node[0] == 't':
                # Call  
                code.append('\n  // checker')      
                #for one_node in branch:
                print one_node #code
                code.append('  var check_'+one_node+' = function(value) {\n    return true;\n  }')
                
                code.append('  correct = check_'+one_node+'(document.getElementById("'+one_node+'").value);'+ \
                            '\n  if (!correct) {\n    return "msg";\n  }')
                
                
                
        code.append('  return "";\n}  // '+'function check_'+branch_name)
                                
    sets = iow.get_utf8_template()
    sets['name'] = "code.js"  
    sets['howOpen'] = 'w'
    iow.list2file(sets, code)
    
    print 'Done'
    
