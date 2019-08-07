#include <opencv2/opencv.hpp>


using namespace std;
using namespace cv;


static void showImage(const char *name, InputArray image) {
  namedWindow(name, CV_WINDOW_NORMAL | CV_WINDOW_KEEPRATIO | CV_GUI_EXPANDED);
  resizeWindow(name, 3200, 3200*3/4);
  imshow(name, image);
  waitKey(0);
  destroyWindow(name);
}


int main(int, char** argv)
{
  Mat src = imread(argv[1], IMREAD_COLOR);

  // Check if image is loaded fine
  if(src.empty()){
    printf(" Error opening image\n");
    printf(" Program Arguments: [image_path]\n");
    return -1;
  }

  //! [gray]
  // Transform source image to gray if it is not already
  Mat gray;

  if (src.channels() == 3) {
    cvtColor(src, gray, CV_BGR2GRAY);
  } else {
    gray = src;
  }


    int morph_elem = 1;
    int morph_size = 1;
    int morph_operator = 0;

    Mat origImage = gray;
    medianBlur(origImage, origImage,1);
    cvtColor(origImage, origImage, COLOR_RGB2GRAY);
    threshold(origImage, origImage, 0, 255, THRESH_OTSU);

    Mat element = getStructuringElement(morph_elem, Size(2 * morph_size + 1, 2 * morph_size + 1), cv::Point(morph_size, morph_size));

    morphologyEx(origImage, origImage, MORPH_OPEN, element);
    //thin(origImage, true, true, true);
    imshow("@", origImage);
