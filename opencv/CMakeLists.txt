# http://stackoverflow.com/questions/7752609/cmake-ordering-of-include-directories-how-to-mix-system-and-user-based-includ?rq=1
project(blur)
cmake_minimum_required(VERSION 2.8)

set (CMAKE_INCLUDE_DIRECTORIES_BEFORE ON)

set(OpenCVDir "/home/zaqwes/src/opencv")
include_directories(${OpenCVDir}/include)
include_directories(${OpenCVDir}/modules/core/include)
include_directories(${OpenCVDir}/modules/hal/include)
include_directories(${OpenCVDir}/modules/imgproc/include)
include_directories(${OpenCVDir}/modules/photo/include)
include_directories(${OpenCVDir}/modules/video/include)
include_directories(${OpenCVDir}/modules/features2d/include)
include_directories(${OpenCVDir}/modules/objdetect/include)
include_directories(${OpenCVDir}/modules/calib3d/include)
include_directories(${OpenCVDir}/modules/imgcodecs/include)
include_directories(${OpenCVDir}/modules/videoio/include)
include_directories(${OpenCVDir}/modules/highgui/include)
include_directories(${OpenCVDir}/modules/ml/include)

include_directories(/home/zaqwes/src/boost_1_58_0)

add_executable(blur.bin
    blur.cc
    #convolution.cpp # need numext - it's dead
    #${OpenCVDir}/modules/imgproc/src/smooth.cpp
)
