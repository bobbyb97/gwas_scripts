#!/bin/bash
#SBATCH -J fastqc
#SBATCH -n 1
#SBATCH --time 12:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

INDIR=calferv_proj/trimmed_fastq_2
OUTDIR=calferv_proj/fastqc/fastqc_v2_24Feb
 
#This is the command for quality check:
mkdir -p $OUTDIR

micromamba run -n bioinfo fastqc $INDIR/*fq.gz -o $OUTDIR