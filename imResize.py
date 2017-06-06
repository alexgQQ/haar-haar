#############################################
#	Code to resize images in a Directory
#############################################
import os
import cv2
rootdir = "Example/Directory"

for subdir, dirs, files in os.walk(rootdir):
    for file in files:
        im = os.path.join(subdir, file)
        print im
        image = cv2.imread(im)
        out = cv2.resize(image, (50, 50))
        cv2.imwrite(im, out)