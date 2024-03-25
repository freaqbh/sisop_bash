#!/bin/bash

FILE_DIR="/home/$USER/praktikum_tka_no.2"

if [ -d $FILE_DIR ]; then
    echo "directory exist."
else
    mkdir $FILE_DIR
fi

cd $FILE_DIR

if [ -d genshin_character ]; then
    cd genshin_character
else
    echo "Error: genshin_character directory not found after unzipping."
    exit 1
fi

pass=""

for file in *.jpg; do
    steghide extract -q -sf "$file" -p "$pass"
done

for file in *.txt; do
    base64 -d "$file" > secret.txt
    regex='(https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]'
    string=$(cat secret.txt)
    if [[ $string =~ $regex ]]; then 
        mv secret.txt $FILE_DIR
        echo "[$(date '+%Y/%M/%d %H:%M:%S')] [FOUND] [$FILE_DIR/genshin_character/$file]" >> image.log
        break
    else
        echo "[$(date '+%Y/%M/%d %H:%M:%S')] [NOT FOUND] [$FILE_DIR/genshin_character/$file]" >> image.log
    fi
    rm "$file"
    sleep 1
done

for file in *.txt; do
    rm "$file"
done

mv image.log $FILE_DIR

cd $FILE_DIR

secret_link=$(cat "secret.txt")

wget -O gambar.jpg "$secret_link"

exec bash
