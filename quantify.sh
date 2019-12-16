#!/bin/bash
featureCounts(){
    # this is a cell-level operation
    # 2 parameter, 1st parameter is gtf, 2nd parameter is bamfile name without location
    gtf=$1
    bamfilename=$2
    path_to_time_stats="../data/time_stats/"
    path_to_bam_file="../data/bam/"
    subfix='Aligned.sortedByCoord.out.bam'
    bamfile="$path_to_bam_file""$bamfilename""$subfix"
    threads=30
    path_to_quantification_stats="../data/quantification_stats/"
    if [ ! -d "$path_to_quantification_stats" ]; then
        mkdir -p $path_to_quantification_stats
    fi
    output="$path_to_quantification_stats""$bamfilename"'.featurecounts'
    start_featurecounts=`date +%s`
    featureCounts -T $threads -p --primary -a $gtf -o $output $bamfile #--primary is for filtering out multiple mapping
    stop_featurecounts=`date +%s`
    echo $bamfilename","$((stop_featurecounts-start_featurecounts))",\n" >> "$path_to_time_stats"time_featurecounts.csv
}
