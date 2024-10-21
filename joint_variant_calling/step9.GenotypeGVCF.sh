#!/bin/bash
#SBATCH -J gatk_genotypegvcf
#SBATCH -n 8
#SBATCH --time 6-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

# Define variables
VCF="vcf_files"
GENDB="vcf_files/genomicDB"
TMP_DIR="vcf_files/tmp"
REF="GCA_041682495.1_iyBomFerv1_genomic.fna"

# Genotype aggregated VCFs
gatk GenotypeGVCFs\
    -R ${REF}\
    -V gendb://${GENDB}\
    -O ${VCF}/joint_vcf_call_bpres.vcf.gz
