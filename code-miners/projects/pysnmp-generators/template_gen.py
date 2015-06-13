# coding: utf-8

from _readers_template_file import read_template_file_update
from _parsers import parse_update
from _generators import generate_get
from _generators import generate_get_set
        
if __name__=='__main__':
    root_path = 'D:\\home\\lugansky-igor\\tmitter-web-service-win\\src-snmp-view'
    
    #@State
    # Теперь все крутится вокруг ключей
    if False:
        keys = root_path+'\\templates-requests\\main_params.keys'
        mib_keys = root_path+'\\templates-mib-slices\\state-path.extract'
        if True:
            parse_update(mib_keys, keys)
        else:
            result_fname = root_path+'\\templates-mib-slices\\state-path.py'
            generate_get(result_fname)
            
    if False:
        keys = root_path+'\\templates-requests\\main_params.keys'
        mib_keys = root_path+'\\templates-mib-slices\\state-path1.extract'
        if True:
            parse_update(mib_keys, keys)
        else:
            result_fname = root_path+'\\templates-mib-slices\\state-path1.py'
            generate_get(result_fname, read_template_file_update)
    
    #mib_keys = root_path+'\\templates-mib-slices\\units.extract'
    #result_fname = root_path+'\\templates-mib-slices\\units.py'
    #parse_doubled(mib_keys, keys)
    #generate_get(result_fname)
    
    #@Control
    
    if True:
        keys = root_path+'\\templates-requests\\main_params.keys'
        mib_keys = root_path+'\\templates-mib-slices\\aat.extract'
        if False:
            parse_update(mib_keys, keys)
        else:
            result_fname = root_path+'\\templates-mib-slices\\aat.py'
            mib_name = 'AA-ALL-POWER'
            generate_get_set(mib_name, result_fname, read_template_file_update)
    
        
    
    
    
    
    
    
    
    
    
    