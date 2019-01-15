#!/bin/bash

# OSMC

curl="curl --create-dirs -kL#o"

fontsUrl=https://github.com/jeryuni/fonts/raw/master
sysFont=NanumBarunGothicBold.ttf
smiFont=cinema.ttf

dst=/home/osmc/.kodi/media/Fonts
arial=/usr/share/kodi/media/Fonts/arial.ttf

echo

echo "### Kodi 시스템 글꼴 $sysFont 다운로드 ###"
$curl "$dst/$sysFont" $fontsUrl/$sysFont
echo

echo "### Kodi 시스템 글꼴 $smiFont 다운로드 ###"
$curl "$dst/$smiFont" $fontsUrl/$smiFont
echo

if [ -e "$dst/$sysFont" ]; then
	echo "### Kodi 시스템 글꼴 $sysFont 적용 ###"
	sudo rm -rf $arial
	sudo ln -s $dst/$sysFont $arial
	echo
fi
