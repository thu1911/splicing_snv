#!/bin/bash
ref=""
gtf=""
fastq_dir=""
















#reference="/data8t_5/mtx/useful_data/hg19/UCSC/hg19/Sequence/WholeGenomeFasta/genome.fa"
#annotation="/data8t_5/mtx/useful_data/hg19/UCSC/hg19/Annotation/Archives/archive-current/Genes/genes.gtf"
filelist_single="../SRR_Acc_List_Single.txt"
filelist_paired="../SRR_Acc_List_Paired.txt"

fastq_inputdir="/data8t_5/mtx/GSE85908/orignal_data/raw_reads/"
indexdir="/data8t_5/mtx/GSE85908/processed_data/index_of_star/"
bam_outputdir="/data8t_5/mtx/GSE85908/processed_data/mapping_result/"

#single
cat $filelist_single | while read line
do
    fastq_input=${fastq_inputdir}${line}.fastq
	output=${bam_outputdir}${line}
    STAR --runThreadN 20 --genomeDir $indexdir \
    --readFilesIn $fastq_input \
    --outSAMtype BAM SortedByCoordinate \
   --outFileNamePrefix $output
done


#paired
cat $filelist_paired | while read line
do
	fastq1=${fastq_inputdir}${line}_1.fastq
	fastq2=${fastq_inputdir}${line}_2.fastq
	output=${bam_outputdir}${line}
    STAR --runThreadN 20 --genomeDir $indexdir \
    --readFilesIn $fastq1 $fastq2 \
    --outSAMtype BAM SortedByCoordinate \
   --outFileNamePrefix $output
done
