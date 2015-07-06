# Build opencv
# http://sysads.co.uk/2014/05/install-opencv-2-4-9-ubuntu-14-04-13-10/
#
# 3.0 on ubuntu 14
# http://stackoverflow.com/questions/25726768/opencv-3-0-trouble-with-installation

# http://stackoverflow.com/questions/519342/what-is-the-difference-between-i-and-l-in-makefile
CV_INCLUDES=-I/opt/opencv/include
# http://stackoverflow.com/questions/10094692/opencv-error-undefined-reference-to-cvloadimage-ubuntu
# Better pkg-config
CV_LIB= 
# export PKG_CONFIG_PATH=/opt/opencv_raw/lib/pkgconfig:$PKG_CONFIG_PATH
# FIXME: set pkg-config to -L \

# http://linuxconfig.org/linux-tutorials/408-101-howto-start-with-opencv-and-computer-vision-on-ubuntu-linux

CFLAGS=-g  $(CFLAGS)
CCFLAGS=-g `pkg-config opencv --cflags` $(CCFLAGS)
#LDFLAGS= 
LIBS=$(CV_LIB)

# Need it
CC=g++

all:  prog 

prog: w1 s4 s5 s7 blur_compare

# Step 3:
w1: w1.o
	$(CC) w1.o -o  $@ `pkg-config opencv --libs`

w1.o: w1.cc
	$(CC) -c -o w1.o w1.cc `pkg-config opencv --cflags`

# Step 4:
s4: s4.o
	$(CC) s4.o -o  $@ `pkg-config opencv --libs`

s4.o: s4.cc
	$(CC) -c -o s4.o s4.cc `pkg-config opencv --cflags`

# Step 5:
# Troubles with codecs
# http://mycodesite.com/compile-opencv-with-ffmpeg-for-ubuntudebian/
s5: s5.o
	$(CC) s5.o -o  $@ `pkg-config opencv --libs`

s5.o: s5.cc
	$(CC) -c -o s5.o s5.cc `pkg-config opencv --cflags`

# Step 7:
s7: s7.o
	$(CC) s7.o -o  $@ `pkg-config opencv --libs`

s7.o: s7.cc
	$(CC) -c -o s7.o s7.cc

# conversions
# Step 10:
blur_compare: blur_compare.o
	$(CC) blur_compare.o -o  $@ `pkg-config opencv --libs`
	
s10.o: blur_compare.cc
	$(CC) -c -o blur_compare.o blur_compare.cc


# http://stackoverflow.com/questions/2172621/cannot-open-shared-object-file-no-such-file-or-directory
# http://stackoverflow.com/questions/15049422/how-to-load-extra-libraries-for-gdb
# set environment LD_LIBRARY_PATH /opt/opencv/lib
# !! http://stackoverflow.com/questions/9631228/how-to-smart-append-ld-library-path-in-shell-when-nounset
#LD_LIBRARY_PATH=/opt/opencv/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}; \
#export LD_LIBRARY_PATH; \
#debug_w1: all
#	gdb w1

#LD_LIBRARY_PATH=/opt/opencv/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}; \
#export LD_LIBRARY_PATH; \
#run_w1: w1
#	./w1

#run_s4: w
#	./s4

#LD_LIBRARY_PATH=/opt/opencv_raw/lib${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}; \
#export LD_LIBRARY_PATH; \
# ldd s5; \
#rs5: all
#	./s5

clean:
	rm -fr *.o w1 s4 s5 s7 blur_compare
