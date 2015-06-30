//#include <opencv2/highgui/highgui.hpp>
//#include <opencv2/imgproc/imgproc.hpp>
//#include <opencv2/opencv.hpp>
//#include <opencv2/core/core.hpp>
//#include <opencv2/highgui/highgui_c.h>

#include <boost/gil/gil_all.hpp>

#include <string>

//using namespace cv;
using namespace std;

int main(int argc, char** argv)
{
   //namedWindow("Before" , CV_WINDOW_AUTOSIZE);

   // Load the source image
   //Mat src = cv::imread( "Image0.jpg", 0 );

   // Create a destination Mat object
   //Mat dst;

   // display the source image
   //imshow("Before", src);

   //for (int i=1; i<51; i=i+2)
   { 
      //smooth the image in the "src" and save it to "dst"
      //blur(src, dst, Size(i,i));

     // GaussianBlur( src, dst, Size( i, i ), 0, 0 );

      //show the blurred image with the text
      //imshow( "Smoothing by avaraging", dst );

      //wait for 3 seconds
      //waitKey(3000);
   }
}