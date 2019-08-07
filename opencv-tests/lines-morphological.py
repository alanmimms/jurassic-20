import sys
import cv2
import numpy as np

def showImage(winName, image):
    cv2.namedWindow(winName, cv2.WINDOW_NORMAL)
#    cv2.namedWindow(winName)
    cv2.imshow(winName, image)
    cv2.waitKey(0)
    cv2.destroyWindow(winName)


def main(argv):
    # [load_image]
    # Check number of arguments
    if len(argv) < 1:
        print ('Not enough parameters')
        print ('Usage:\nhv.py < path_to_image >')
        return -1

    # Load the image
    img = cv2.imread(argv[0], cv2.IMREAD_COLOR)

    # Convert to inverted grayscale for manipulation
    gray = cv2.bitwise_not(cv2.cvtColor(img, cv2.COLOR_BGR2GRAY))

    th2 = cv2.adaptiveThreshold(gray, 255,
                                cv2.ADAPTIVE_THRESH_MEAN_C,
                                cv2.THRESH_BINARY,
                                15, -2)

    horz = th2
    vert = th2

    rows,cols = horz.shape
    hSize = cols/30
    hStruct = cv2.getStructuringElement(cv2.MORPH_RECT, (hSize, 1))
    horz = cv2.erode(horz, hStruct, (-1, -1))
    horz = cv2.dilate(horz, hStruct, (-1, -1))

    vSize = rows/30
    vStruct = cv2.getStructuringElement(cv2.MORPH_RECT, (1, vSize))
    vert = cv2.erode(vert, vStruct, (-1, -1))
    vert = cv2.dilate(vert, vStruct, (-1, -1))

    zeros = np.zeros((rows, cols), dtype = np.uint8)
    blended = cv2.merge([horz, vert, zeros], img);
    blended = cv2.add(src1 = blended, src2 = img, dst = blended)
    showImage("blended", blended)

if __name__ == "__main__":
    main(sys.argv[1:])
