#include "CImg.h"

#include <iostream>

#include <sys/time.h>

using namespace std;

using namespace cimg_library;
int main () {
    //CImg<unsigned char> img("photo.jpeg");
    //(img, img.get_blur(8)).display("Hello, CImg!");

    unsigned char tab[1024*1024] = { 212 };
	CImg<unsigned char>  img(tab,1024,1024,1,1,true);

	// http://cimg.eu/reference/structcimg__library_1_1CImg.html
    //const CImg<float> img1(129,129,1,3,"0,64,128,192,255",true);                   // Construct image filled from a value sequence.
    //const CImg<float> img2(129,129,1,3,"if(c==0,255*abs(cos(x/10)),1.8*y)",false); // Construct image filled from a formula.
	//(img1,img2).display();

	struct timeval t1, t2;
    double elapsedTime;

    // start timer
    gettimeofday(&t1, NULL);

    // do something
    // ...
    img.get_blur(1);

    // stop timer
    gettimeofday(&t2, NULL);

    // compute and print the elapsed time in millisec
    elapsedTime = (t2.tv_sec - t1.tv_sec) * 1000.0;      // sec to ms
    elapsedTime += (t2.tv_usec - t1.tv_usec) / 1000.0;   // us to ms
    cout << elapsedTime << " ms.\n";

	//(img, img.get_blur(8)).display("Hello, CImg!");

    return 0;
}
