#!/bin/bash
#SBATCH -J index
#SBATCH -n 4
#SBATCH --time 00-006:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#Build bwa index for reference genome
bwa index /storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/refs/GCF_000188095.3_BIMP_2.2_genomic.fna 2>>bwa.log.txt
#Build IGV index for the reference genome
samtools faidx /storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/refs/GCF_000188095.3_BIMP_2.2_genomic.fna