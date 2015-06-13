#-*- coding: utf-8 -*-

import sys
sys.path.append('/home/zaqwesc/github-dev')
sys.path.append('/home/zaqwesc/github-dev/text-processors')

import to_utf

# Run()
if __name__=="__main__":
    path_to_bt = '../Bugtracker/'
    ifile = path_to_bt+'Bugtracker.txt'
    ofile = path_to_bt+'Bugtracker_utf8.txt'
    to_utf.cp1251_to_utf8(ifile, ofile)
    

