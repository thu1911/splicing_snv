#!/bin/bash
set -x
# this code is for calling snv
# at least 2 parameters
# 1st arg, gtf file
# 2nd arg, fasta file
# 3rd arg, input file name without location
# 4th arg, picard.jar location
# 5th arg, gatk location
# 6th arg(optional), snp reference
# 7th arg(optional), indel reference

# argument setting
ref_gtf=$1
ref_fasta=$2
filename=$3
picard=$4
gatk=$5
ref_snp=${6:SNP_reference_without_given}
ref_indel=${7:Indel_reference_without_given}

# folder path
path_to_bam="../data/bam/"
path_to_snv="../data/snv/"
path_to_cell_level_snv="$path_to_snv"'cell_level_snv/'
if [ ! -d $path_to_cell_level_snv ]; then
    mkdir -p $path_to_cell_level_snv
fi
path_to_time_stats="../data/time_stats/"
if [ ! -d $path_to_time_stats ]; then
    mkdir -p $path_to_time_stats
fi
gatk_time_stats="$path_to_time_stats"'time_GATK.csv'
if [ ! -f $gatk_time_stats ]; then
    echo "Filename, Time" >> $gatk_time_stats
fi


# For GATK, it requires that reference folder contains .fa .fai .dict
# check if .fa, .fai, .dict are in reference folder
path_to_ref_fasta=${ref_fasta%/*}
ref_fasta_fai="$ref_fasta".fai
ref_fasta_dict=`echo $ref_fasta | sed -e 's/.fa/.dict/g'`
if [ ! -f $ref_fasta_fai ]; then
    echo "genome.fa.fai doesn't exist, this code just build a new one."
    samtools faidx "$ref_fasta"
fi
if [ ! -f $ref_fasta_dict ]; then
    echo "genome.dict doesn't exist, this code just build a new one."
    java -jar $picard CreateSequenceDictionary R=$ref_fasta
fi


# Start real work
if [ -d $path_to_output ]; then
    mkdir -p $path_to_output
fi
start_GATK=`date +%s`
in_bam="$path_to_bam""$filename"Aligned.sortedByCoord.out.bam
# add read group
addrg_bam="$path_to_cell_level_snv""$filename"'_rg.bam'
dedup_bam="$path_to_cell_level_snv""$filename"'_sortByCoord_dedup.bam'
myRGID="$filename"'_RGID'
myRGLB=$filename
myRGPU=$filename
myRGSM=$filename
java -jar $picard AddOrReplaceReadGroups \
    I=$in_bam \
    O=$addrg_bam \
    RGID=$myRGID \
    RGLB=$myRGLB \
    RGPL=illumina \
    RGPU=$myRGPU \
    RGSM=$myRGSM
    stop_GATK=`date +%s`
echo $filename","$((stop_GATK-start_GATK)) >> $gatk_time_stats





if false; then
java -jar picard.jar MarkDuplicates I=$inBam O=$dedupped_bam CREATE_INDEX=true M=$output_metrics
java -jar $path_to_gatk/gatk SplitNCigarReads -R $faFile -I $dedupped_bam -O $split_bam --read-validation-stringency LENIENT
java -jar $path_to_gatk/gatk BaseRecalibrator -R $faFile -I $split_bam -O $recalibrated_bam_tmp1 --known-sites $vcf_file
java -jar $path_to_gatk/gatk PrintReads -I $split_bam -O $recalibrated_bam_tmp2
java -jar $path_to_gatk/gatk ApplyBQSR -I $recalibrated_bam_tmp2 -O $recalibrated_bam -bqsr $recalibrated_bam_tmp1
inBam=$recalibrated_bam
$path_to_gatk/gatk HaplotypeCaller -R $faFile -I $inBam --recover-dangling-heads true --dont-use-soft-clipped-bases -stand-call-conf 0 -O $outDir/$sample.pre.vcf #to adjust parameters
$path_to_gatk/gatk VariantFiltration -R $faFile -V $outDir/$sample.pre.vcf -window 35 -cluster 3 --filter-name FS -filter "FS > 30.0" --filter-name QD -filter "QD < 2.0" -O $outDir/$sample.filtered.vcf
cat $outDir/$sample.filtered.vcf |grep -e "#\|PASS"  >$outDir/${sample}.vcf
fi
