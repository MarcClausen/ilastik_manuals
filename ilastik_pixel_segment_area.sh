#!/bin/bash
# Marc Mathias Clausen 2018
#
# ARGUMENTS..
# 1 : absolute path to run_ilastik.sh
# 2 : Name or absolute path to project file (.ilp)
# 3 : Path to folder containing ONLY the input images (ends like / )
# 4 : number of labels used

DATE=$(date +%Y%m%d_%H%M%S)
absoluteilastik=$1
inputfiles=""$3""*
project=$2
outputdir=./""$DATE""_ilastik/
output="$outputdir"{nickname}_results.jpeg
labels=$4
echo $DATE

sh $absoluteilastik --headless	\
		--export_source="Simple Segmentation" 				\
		--project=$project						\
		--export_dtype=uint8						\
                --output_format=jpeg						\
                --output_filename_format=$output				\
		--pipeline_result_drange="(0.0, ""$labels"".0)" 		\
		--export_drange="(0, 255)" 					\
                $inputfiles

FILES=""$outputdir""*.jpeg
for f in $FILES
do
  echo "Measuring $f ..."
  echo "Saving Data from $f ..."
  convert $f +dither -colors $labels -define histogram:unique-colors=true -format "%f\n%c\n" histogram:info:			\
| sed -e 's/^[[:space:]]*//' | cut -f1 -d":" | paste -s >> ""$outputdir""""$DATE""_nice_data.txt
done

# The output will be shown as top label from ilastik being the 
# value of the first column, second from the top is second column etc.
# the white color of the output directory images corresponds to the bottom label in ilastik
