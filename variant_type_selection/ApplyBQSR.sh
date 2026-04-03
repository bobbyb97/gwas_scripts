#!/bin/bash
#SBATCH -J ApplyBQSR
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=4:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=6G
#SBATCH --array=0-98%10
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

#define variables

REF=calferv_proj/ref_genome/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna

IN_DIR=calferv_proj/GWAS_2026/bam/all_bam
SUFFIX="_trimmed_sorted_RG_dedup.bam"

DATA_DIR=calferv_proj/GWAS_2026/bam/BQSR/tables
OUT_DIR=calferv_proj/GWAS_2026/bam/BQSR/recalibrated_bams

mkdir -p ${OUT_DIR}

	# Read full sample paths into array
		SAMPLES=(${IN_DIR}/*_trimmed_sorted_RG_dedup.bam)

	# Define sample basenames
		SAMPLE_NAMES=("${SAMPLES[@]##*/}")
		SAMPLE_NAMES=("${SAMPLE_NAMES[@]%${SUFFIX}}") 

	# Grab specific sample from array 
		SAMPLE_NAME=${SAMPLE_NAMES[$SLURM_ARRAY_TASK_ID]} 

apply_bqsr() {
	output="$1"
	echo "Applying BQSR on ${output}${SUFFIX}, using ${DATA_DIR}/${output}_recal_data.table ..."
	echo "Writing to ${OUT_DIR}/${output}_BQSR.bam"
	micromamba run -n gatk gatk ApplyBQSR \
		--reference ${REF} \
		--input ${IN_DIR}/${output}${SUFFIX} \
		--bqsr-recal-file ${DATA_DIR}/${output}_recal_data.table \
		--output ${OUT_DIR}/${output}_BQSR.bam

}

apply_bqsr ${SAMPLE_NAME}