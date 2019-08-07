#include <opencv2/opencv.hpp>
#include <iostream>

using namespace std;
using namespace cv;

Mat img;
Mat templ;
Mat result;
const char* image_window = "Source Image";
const char* result_window = "Result window";

void MatchingMethod(int matchMethod);


static void showImage(const char *name, InputArray image) {
  namedWindow(name, CV_WINDOW_NORMAL | CV_WINDOW_KEEPRATIO | CV_GUI_EXPANDED);
  resizeWindow(name, 3200, 3200*3/4);
  imshow(name, image);
  waitKey(0);
  destroyWindow(name);
}


static int usage(const char *msg) {
  cout << msg << endl
       << endl
       << "Usage:" << endl
       << endl
       << "./match-template <match-method> <image_name> <template_name>" << endl
       << endl
       << "Possible <match-method> values:" << endl
       << " 0: SQDIFF" << endl
       << " 1: SQDIFF NORMED" << endl
       << " 2: TM CCORR" << endl
       << " 3: TM CCORR NORMED" << endl
       << " 4: TM COEFF" << endl
       << " 5: TM COEFF NORMED" << endl;

  return -1;
}


int main(int argc, char** argv) {
  if (argc != 4) return usage("Wrong number of arguments");

  int matchMethod = atoi(argv[1]);
  img = imread(argv[2], IMREAD_COLOR);
  templ = imread(argv[3], IMREAD_COLOR);

  if (img.empty() || templ.empty()) return usage("Can't read one of the images");
  if (matchMethod < 0) return usage("Bad <match-method>");

  MatchingMethod(matchMethod);
  waitKey(0);
  return 0;
}


void MatchingMethod(int matchMethod) {
  int result_cols =  img.cols - templ.cols + 1;
  int result_rows = img.rows - templ.rows + 1;
  Mat img_display;

  img.copyTo(img_display);

  result.create(result_rows, result_cols, CV_32FC1);
  matchTemplate(img, templ, result, matchMethod);
  normalize(result, result, 0, 1, NORM_MINMAX, -1, Mat());

  double minVal;
  double maxVal;
  Point minLoc;
  Point maxLoc;
  Point matchLoc;

  minMaxLoc(result, &minVal, &maxVal, &minLoc, &maxLoc, Mat());
  matchLoc = (matchMethod == TM_SQDIFF || matchMethod == TM_SQDIFF_NORMED) ? minLoc : maxLoc;

  rectangle(result, matchLoc,
            Point(matchLoc.x + templ.cols , matchLoc.y + templ.rows),
            Scalar(0, 255, 0, 0), 4, 8, 0);

  //  showImage("source", img_display);
  showImage("result", result);
}
