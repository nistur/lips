#!/bin/bash
TEXT="$(echo ${1} | awk '{print toupper($0)}')"
SIZE="${2}"
BG="${3}"
FILENAME="${4}"

FONT="ComicSansMSB"
FONTSIZE=$(echo "${SIZE} / 5" | bc)
BOTTOM=$(echo "(${SIZE} / 2) + (${FONTSIZE} / 2)" | bc)
STYLE="-annotate 0x20+20+67"

OUTLINE1="-stroke yellow -strokewidth 40"
OUTLINE2="-stroke black -strokewidth 20"
TEXTSTYLE="-stroke white -strokewidth 5"

TEXTWIDTH=$(convert -debug annotate  xc: -font ${FONT} -pointsize ${FONTSIZE} \
					  ${OUTLINE1} ${STYLE} ${TEXT} null: 2>&1 |\
		grep Metrics: | tr ";" "\n" | grep "width" | cut -d\  -f3)
LEFT=$(echo "(${SIZE}-${TEXTWIDTH})/2" | bc)

STYLE="-annotate 0x20+${LEFT}+${BOTTOM}"

				     
convert -size ${SIZE}x${SIZE} xc:${BG} -font ${FONT} -pointsize ${FONTSIZE} \
	-fill white \
        ${OUTLINE1} ${STYLE} ${TEXT} \
        ${OUTLINE2} ${STYLE} ${TEXT} \
        ${TEXTSTYLE} ${STYLE} ${TEXT} \
	"${FILENAME}"
