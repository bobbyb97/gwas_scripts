#!/bin/bash
#SBATCH -J scaffold_genotypeGVCFarray
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --time 7:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=24G
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err
#SBATCH --array=1-8
#SBATCH --account=hmh19_cr_default
#SBATCH --partition=standard

# Define variables
VCF=calferv_proj/GWAS_2026/vcf/raw_vcf
OUT_DIR=calferv_proj/GWAS_2026/vcf/joint/v3/chunks
GENDB=calferv_proj/GWAS_2026/genomicDB_v3
REF=calferv_proj/ref_genome/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna

mkdir -p ${OUT_DIR}

INTERVALS_FILE=${VCF}/intervals.intervals

INTERVAL=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${INTERVALS_FILE})


echo "Running GenotypeGVCFs on ${INTERVAL}, writing to ${OUT_DIR}/${INTERVAL}.gvcf.gz"

# Genotype aggregated VCFs
micromamba run -n gatk gatk --java-options "-Xmx20g" GenotypeGVCFs\
	--reference ${REF}\
	--variant gendb://${GENDB}\
	--intervals ${INTERVAL}\
	-output ${OUT_DIR}/${INTERVAL}.gvcf.gz
