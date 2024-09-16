#!/bin/bash
#SBATCH -J samtobam
#SBATCH -n 8
#SBATCH --time 18-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

files=(
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/JK37_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/JK37_2P.fq JK37"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/JKAL36_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/JKAL36_2P.fq JKAL36"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/JKMIR022_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/JKMIR022_2P.fq JKMIR022"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/MIR001A_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/MIR001A_2P.fq MIR001A"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB001_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB001_2P.fq TDB001"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB002_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB002_2P.fq TDB002"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB003_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB003_2P.fq TDB003"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB004_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB004_2P.fq TDB004"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB009_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB009_2P.fq TDB009"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB010_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB010_2P.fq TDB010"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB011_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB011_2P.fq TDB011"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB012_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB012_2P.fq TDB012"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB013_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB013_2P.fq TDB013"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB016_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB016_2P.fq TDB016"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB017_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB017_2P.fq TDB017"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB018_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB018_2P.fq TDB018"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB019_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB019_2P.fq TDB019"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB020_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB020_2P.fq TDB020"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB021_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB021_2P.fq TDB021"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB022_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB022_2P.fq TDB022"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB023_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDB023_2P.fq TDB023"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR002_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR002_2P.fq TDR002"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR003_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR003_2P.fq TDR003"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR005_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR005_2P.fq TDR005"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR006_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR006_2P.fq TDR006"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR007_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR007_2P.fq TDR007"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR008_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR008_2P.fq TDR008"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR009_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR009_2P.fq TDR009"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR010_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR010_2P.fq TDR010"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR011_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR011_2P.fq TDR011"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR012_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR012_2P.fq TDR012"
   #"/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR014_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR014_2P.fq TDR014"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR016_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR016_2P.fq TDR016"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR017_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR017_2P.fq TDR017"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR018_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR018_2P.fq TDR018"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR019_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR019_2P.fq TDR019"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR021_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR021_2P.fq TDR021"
    "/storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR025_1P.fq /storage/group/hmh19/default/NGS_Data_Color_Genetics_2023/01.Trimmed_fastq/TDR025_2P.fq TDR025"
)
    REF=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/refs/flavifrons/Bombus_flavifrons.p_ctg.purged.clean.fasta

for input in "${files[@]}"; do
    set -- $input
    #Set the variable for each file
    RGPU=$(zcat ${1}.gz | head -1 | grep '@' | sed 's/:/\t/g' | sed 's/.1/\t/'| cut -f1 | sed 's/@//')
    #SamtoBam
    #samtools sort /storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/SAMS/${3}.sam -o /storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/${3}.bam
    #Alternative /w picard
    #picard AddOrReplaceReadGroups INPUT=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/${3}.bam OUTPUT=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/${3}_fixed.bam VALIDATION_STRINGENCY=LENIENT RGID=${3}_RGID RGLB=lib1 RGPL=illumina RGPU=${RGPU} RGSM=${3}
    #Building Index for the new .bam file
    sambamba index /storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/${3}_fixed.bam
done
