#!/bin/bash
#SBATCH -J bam_qc
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=2G
#SBATCH --array=0-97%10
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err


### debugging ###
## set SLURM_ARRAY_TASK_ID manually for testing

# Define the input, output directories and reference genome
IN_DIR=calferv_proj/GWAS_2026/bam
OUT_DIR=calferv_proj/GWAS_2026/bam/qc_stats

REF=calferv_proj/ref_genome/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna

# make output directory if it doesn't exist
mkdir -p ${OUT_DIR}

# define stats function
stats() {
	local bam="$1"
	echo "Reading files from ${IN_DIR}..."
	# echo "Processing $(basename "${bam%.bam}"), writing to ${OUT_DIR}"
	echo "Indexing bam file ..."
	micromamba run -n bioinfo samtools index "$bam"
	echo "Running samtools stats for $(basename "${bam%.bam}")..."
	micromamba run -n bioinfo samtools stats --verbosity 1 --ref-seq ${REF} "$bam" > ${OUT_DIR}/"$(basename "${bam%.bam}.stats")"
	echo "Running samtools coverage for $(basename "${bam%.bam}")..."
	micromamba run -n bioinfo samtools coverage "$bam" > ${OUT_DIR}/"$(basename "${bam%.bam}.cov")"
}

# Create variables

	# Read full sample paths into array
		SAMPLES=(${IN_DIR}/*.bam)

	# # Define sample basenames
	# 	SAMPLE_NAMES=("${SAMPLES[@]##*/}")
	# 	SAMPLE_NAMES=("${SAMPLE_NAMES[@]%_trimmed_sorted.bam}") 

	# Grab specific sample from array 
		BAM=${SAMPLES[$SLURM_ARRAY_TASK_ID]} 

	# # Define bam file names off of specific sample name
	# 	BAM="${SAMPLE_NAME}_trimmed_sorted.bam"

	# Echo slurm array task ID and sample name for debugging
		echo "Task ID $SLURM_ARRAY_TASK_ID: Conducting QC suite for $(basename "${BAM%.bam}")"

# Run stats function
stats ${BAM}