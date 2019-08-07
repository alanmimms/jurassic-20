import cv2
import numpy as np

def showImage(winName, image):
#    cv2.namedWindow(winName, cv2.WINDOW_NORMAL)
    cv2.namedWindow(winName)
    cv2.imshow(winName, image)
    cv2.waitKey(0)
    cv2.destroyWindow(winName)


# Loading image contains lines
#img = cv2.imread('../PNGs/kl10pv-014.png', cv2.IMREAD_COLOR)
img = cv2.imread('sudoku1.jpg', cv2.IMREAD_COLOR)

# Convert to grayscale for manipulation
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

# Apply adaptive thresholding to eroded image
kernel = np.ones((5, 5), np.uint8)
opened = cv2.morphologyEx(gray, cv2.MORPH_OPEN, kernel)
showImage("opened", opened)

# Apply Canny edge detection, return will be a binary image
edges = cv2.Canny(opened, 50, 150, apertureSize = 3)

#edges = cv2.adaptiveThreshold(opened, 255,
#                              cv2.ADAPTIVE_THRESH_GAUSSIAN_C,
#                              cv2.THRESH_BINARY, 11, -2)
showImage("edges", edges)

lines = cv2.HoughLines(edges,1,np.pi/180,300)
for rho,theta in lines[0]:
#    rho,theta = line
    a = np.cos(theta)
    b = np.sin(theta)
    x0 = a*rho
    y0 = b*rho
#    print(rho, theta*180/np.pi, x0, y0)
    xc = int(x0)
    yc = int(y0)
    x1 = int(x0 + 1000*(-b))
    y1 = int(y0 + 1000*(a))
    x2 = int(x0 - 1000*(-b))
    y2 = int(y0 - 1000*(a))

    cv2.line(img, (xc, yc-10), (xc, yc+10), (0, 255, 0), 2)
    cv2.line(img,(x1,y1),(x2,y2),(0,0,255),2)

#minLineLength = 100
#maxLineGap = 5

#lines = cv2.HoughLinesP(image = edges, rho = 1, theta = np.pi/2, threshold = 5,
#                        minLineLength = minLineLength, maxLineGap = maxLineGap)
#for line in lines[0]:
#    p1 = (line[0], line[1])
#    p2 = (line[2], line[3])
#    cv2.line(img, p1, p2, (0, 0, 255), 3)

#minLineLength = 200

# Apply Hough Line Transform, minimum length of line is 200 pixels
#lines = cv2.HoughLinesP(edges, 1, np.pi/180, minLineLength, None, 30, 1)

# Print and draw line on the original image
#for x0,y0,x1,y1 in lines[0]:
#  cv2.line(img, (x0,y0), (x1,y1), (0,0,255), 3, cv2.CV_AA)

# Show the result
showImage("Line Detection", img)
