#!/bin/bash
#SBATCH -J haplotype_caller_array
#SBATCH --nodes 1
#SBATCH --ntasks 1
#SBATCH --time 5:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 6G
#SBATCH --array=0-55%10
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

## MAKE SURE YOU USE THE CORRECT PLOIDY ##

IN_DIR=calferv_proj/GWAS_2026/bam/BQSR/recalibrated_bams/haploid
OUT_DIR=calferv_proj/GWAS_2026/vcf/BQSR/bqsr_vcf
SUFFIX="BQSR.bam"

REF=calferv_proj/ref_genome/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna

PLOIDY=1




mkdir -p ${OUT_DIR}

	# Read full sample paths into array
		SAMPLES=(${IN_DIR}/*${SUFFIX})

	# Define sample basenames
		SAMPLE_NAMES=("${SAMPLES[@]##*/}")
		SAMPLE_NAMES=("${SAMPLE_NAMES[@]%${SUFFIX}}") 

	# Grab specific sample from array 
		SAMPLE_NAME=${SAMPLE_NAMES[$SLURM_ARRAY_TASK_ID]} 



call_var() {
	output="$1"
	echo "Calling variants from ${output}${SUFFIX}, writing to ${OUT_DIR}/${output}_BQSR.gvcf"
	micromamba run -n gatk gatk HaplotypeCaller\
		-R ${REF}\
		-I ${IN_DIR}/${output}${SUFFIX}\
		-O ${OUT_DIR}/${output}_BQSR.gvcf\
		-ploidy ${PLOIDY} \
		-ERC GVCF
}

call_var ${SAMPLE_NAME}