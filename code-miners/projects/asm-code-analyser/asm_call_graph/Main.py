#!/usr/bin/python
#-*- coding: utf-8 -*-
import call_gr_finder
# ui
# Файлы со входными модулями
ifile = 'statistic/comp_purged.asm'
ofile = 'odata/example2_graph.jpg'

# Call
call_gr_finder.Run( ifile, ofile )
