#!/bin/bash
#SBATCH -J bedtools_genomecov
#SBATCH -n 16
#SBATCH --time 023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 16G

INDIR="calferv_bams"
OUTDIR="calferv_bedtools_genomecov"

mkdir -p ${OUTDIR}

parallel -j 16 \
 "echo 'Calculating genome coverage for {} and writing to ${OUTDIR}/{/}_genomecov.txt' && \
 bedtools genomecov -ibam {} \
 -d \
 > ${OUTDIR}/{/}_genomecov.txt" ::: ${INDIR}/*.bam
