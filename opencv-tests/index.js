const cv = require('opencv');

const lowThresh = 0;
const highThresh = 100;
const nIters = 2;
const minArea = 20;

const THREE_COLOR = [  0, 255,   0]; // B, G, R
const OTHER_COLOR = [255,   0, 255]; // B, G, R
const FOUR_COLOR  = [  0,   0, 255]; // B, G, R
const LINE_COLOR  = [255, 255,   0]; // B, G, R


cv.readImage("../PNGs/kl10pv-014.png", function(err, im){
  console.log(`readImage callback err=${err}, im=${im}`);

  if (err) throw err;

  const width = im.width();
  const height = im.height();
  if (width < 1 || height < 1) throw new Error('Image has no size');

  const hImage = im.clone();
  const vImage = im.clone();

  const hSize = 50;
  const vSize = 50;
  const hStruct = cv.imgproc.getStructuringElement(0, [hSize, 1]);
  const anchor = new cv.Point(-1, -1);
  hImage.erode(hStruct, anchor);
  hImage.dilate(hStruct, anchor);
  const hWindow = new cv.NamedWindow('horizontal');
  hWindow.show(out);
  hWindow.blockingWaitKey();

  const vStruct = cv.imgproc.getStructuringElement(0, [1, vSize]);
  vImage.erode(vStruct, anchor);
  vImage.dilate(vStruct, anchor);
  const vWindow = new cv.NamedWindow('vertical');
  vWindow.show(out);
  vWindow.blockingWaitKey();

  const out = im.clone();
  out.cvtColor('CV_GRAY2BGR');

  out.save('./tmp/detect-shapes.png');
  console.log('Image saved to ./tmp/detect-shapes.png');

  const window = new cv.NamedWindow('shapes');
  window.show(out);
  window.blockingWaitKey();
})
