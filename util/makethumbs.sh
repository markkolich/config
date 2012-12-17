#!/bin/sh

#########################################################################
# A simple script to change a directory of one type of images to another.
#   -- Garrett LeSage <garrett@linux.com>
#########################################################################
#		Yes, this is a hack, but it works pretty well.
#
#		  Note: you probably want to get "tidy" at:
#          http://www.w3.org/People/Raggett/tidy/
#	  (or just "apt-get install tidy" if using Debian)
#########################################################################

# Version of imgconvert
IMGCONVERT_VERSION=0.2


# The file format you wish to change
FROM=jpg

# The end result file format
TO=jpg

# Options for "convert"
CONVERT_OPTIONS='-quality 100'

# Pull the directory name for the title
DIR_NAME=`basename $PWD`

# Site name for the title
SITENAME="Linuxart.com"

# This is for the <title> area, and automatically pulls fromt the sitename,
# which can be edited directly above
TOPTITLE="$SITENAME - "

# General title
TITLE="My pictures: $DIR_NAME"

# Description
DESC="random pictures"

# Instructions for the viewer
INSTR="Clicking on the thumbnail will download the 640x480 version of 
the image.<br> Both pixel and file sizes are located under each 
picture."

# Page colors, fonts, etc
TEXT="#000000"
BGCOLOR="#ffffff"
LINK="#5555aa"
ALINK="#9999AA"
VLINK="#bbbbee"
FONT_FAMILY="helvetica,arial,sans-serif"

# This credits imgconvert, if you don't want to give credit (for whatever
# reason, I don't know), you can turn it off here. Default is "1". "0" will
# turn off the credit at the bottom.
CREDIT=0

#########################################################################
# The actual convertion stuff
# You can edit stuff below here to change how this works, or just stick
# with the variables above (which should be good for most people
#########################################################################

echo Running $0
echo

if [ ! -s "thumb/" ] 
then
	mkdir thumb
fi

if [ ! -s "640/" ]
then 	
	mkdir 640
fi

if [ ! -s "800/" ] 
then
	mkdir 800
fi

if [ ! -s "1024/" ]
then 	
	mkdir 1024
fi

if [ ! -s "1600/" ] 
then
	mkdir 1600
fi

### Header
echo "<html><head><title>$TOPTITLE$TITLE</title><style type=\"text/css\">" > index.html
echo "H1, P {font-family: $FONT_FAMILY}" >> index.html
echo "</style><meta name=\"generator\" content=\"imgconvert $IMGCONVERT_VERSION - http://linuxart.com/imgconvert/\"></head>" >> index.html
echo "<body bgcolor=\"$BGCOLOR\" text=\"$TEXT\"" >> index.html
echo "vlink=\"$VLINK\" link=\"$LINK\">" >> index.html
echo "<h1 align=\"center\">$TITLE</h1>" >> index.html
echo "<p align=\"center\">$DESC" >> index.html
echo "<p align=\"center\"><small>Instructions: <br> $INSTR</small>" >> index.html
echo "<p align=\"center\">[<a href=\"../\">back</a>]" >> index.html

### End Header

TABLE_START="<center><table border=0 cellspacing=5 cellpadding=7 align=center><tr>"

COUNT=0

for i in `ls *.$FROM`;
	do
	
	COUNTLOOP=`expr $COUNT \% 4`
	
	echo $COUNT   $COUNTLOOP
	if [ $COUNTLOOP -eq 0 ]
	then
		echo "</tr></table></center>$TABLE_START" >> index.html
		echo "4444"
	fi

	COUNT=`expr $COUNT + 1`

	echo "<td>" >> index.html

	CONVERT_OPTIONS='-quality 100 -geometry  100x75'
	_thumb=`basename $i $FROM`thumb.$TO
	if [ ! -s "thumb/$_thumb" ] 
	then
		echo Thumbnailing $i...
		echo      convert $CONVERT_OPTIONS $i $_thumb
		convert $CONVERT_OPTIONS $i thumb/$_thumb
	fi
	
	echo Converting $i...
	CONVERT_OPTIONS='-quality 100 -geometry  640x480'
	_640=`basename $i $FROM`640.$TO
	if [ ! -s "640/$_640" ] 
	then
		echo      convert $CONVERT_OPTIONS $i $_640
		convert $CONVERT_OPTIONS $i 640/$_640
	fi

	CONVERT_OPTIONS='-quality 100 -geometry  800x600'
	_800=`basename $i $FROM`800.$TO
	if [ ! -s "800/$_800" ]
	then
		echo      convert $CONVERT_OPTIONS $i $_800 
		convert $CONVERT_OPTIONS $i 800/$_800
	fi

	CONVERT_OPTIONS='-quality 100 -geometry  1024x768'
	_1024=`basename $i $FROM`1024.$TO
	if [ ! -s "1024/$_1024" ]
	then
		echo      convert $CONVERT_OPTIONS $i $_1024 
		convert $CONVERT_OPTIONS $i 1024/$_1024
	fi

	#CONVERT_OPTIONS='-quality 75 -geometry  1600x1200'
	_1600=`basename $i $FROM`1600.$TO
	if [ ! -s "1600/$_1600" ]
	then
	#	echo      convert $CONVERT_OPTIONS $i $_1600
	#	convert $CONVERT_OPTIONS $i 1600/$_1600
		cp -rv $i 1600/$_1600
	fi

echo "<p align=\"center\">" >> index.html
echo "<strong>$COUNT</strong>: <small>$i</small>" >> index.html
echo "<br>" >> index.html
echo "<a href=\"640/$_640\"><img src=\"thumb/$_thumb\"" >> index.html
echo "width=100 height=75 alt=\"$i\"></a><br>" >> index.html
echo "<font size=\"2\">" >> index.html

echo "<a href=\"640/$_640\">640x480</a>" >> index.html
SIZE=`du -sh 640/$_640 | cut -f 1`
echo "(${SIZE})  " >> index.html

echo "<br>" >> index.html

echo "<a href=\"800/$_800\">800x600</a>" >> index.html
SIZE=`du -sh 800/$_800 | cut -f 1`
echo "(${SIZE})  " >> index.html

echo "<br>" >> index.html

echo "<a href=\"1024/$_1024\">1024x768</a>" >> index.html
SIZE=`du -sh 1024/$_1024 | cut -f 1`
echo "(${SIZE})  " >> index.html

echo "<br>" >> index.html

echo "<a href=\"1600/$_1600\">1600x1200</a>" >> index.html
SIZE=`du -sh 1600/$_1600 | cut -f 1`
echo "(${SIZE})  " >> index.html

echo "</font>" >> index.html

echo "</td>" >> index.html

done;

echo "</td></tr></table>" >> index.html
echo "<p align=\"center\">[<a href=\"../\">back</a>]" >> index.html

#########################################################################
# Tagline at the bottom
# you can turn this off by toggling the "CREDIT" variable at the top
#########################################################################

if [ $CREDIT -eq 1 ]
	then
		echo "<p align=\"center\"><small>Generated by " >> index.html
		echo "<a href=\"http://linuxart.com/imgconvert/\">imgconvert" >> index.html
		echo " $IMGCONVERT_VERSION</a></small>" >> index.html
fi

############################

echo "</body></html>" >> index.html

exit;


