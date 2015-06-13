''' удаляем комментаии '''
def purgeFromComments( fname ):
	# читаем в список
	linesFromInc = file2ListLines( fname )
	
	# ищем закомментированные строки и пишем незак. в файл
	try:
		f = io.open( fname, "wt")#, encoding='utf-8' )	# пусть так и остается
		try:
			for at in linesFromInc:
				if not ';' in at:
					f.write( at )
				else:
					at = at.replace(';', '; ')	# добавляе к точкам с запяты пробелы
					at_tmp = at.replace('\t', '')	# удаляем табы
					at_tmp = at_tmp.split(' ')
					if at_tmp[0] != ';':	# не комментарий
						f.write( at )
		finally:
			f.close()
	except IOError:
		print 'IOError'