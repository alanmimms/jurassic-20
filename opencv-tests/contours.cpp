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

  if(src.empty()){
    printf(" Error opening image\n");
    printf(" Program Arguments: [image_path]\n");
    return -1;
  }

  // Transform source image to gray if it is not already
  Mat gray;

  if (src.channels() == 3) {
    cvtColor(src, gray, CV_BGR2GRAY);
  } else {
    gray = src;
  }

  Mat bwSrc;
  Mat blurred;
  medianBlur(src, blurred, 7);

  // Convert to black background grayscale and emphasize rectilinear
  // corners by convolution using a cross-shaped kernel.
#define X (1.0/13.0)
#define B (-0.5/13.0)
  static float crossKdata[] = {
    B, B, X, X, X, B, B,
    B, B, X, X, X, B, B,
    X, X, X, X, X, X, X,
    X, X, X, X, X, X, X,
    X, X, X, X, X, X, X,
    B, B, X, X, X, B, B,
    B, B, X, X, X, B, B,
  };
  Mat crossK(7, 7, CV_32F, crossKdata);
#undef X
#undef B

  Mat crossed;
  Mat blurredBW;
  cvtColor(blurred, blurredBW, COLOR_RGB2GRAY);
  filter2D(~blurredBW, crossed, CV_8UC1, crossK);
  cv::imwrite("corners-crossed.png", crossed);
  threshold(crossed, bwSrc, 2, 127, THRESH_BINARY | THRESH_OTSU);
  showImage("crossed B&W thresholded 2..127", bwSrc);

  // Find corners
  vector<vector<Point> > contours;
  vector<Vec4i> hierarchy;
  findContours(bwSrc, contours, hierarchy, 
               cv::RETR_TREE, cv::CHAIN_APPROX_SIMPLE, 
               Point(0, 0));

  Mat result = blurred;
  int maxDepth = 0;
  vector<int> depths;

  for(int i = 0; i < contours.size(); ++i) {
    int depth = 0;
    for (int d = hierarchy[i][3]; d >= 0; d = hierarchy[d][3]) ++depth;
    if (depth > maxDepth) maxDepth = depth;
    depths.push_back(depth);
  }

  cout << "Contours.size()=" << contours.size() << ", maxDepth=" << maxDepth << endl;

  static const struct RGB {
    unsigned char r, g, b;
  } colorSchemes[][10] = {
    #include "./colors/colors.h"
  };

  const struct RGB *scheme = colorSchemes[maxDepth + 1];
  int contourT = 3;

  vector<vector<Point> > approxContours = contours;

  for (int i = 0; i < contours.size(); ++i) {
    approxPolyDP(Mat(contours[i]), approxContours[i], 5, false);
    cout << "contour.size=" << contours[i].size()
         << ", approx.size=" << approxContours[i].size()
         << endl;
  }

  for (int i = 0; i < contours.size(); ++i) {
    const int depth = depths[i];
    struct RGB rgb = scheme[depth];
    //    const unsigned gray = 200 * depth / maxDepth;

    if (approxContours[i].size() > 34) continue;

    drawContours(result, approxContours, i,
                 Scalar(rgb.b, rgb.g, rgb.r, 0),
                 contourT, 8, hierarchy, 0);
  }

  // Show extracted horizontal lines
  cv::imwrite("corners.png", result);
  cout << "corners.png written" << std::endl;
  showImage("corners", result);

  return 0;
}
