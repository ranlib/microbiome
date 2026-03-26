#!/bin/bash

for i in $(ls centrifuge/*summary.report.tsv) ; do
    echo $i
    BASENAME=$(basename $i .centrifuge.summary.report.tsv)
    echo $BASENAME
    csvsort -r -c7 $i | head -11 > centrifuge/${BASENAME}_top10.tsv
done

FILES=$(ls centrifuge/*_top10.tsv)
grouping=""
for i in $FILES ; do
    BASENAME=$(basename $i _top10.tsv)
    #echo $BASENAME
    if [[ $grouping == "" ]] ; then
	grouping=$BASENAME
    else
	grouping="${grouping},${BASENAME}"
    fi
done
echo $grouping

csvstack -n sample -g $grouping $FILES > centrifuge_top10_summary.tsv

exit 0
