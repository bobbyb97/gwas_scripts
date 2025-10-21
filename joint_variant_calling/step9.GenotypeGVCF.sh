#!/bin/bash
#SBATCH -J gatk_genotypegvcf
#SBATCH -n 1
#SBATCH --cpus-per-task=8
#SBATCH --time 1-23:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=24G


### --account=hmh19_cr_default
### --partition=standard

# Define variables
VCF="calferv_2025/calferv25_vcf_files"
GENDB="calferv_2025/calferv25_vcf_files/genomicDB"
TMP_DIR="calferv_2025/calferv25_vcf_files/tmp"
REF="ncbi_dataset/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna"

# Genotype aggregated VCFs
micromamba run -n gatk gatk GenotypeGVCFs\
    -R ${REF}\
    -V gendb://${GENDB}\
    -O ${VCF}/joint_vcf_call_bpres.vcf.gz
