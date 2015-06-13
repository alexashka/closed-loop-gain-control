#!/usr/bin/python
#-*- coding: utf-8 -*-
import pycallgraph
from method import *
pycallgraph.start_trace()

# Run()
# Файлы со входными модулями
#file = "test_with_err.asm"
#file = "test.asm"
#file = '_v3_COMP.asm'
ifile = 'idata/ITest.asm'
ofile = 'odata/example2_graph.jpg'
# поиск распределения
Run( ifile, ofile )

pycallgraph.make_dot_graph('calls/test.png')
#pycallgraph.make_dot_graph('calls/test.jpg', format='jpg', tool='neato')