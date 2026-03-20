#!/bin/bash
#SBATCH -J merge_vcfs
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=4G
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

CONDA="micromamba run -n gatk"
REF=
VCF_DIR=calferv_proj/GWAS_2026/vcf/joint/chunks
MERGED_GVCF=

printf "%s\n" ${VCF_DIR}/*.gvcf.gz > ${VCF_DIR}/vcf_file.list

cat ${VCF_DIR}/vcf_file.list

	${CONDA} gatk MergeVcfs \
	--REFERENCE_SEQUENCE ${REF} \
	--INPUT ${VCF_DIR}/vcf_file.list \
	--O ${MERGED_GVCF}