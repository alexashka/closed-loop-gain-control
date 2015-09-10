# What pthread lining? What pthread linking on build?
TEMPLATE = app
TARGET = hello_qt
INCLUDEPATH += .

CONFIG += release

QT -= gui



linux-arm5te-g++{
# Input
SOURCES += main.cpp
}
