#!/bin/bash
#
# run SortMeRNA on output of fastp_cleanifier
#
set -euxo

DBDIR=/home/dbest/data/SILVA
DB=SILVA_138.1_Ref_NR99_tax_silva.fasta
THREADS=32

FORWARDS=$(ls fastp_cleanifier/*_1_keep.fastq.gz)
ARR_FORWARDS=($FORWARDS)
ARR_FORWARDS=("${ARR_FORWARDS[@]:1}") # skip first element

for R1 in "${ARR_FORWARDS[@]}" ; do
    R2=$(echo $R1 | sed 's|_1|_2|')
    SAMPLE=$(basename $R1 _1_keep.fastq.gz)
    echo $R1
    echo $R2
    echo $SAMPLE
    if [ -e $R2 ] ; then
	echo "$R1: R2 does exist"
	OUTPUT=./sortmerna/$SAMPLE
	time docker run --rm --user $(id -u):$(id -g) -v .:/mnt -v $DBDIR:/data -w /mnt informationsea/sortmerna:4.3.6 /opt/sortmerna/sortmerna-4.3.6-Linux/bin/sortmerna \
	     --reads $R1 \
	     --reads $R2 \
	     --ref /data/$DB \
	     --idx-dir /data \
	     --fastx \
	     --other $OUTPUT/${SAMPLE}_non_rrna \
	     --aligned $OUTPUT/${SAMPLE}_rrna \
	     --threads $THREADS \
	     --workdir $OUTPUT \
	     --v \
	     --dbg-level 1
    else
	echo "$R1: R2 does not exist"
    fi
done

exit 0
