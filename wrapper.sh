#!/bin/bash
ref_fasta="/data8t/mtx/useful_data/mouse/mm10_ERCC/mm10_ERCC.fa"
ref_gtf="/data8t/mtx/useful_data/mouse/mm10_ERCC/gencodevM23annotation_ERCC.gtf"
# setup
# ./setup.sh
# index for star
# ./mapping.sh star_index "$ref_gtf" "$ref_fasta"

# cellwise-operation
for i in ../data/fastq/*_1.fastq;
do
    filename=`echo $i |awk -F/ '{print $NF}' |  awk 'gsub("_1.fastq","")'` 
    ./cell_level_analysis.sh $filename
done
