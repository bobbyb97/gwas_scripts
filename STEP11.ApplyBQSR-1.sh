#!/bin/bash
#SBATCH -J apply_bqsr
#SBATCH -n 8
#SBATCH --time 10-010:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio
#SBATCH --mem-per-cpu 8000


FILE=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/
FILE1=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/
FILE2=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Recalibration_tables/
REF=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/refs/flavifrons/Bombus_flavifrons.p_ctg.purged.clean.fasta

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
    echo "Base recalibration applying for ${1}"

/storage/home/tpd5366/work/gatk-4.4.0.0/gatk ApplyBQSR -R ${REF} -I ${FILE}${1}_sorted_dedup_reads.bam -bqsr ${FILE2}${1}_recal_data.table -O ${FILE1}${1}_recalibrated_reads.bam
done
