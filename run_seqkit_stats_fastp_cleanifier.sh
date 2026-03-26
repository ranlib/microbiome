#!/bin/bash
#
# run seqkit stats
#
# real	527m53.847s
# user	1090m25.398s
# sys	27m38.473s
#
threads=48
OUTDIR=seqkit_stats_fastp_cleanifier
mkdir -p ${OUTDIR}
FORWARDS=$(find ./fastp_cleanifier -iname "*_1_keep.fastq.gz")
# for FORWARD in ${FORWARDS} ; do
#     REVERSE="${FORWARD/_1/_2}"
#     BASENAME=$(basename $FORWARD _1_keep.fastq.gz)
#     OUTPUT=${OUTDIR}/${BASENAME}.stats
#     echo "$FORWARD $REVERSE ${OUTPUT}"
#     seqkit stats --quiet --threads $threads --all --tabular --out-file $OUTPUT $FORWARD $REVERSE
# done

csvstack -t $(find ${OUTDIR}/*.stats) > $OUTDIR/seqkit_stats_all.tsv
#file,format,type,num_seqs,sum_len,min_len,avg_len,max_len,Q1,Q2,Q3,sum_gap,N50,N50_num,Q20(%),Q30(%),AvgQual,GC(%)
# 1  ,2     ,3   ,4       ,5      ,6      ,7      ,8      ,9 ,10,11,12,    ,13 ,14     ,15    ,16    ,17     ,18
cat $OUTDIR/seqkit_stats_all.tsv | awk -F, 'BEGIN{OFS="\t"}{print $1,$4,$6,$7,$8,$17,$18}' | tee $OUTDIR/seqkit_stats.tsv
#csvlook -I $OUTDIR/seqkit_stats.tsv

exit

exit 0
