#!/bin/bash

FILE_DIR="/home/$USER/praktikum_tka_no.2"

if [ -d $FILE_DIR ]; then
  echo "directory exist."
else
  mkdir $FILE_DIR
fi

cd $FILE_DIR

wget -q --no-check-certificate 'https://docs.google.com/uc?export=download&id=1oGHdTf4_76_RacfmQIV4i7os4sGwa9vN' -O genshin.zip

unzip -q genshin.zip
unzip -q genshin_character.zip

if [ -d genshin_character ]; then
  cd genshin_character
else
  echo "Error: genshin_character directory not found after unzipping."
  exit 1
fi

for file in *.jpg; do
  new_name=$(echo "$file" | xxd -p -r)
  mv "$file" "$new_name".jpg
done

dos2unix $FILE_DIR/list_character.csv

while IFS="," read -r col1 col2 col3 col4; do
  for file in *.jpg; do
    if [ "$file" == "$col1".jpg ]; then
      mv "$file" "$col2 - $col1 - $col3 - $col4".jpg
    fi
  done
done < $FILE_DIR/list_character.csv


for file in *.jpg; do 
  dir_name=$(echo "$file" | cut -d "-" -f1)
  if [ -d $dir_name ]; then
    cp "$file" $FILE_DIR/genshin_character/$dir_name
  else
    mkdir $dir_name
    cp "$file" $FILE_DIR/genshin_character/$dir_name
  fi
done

claymore=$(ls | grep -o "Claymore" | wc -l)
echo "Claymore : $claymore"

sword=$(ls | grep -o "Sword" | wc -l)
echo "Sword : $sword"

polearm=$(ls | grep -o "Polearm" | wc -l)
echo "Polearm : $polearm"

catalyst=$(ls | grep -o "Catalyst" | wc -l)
echo "Catalyst : $catalyst"

bow=$(ls | grep -o "Bow" | wc -l)
echo "Bow : $bow"

cd $FILE_DIR
rm genshin.zip && rm genshin_character.zip && rm list_character.csv


exec bash