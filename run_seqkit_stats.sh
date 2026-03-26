#!/bin/bash
#
# run seqkit stats
#
#
threads=48
OUTDIR=seqkit_stats
mkdir -p ${OUTDIR}
FORWARDS=$(find ~/data/microbiome/ -iname "*_R1*.fastq.gz" ! -iname "*trimmed*")
for FORWARD in ${FORWARDS} ; do
    REVERSE="${FORWARD/_R1/_R2}"
    BASENAME=$(basename $FORWARD .fastq.gz)
    SAMPLE=$(echo $BASENAME | sed 's|_L.*$||')
    LANE=$(echo $BASENAME | sed 's|^.*_L||' | sed 's|_R1||')
    OUTPUT=${OUTDIR}/${BASENAME}.stats
    echo "$FORWARD $REVERSE ${OUTPUT}"
    seqkit stats --quiet --threads $threads --all --tabular --out-file $OUTPUT $FORWARD $REVERSE
done

csvstack -t $(find ${OUTDIR}/*.stats) > $OUTDIR/seqkit_stats_all.tsv
#file,format,type,num_seqs,sum_len,min_len,avg_len,max_len,Q1,Q2,Q3,sum_gap,N50,N50_num,Q20(%),Q30(%),AvgQual,GC(%)
# 1  ,2     ,3   ,4       ,5      ,6      ,7      ,8      ,9 ,10,11,12,    ,13 ,14     ,15    ,16    ,17     ,18
cat $OUTDIR/seqkit_stats_all.tsv | awk -F, 'BEGIN{OFS="\t"}{print $1,$4,$6,$7,$8,$17,$18}' | tee $OUTDIR/seqkit_stats.tsv
#csvlook -I $OUTDIR/seqkit_stats.tsv

exit

exit 0
