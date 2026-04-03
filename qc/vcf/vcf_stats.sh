#!/bin/bash
#SBATCH -J vcf_stats
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=1G
#SBATCH --array=0-11
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

IN_DIR=calferv_proj/GWAS_2026/vcf/BQSR
OUT_DIR=${IN_DIR}/vcf_stats
SUFFIX=".vcf.gz"

# make output directory if it doesn't exist
mkdir -p ${OUT_DIR}

# define stats function
stats() {
	local vcf="$1"
	echo "Processing $vcf, writing to ${OUT_DIR}/$(basename "${vcf%${SUFFIX}}")"
	micromamba run -n bioinfo bcftools stats $vcf > ${OUT_DIR}/$(basename "${vcf%${SUFFIX}}").vcf.stats
}

# Create variables

	# Read full sample paths into array
		SAMPLES=(${IN_DIR}/*${SUFFIX})

	# Grab specific sample from array 
		VCF=${SAMPLES[$SLURM_ARRAY_TASK_ID]} 

	# Echo slurm array task ID and sample name for debugging
		echo "Task ID $SLURM_ARRAY_TASK_ID: Conducting VCF QC for $(basename "${VCF%${SUFFIX}}")"


stats ${VCF}