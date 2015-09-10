#-*- coding: utf-8 -*-
#import AirCurvesDB as airDB
# хранилище
import sqlite3

''' Получить данные по кривой '''
def getDataFromDb( nameCurve ):
	CurvesSet = {} 
	hex = {}
	
	# Открываем базу
	conn = sqlite3.connect('Curves.db')
	
	# создаем курсор
	c = conn.cursor()
	
	# делаем выборку
	for row in c.execute("SELECT * FROM stocks WHERE  NameCurve = '"+nameCurve+"'"):
		CurvesSet[nameCurve] = row[-2]
		hex[nameCurve] = bool(row[-1])

	# Загрываем базу данных
	c.close()
	
	# Возвращаем результаты
	return CurvesSet, hex
	


''' Создать кривую '''
def addCurveIntoDB( name, type, data ):
	conn = sqlite3.connect('Curves.db')
	
	# создаем курсор
	c = conn.cursor()

	# Create table
	c.execute('''
		CREATE TABLE if not exists stocks(
			NameCurve text primary key, 
			CurveValue text,
			Type boolean
		)'''
	)

	# Insert a row of data
	INSET_REQ = 'INSERT INTO stocks VALUES ('
	fullReq = INSET_REQ+" '"+name+"','"+ data +" ',"+str(int(type))+")"
	try:
		c.execute( fullReq )
	except sqlite3.IntegrityError:
		print "Record exist"
		# закрываем базу
		c.close()
		return False

	# Save (commit) the changes
	conn.commit()
	
	# We can also close the cursor if we are done with it
	c.close()
	return True 
	
''' '''
def showDB():
	conn = sqlite3.connect('Curves.db')
	
	# создаем курсор
	c = conn.cursor()
	# Выворачиваем всю базу
	#for row in c.execute('SELECT NameCurve FROM stocks ORDER BY id'):
	for row in c.execute("SELECT * FROM stocks"):# WHERE  NameCurve = 'VIRTUAL_ONE_0'"):
		print row

	# We can also close the cursor if we are done with it
	c.close()