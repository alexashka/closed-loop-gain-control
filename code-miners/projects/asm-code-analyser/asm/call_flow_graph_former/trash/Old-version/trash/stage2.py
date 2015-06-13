
'''
# поиск конкретной строки
patt_call = '_TASK_HLTuw_DataReq2Wait'

# граф сформирован. Можно искать пути
# Циклы!! как быть с ними
# Распределение узлов посел всех итераций
# Поиск путей
listFindRoots = [u'_v#v(HERE)_COMP_SETuw_ByteOut;(void/void)']
root = u'_Cash_Out' # ищем с того который задан в поиске вызовов
st, pre, post = depth_first_search(gr, root=root)
# Вывод на экран
for root_pr in listFindRoots :
	step = ''
	root_pr_inner = root_pr
	while (1):
		# рисуем
		if root_pr_inner != root :
			print step+root_pr_inner
		else :
			print step+root_pr_inner
	
		# действия по выходу
		step += '  '
		root_pr_inner = st[root_pr_inner]
		if root_pr_inner == None :
			break 
	print '\n'
	'''