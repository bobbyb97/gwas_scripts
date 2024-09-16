#!/bin/bash
#SBATCH -J gatk_select_and_filter
#SBATCH -n 8
#SBATCH --time 5-010:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio
#SBATCH --mem-per-cpu 8000


FILE=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/
FILE1=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/
FILE2=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/indels/
FILE3=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/snps/
FILE4=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Recalibration_tables/
REF=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/refs/flavifrons/Bombus_flavifrons.p_ctg.purged.clean.fasta

/storage/home/tpd5366/work/gatk-4.4.0.0/gatk SelectVariants -R ${REF} -V ${FILE1}Vcfcall_from_genomicsdb_bpresolution_strict_alignment.vcf.gz --select-type-to-include SNP -O ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_snps.vcf
/storage/home/tpd5366/work/gatk-4.4.0.0/gatk SelectVariants -R ${REF} -V ${FILE1}Vcfcall_from_genomicsdb_bpresolution_strict_alignment.vcf.gz --select-type-to-include INDEL -O ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_indels.vcf

/storage/home/tpd5366/work/gatk-4.4.0.0/gatk VariantFiltration -R ${REF} -V ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_snps.vcf -O ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_filtered_snps.vcf \
--filter-name "QD_filter" --filter-expression "QD < 2.0" \
--filter-name "FS_filter" --filter-expression "FS > 60.0" \
--filter-name "MQ_filter" --filter-expression "MQ < 40.0" \
--filter-name "SOR_filter" --filter-expression "SOR > 4.0"
--filter-name "MQRankSum_filter" --filter-expression "MQRankSum < -12.5" \
--filter-name "ReadPosRankSum_filter" -filter-expression "ReadPosRankSum < -8.0"

/storage/home/tpd5366/work/gatk-4.4.0.0/gatk VariantFiltration -R ${REF} -V ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_indels.vcf -O ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_filtered_indels.vcf \
--filter-name "QD_filter" --filter-expression "QD < 2.0" \
--filter-name "FS_filter" --filter-expression "FS > 60.0" \
--filter-name "SOR_filter" --filter-expression "SOR > 4.0"


/storage/home/tpd5366/work/gatk-4.4.0.0/gatk SelectVariants --exclude-filtered -V ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_filtered_snps.vcf -O ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_bqsr_snps.vcf
/storage/home/tpd5366/work/gatk-4.4.0.0/gatk SelectVariants --exclude-filtered -V ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_filtered_indels.vcf -O ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_bqsr_indels.vcf

files=(
    "JK37"
    "JKAL36"
    "JKMIR022"
    "MIR001A"
    "TDB001"
    "TDB002"
    "TDB003"
    "TDB004"
    "TDB009"
    "TDB010"
    "TDB011"
    "TDB012"
    "TDB013"
    "TDB016"
    "TDB017"
    "TDB018"
    "TDB019"
    "TDB020"
    "TDB021"
    "TDB022"
    "TDB023"
    "TDR002"
    "TDR003"
    "TDR005"
    "TDR006"
    "TDR007"
    "TDR008"
    "TDR009"
    "TDR010"
    "TDR011"
    "TDR012"
    "TDR016"
    "TDR017"
    "TDR018"
    "TDR019"
    "TDR021"
    "TDR025"
)

for input in "${files[@]}"; do
    set -- $input
    echo "Base recalibrating for ${1}"

/storage/home/tpd5366/work/gatk-4.4.0.0/gatk BaseRecalibrator -R ${REF} -I ${FILE}${1}_sorted_dedup_reads.bam --known-sites ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_bqsr_snps.vcf --known-sites ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_bqsr_indels.vcf -O ${FILE4}${1}_recal_data.table
done
