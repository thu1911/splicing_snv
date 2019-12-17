#!/bin/bash
# this code is for calling snv



java -jar picard.jar MarkDuplicates I=$inBam O=$dedupped_bam CREATE_INDEX=true M=$output_metrics
java -jar $path_to_gatk/gatk SplitNCigarReads -R $faFile -I $dedupped_bam -O $split_bam --read-validation-stringency LENIENT
java -jar $path_to_gatk/gatk BaseRecalibrator -R $faFile -I $split_bam -O $recalibrated_bam_tmp1 --known-sites $vcf_file
java -jar $path_to_gatk/gatk PrintReads -I $split_bam -O $recalibrated_bam_tmp2
java -jar $path_to_gatk/gatk ApplyBQSR -I $recalibrated_bam_tmp2 -O $recalibrated_bam -bqsr $recalibrated_bam_tmp1
inBam=$recalibrated_bam
$path_to_gatk/gatk HaplotypeCaller -R $faFile -I $inBam --recover-dangling-heads true --dont-use-soft-clipped-bases -stand-call-conf 0 -O $outDir/$sample.pre.vcf #to adjust parameters
$path_to_gatk/gatk VariantFiltration -R $faFile -V $outDir/$sample.pre.vcf -window 35 -cluster 3 --filter-name FS -filter "FS > 30.0" --filter-name QD -filter "QD < 2.0" -O $outDir/$sample.filtered.vcf
cat $outDir/$sample.filtered.vcf |grep -e "#\|PASS"  >$outDir/${sample}.vcf
