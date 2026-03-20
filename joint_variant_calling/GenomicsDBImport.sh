#!/bin/bash
#SBATCH -J GenomicsDBImport
#SBATCH -n 1
#SBATCH --ntasks 4
#SBATCH --time 2-23:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 12G
#SBATCH --account=hmh19_cr_default
#SBATCH --partition=standard
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err


## GenomicsDB must not exist before running script, otherwise it will fail ##

# Define variables
VCF="calferv_proj/GWAS_2026/vcf/raw_vcf"
GENDB="calferv_proj/GWAS_2026/genomicDB"
TMP_DIR="calferv_proj/GWAS_2026/vcf/tmp"
REF="calferv_proj/ref_genome/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna"


mkdir -p ${TMP_DIR}

# Create GVCF map file
# for f in ${VCF}/*.gvcf.gz; do
#     sample_id=$(echo $f | grep -oP ${VCF}'\/\K(.*?)(?=_raw_variant\.gvcf\.gz)')
#     echo -e "${sample_id}\t${f}" >> ${VCF}/gvcf.sample_map
# done

# Create intervals file
cat ${REF}.fai | cut -f 1 > ${VCF}/intervals.intervals

# Aggregate all samples together for joint genotyping

micromamba run -n gatk gatk GenomicsDBImport\
		--sample-name-map ${VCF}/gvcf.sample_map\
		--genomicsdb-workspace-path ${GENDB}\
		--tmp-dir ${TMP_DIR}\
		--intervals ${VCF}/intervals.intervals\
		--reader-threads 4 \
		--max-num-intervals-to-import-in-parallel 6 \
		--batch-size 12 \
		--merge-input-intervals true \
		--java-options '-DGATK_STACKTRACE_ON_USER_EXCEPTION=true'