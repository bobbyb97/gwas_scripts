#!/bin/bash
#SBATCH -J megahit_assembly
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --time=23:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

PE1=all_calferv_trimmed_fastq/JBUK202Y_trimmed_R1.fq.gz
PE2=all_calferv_trimmed_fastq/JBUK202Y_trimmed_R2.fq.gz
THREADS=8 
MEM=0.9 # fraction of available memory to use
OUT_DIR=calferv_proj/GWAS_2026/assemblies/megahit/californicus/JBUK202Y_hap

micromamba run -n megahit megahit \
	-1 ${PE1} \
	-2 ${PE2} \
	-t ${THREADS} \
	-m ${MEM} \
	-o ${OUT_DIR}