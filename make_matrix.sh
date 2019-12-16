#!/bin/bash
set -x
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
featurecounts_statistic(){
    # this function is for generating gene expression matrix and summary matrix
    path_to_input="../data/quantification_stats/cell_level_files/"
    path_to_output="../data/quantification_stats/gene_expression_matrix/"
    outputfile_gene_expression="$path_to_output"gene_expression_matrix.csv
    outputfile_featurecounts_summary="$path_to_output"featurecounts_summary_matrix.csv
    outputfile_gtf_parse="$path_to_output"feature_parse_matrix.csv
    # to check if input folder exist
    if [ ! -d "$path_to_input" ]; then
        echo 'Folder '"$path_to_output"' does not exist! Can not make gene expression profile.'
        exit 1
    fi
    # to check if output folder exist
    if [ ! -d "$path_to_output" ]; then
        mkdir -p $path_to_output
    fi
    # parse gtf files
    # I need to remove header(first line) and read counts(last column)
    for i in "$path_to_input"*.featurecounts ;
    do
        NumColumn=`cat $i | tail -n +2 | awk '{print NF}' | sort -nu | head -n 1`
        cat $i | tail -n +2 |tr '\t' ',' |cut --complement -f $NumColumn -d, > "$outputfile_gtf_parse"
        break
    done
    # generate gene expression matrix
    # use python to do process
    # 1st parameter is input folder
    # 2nd parameter is output file name with location
    python ./generate_gene_expression_matrix.py "$path_to_input" "$outputfile_gene_expression"
}

"$@"
