#!/bin/bash
#SBATCH -J gatk_aggregate
#SBATCH -n 8
#SBATCH --time 4-023:59:00
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

# Create GVCF map file
for f in ${VCF}/*.g.vcf.gz; do
    sample_id=$(echo $f | grep -oP 'vcf_files\/\K(.*?)(?=_trimmed_raw_variant\.g\.vcf\.gz)')
    echo -e "${sample_id}\t${f}" >> ${VCF}/gvcf.sample_map
done

# Create intervals file
cat ${REF}.fai | cut -f 1 > ${VCF}/intervals.intervals

# Aggregate all samples together for joint genotyping

gatk GenomicsDBImport\
    --sample-name-map ${VCF}/gvcf.sample_map\
    --genomicsdb-workspace-path ${GENDB}\
    --tmp-dir ${TMP_DIR}\
    -L ${VCF}/intervals.intervals\
    --reader-threads 8