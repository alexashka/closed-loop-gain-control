# coding: utf-8
from util import file_as_list

def parse_update(mib_map, access_map):
    def recode(file_name):
        keys_list = file_as_list(file_name)
        keys_dict = {}
        for k in keys_list:
            key = k.split(' ')[0]
            value = k.split(' ')[1]
            keys_dict[key] = value
        return keys_dict
    
    mib_dict = recode(mib_map)
    keys_dict = recode(access_map)
    
    i = 0
    for k in mib_dict:
        print keys_dict[k], mib_dict[k], '@DESCRIPTION' 
        i += 1
        
        
def parse_doubled(mib_map, access_map):
    from collections import defaultdict
    def recode(file_name):
        keys_list = file_as_list(file_name)
        keys_dict = {}
        for k in keys_list:
            key = k.split(' ')[0]
            value = k.split(' ')[1]         
            
            keys_dict[key] = value
            
        return keys_dict
    
    def recode_multy(file_name):
        
        keys_list = file_as_list(file_name)
        keys_dict = []
        for k in keys_list:
            key = k.split(' ')[0]
            value = k.split(' ')[1]
            if len(k.split(' ')) == 3:
                key2 = k.split(' ')[2]
                keys_dict.append((key2, value))
            keys_dict.append((key, value))
            
        processed_response = defaultdict(list)
        for k, v in keys_dict:
            processed_response[k].append(v)
        return processed_response
    
    mib_dict = recode_multy(mib_map)
    keys_dict = recode(access_map)
    
    result_list = []
    for k in mib_dict:
        for j in mib_dict[k]:
            result_list.append((j, keys_dict[k]))
        
    processed_response = defaultdict(list)
    for k, v in result_list:
        processed_response[k].append(v)
    
    for k in processed_response:
        print processed_response[k], k, '@DESCRIPTION' 
      
def parser_first(mib_file_name, map_file_name):
    # Из существующего MIB
    mib_extract_fname = mib_file_name
    mib_extract = file_as_list(mib_extract_fname)
    mib_map = {}
    for record in mib_extract:
        if '?' not in record:
            splitted = record.split(' ') 
            mib_map[int(splitted[0])] = splitted[1]
    
    # Выделеные данные из пакета полученного по каналу
    channal_extract = file_as_list(map_file_name)
    for record in channal_extract:
        splitted = record.split(' ') 
        idx = int(splitted[0])
        if True:
            if idx in mib_map:
                print splitted[0], splitted[2], splitted[1], splitted[2], '@DESCRIPTION <> ', mib_map[idx]
            else:
                print splitted[0], splitted[2], splitted[1], splitted[2], '@DESCRIPTION <> ', 'NO_USED'
         
        else:   
            # Печать перекодировщика
            print "mapper["+splitted[0]+"] = '"+splitted[1]+"'"