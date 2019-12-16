#!/bin/bash
#for cell level analysis
#3 parameter: 
#1st parameter: gtf
#2nd parameter: fasta
#3rd parameter: cell name without location

ref_gtf=$1
ref_fasta=$2
filename=$3

# mapping
# ./mapping.sh star_mapping $filename

# quantify
./quantify.sh featureCounts $ref_gtf $filename 

