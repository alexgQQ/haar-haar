################################################################################################
#
#	Video Detection Test
#
###############################################################################################
#
#	This will detect the object trained for from a USB video feed.
#	Usefull to see the detection in real time. 
#	Press ESC to close the camera window when using.
#
###############################################################################################

import numpy as np
import cv2
import argparse

parser = argparse.ArgumentParser(description='Will use a XML cascade file generated from OpenCV Haar training to detect objects. Supply a target directory of images to test. A box will be drawn around detection points. The images in the directory will be overwritten.')

parser.add_argument("xml",
			help="Location of cascade xml file")

args = parser.parse_args()

cascade = cv2.CascadeClassifier(args.xml)

cap = cv2.VideoCapture(0)		#	Camera ID, defaults to the first camera detected

#############################################
#	Tunable variables to check for
#############################################

n = 10					#	Number of neighbors that the detector will validate against. 
						#	The higher the numnber, the more noise is filtered but may miss a target.

scaleF = 1.2			#	Scale factor of the trained object to detect for

minSize = (50, 50)		#	Minimum size of the target object trained for. 
						# 	Should match the size that the image was trained on.

while 1:
    ret, img = cap.read()
    det = cascade.detectMultiScale(img, scaleFactor=scaleF, minNeighbors=n, minSize=minSize, flags=cv2.CASCADE_SCALE_IMAGE)
    for (x,y,w,h) in det:
        cv2.rectangle(img,(x,y),(x+w,y+h),(127,255,0),2)
    
    cv2.imshow('OUT',img)
    k = cv2.waitKey(30) & 0xff		#	Press ESC to close the camera window when using.
    if k == 27:
        break

cap.release()
cv2.destroyAllWindows()