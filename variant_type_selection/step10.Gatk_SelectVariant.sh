#!/bin/bash
#SBATCH -J gatk_select_and_filter
#SBATCH -n 8
#SBATCH --time 5-010:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio
#SBATCH --mem-per-cpu 8000


BAM_DIR="sorted_dedup"
FILE1=VCFS/Raw/
FILE2=VCFS/Raw/indels/
FILE3=VCFS/Raw/snps/
FILE4=VCFS/Recalibration_tables/
REF="GCA_041682495.1_iyBomFerv1_genomic.fna"

gatk SelectVariants -R ${REF} -V ${FILE1}Vcfcall_from_genomicsdb_bpresolution_strict_alignment.vcf.gz --select-type-to-include SNP -O ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_snps.vcf
gatk SelectVariants -R ${REF} -V ${FILE1}Vcfcall_from_genomicsdb_bpresolution_strict_alignment.vcf.gz --select-type-to-include INDEL -O ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_indels.vcf

gatk VariantFiltration -R ${REF} -V ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_snps.vcf -O ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_filtered_snps.vcf \
--filter-name "QD_filter" --filter-expression "QD < 2.0" \
--filter-name "FS_filter" --filter-expression "FS > 60.0" \
--filter-name "MQ_filter" --filter-expression "MQ < 40.0" \
--filter-name "SOR_filter" --filter-expression "SOR > 4.0"
--filter-name "MQRankSum_filter" --filter-expression "MQRankSum < -12.5" \
--filter-name "ReadPosRankSum_filter" -filter-expression "ReadPosRankSum < -8.0"

gatk VariantFiltration -R ${REF} -V ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_indels.vcf -O ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_filtered_indels.vcf \
--filter-name "QD_filter" --filter-expression "QD < 2.0" \
--filter-name "FS_filter" --filter-expression "FS > 60.0" \
--filter-name "SOR_filter" --filter-expression "SOR > 4.0"

gatk SelectVariants --exclude-filtered -V ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_filtered_snps.vcf -O ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_bqsr_snps.vcf
gatk SelectVariants --exclude-filtered -V ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_filtered_indels.vcf -O ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_bqsr_indels.vcf

files=()

for input in "${files[@]}"; do
    set -- $input
    echo "Base recalibrating for ${1}"

gatk BaseRecalibrator -R ${REF} -I ${BAM_DIR}${1}_sorted_dedup_reads.bam --known-sites ${FILE3}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_bqsr_snps.vcf --known-sites ${FILE2}Vcfcall_from_genomicsdb_bpresolution_strict_alignment_bqsr_indels.vcf -O ${FILE4}${1}_recal_data.table
done
