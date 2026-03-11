#!/bin/bash
#SBATCH -J perc_endog
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=1:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=1G
#SBATCH --array=0-20%10
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

CONDA="micromamba run -n bioinfo"

# Define variables
IN_DIR=pen_proj/bam_files/bwa_v2_Feb27/bam_with_RG_dedup
OUT_DIR=pen_proj/bam_files/bwa_v2_Feb27/bam_with_RG_dedup/qc_stats

# Create variables

	# Read full sample paths into array
		SAMPLES=(${IN_DIR}/*.bam)

	# Grab specific sample from array 
		BAM=${SAMPLES[$SLURM_ARRAY_TASK_ID]} 
		SAMPLE_NAME=$(basename "${BAM%.bam}")


	# Echo slurm array task ID and sample name for debugging
		echo "Task ID $SLURM_ARRAY_TASK_ID: Calculating % endogenous content for ${SAMPLE_NAME}"


# Find endogenous DNA % = (Mapped, Non-duplicate, MapQ > 20 reads) / (Total Trimmed reads)
# -F 3332 excludes: unmapped (4), secondary (256), duplicate (1024), supplementary (2048)
ENDOGENOUS=$( $CONDA samtools view -c -F 3332 -q 20 "$BAM")
TOTAL=$( $CONDA samtools view -c "$BAM")
# Use bc for the math
PERC_ENDOG=$(echo "scale=4; ($ENDOGENOUS / $TOTAL) * 100" | bc)

echo -e "${SAMPLE_NAME}\t${ENDOGENOUS}\t${TOTAL}\t${PERC_ENDOG}" >> ${OUT_DIR}/perc_endog.tsv
