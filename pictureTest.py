################################################################################################
#
#	Picture Detection Test
#
###############################################################################################
#
#	This will detect the object trained for in a set of images in a directory, 
#	usefull if you do not have a camera or want to see what it does on a range of images.
#
###############################################################################################
import numpy as np
import cv2
import os
import argparse

parser = argparse.ArgumentParser(description='Will use a XML cascade file generated from OpenCV Haar training to detect objects. Supply a target directory of images to test. A box will be drawn around detection points. The images in the directory will be overwritten.')

parser.add_argument("directory",
			help="Directory address of images to test")

parser.add_argument("xml",
			help="Location of cascade xml file")

args = parser.parse_args()

cascade = cv2.CascadeClassifier(args.xml)

#############################################
#	Tunable variables to check for
#############################################

n = 1					#	Number of neighbors that the detector will validate against. 
						#	The higher the numnber, the more noise is filtered but may miss a target.

scaleF = 1.2			#	Scale factor of the trained object to detect for

minSize = (20, 20)		#	Minimum size of the target object trained for. 
						# 	Should match the size that the image was trained on.

for subdir, dirs, files in os.walk(args.directory):
    for file in files:
        im = os.path.join(subdir, file)
        img = cv2.imread(im)
        det = cascade.detectMultiScale(img, scaleFactor=scaleF, minNeighbors=n, minSize=minSize, flags=cv2.CASCADE_SCALE_IMAGE)
        for (x,y,w,h) in det:
            cv2.rectangle(img,(x,y),(x+w,y+h),(127,255,0),2)
            cv2.line(img,(x,y+(h/2)),(x+w,y+(h/2)),(127,255,0),2)
            cv2.line(img,(x+(w/2),y),(x+(w/2),y+h),(127,255,0),2)
    
        cv2.imwrite(im, img)