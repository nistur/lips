#!/bin/bash

LOGOCOLOUR=blue

source "$(pwd)/config.lips"

LOGOFILE="$(mktemp).png"

OUTHEIGHT=0
OUTWIDTH=0

LAYERS=""
for FILE in Cover/*.png ; do
    LAYERS="${FILE}"
    #    LAYERS="${LAYERS}  -gravity Center -draw \"image over 0,0 0,0 '${file}'\""
    WIDTH=$(identify -format "%[fx:w]" ${FILE})
    HEIGHT=$(identify -format "%[fx:h]" ${FILE})
    if [ ${WIDTH} -gt ${OUTWIDTH} ] ; then
	OUTWIDTH=${WIDTH}
    fi

    if [ ${HEIGHT} -gt ${OUTHEIGHT} ] ; then
	OUTHEIGHT=${HEIGHT}
    fi
done

if [ ${OUTHEIGHT} -le 0 ] ; then
    OUTHEIGHT=768
fi
if [ ${OUTWIDTH} -le 0 ] ; then
    OUTWIDTH=1024
fi

LOGOSIZE=$(echo ${OUTHEIGHT} / 8 | bc)

NUMPARTS=0

for FILE in Parts/*.xml ; do
    for LINE in $(grep MINQTY "${FILE}") ; do
	NUMPARTS=$(expr ${NUMPARTS} + $(echo ${LINE} | sed -e 's@<[/]*MINQTY>@@g'))
    done
done

FILENAME="$(basename $LAYERS)"
EXTENSION="${FILENAME##*.}"
FILENAME="Combined/${FILENAME%%.*}-00.${EXTENSION}"


LIPS=${LIPS} sh ${LIPS}lips-logo.sh ${AUTHOR} ${LOGOSIZE} ${LOGOCOLOUR} ${LOGOFILE}

BORDER=$(echo ${OUTHEIGHT} / 30 | bc)

LOGOPOS="${BORDER},${BORDER}"

HEADERPOINTSIZE=$(echo ${OUTHEIGHT} / 20 | bc)
SUBHEADERPOINTSIZE=$(echo ${HEADERPOINTSIZE} / 1.5 | bc)

HEADERPOS="${BORDER}, $(echo ${LOGOSIZE} + ${BORDER} | bc)"
SUBHEADERPOS="${BORDER},$(echo ${LOGOSIZE} + ${BORDER} + ${HEADERPOINTSIZE} | bc )"

LINESPACE=$(echo ${OUTHEIGHT} / 100 | bc)
SEPARATORSPACE=$(echo ${OUTHEIGHT} / 50 | bc)
SEPARATORLENGTH=$(echo ${OUTWIDTH} / 5 | bc)

SEPARATORRIGHT=$(echo ${BORDER} + ${SEPARATORLENGTH} | bc)

AUTHORHEIGHT=$(echo ${OUTHEIGHT} - ${BORDER} - ${SUBHEADERPOINTSIZE} | bc)
CREDITSHEIGHT=$(echo ${AUTHORHEIGHT} - ${SUBHEADERPOINTSIZE} - ${LINESPACE} | bc)
LOWERLINEHEIGHT=$(echo ${CREDITSHEIGHT} - ${SEPARATORSPACE} | bc)
PIECEHEIGHT=$(echo ${LOWERLINEHEIGHT} - ${SUBHEADERPOINTSIZE} - ${SEPARATORSPACE} | bc)
PIECECOUNTHEIGHT=$(echo ${PIECEHEIGHT} - ${HEADERPOINTSIZE} - ${LINESPACE} | bc)

convert -size ${OUTWIDTH}x${OUTHEIGHT} xc:black \
	-gravity Center -draw "image Over 0,0 0,0 '${LAYERS}'" \
	-gravity NorthWest -draw "image Over     ${LOGOPOS} 0,0 '${LOGOFILE}'" \
	-stroke ${TEXTCOLOUR} -fill ${TEXTCOLOUR} \
	        -pointsize ${HEADERPOINTSIZE} -draw "text ${HEADERPOS} '${HEADER}'" \
	        -pointsize ${SUBHEADERPOINTSIZE} -draw "text ${SUBHEADERPOS} '${SUBHEADER}'" \
		-pointsize ${HEADERPOINTSIZE} -kerning 30 -draw "text ${BORDER},${PIECECOUNTHEIGHT} '${NUMPARTS}'" \
		-pointsize ${SUBHEADERPOINTSIZE} -kerning 0 -draw "text ${BORDER},${PIECEHEIGHT} 'pcs/pzs'" \
		-draw "line ${BORDER},${LOWERLINEHEIGHT} ${SEPARATORRIGHT},${LOWERLINEHEIGHT}" \
		-pointsize ${SUBHEADERPOINTSIZE} -kerning 0 -draw "text ${BORDER},${CREDITSHEIGHT} 'Model designed by'" \
		-pointsize ${SUBHEADERPOINTSIZE} -kerning 0 -draw "text ${BORDER},${AUTHORHEIGHT} '${AUTHOR}'" \
	${FILENAME}
