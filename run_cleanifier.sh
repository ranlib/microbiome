#!/bin/bash

#
# decontaminate fastq from human contamination
# need to run in cleanifier conda environment
#
# real	193m38.960s
# user	7901m23.115s
# sys	64m59.718s

source /home/dbest/mambaforge/envs/cleanifier/lib/python3.13/venv/scripts/common/activate

threads=48

FORWARDS1=$(find ~/data/microbiome/ -iname "*_R1*.fastq.gz" ! -iname "*trimmed*" ! -name "*BTRAN_20210316_A00904_IL100165847_N2UD-F07*")
FORWARDS2=$(find ~/data/microbiome/ -type f -wholename "*merged*BTRAN_20210316_A00904_IL100165847_N2UD-F07*R1*.fastq.gz" ! -name "*trimmed*")
FORWARDS="$FORWARDS1 $FORWARDS2"
	    
mkdir -p cleanifier
date

for R1 in $FORWARDS ; do
    R2=$(echo $R1 | sed 's|_R1|_R2|')
    BASENAME=$(basename $R1 .fastq.gz)
    SAMPLE=$(echo $BASENAME | sed 's|_L.*$||')
    echo $R1
    echo $R2
    echo $SAMPLE
    PREFIX=$PWD/cleanifier/$SAMPLE
    LOG=$PWD/cleanifier/${SAMPLE}.log
    if [ -e $R2 ] ; then
	echo "$R1: R2 does exist"
	time cleanifier filter --progress --threads $threads --index cleanifier_index/t2t_pangenome_hla_variants_cdna_cleanifier_index_k29_w33 --fastq $R1 --pair $R2 --prefix $PREFIX |tee $LOG
    else
	echo "$R1: R2 does not exist"
    fi
done

date


exit 0
