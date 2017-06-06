#############################################
#	Picture Detection Test
#############################################
#this will detect the object trained for in a set of images in a directory, usefull if you do not have a camera or want to see what it does on a range of images.
import numpy as np
import cv2
import os

#directory that holds test images for detection
testdir = 'Example\Directory'

#this is the cascade we just made. Call it what you want but the location needs to point to where the file is. 
cascade = cv2.CascadeClassifier('Cascades\cascade.xml')

lower = np.array([1, 1, 100])  #BGR
upper = np.array([70, 60, 200])
facial = False
color = False

n = 1
scaleF = 1.2
minSize = (20, 20)

for subdir, dirs, files in os.walk(testdir):
    for file in files:
        im = os.path.join(subdir, file)
        img = cv2.imread(im)
        det = cascade.detectMultiScale(img, scaleFactor=scaleF, minNeighbors=n, minSize=minSize, flags=cv2.CASCADE_SCALE_IMAGE)
        for (x,y,w,h) in det:
            cv2.rectangle(img,(x,y),(x+w,y+h),(127,255,0),2)
            cv2.line(img,(x,y+(h/2)),(x+w,y+(h/2)),(127,255,0),2)
            cv2.line(img,(x+(w/2),y),(x+(w/2),y+h),(127,255,0),2)
    
        cv2.imwrite(im, img)