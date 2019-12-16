#!/bin/bash
cat $1 | while read line
do
    echo "$line"
    cp /stor/public/mtx/batch_effect_fastq/"$line" ../data/fastq/
done
