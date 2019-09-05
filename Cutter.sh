#!/bin/bash

URL=$1
THRESHOLD=$2

FILENAME=$(youtube-dl $URL --no-overwrites --restrict-filenames --format mp4 --get-filename --no-continue)
youtube-dl $URL --no-overwrites --restrict-filenames --format mp4 --no-continue

rm -r TEMP 

# Corta o video em partes menores de 5 minutos cada

DIR="${FILENAME%.*}"

if ! [ -d $DIR ]; then
    mkdir $DIR
    ffmpeg -i $FILENAME -c copy -map 0 -segment_time 00:05:00 -f segment $DIR/${FILENAME%.*}_part_%d_.mp4
fi
    
FILES=${FILENAME%.*}/${FILENAME%.*}_part_*_.mp4

for f in $FILES
do
    
    python3 jumpcutter.py --input_file $f --output_file ${f%_.*}_CUTTED.mp4 --silent_threshold $THRESHOLD --sounded_speed 1.5 && rm $f
    
done

