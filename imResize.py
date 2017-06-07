#############################################
#	Code to resize images in a Directory
#############################################
import os
import cv2
import argparse

parser = argparse.ArgumentParser(description='Resize images in a given directory to given size.')

parser.add_argument("directory",
			help="Directory address of images to resize")

parser.add_argument('--height', type=int, default=50,
            help="New height of the image in pixels")

parser.add_argument('--width', type=int, default=50,
            help="New width of the image in pixels")

args = parser.parse_args()

for subdir, dirs, files in os.walk(args.directory):
    for file in files:
        im = os.path.join(subdir, file)
        print im
        image = cv2.imread(im)
        out = cv2.resize(image, (args.width, args.height))
        cv2.imwrite(im, out)