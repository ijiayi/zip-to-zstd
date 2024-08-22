#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <input_file.zip>"
  exit 1
fi

# Assign input filename to a variable
input_zip="$1"

# Check if the input file exists
if [ ! -f "$input_zip" ]; then
  echo "File not found: $input_zip"
  exit 1
fi

# Extract the base name of the file (without extension)
base_name=$(basename "$input_zip" .zip)

# Create a temporary directory to extract the zip contents
# temp_dir=$(mktemp -d)
temp_dir=$(pwd)/tmp

# Extract the contents of the zip file to the temporary directory
unzip "$input_zip" -d "$temp_dir"

# Exclude list
tar_exclude="--exclude=.DS_Store --exclude=.localized --exclude=._* --exclude=.FBC* --exclude=.Spotlight-V100 --exclude=.Trash --exclude=.Trashes --exclude=.background --exclude=.TemporaryItems --exclude=.fseventsd --exclude=.com.apple.timemachine.* --exclude=.VolumeIcon.icns --exclude=__MACOSX"

# Compress the extracted files using zstd
output_file="${base_name}.tar.zst"
tar -C "$temp_dir" $tar_exclude -cf - . | zstd -19 -o "$output_file"

# Clean up the temporary directory
rm -rf "$temp_dir"

echo "Compression complete. Output file: $output_file"
