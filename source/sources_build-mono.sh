#!/bin/sh

#===========================================================================
#Update this variable ==========================================================

thisFont="XanhMono"  #must match the name in the font file

#===========================================================================
#Generating fonts ==========================================================

#source ../env/bin/activate
set -e

#echo "CLEAN FONTS FOLDERS"
#rm -rf ./fonts/ttf/ ./fonts/otf/ ./fonts/variable/ ./fonts/webfonts/

echo ".
GENERATING STATIC TTF
."
mkdir -p /Users/gabriel/Documents/fonts
fontmake -g /Users/gabriel/Documents/Glyphs/XanhMonoRoman.glyphs  -i -o ttf --output-dir /Users/gabriel/Documents/fonts/ttf

echo ".
GENERATING STATIC OTF
."
mkdir -p /Users/gabriel/Documents/fonts
fontmake -g /Users/gabriel/Documents/Glyphs/XanhMonoRoman.glyphs  -i -o otf --output-dir /Users/gabriel/Documents/fonts/otf

#============================================================================
#Post-processing fonts ======================================================

echo ".
POST-PROCESSING TTF
."
ttfs=$(ls /Users/gabriel/Documents/fonts/ttf/XanhMono-Regular.ttf)
echo XanhMono-Regular.ttf
for ttf in $ttfs
do
	gftools fix-dsig --autofix $ttf
	ttfautohint $ttf $ttf.fix
	[ -f $ttf.fix ] && mv $ttf.fix $ttf
	gftools fix-hinting $ttf
	[ -f $ttf.fix ] && mv $ttf.fix $ttf
done


echo ".
POST-PROCESSING OTF
."
otfs=$(ls /Users/gabriel/Documents/fonts/otf/XanhMono-Regular.otf)
for otf in $otfs
do
	gftools fix-dsig --autofix $otf
	gftools fix-weightclass $otf
	[ -f $otf.fix ] && mv $otf.fix $otf
done


#============================================================================
#Build woff and woff2 fonts =================================================
#requires https://github.com/bramstein/homebrew-webfonttools

echo ".
BUILD WEBFONTS
."
mkdir -p /Users/gabriel/Documents/fonts/webfonts

ttfs=$(ls /Users/gabriel/Documents/fonts/ttf/XanhMono-Regular.ttf)
for ttf in $ttfs
do
  woff2_compress $ttf
  sfnt2woff-zopfli $ttf
done

woffs=$(ls /Users/gabriel/Documents/fonts/ttf/XanhMono-Regular.woff*)
for woff in $woffs
do
	mv $woff /Users/gabriel/Documents/fonts/webfonts
done

rm -rf master_ufo/ instance_ufo/


echo ".
COMPLETE!
."
