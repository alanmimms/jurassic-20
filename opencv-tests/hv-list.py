"""
@file get list of horizontal and vertical lines
"""

import sys
import cv2
import numpy as np


def show_wait_destroy(winname, img):
    cv2.namedWindow(winname, cv2.WINDOW_NORMAL)
    cv2.imshow(winname, img)
    cv2.moveWindow(winname, 500, 0)
    cv2.resizeWindow(winname, 2000, 1500)
    cv2.waitKey(0)
    cv2.destroyWindow(winname)


def main(argv):
    # [load_image]
    # Check number of arguments
    if len(argv) < 1:
        print ('Not enough parameters')
        print ('Usage:\nhv.py < path_to_image >')
        return -1
    # Load the image
    src = cv2.imread(argv[0], cv2.IMREAD_COLOR)
    # Check if image is loaded fine
    if src is None:
        print ('Error opening image: ' + argv[0])
        return -1

    # Apply Canny edge detection, return will be a binary image
    edges = cv2.Canny(src,50,100,apertureSize = 3)
    # Apply Hough Line Transform, minimum lenght of line is 200 pixels
    lines = cv2.HoughLines(edges,1,np.pi/180,200)
    # Print and draw line on the original image
    for rho,theta in lines[0]:
     print(rho, theta)
     a = np.cos(theta)
     b = np.sin(theta)
     x0 = a*rho
     y0 = b*rho
     x1 = int(x0 + 1000*(-b))
     y1 = int(y0 + 1000*(a))
     x2 = int(x0 - 1000*(-b))
     y2 = int(y0 - 1000*(a))
     cv2.line(img,(x1,y1),(x2,y2),(0,0,255),2)

    # Show the result
    cv2.imshow("Line Detection", img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
    return 0





import numpy as np
import sys
import cv2

def show_wait_destroy(winname, img):
    cv2.namedWindow(winname, cv2.WINDOW_NORMAL)
    cv2.imshow(winname, img)
    cv2.moveWindow(winname, 500, 0)
    cv2.resizeWindow(winname, 2000, 1500)
    cv2.waitKey(0)
    cv2.destroyWindow(winname)

def main(argv):
    # [load_image]
    # Check number of arguments
    if len(argv) < 1:
        print ('Not enough parameters')
        print ('Usage:\nhv.py < path_to_image >')
        return -1

    # Load the image
    src = cv2.imread(argv[0], cv2.IMREAD_COLOR)

    # Check if image is loaded fine
    if src is None:
        print ('Error opening image: ' + argv[0])
        return -1

    # Show source image
    cv2.namedWindow("src", cv2.WINDOW_NORMAL)
    cv2.imshow("src", src)

    # [load_image]
    # [gray]
    # Transform source image to gray if it is not already
    if len(src.shape) != 2:
        result = src
        gray = cv2.cvtColor(src, cv2.COLOR_BGR2GRAY)
    else:
        result = cv2.cvtColor(src, cv2.COLOR_GRAY2BGR)
        gray = src
    
    # Apply Canny edge detection, returns binary image
    edges = cv2.Canny(gray, 50, 100, apertureSize = 3)

    # Apply Hough Line Transform with min length of lines of 200 pixels
    lines = cv2.HoughLines(edges, 1, np.pi/180, 200)

    for rho, theta in lines[0]:
        print(rho, theta)
        a = np.cos(theta)
        b = np.sin(theta)
        x0 = a*rho
        y0 = b*rho
        x1 = int(x0 + 1000*(-b))
        y1 = int(y0 + 1000*(a))
        x2 = int(x0 - 1000*(-b))
        y2 = int(y0 - 1000*(a))
        cv2.line(result, (x1, y1), (x2, y2), (0, 0, 255), 2)

    # Show result
    show_wait_destroy("result", result)

    return 0

if __name__ == "__main__":
    main(sys.argv[1:])
