#!/bin/bash

################################################################################################
#
# 	This is a custom script I made to take positiv images you import into "pos" and 
# 	creates more positive samples based on open cv
# 	it will itemize and vectorize each block of samples and feed them into a training function
# 	IT WILL TAKE SOME TIME DEPENDING ON THE STAGES AND IMAGES PROVIDED
#
#################################################################################################
#
#	SAVE THE "data" DIRECTORY IF THE TRAINING WAS DESIREABLE BEFORE RUNNING AGAIN.
#	THE TEMPLATE WILL BE CLEANED AND REGENRATED IN THE SECTION BELOW.	
#
#################################################################################################

echo -n "Make sure prior training data is saved before continuing. Prior training will be removed once ran further."

echo -n "Please enter number of training stages: "
read stages

echo -n "Please enter desired number of positive samples: "
read initPos

echo -n "Please enter desired number of positive samples: "
read initPos

echo -n "Please enter image training height: "
read height

echo -n "Please enter image training width: "
read width

echo -n "Clearing working directory..."

rm -rf neg
rm -rf data
rm -rf positives.vec
rm -rf vectors

echo -n "Regenerating initial test directory..."

mkdir neg
cp ./negBackup/* ./neg
mkdir data
mkdir vectors

##########################################################################################
#
#	UPDATE FILE EXTENSIONS TO THE IMAGE FILE EXTENSIONS
#	IMAGES IN EACH DIRECTORY SHOULD HAVE THE SAME FILE EXTENSIONS
#
#########################################################################################

echo -n "Indexing positive and negative images..."

num_of_neg_samples = ls -1q ./pos | wc -l
initial_positives = ls -1q ./neg | wc -l

find ./pos -iname "*.jpeg" > posList.txt
find ./neg -iname "*.jpg" > negList.txt
mapfile -t positives < posList.txt

echo -n "Generating new positive samples..."
samples_per_image = $(( $initPos / $initial_positives))

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
	
	opencv_createsamples -img $file -bg negList.txt -info $lstData -pngoutput $dirName -maxxangle 0.5 -maxyangle 0.5 -maxzangle 0.5 -num $samples_per_image
	opencv_createsamples -info $lstData -num $samples_per_image -w $width -h $height -vec $vecLoc
done

#############################################################################################
#numPos should be double of numNeg,
#make sure enough images are present for the training as those two flags represent how many images will be used for negative and positive samples
#-numStages will dictate how many stages it will run
#############################################################################################

echo -n "Merginf vector files..."

python mergevec.py -v vectors -o positives.vec

echo -n "Starting training..."
trainNeg = $(( $initPos / 2 ))
opencv_traincascade -data data -vec positives.vec -bg negList.txt -featureType HAAR -numPos $initPos -numNeg $trainNeg -numStages $stages -minHitRate 0.999 -maxFalseAlarmRate 0.5 -w 20 -h 20

