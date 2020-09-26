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
mkdir -p ../fonts/ttf
fontmake -g $thisFont.glyphs -i -o ttf --output-dir ../fonts/ttf/

echo ".
GENERATING STATIC OTF
."
mkdir -p ../fonts/otf
fontmake -g $thisFont.glyphs -i -o otf --output-dir ../fonts/otf/

#============================================================================
#Post-processing fonts ======================================================

echo ".
POST-PROCESSING TTF
."
ttfs=$(ls ../fonts/ttf/*.ttf)
echo $ttfs
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
otfs=$(ls ../fonts/otf/*.otf)
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
mkdir -p ../fonts/webfonts

ttfs=$(ls ../fonts/ttf/*.ttf)
for ttf in $ttfs
do
  woff2_compress $ttf
  sfnt2woff-zopfli $ttf
done

woffs=$(ls ../fonts/ttf/*.woff*)
for woff in $woffs
do
	mv $woff ../fonts/webfonts/
done

rm -rf master_ufo/ instance_ufo/


echo ".
COMPLETE!
."
