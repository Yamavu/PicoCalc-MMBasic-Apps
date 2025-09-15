#!/bin/bash

# Companion to Picocalc Player Script player.bas
# Copyright (C) 2025 Yamavu
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# this script shoud be placed in root of SD Card

# convert mp3 using ffmpeg and move to ./music/ folder on the SD card
# Path should be: /music/<album>/<track>.mp3
# not sure about the specifics yet

# convert album art to BMP 180x180x24bit using imagemagick v5 or v6

# check ffmpeg exists, copy otherwise
# check imagemagick exists

usage() {
    echo "Usage: $0 <source_folder> <destination_folder>"
    echo "  <source_folder>: The source directory containing an album image and mp3s."
    echo "  <destination_folder>: The directory to save the processed BMP file and optimized mp3s."
    exit 1
}

if [ -z "$1" ] || [ -z "$2" ]; then
    usage
fi

SRC_DIR="$1"
DEST_DIR="$2"

if [ ! -d "$SRC_DIR" ]; then
    echo "Error: Source directory '$SRC_DIR' does not exist."
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    mkdir -p "$DEST_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create destination directory '$DEST_DIR'."
        exit 1
    fi
fi

ALBUM_ART_IN=$(find "$SRC_DIR" -maxdepth 1 -type f \
  -iname "*.jpg" -o \
  -iname "*.jpeg" -o \
  -iname "*.png" -o \
  -iname "*.webp" | sort | head -n 1)

if [ -z "$ALBUM_ART_IN" ]; then
    echo "No jpg, png, or webp images found in '$SRC_DIR'."
    exit 0
fi

FILENAME=$(basename -- "$ALBUM_ART_IN")
FILENAME_NO_EXT="${FILENAME%.*}"

ALBUM_ART_DEST="$DEST_DIR/$FILENAME_NO_EXT.bmp"

convert "$ALBUM_ART_IN" -resize '180x180^' -gravity center \
  -crop '180x180+0+0' +repage -resize 180x180 "$ALBUM_ART_DEST"
  
if [ $? -eq 1 ]; then
    echo "Error: ImageMagick conversion failed."
    exit 1
fi

exit 0