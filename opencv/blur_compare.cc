#include <iostream>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>

#include <algorithm>
 
using namespace std;
using namespace cv;
 
// reflected indexing for border processing
int reflect(int M, int x)
{
    if(x < 0)
    {
        return -x - 1;
    }
    if(x >= M)
    {
        return 2*M - x - 1;
    }
    return x;
}
 
int main()
{
 
      Mat src, dst, temp;
      //float sum, x1, y1;
 
      /// Load an image
      src = imread("/home/zaqwes/work/materials/Image0.jpg", CV_LOAD_IMAGE_GRAYSCALE);
 
      if( !src.data )
      { return -1; }
 
      // coefficients of 1D gaussian kernel with sigma = 1
      std::vector<float> f;
      const int kern_size = 11;
      const int half = kern_size / 2;
      Mat kern = cv::getGaussianKernel (kern_size, 5, CV_32F);

      Mat out;
      transpose(kern, out);

      float *p = out.ptr<float>(0); // pointer to row 0
      f.insert(f.end(), p, p + out.cols); // construct a vector using pointer

      dst = src.clone();
      temp = src.clone();
      Mat dst_compare = src.clone();
      sepFilter2D(src, dst_compare, -1, out, out);
 
      // along y - direction
      for(int y = 0; y < src.rows; ++y){
          for(int x = 0; x < src.cols / 2; ++x){
              float sum = 0.0;
              for(int i = 
                //0
                -half
                ; i <= half; i++){
                  int y1 = reflect(src.rows, y - i);
                  sum += f[i + half]* (uchar)src.at<uchar>(y1, x);
              }
              dst.at<uchar>(y,x) = (uchar)sum;
          }
      }

      // along x - direction
      for(int y = 0; y < src.rows; ++y){

          for(int x = half; x < src.cols / 2; ++x){
              float sum = 0.0;
              for(int i = 
                //0
                -half
                ; i <= half; i++){
                  int x1 = //reflect(src.cols, 
                    x - i;//);
                  sum += f[i + half]*(uchar)dst.at<uchar>(y, x1);
              }
              src.at<uchar>(y,x) = (uchar)sum;
          }

      }

      Mat diff = dst_compare - src;
      //Mat diff = dst - dst_compare;

      //namedWindow("final");
      //imshow("final", dst);

      namedWindow("initial");
      imshow("initial", diff);
 
      waitKey();
 
 
    return 0;
}