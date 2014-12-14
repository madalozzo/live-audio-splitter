#!/bin/bash

#LineIn Splitter v1.2 Dec 2014
#Saulo Matte Madalozzo saulo.zz@gmail.com

#Shell script to create audio files from line-in or mic, compressed in mp3 or ogg with configurable quality, size and duration

# ----------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <saulo.zz@gmail.com> wrote this file.  As long as you retain this notice you
# can do whatever you want with this stuff. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return. Saulo Matte Madalozzo
# ----------------------------------------------------------------------------

#To use this script you will need to install vorbis-tools, sox and lame:
#sox to record sound, lame to compress to mp3 file type and vorbis-tools to compress to ogg.
#sudo apt-get install vorbis-tools sox lame

#This shell script captures sound from line in or mic, write this to a wav file and converts to mp3 or ogg. Once finished, it calls itself again to continue.
#Attention: The terminal can be blocked by this script and ctrl+c won't work, in this case you must open another terminal and execute this program with --kill parameter. This parameter will kill all instances




#default config start
	TEMP_FOLDER=temp
	FOLDER=linein

	QUALITY_OGG=2,5
	#in kbps
	QUALITY_MP3=96

	TAG_ARTIST="Virtual FM 104.7"
	TAG_GENDER="Live Record"
	TAG_COMMENT="github.com/madalozzo/live-audio-splitter"
#default config end

if [ "$1" = "--kill" ]; then
	killall linein-splitter
	killall rec
	killall rec
	killall rec
        exit	
fi

createFolderIfNotExist(){
	if [ ! -d "$1" ];
		then
		mkdir $1
		chmod 777 $1
	fi
}

showHelp(){
	echo ""
	echo "LineIn Splitter v1.2 Dec 2014 - Saulo Matte Madalozzo <saulo.zz@gmail.com>"
	echo ""
	echo "	Usage:  ./linein-splitter [TIME] [FILE TYPE]"
	echo "		TIME: Time for each record in milisseconds"
	echo "		FILE TYPE: use --ogg for oggVorbis and --mp3 for mp3 files"
	echo "To kill all instances: ./linein-splitter --kill"
	echo "Edit this file and change 'default config' to change other options"
	echo ""
	exit
}

createFolderIfNotExist $TEMP_FOLDER
createFolderIfNotExist $FOLDER

if [ "$1" = "" ]; then
	showHelp
fi

if [ "$2" = "" ]; then
	showHelp
fi

YEAR=`date +%Y`
MONTH=`date +%B`
MONTHB=`date +%m`
DAY=`date +%d`
DAYB=`date +%d`
DAYC=`date +%d' - '%a`
HOUR=`date +%H`
MINUTE=`date +%M`
SECOND=`date +%S`


FILE_NAME_TEMP=temp_$MONTH'-'$DAYB'_'$HOUR'-'$MINUTE'-'$SECOND

#recording...
rec -c 1 --rate 44100 $TEMP_FOLDER/$FILE_NAME_TEMP.wav trim 0 $1

#call another rec instance to continue
./linein-splitter $1 $2&

#wait a little
sleep 5

#final file name
TAG_TITLE="$YEAR / $MONTHB / $DAYB - $HOUR : $MINUTE : $SECOND"
TAG_ALBUM="$YEAR - $MONTHB - $DAYB"
FILE_NAME=$HOUR'-'$MINUTE'-'$SECOND

createFolderIfNotExist $FOLDER/$YEAR
createFolderIfNotExist $FOLDER/$YEAR/$MONTH
createFolderIfNotExist $FOLDER/$YEAR/$MONTH/$DAY

#final file in ogg
if [ "$2" = "--ogg" ]; then
	oggenc  $TEMP_FOLDER/$FILE_NAME_TEMP.wav -q $QUALITY_OGG -o $FOLDER/$YEAR/$MONTH/$DAY/$FILE_NAME.ogg -t "$TAG_TITLE" -a "$TAG_ARTIST" -l "$TAG_ALBUM" -G "$TAG_GENDER" -c "COMMENT=$TAG_COMMENT" -c "ENCODED-BY=OggEnc - linein-splitter"
fi

#final file in mp3
if [ "$2" = "--mp3" ]; then
	lame -a -b $QUALITY_MP3  --tt "$TAG_TITLE" --ta "$TAG_ARTIST" --tl "$TAG_ALBUM" --ty "$YEAR" --tc "$TAG_COMMENT" --tg "live" $TEMP_FOLDER/$FILE_NAME_TEMP.wav $FOLDER/$YEAR/$MONTH/$DAY/$FILE_NAME.mp3
fi

#delete temp file
rm $TEMP_FOLDER/$FILE_NAME_TEMP.wav
