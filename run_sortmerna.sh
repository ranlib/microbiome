#!/bin/bash

R1=fastp_cleanifier/BDATA_20230411_A00904_IL100291022_N1UD-D04_1_keep.fastq.gz
R2=fastp_cleanifier/BDATA_20230411_A00904_IL100291022_N1UD-D04_2_keep.fastq.gz

DBDIR=/home/dbest/data/SILVA
DB=SILVA_138.1_Ref_NR99_tax_silva.fasta

#time docker run --rm --user $(id -u):$(id -g) -v .:/mnt -w /mnt informationsea/sortmerna:4.3.6 /opt/sortmerna/sortmerna-4.3.6-Linux/bin/sortmerna -h

# make index
#time docker run --rm --user $(id -u):$(id -g) -v .:/mnt -v $DBDIR:/data -w /mnt informationsea/sortmerna:4.3.6 /opt/sortmerna/sortmerna-4.3.6-Linux/bin/sortmerna \
#       --reads $R1 --reads $R2 \
#       --ref /data/$DB \
#       --idx-dir /data --index 1 --threads 8

# run on one sample
time docker run --rm --user $(id -u):$(id -g) -v .:/mnt -v $DBDIR:/data -w /mnt informationsea/sortmerna:4.3.6 /opt/sortmerna/sortmerna-4.3.6-Linux/bin/sortmerna \
  --reads $R1 \
  --reads $R2 \
  --ref /data/$DB \
  --idx-dir /data \
  --fastx \
  --other non_rrna \
  --aligned rrna \
  --threads 16 \
  --workdir sortmerna \
  --v \
  --dbg-level 1


exit 0
