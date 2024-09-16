#!/bin/bash
#SBATCH -J bcf_variant2
#SBATCH -n 8
#SBATCH --time 5-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio
#SBATCH --mem-per-cpu 8000

REF=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/refs/flavifrons/Bombus_flavifrons.p_ctg.purged.clean.fasta
files=(
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/JK37_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/JKAL36_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/JKMIR022_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/MIR001A_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB001_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB002_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB003_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB004_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB009_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB010_recalibrated_reads.bam"
    #"/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB011_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB012_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB013_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB016_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB017_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB018_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB019_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB020_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB021_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB022_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDB023_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR002_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR003_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR005_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR006_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR007_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR008_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR009_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR010_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR011_recalibrated_reads.bam"
    #"/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR012_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR016_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR017_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR018_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR019_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR021_recalibrated_reads.bam"
    "/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/BAMS/Recalibrated/TDR025_recalibrated_reads.bam"
)

bcftools mpileup -Ou -f ${REF} "${files[@]}" | bcftools call -mv --ploidy 1 -Ov -o /storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Recalibrated/All_strict_variants_called_with_recalibrated_bams_via_bcftools_18black_17red.vcf
