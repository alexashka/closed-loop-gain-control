# encoding: utf-8

import numpy as np

class GreedyLineDispatcher(object):
	""" запрос новой полосы """
	def regen_new(self):
		return 0

	def check_intersection(self, lhs_id, rhs_id):
		pass

class AnyPoint(object):
	def __init__(self, x, y):
		pass

class Region(object):
	""" 
		может представлять линию
		Two points 
	"""
	def __init__(self):
		# при поиске не имеет значения какая какая

		self.start_point = None
		self.stop_point = None


if __name__=='__main__':
	grid = np.zeros( [8, 5] )
	grid[1][2] = 1

	print grid



