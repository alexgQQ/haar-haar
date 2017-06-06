#############################################
#	Code to test detection with a USB camera
#############################################
import numpy as np
import cv2

# This is the cascade xml file made in training.
cascade = cv2.CascadeClassifier('Cascades\cascade.xml')

cap = cv2.VideoCapture(0)

lower = np.array([1, 1, 100])  #BGR
upper = np.array([70, 60, 200])
facial = False
color = False

n = 10
scaleF = 1.2
minSize = (50, 50)

while 1:
    ret, img = cap.read()
    det = cascade.detectMultiScale(img, scaleFactor=scaleF, minNeighbors=n, minSize=minSize, flags=cv2.CASCADE_SCALE_IMAGE)
    for (x,y,w,h) in det:
        cv2.rectangle(img,(x,y),(x+w,y+h),(127,255,0),2)
    
    cv2.imshow('OUT',img)
    k = cv2.waitKey(30) & 0xff
    if k == 27:
        break

cap.release()
cv2.destroyAllWindows()