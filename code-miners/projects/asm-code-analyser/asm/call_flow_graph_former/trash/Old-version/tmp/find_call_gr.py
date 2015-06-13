#!/usr/bin/python
#-*- coding: utf-8 -*-
import CallGrFinder
# ui
# Файлы со входными модулями
#file = "test_with_err.asm"
#file = "test.asm"
ifile = 'idata/_v3_COMP.asm'
ifile = 'idata/ITest.asm'
#ifile = 'idata/simples.asm'
ofile = 'odata/example2_graph.jpg'

# Call
CallGrFinder.Run( ifile, ofile )
