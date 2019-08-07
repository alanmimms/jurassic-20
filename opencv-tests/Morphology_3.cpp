/**
 * @file Morphology_3(Extract_Lines).cpp
 * @brief Use morphology transformations for extracting horizontal and vertical lines sample code
 * @author OpenCV team
 */

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

  //! [bin]
  // Apply adaptiveThreshold at the bitwise_not of gray, notice the ~ symbol
  Mat bw;
  adaptiveThreshold(~gray, bw, 255, CV_ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, 15, -2);

  Mat toFindIn = imread("left-register-mark.png", 0);
  Mat toFindSE;
  adaptiveThreshold(toFindIn, toFindSE, 255, CV_ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, 15, -2);

  // Apply morphological open operator
    morphologyEx(bw, bw, MORPH_OPEN, toFindSE);
    //  erode(bw, bw, toFindSE);
    //    showImage("eroded", bw);
    //    dilate(bw, bw, toFindSE);
    //    showImage("dilated", bw);

  // Make result image out of original + our computed image in green
  Mat zeros(bw.size(), CV_8UC1);
  Mat result(bw.size(), CV_8UC3);
  vector<Mat> sources = {zeros, bw, zeros};
  merge(sources, result);
  add(src, result, result);

  // Show extracted horizontal lines
  cv::imwrite("crossed.png", result);
  cout << "crossed.png written" << std::endl;
  showImage("crossed", result);

  return 0;
}
