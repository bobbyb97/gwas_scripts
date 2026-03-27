#!/bin/bash
#SBATCH -J vcf_stats
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=4G
#SBATCH --array=0%10
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

IN_DIR=calferv_proj/GWAS_2026/vcf/joint
OUT_DIR=${IN_DIR}/vcf_stats/metrics
REF=calferv_proj/ref_genome/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna
SUFFIX=".gvcf.gz"
DBSNP=calferv_proj/GWAS_2026/vcf/dbsnp/dbsnp.vcf.gz

mkdir -p ${OUT_DIR}

collect_metrics() {
	local VCF="$1"
	echo "Processing $VCF, writing to ${OUT_DIR}/$(basename "${VCF%${SUFFIX}}")"
	# micromamba run -n gatk gatk CollectVariantCallingMetrics \
	# --REFERENCE_SEQUENCE ${REF} \
	# --DBSNP ${DBSNP} \
	# --INPUT ${VCF} \
	# --OUTPUT ${OUT_DIR}/$(basename "${VCF%${SUFFIX}}")
}

# Create variables

	# Read full sample paths into array
		SAMPLES=(${IN_DIR}/*${SUFFIX})

	# # Define sample basenames
	# 	SAMPLE_NAMES=("${SAMPLES[@]##*/}")
	# 	SAMPLE_NAMES=("${SAMPLE_NAMES[@]%_trimmed_sorted.bam}") 

	# Grab specific sample from array 
		VCF=${SAMPLES[$SLURM_ARRAY_TASK_ID]} 
	# # Define bam file names off of specific sample name
	# 	BAM="${SAMPLE_NAME}_trimmed_sorted.bam"

	# Echo slurm array task ID and sample name for debugging
		echo "Task ID $SLURM_ARRAY_TASK_ID: Conducting VCF QC for $(basename "${VCF%${SUFFIX}}")"

collect_metrics ${VCF}