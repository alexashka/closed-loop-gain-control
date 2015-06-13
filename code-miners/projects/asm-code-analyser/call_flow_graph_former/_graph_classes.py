#-*- coding: utf-8 -*-
""" 
file : import GrClasses
"""
import sys
from subprocess import call
import os

# Other
import pydot
from pygraph.classes.graph import graph
from pygraph.classes.digraph import digraph
from pygraph.readwrite.dot import write
from pygraph.readwrite.dot import read
from pygraph.classes.exceptions import AdditionError
# подключаем поисковые алгоритмы
from pygraph.algorithms.searching import breadth_first_search
import pygraph.algorithms.critical as cr

class OneGrPyDot:
    _gr = pydot.Dot(graph_type='digraph')
    def addEdge(self, v, u):
        self._gr.add_edge(pydot.Edge(v, u))

    def addMainNodes(self, headers):
        for node in headers:
            node_c = pydot.Node(node, style="filled", fillcolor="#976856")
            self._gr.add_node(node_c)    # добавляем узлы

    def write_graph(self, ofile):
        self._gr.write_jpg(ofile)

    def addSecondNodes(self, locals, headers):
        externLinks = list('')
        for at in locals :
            if at.find('ret') != -1:
                node_c = pydot.Node(at, style="filled", fillcolor="#009933")
            # проверяем на входимость метку
            elif at.find('zxy') != -1 :
                node_c = pydot.Node(at, style="filled", fillcolor="#22cc33")
            elif at.find('xyz') != -1 :
                node_c = pydot.Node(at, style="filled", fillcolor="#11dd33")
            elif findExternLink(headers, at): # да есть
                externLinks.append(at)
                node_c = pydot.Node(at, style="filled", fillcolor="lightblue")
            else:
                node_c = pydot.Node(at)

            # добавляем узел
            self._gr.add_node(node_c)

def findExternLink(headers, localsMinusOne):
    """ Проверка нахождения конеченй точки перехода интерфейсному методу """
    for i in headers:
        if i == localsMinusOne:
            return False
    return True


class OneGrPyGr :
    """ Класс для работы с графом методома python-graph
    особенность в том что вершины графай соединяются только одной линией
    что необходимо для алгоритмов поиска
     """
    _gr = digraph()
    
    # Добавляет главные узлы
    def addMainNodes(self, headers):
        for node in headers:
            try:
                self._gr.add_node(node)
            except AdditionError:
                pass
    
    # Добавляет вспомогательные узлы
    def addSecondNodes(self, locals, headers):
        for node in locals:
            try:
                self._gr.add_node(node)
            except AdditionError:
                pass
        
    # Добавление ребра
    def addEdge(self, v, u):
        try:
            self._gr.add_edge((v, u))
        except AdditionError:
            pass
            
    # Запись в файл
    def write_graph(self, ofile):
        dot = write(self._gr)
        with open("odata/gr.dot", 'w') as f:
            f.write(dot)
        #call(["dot", "odata/gr.dot", "-Tjpg", "-o", ofile])
    
    # Ищет все узлы доступные из данного узла
    def searchNodes(self, root):
        st, order = breadth_first_search(self._gr, root=root)
        gst = digraph()
        #gst.add_spanning_tree(st)
        #dot = write(gst)
        #with open("odata/grf.dot", 'w') as f:
        #    f.write(dot)
        #call(["dot", "odata/grf.dot", "-Tjpg", "-o", "odata/grf.jpg"])
        return order



