#!/bin/bash
#for cell level analysis
#3 parameter: 
#1st parameter: gtf
#2nd parameter: fasta
#3rd parameter: cell name without location

filename=$1

# mapping
./mapping.sh star_mapping $filename

# quantify
./quantify.sh featureCounts  

