#!/usr/bin/python
#-*- coding: utf-8 -*-
'''
	abs. : 
	
; Call graph
;_BUM_SETdw_AT Topen
;	_TASK_FullOnMip
;		_TASK_NextUmOn
;			_TASK_HLTuw_DataRead2Wait(2-1)  # хорошо бы число повторов сделать
;				_CLK_HLTuw_Tick
;					_PIO_SETuw_Timer1Int;(void/void)	
;						_IRQ_SETuw_LowPriorInt 
;			_TASK_OTKAZ_CurUm(13-1) 
;				_TASK_CurUmNotReseted
;					_TASK_HLTuw_AmpResWait;
'''
# Import the module and instantiate a graph object
from pygraph.classes.graph import graph
from pygraph.algorithms.searching import depth_first_search
gr = graph()

# Формирование графа
''' 
  Отдельная проблема.
''' 
# Add nodes
nodes = [
  '_BUM_SETdw_ATTopen ', #фыва',
  '_TASK_FullOnMip',
  '_TASK_NextUmOn',
  '_TASK_OTKAZ_CurUm']
gr.add_nodes( nodes )
#gr.add_nodes(['A','B','C'])

# Add edges  
# ориентация безразлична
gr.add_edge(( nodes[0],'_TASK_FullOnMip' ))
gr.add_edge(( '_TASK_FullOnMip', '_TASK_NextUmOn'))
gr.add_edge(( nodes[0], '_TASK_OTKAZ_CurUm' ))

# Распределение узлов посел всех итераций
listFindRoots = ['_TASK_NextUmOn', '_TASK_OTKAZ_CurUm']

''' 
  Тут проблема решена, может резве, что офформление сделать
    покрасивее
  1. русские комментарии к функциям
'''
# Поиск путей
root = nodes[0]  # ищем с того который задан в поиске вызовов
st = depth_first_search(gr, root=root)

# Вывод на экран
for root_pr in listFindRoots :
	print '# call Top <-' 
	step = ''
	root_pr_inner = root_pr
	while (1):
		# рисуем
		if root_pr_inner != root :
			print step+root_pr_inner
		else :
			print step+root_pr_inner + ' <- call Bottom'
	
		# действия по выходу
		step += '  '
		root_pr_inner = st[root_pr_inner]
		if root_pr_inner == None :
			break 
	print '\n'