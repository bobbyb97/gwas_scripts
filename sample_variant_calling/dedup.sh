#!/bin/bash
#SBATCH -J gatk_dedup
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time 12:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --array=0-20%10
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err


# --account=hmh19_cr_default
#--partition=standard

IN_DIR="pen_proj/bam_files/bwa_v2_Feb27/bam_with_RG"
OUT_DIR="pen_proj/bam_files/bwa_v2_Feb27/bam_with_RG_dedup"


mkdir -p ${OUT_DIR}/metrics

# Create variables

	# Read full sample paths into array
		SAMPLES=(${IN_DIR}/*.bam)

	# Define sample basenames
		SAMPLE_NAMES=("${SAMPLES[@]##*/}")
		SAMPLE_NAMES=("${SAMPLE_NAMES[@]%.bam}") 

	# Grab specific sample from array 
		SAMPLE_NAME=${SAMPLE_NAMES[$SLURM_ARRAY_TASK_ID]} 


echo "Writing files to ${OUT_DIR}/${SAMPLE_NAME}_dedup.bam"
echo "Writing metrics to ${OUT_DIR}/metrics/${SAMPLE_NAME}_dedup_metrics.txt"

	micromamba run -n gatk gatk MarkDuplicatesSpark \
	-I ${IN_DIR}/${SAMPLE_NAME}.bam \
	-M ${OUT_DIR}/metrics/${SAMPLE_NAME}_dedup_metrics.txt \
	-O ${OUT_DIR}/${SAMPLE_NAME}_dedup.bam

echo "Finished processing ${SAMPLE_NAME}"
