#!/bin/bash
#SBATCH -J gatk_variant
#SBATCH -n 8
#SBATCH --time 12-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

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
    #"TDR014"
    "TDR016"
    "TDR017"
    "TDR018"
    "TDR019"
    "TDR021"
    "TDR025"
)

FILE=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/
FILE2=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/
REF=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/refs/flavifrons/Bombus_flavifrons.p_ctg.purged.clean.fasta
for input in "${files[@]}"; do
    set -- $input
    echo "Calling variant for ${1}"
/storage/home/tpd5366/work/gatk-4.4.0.0/gatk HaplotypeCaller -R ${REF} -I ${FILE}${1}_sorted_dedup_reads.bam -O ${FILE2}${1}_raw_variant.g.vcf -ploidy 1 -ERC BP_RESOLUTION
done
