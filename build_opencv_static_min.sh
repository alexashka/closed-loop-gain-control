#!/bin/bash

#wget https://github.com/Itseez/opencv/archive/3.0.0.tar.gz

#tar xvf 3.0.0.tar.gz
cd opencv-3.0.0
mkdir build
cd build

cmake \
	-D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/opt/opencv-3.0.0 \
	-D BUILD_SHARED_LIBS=OFF \
	-D WITH_TBB=OFF \
	-D WITH_CUDA=OFF \
	-D WITH_IPP=OFF \
	-D WITH_OPENCL=OFF \
	-D BUILD_opencv_ml=OFF \
	-D BUILD_JAVA_SUPPORT=OFF \
	-D BUILD_PYTHON_SUPPORT=ON \
	-DBUILD_ZLIB=ON -DBUILD_TIFF=ON -DBUILD_JASPER=ON -DBUILD_JPEG=ON -DBUILD_PNG=ON \
	-DBUILD_EXAMPLES=OFF \
	-D BUILD_SAMPLES=OFF \
	-DBUILD_OPENEXR=OFF -DWITH_OPENEXR=OFF \
	..

make -j4