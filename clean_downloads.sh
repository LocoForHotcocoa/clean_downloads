#!/bin/bash

EXT_AUDIO=("mp3" "wav" "raw")
EXT_VIDEO=("mp4" "mov" "mkv")
EXT_IMG=("png" "jpg" "jpeg" "gif" "svg" "heic" "tif" "tiff")
EXT_DOC=("txt" "pdf" "csv" "xls" "xlsx" "doc" "docx" "html" "ppt" "pptx")
EXT_COMPR=("zip" "7z" "rar" "tar" "gz" "pkg" "deb")

DEST_DIRS=("Music" "Movies" "Pictures" "Documents" "Compressed" "Misc")
DOWNLOAD_DIR="$HOME/Downloads"

# create downloads directories if not already created
for t in ${DEST_DIRS[@]}; do
	mkdir -p "$DOWNLOAD_DIR/$t"
done

move_files() {
	# jeez dude, find command is good!
	# you use find -iname to search all files,
	# then use -exec to feed that result into another command!
	local ext_array=("${!1}")
	local dest_dir="$2"

	for ext in "${ext_array[@]}"; do
		find "$DOWNLOAD_DIR" -maxdepth 1 -iname "*.$ext" -exec mv {} "$DOWNLOAD_DIR/$dest_dir/" \;
	done
}

move_files EXT_AUDIO[@] "Music"
move_files EXT_VIDEO[@] "Movies"
move_files EXT_IMG[@] "Pictures"
move_files EXT_DOC[@] "Documents"
move_files EXT_COMPR[@] "Compressed"


# build our exclude path arguments for eval statement
exclude_paths="! -path $DOWNLOAD_DIR "

for dir in "${DEST_DIRS[@]}"; do
	exclude_paths+="! -path $DOWNLOAD_DIR/$dir "
done

# echo $exclude_paths

# move all remaining *files* into misc folder
find "$DOWNLOAD_DIR" -maxdepth 1 -type f -exec mv {} "$DOWNLOAD_DIR/Misc/" \;

# move all remaining folders into misc folder (excluding all other folders, and itself!!)
eval "find \"$DOWNLOAD_DIR\" -maxdepth 1 -type d $exclude_paths -exec mv {} \"$DOWNLOAD_DIR/Misc/\" \;"

echo "done!"