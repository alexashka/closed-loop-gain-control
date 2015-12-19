#-*- coding: utf-8 -*-
import usaio
''' добавляет строку в фиксирванный файл  '''
def printStrToFile(string, fname):
	filename = fname
	# Create a file object:
	# in "write" mode
	FILE = open(filename,"at")

	# Write all the lines at once:
	FILE.writelines(string)
    
	# Alternatively write them one by one:
	FILE.close()

''' '''
def wrString(ofile, string):
  try:
    fwr = open(ofile, "w")
    try:
      fwr.write(string) # Write a string to a file
    finally:
      fwr.close()
  except IOError:
    print 'write error'
  
''' переводит строки файла в список '''
def fileToList(fname, inList):
    string = None
    try:
      f = open(fname, "r")
      try:
        # Read the entire contents of a file at once.
        while True:
          string = f.readline() 
          if(string == ''):
            break
          string = string.replace( '\n', '' )
          inList.append(string)
        # обязательно будет выполнено
      finally:
        f.close()
    except IOError:
      print 'read error'
	  