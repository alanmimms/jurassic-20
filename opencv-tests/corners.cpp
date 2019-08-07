#include <fstream>
#include <opencv2/opencv.hpp>
#include <opencv2/ximgproc.hpp>

using namespace std;
using namespace cv;
using namespace cv::ximgproc;


static void showImage(const char *name, InputArray image) {
  namedWindow(name, CV_WINDOW_NORMAL | CV_WINDOW_KEEPRATIO | CV_GUI_EXPANDED);
  resizeWindow(name, 3200, 3200*3/4);
  imshow(name, image);
  waitKey(0);
  destroyWindow(name);
}


static inline double degreesToRadians(const double deg) {
  return deg * CV_PI / 180.0;
}


// Lines closer together than this and with slope within slopeEpsilon
// of each other are the SAME line.
static const double lineEpsilon = 10;
static const double slopeEpsilon = 0.05;


int main(int, char** argv)
{
  Mat src = imread(argv[1], IMREAD_COLOR);

  if(src.empty()){
    printf(" Error opening image\n");
    printf(" Program Arguments: [image_path]\n");
    return -1;
  }

  // Transform source image to gray if it is not already
  Mat graySrc;

  if (src.channels() == 3) {
    cvtColor(src, graySrc, CV_BGR2GRAY);
  } else {
    graySrc = src;
  }

  Mat result = src;

#if 0
  // Convert to black background grayscale and emphasize rectilinear
  // corners by convolution using a cross-shaped kernel.
  //  const double XFRAC = 7*7 - 16;
  const double XFRAC = 100.0;
  const double X = 1.0/XFRAC;
  const double B = -0.01/XFRAC;
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

  Mat blurred;
  Mat crossed;
  Mat blurredBW;
  Mat bwSrc;
  medianBlur(graySrc, blurred, 7);
  cvtColor(blurred, blurredBW, COLOR_RGB2GRAY);
  filter2D(~blurredBW, crossed, CV_8UC1, crossK);
  cv::imwrite("corners-crossed.png", crossed);
  threshold(crossed, bwSrc, 1, 255, THRESH_BINARY | THRESH_OTSU);

  // Use Hough to find lines
  vector<Vec4i> lines;
  Mat toHough = bwSrc;
  const double thetaDeg = 1.0;
  const double rho = 7.0;
  const int threshold = 7000;
  const int minLineLength = 10;
  const double maxLineGap = 20.0;
  HoughLinesP(toHough, lines,
              rho, degreesToRadians(thetaDeg),
              threshold, minLineLength, maxLineGap);

  for (size_t i = 0; i < lines.size(); ++i) {
    Point p1 = Point(lines[i][0], lines[i][1]);
    Point p2 = Point(lines[i][2], lines[i][3]);
    line(result, p1, p2, Scalar(0, 255, 0), 3, 8);
  }
#else
  const int sigma = 1;
  const int kSize = (sigma * 5) | 1;
  Mat blurred;
  GaussianBlur(~graySrc, blurred, Size(kSize, kSize), sigma, sigma);
  cv::imwrite("corners-blurred.png", blurred);
  showImage("blurred", blurred);

  Mat thresholded;
  threshold(blurred, thresholded, 2, 255, THRESH_BINARY);
  cv::imwrite("corners-thresholded.png", thresholded);
  showImage("thresholded", thresholded);

  vector<Vec4f> lines;
  Mat linesSrc;
  Mat crossStructElem = getStructuringElement(MORPH_CROSS, Size(3, 3));
  erode(thresholded, linesSrc, crossStructElem, Point(-1, -1), 3);

  cv::imwrite("corners-eroded.png", linesSrc);
  showImage("eroded", linesSrc);

  if (true) {
    const int refineMode = LSD_REFINE_STD;
    const double scale = 0.8;
    const double sigmaScale = 0.6;
    const double quantErr = 2;
    const double angleToler = 30;
    const double logEps = 0;
    const double minDensity = 0.7;
    const int nBins = 2048;
    Ptr<LineSegmentDetector> lsd;
    lsd = createLineSegmentDetector(refineMode, scale, sigmaScale,
                                    quantErr, angleToler, logEps,
                                    minDensity, nBins);
    lsd->detect(linesSrc, lines);
  } else {
  
    const int lengthThreshold = 20;
    const double distanceThreshold = 1.4142;
    const double cannyTh1 = 50;
    const double cannyTh2 = 50;
    const int cannyAperture = 3;
    const bool doMerge = false;
    Ptr<FastLineDetector> fld = createFastLineDetector(lengthThreshold, distanceThreshold,
                                                       cannyTh1, cannyTh2, cannyAperture,
                                                       doMerge);
    fld->detect(linesSrc, lines);
  }

  cout << "lines.size=" << lines.size() << endl;

  for (size_t i = 0; i < lines.size(); ++i) {
    Point p1 = Point(lines[i][0], lines[i][1]);
    Point p2 = Point(lines[i][2], lines[i][3]);
    line(result, p1, p2, Scalar(0, 255, 0), 3, 8);
  }
  //  fld->drawSegments(result, lines);
#endif

  // Find and merge parallel lines less than lineEpsilon apart into
  // one line.

  // Show extracted horizontal lines
  cv::imwrite("corners.png", result);
  cout << "corners.png written" << std::endl;
  showImage("corners", result);

  fstream linesFS;
  linesFS.open("corners.lines.js", fstream::out | fstream::trunc);
  linesFS << "module.exports = [" << endl;

  for (size_t i = 0; i < lines.size(); ++i) {
    linesFS << "{x1: " << lines[i][0]
            << ", y1: " << lines[i][1]
            << ", x2: " << lines[i][2]
            << ", y2: " << lines[i][3]
            << "}," << endl;
  }
  
  linesFS << "];" << endl;
  linesFS.close();

  return 0;
}
