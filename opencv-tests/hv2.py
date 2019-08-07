import numpy as np
import cv2
    

def show_wait_destroy(winname, img):
    cv2.namedWindow(winname, cv2.WINDOW_NORMAL)
    cv2.imshow(winname, img)
    cv2.moveWindow(winname, 500, 0)
    cv2.resizeWindow(winname, 2000, 1500)
    cv2.waitKey(0)
    cv2.destroyWindow(winname)


gray = cv2.imread('../PNGs/kl10pv-014.png')
out = cv2.cvtColor(src = gray, code = cv2.COLOR_GRAY2BGR, dstCn = 3)
edges = cv2.Canny(gray,50,150,apertureSize = 3)
#cv2.imwrite('edges-50-150.png',edges)

lines = cv2.HoughLinesP(image=edges,
                        rho=1,
                        theta=np.pi/180,
                        threshold=100,lines=np.array([]),
                        minLineLength=100,
                        maxLineGap=80)

a,b,c = lines.shape
for i in range(a):
    cv2.line(out,
             (lines[i][0][0],
              lines[i][0][1]),
             (lines[i][0][2],
              lines[i][0][3]),
             (0, 0, 255),
             3)

    cv2.imwrite('hv2-lines.png', out)
    cv2.imwrite('hv2-gray.png', gray)
    show_wait_destroy('lines', out)
