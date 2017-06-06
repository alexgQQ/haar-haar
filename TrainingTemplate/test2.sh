#!/bin/bash

#####################################################################################
# This is a custom script I made to take positiv images you import into "pos" and 
# creates more positive samples based on open cv
# it will itemize and vectorize each block of samples and feed them into a training function
# IT WILL TAKE SOME TIME DEPENDING ON THE STAGES AND IMAGES PROVIDED
#########################################################################################

rm -rf neg
mkdir neg
cp ./negBackup/* ./neg

rm -rf data
mkdir data

rm -rf positives.vec

rm -rf vectors
mkdir vectors

#####################################################################################
#	UPDATE FILE EXTENSIONS TO THE IMAGE FILE EXTENSIONS
#	IMAGES SHOULD HAVE THE SAME FILE EXTENSIONS
#########################################################################################

find ./pos -iname "*.jpeg" > posList.txt
find ./neg -iname "*.jpg" > negList.txt
mapfile -t positives < posList.txt

for file in "${positives[@]}"
do
	ext=".jpeg"
	remove="pos"
	lst=".lst"
	rem="./pos/"
	fileRemove="./pos"
	blank=""
	slash="/"
	vector="/vectors"
	p="./"
	vec=".vec"
	copy=${file//$fileRemove/$PWD}
	dirName=${copy//$ext/$slash}
	copy=${file//$ext/$lst}
	lstData=${copy//$rem/$dirName}
	copy=${file//$remove/$vector}
	copy1=${copy//$p/$PWD}
	vecLoc=${copy1//$ext/$vec}
	
	echo $dirName
	echo $file
	echo $lstData
	echo $vecLoc

	rm -rf $dirName
	
	mkdir -p $dirName	
	
	###############################################################################################################
	#MAKE NOTE OF THE "-num" AS IT WILL MAKE THAT MANY NEW POSITIVE IMAGES FOR EACH MANUAL IMAGE PROVIDED IN "pos"
	#FOR REFERENCE I PUT 10 IMAGES IN "pos" SO THE BELOW GENERATES 2000 POSITIVE SAMPLES
	#MAKE NOTE OF "-w" and "-h" AS THEY SHOULD BE UNDER 50ish AND NEED TO MATCH THE SAME FLAGS IN THE "opencv_traincascade" function
	#################################################################################################################
	
	opencv_createsamples -img $file -bg negList.txt -info $lstData -pngoutput $dirName -maxxangle 0.5 -maxyangle 0.5 -maxzangle 0.5 -num 200
	opencv_createsamples -info $lstData -num 200 -w 20 -h 20 -vec $vecLoc
done

#############################################################################################
#numPos should be double of numNeg,
#make sure enough images are present for the training as those two flags represent how many images will be used for negative and positive samples
#-numStages will dictate how many stages it will run
#############################################################################################

python mergevec.py -v vectors -o positives.vec
opencv_traincascade -data data -vec positives.vec -bg negList.txt -featureType HAAR -numPos 3000 -numNeg 1500 -numStages 15 -minHitRate 0.999 -maxFalseAlarmRate 0.5 -w 20 -h 20

