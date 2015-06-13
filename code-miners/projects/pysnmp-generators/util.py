# coding: utf-8
'''
Created on 08.08.2013

@author: Igor
'''

from ipc.pipe_channel_controller import PipeController
import dals.os_io.io_wrapper as io

def to_name(line):
    # Make accessors form template
    #print 'get_'+line
    ptr = 0
    result = ''
    while ptr < len(line):
        if ptr+1 == len(line) or ptr+2 == len(line):
            result += line[ptr]
        elif line[ptr+1].istitle():
            result += line[ptr]+'_'
        else:
            result += line[ptr]
        ptr += 1
    return result.lower()

def _all_first_item_to_upper_and_remove_spaces(sentence):
    #sentence[0] = sentence[0].upper()
    result_string = ''
    space_was = False
    for at in sentence:
        if at == sentence[0]:
            result_string += at.upper()
        elif at != ' ':
            if space_was:
                result_string += at.upper()
                space_was = False
            else:
                result_string += at
        else:
            space_was = True
    return result_string

def strip(string):
    return string.lstrip().rstrip()

'''
def get_params(request):
    PIPE_NAME = "\\\\.\\pipe\\MDI_PIPE"
    controller = PipeController(PIPE_NAME)
    response = controller.exchange(request)
    params = response.split(' ')[2].split('&')
    return params'''

def file_as_list(file_name):
    template = io.get_utf8_template()
    template['name'] = file_name 
    return io.file2list(template)

