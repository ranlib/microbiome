#!/bin/bash

#
# decontaminate fastq from human contamination
# need to run in cleanifier conda environment
#
# real	216m36.044s
# user	8371m12.569s
# sys	58m40.919s
#
# real	193m38.960s
# user	7901m23.115s
# sys	64m59.718s

source /home/dbest/mambaforge/envs/cleanifier/lib/python3.13/venv/scripts/common/activate

threads=48

FORWARDS=$(ls fastp/*trimmed_1.fastq.gz)

OUTPUT=$PWD/fastp_cleanifier	    
mkdir -p $OUTPUT
date

for R1 in $FORWARDS ; do
    R2=$(echo $R1 | sed 's|_1|_2|')
    SAMPLE=$(basename $R1 _trimmed_1.fastq.gz)
    echo $R1
    echo $R2
    echo $SAMPLE
    PRE=$OUTPUT/${SAMPLE}
    LOG=$OUTPUT/${SAMPLE}.log
    if [ -e $R2 ] ; then
	echo "$R1: R2 does exist"
	time cleanifier filter --progress --threads $threads --index cleanifier_index/t2t_pangenome_hla_variants_cdna_cleanifier_index_k29_w33 --fastq $R1 --pair $R2 --prefix $PRE |tee $LOG
    else
	echo "$R1: R2 does not exist"
    fi
done

date


exit 0
