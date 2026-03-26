#!/usr/bin/bash
#
# run centrifuge on all files
#
#
#
export CENTRIFUGE_INDEXES=$HOME/data/centrifuge

threads=48

FORWARDS1=$(find ~/data/microbiome/ -iname "*_R1*.fastq.gz" ! -iname "*trimmed*" ! -name "*BTRAN_20210316_A00904_IL100165847_N2UD-F07*")
FORWARDS2=$(find ~/data/microbiome/ -type f -wholename "*merged*BTRAN_20210316_A00904_IL100165847_N2UD-F07*R1*.fastq.gz" ! -name "*trimmed*")
FORWARDS="$FORWARDS1 $FORWARDS2"

mkdir -p centrifuge
date

for R1 in $FORWARDS ; do
    R2=$(echo $R1 | sed 's|_R1|_R2|')
    BASENAME=$(basename $R1 .fastq.gz)
    SAMPLE=$(echo $BASENAME | sed 's|_L.*$||')
    LANE=$(echo $BASENAME | sed 's|^.*_L||' | sed 's|_R1||')
    echo $R1
    echo $R2
    echo $SAMPLE
    if [ -e $R2 ] ; then
	echo "$R1: R2 does exist"
	RP=centrifuge/${SAMPLE}.centrifuge.summary.report.tsv
	SM=centrifuge/${SAMPLE}.centrifuge.classification.tsv
	time centrifuge -x p_compressed+h+v --threads $threads -1 $R1 -2 $R2 --report-file $RP -S $SM
	ERR=centrifuge/${SAMPLE}.centrifuge.classification.kraken_style.err
	KRP=centrifuge/${SAMPLE}.centrifuge.classification.kraken_style.tsv
	centrifuge-kreport -x /mnt/data/p_compressed+h+v $RP 2> $ERR 1> $KRP
    else
	echo "$R1: R2 does NOT exist"
    fi
done

date

exit 0
