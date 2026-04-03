#!/bin/bash
#SBATCH -J spades_assembly
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=80G
#SBATCH --time=12:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=hmh19_cr_default
#SBATCH --partition=standard
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

LIB_1_PE1=calferv_proj/fastq/trimmed/JBUK202Y_trimmed_R1.fq.gz
LIB_1_PE2=calferv_proj/fastq/trimmed/JBUK202Y_trimmed_R2.fq.gz
LIB_2_PE1=calferv_proj/fastq/trimmed/JBUK203Y_trimmed_R1.fq.gz
LIB_2_PE2=calferv_proj/fastq/trimmed/JBUK203Y_trimmed_R2.fq.gz
THREADS=16
MEM=80
TRUSTED_CONTIGS=calferv_proj/GWAS_2026/assemblies/spades/megahit_trusted_contigs.fa
OUT_DIR=calferv_proj/GWAS_2026/assemblies/spades/K127

micromamba run -n spades spades.py \
	--pe1-1 $LIB_1_PE1 \
	--pe1-2 $LIB_1_PE2 \
	--pe2-1 $LIB_2_PE1 \
	--pe2-2 $LIB_2_PE2 \
	-k 127 \
	--threads $THREADS \
	--memory $MEM \
	--only-assembler \
	--trusted-contigs $TRUSTED_CONTIGS \
	-o $OUT_DIR