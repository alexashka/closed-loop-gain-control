#include <opencv2/opencv.hpp>
#include <opencv/highgui.h>

#include <stdlib.h>
#include <stdio.h>

IplImage* image = NULL;
IplImage* dst = NULL;

int main(int argc, char* argv[]) {
	const char* filename = argc == 2 ? argv[1] : "/home/zaqwes/work/materials/Image0.jpg";

	image = cvLoadImage(filename, 1);

	dst = cvCloneImage(image);

	printf("[i] image: %s\n", filename);
	assert( image != 0 );

	cvNamedWindow("original", CV_WINDOW_AUTOSIZE);
	cvNamedWindow("smooth", CV_WINDOW_AUTOSIZE);

	cvSmooth(image, dst, CV_GAUSSIAN, 3, 3);

}
