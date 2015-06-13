#!/usr/bin/python
#-*- coding: utf-8 -*-

import PreProc 

import re
s = "start foo end"
s = re.sub("foo", "replaced", s)
print s
