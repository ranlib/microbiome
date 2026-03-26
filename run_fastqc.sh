#!/usr/bin/bash
#
# loop over original illumina data and run fastqc
#
#
# real	571m32.440s
# user	1069m2.878s
# sys	51m51.030s
#
threads=48

FORWARDS1=$(find ~/data/microbiome/ -iname "*_R1*.fastq.gz" ! -iname "*trimmed*" ! -name "*BTRAN_20210316_A00904_IL100165847_N2UD-F07*")
FORWARDS2=$(find ~/data/microbiome/ -type f -wholename "*merged*BTRAN_20210316_A00904_IL100165847_N2UD-F07*R1*.fastq.gz" ! -name "*trimmed*")
FORWARDS="$FORWARDS1 $FORWARDS2"
	    
mkdir -p fastqc
date

for R1 in $FORWARDS ; do
    echo $R1
    R2=$(echo $R1 | sed 's|_R1|_R2|')
    echo $R2
    if [ -e $R2 ] ; then
	echo "$R1: R2 does exist"
	time fastqc --outdir fastqc --extract --threads $threads $R1 $R2
    else
	echo "$R1: R2 does not exist"
    fi
done

date

#
# multiQC report
#
#
#multiqc --no-data-dir --filename fastqc_original_multiqc.html fastqc

exit 0
