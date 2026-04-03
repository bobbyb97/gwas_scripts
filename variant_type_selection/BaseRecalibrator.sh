#!/bin/bash
#SBATCH -J BaseRecalibrator
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=6:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=8G
#SBATCH --array=0-98%10
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err


#define variables
IN_DIR=calferv_proj/GWAS_2026/bam/all_bam
OUT_DIR=calferv_proj/GWAS_2026/bam/BQSR
SUFFIX="_trimmed_sorted_RG_dedup.bam"
VCF=calferv_proj/GWAS_2026/vcf/BQSR/exclude_hard_filtered_vars.vcf.gz
REF=calferv_proj/ref_genome/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna


mkdir -p ${OUT_DIR}

	# Read full sample paths into array
		SAMPLES=(${IN_DIR}/*_trimmed_sorted_RG_dedup.bam)

	# Define sample basenames
		SAMPLE_NAMES=("${SAMPLES[@]##*/}")
		SAMPLE_NAMES=("${SAMPLE_NAMES[@]%${SUFFIX}}") 

	# Grab specific sample from array 
		SAMPLE_NAME=${SAMPLE_NAMES[$SLURM_ARRAY_TASK_ID]} 


get_bqsr_table() {
	output="$1"
	echo "Running BaseRecalibrator on ${output}${SUFFIX}, writing to ${OUT_DIR}/${output}_recal_data.table"
	micromamba run -n gatk gatk BaseRecalibrator\
		--input ${IN_DIR}/${output}${SUFFIX}\
		--reference ${REF}\
		--known-sites ${VCF}\
		--output ${OUT_DIR}/${output}_recal_data.table
}

get_bqsr_table ${SAMPLE_NAME}