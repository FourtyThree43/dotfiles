#!/usr/bin/env bash

# Source directories
src_dirs=("src1/" "src2/" "src3/")

# Destination directory
dest_dir="/mnt/d/backup/dest/"

# Directories to exclude
exclude_dirs=(".git/" "test00/" "test01/" "test02/")

# Loop through source directories and perform rsync
for dir in "${src_dirs[@]}"; do
	rsync -v --recursive --update --progress "${exclude_dirs[@]/#/--exclude=}" "$dir" "$dest_dir"
done
