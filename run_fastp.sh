#!/bin/bash
#
# run fastp
#
threads=16 # maximum number fastp uses
poly_x_min_len=10
min_read_length=50
n_base_limit=5
average_qual=10 #=0 means no requirement
cut_window_size=4
cut_mean_quality=20
low_complexity_threshold=30 # 30% is the default

deduplication=false
verbose=false
overrepresentation_analysis=false
low_complexity_filter=true
disable_quality_filtering=false
disable_length_filtering=false
trim_poly_x=true

FORWARDS1=$(find ~/data/microbiome/ -iname "*_R1*.fastq.gz" ! -iname "*trimmed*" ! -name "*BTRAN_20210316_A00904_IL100165847_N2UD-F07*")
FORWARDS2=$(find ~/data/microbiome/ -type f -wholename "*merged*BTRAN_20210316_A00904_IL100165847_N2UD-F07*R1*.fastq.gz" ! -name "*trimmed*")
FORWARDS="$FORWARDS1 $FORWARDS2"
	    
OUT_DIR=fastp
mkdir -p $OUT_DIR

date

for read1 in $FORWARDS ; do
    
    read2=${read1/_R1/_R2}
    BASENAME=$(basename $read1 .fastq.gz)
    samplename=$(echo $BASENAME | sed 's|_L.*$||')

    echo $read1 $read2 $samplename
    
    trimmed1=$OUT_DIR/${samplename}"_trimmed_1.fastq.gz"
    trimmed2=$OUT_DIR/${samplename}"_trimmed_2.fastq.gz"
    unpaired1=$OUT_DIR/${samplename}"_unpaired_1.fastq.gz"
    unpaired2=$OUT_DIR/${samplename}"_unpaired_2.fastq.gz"
    html_report=$OUT_DIR/${samplename}".html"
    json_report=$OUT_DIR/${samplename}".json"
    log=$OUT_DIR/${samplename}".log"
    
    time fastp --in1 ${read1} \
	  --in2 ${read2} \
	  --out1 ${trimmed1} \
	  --out2 ${trimmed2} \
	  --json ${json_report} \
	  --html ${html_report} \
	  --thread ${threads} \
	  --detect_adapter_for_pe \
	  --unpaired1 ${unpaired1} \
	  --unpaired2 ${unpaired2} \
	  --poly_x_min_len ${poly_x_min_len} \
	  --length_required ${min_read_length} \
	  --n_base_limit ${n_base_limit} \
	  --complexity_threshold ${low_complexity_threshold} \
	  --average_qual ${average_qual} \
	  --cut_tail \
	  --cut_window_size ${cut_window_size} \
	  --cut_mean_quality ${cut_mean_quality} \
	  --adapter_fasta adapters.fa.gz \
	  --trim_poly_x \
	  --verbose \
	  --dedup \
	  --overrepresentation_analysis 2> $log

done    
date

exit 0
