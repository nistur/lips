#!/bin/bash

CROSSLINEWIDTH=0
source "$(pwd)/config.lips"

FILES=(${2})
FILENAME=$(basename ${FILES[0]})
EXTENSION="${FILENAME##*.}"

WIDTH=$(identify -format "%[fx:w]" ${FILES[0]})
HEIGHT=$(identify -format "%[fx:h]" ${FILES[0]})

HALFWIDTH=${WIDTH}
HALFHEIGHT=${HEIGHT}

HEIGHT=$(echo "${HEIGHT}*2" | bc)
WIDTH=$(echo "${WIDTH}*2" | bc)

TOP=$(echo "${HEIGHT}/10" | bc)
BOTTOM=$(echo "${HEIGHT}-${TOP}" | bc)

LEFT=$(echo "${WIDTH}/10" | bc)
RIGHT=$(echo "${WIDTH}-${LEFT}" | bc)

VERTLINE=$(printf "line %d,%d %d,%d" ${HALFWIDTH} ${TOP} ${HALFWIDTH} ${BOTTOM})
HORZLINE=$(printf "line %d,%d %d,%d" ${LEFT} ${HALFHEIGHT} ${RIGHT} ${HALFHEIGHT})

FILENAME="${FILENAME%%.*}"
BASE=$(echo ${FILENAME} | sed -e "s/-[0-9]*//")


I=1
while [ -e ${1}/${BASE}-$(printf '%02d' "${I}").${EXTENSION} ] ; do
    I=$(expr ${I} + 1)
done

OUTFILE=${1}/${BASE}-$(printf '%02d' "${I}").${EXTENSION}

echo "Combining " ${2} " into " ${OUTFILE}

if [ ${CROSSLINEWIDTH} -gt 0 ] ; then
    montage ${2} -geometry +0+0 - | convert - -fill none -stroke ${TEXTCOLOUR} -strokewidth ${CROSSLINEWIDTH} -draw "${VERTLINE}" -draw "${HORZLINE}" ${OUTFILE}
else
    montage ${2} -geometry +0+0 ${OUTFILE}
fi
