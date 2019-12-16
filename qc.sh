#!/bin/bash
star_statistic(){
    # this function is for calculate the metrics in log.final.out
    path_to_output='../data/mapping_stat/'
    mkdir -p  $path_to_output
    outputfile="$path_to_output"'mapping_stat.csv'
    if [ -f $outputfile ]; then
        echo "rewrite a new CSV file!"
        rm $outputfile
    fi
    echo "Filename,StartTime,FinishTime,ReadLength,NumReads,Unique,Unique_Percent,Multi,Multi_Percent" >> $outputfile
    path_to_bam="../data/bam/"
    for i in "$path_to_bam"*Log.final.out;
    do
        Filename=`echo $i | awk -F/ '{print $NF}'|awk '{gsub("Log.final.out", "");print}'`
        StartTime=`cat $i | grep "Started mapping on" | awk -F"|" '{print $NF}'`
        FinishTime=`cat $i | grep "Finished on" | awk -F"|" '{print $NF}'`
        ReadLength=`cat $i | grep "Number of input reads" | awk -F"|" '{print $NF}'`
        NumReads=`cat $i | grep "Average input read length" | awk -F"|" '{print $NF}'` 
        Unique=`cat $i | grep "Uniquely mapped reads number" | awk -F"|" '{print $NF}'` 
        Unique_Percent=`cat $i | grep "Uniquely mapped reads %" | awk -F"|" '{print $NF}'` 
        Multi=`cat $i | grep "Number of reads mapped to multiple loci" | awk -F"|" '{print $NF}'` 
        Multi_Percent=`cat $i | grep "% of reads mapped to multiple loci" | awk -F"|" '{print $NF}'` 
        echo $Filename","$StartTime","$FinishTime","$ReadLength","$NumReads","$Unique","$Unique_Percent","$Multi","\
            $Multi_Percent>> $outputfile
    done
}
"$@"
