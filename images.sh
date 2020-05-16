#!/usr/bin/env bash

set -ex

find assets -iname "*.original.jpg" -o -iname "*.original.png"|while read -r infile; do
  outfile=${infile/.original/}
  outfile=${outfile/.png/.jpg}
  magick "$infile" -resize 500 -quality 85% "$outfile"
done

find assets/sidebar-bg -iname "*.original.jpg" -o -iname "*.original.png"|while read -r infile; do
  outfile=${infile/.original/}
  outfile=${outfile/.png/.jpg}
  magick "$infile" -resize 900 -quality 50% "$outfile"
done

find assets/screenshots -iname "*.original.jpg" -o -iname "*.original.png"|while read -r infile; do
  outfile=${infile/.original/}
  outfile=${outfile/.png/.jpg}
  magick "$infile" -resize 1140 -quality 85% "$outfile"
done

sizes=(16 32 64 128 180 192 256 340 400 420 580 700 )
for size in "${sizes[@]}"
do
  magick assets/craig-square.original.jpg -resize "$size" -quality 85% "assets/craig-square-$size.jpg"
done

magick assets/craig.original.jpg -resize 500 -quality 85% assets/craig.jpg
