#!/usr/bin/python
#-*- coding: utf-8 -*-
import sys
sys.path.append('G:/github-dev')
import code_processors_and_analysers.asm.\
    call_flow_graph_former.call_graph_finder as call_graph_finder

if __name__=='__main__':
    # ui
    # Файлы со входными модулями
    ifile = 'statistic/main.asm'
    ofile = 'odata/main.jpg'

    # Call
    call_graph_finder.run( ifile, ofile )
