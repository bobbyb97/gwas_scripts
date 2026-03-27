#!/bin/bash
#SBATCH -J gatk_select_variants
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=12G
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

CONDA="micromamba run -n gatk"
JAVA_OPTS="-Xmx8g"

# Define required inputs
REF=calferv_proj/ref_genome/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna
IN_DIR=calferv_proj/GWAS_2026/vcf/joint
OUT_DIR=calferv_proj/GWAS_2026/vcf/BQSR
JOINT_GVCF=${IN_DIR}/all_scaffolds_merged.gvcf.gz

# SNP AND INDEL file names (unfiltered)
SNP_GVCF=${IN_DIR}/snp_variants.gvcf.gz
INDEL_GVCF=${IN_DIR}/indel_variants.gvcf.gz

# Intermediate outputs, filtered files of high quality snps and indels
SNP_FILTERED_VCF=${IN_DIR}/snp_variants_hard_filtered.vcf.gz
INDEL_FILTERED_VCF=${IN_DIR}/indel_variants_hard_filtered.vcf.gz

# Final merged output of all filtered variants to be used for BQSR bootstrapping and initial popgen estimates
MERGED_VCF=${OUT_DIR}/known_vars_hard_filtered.vcf.gz
MERGED_HARD_FILTERED_VCF=${OUT_DIR}/exclude_hard_filtered_vars.vcf.gz

### Variant selection and filtering for known variants for BQSR bootstrapping ####
# echo "Starting variant type selection and filtering for BQSR bootstrapping: $(date +%D_%T)"

# # Select base SNP file
# 	${CONDA} gatk --java-options ${JAVA_OPTS} SelectVariants \
# 	--reference ${REF} \
# 	--V ${JOINT_GVCF} \
# 	--select-type SNP \
# 	--O ${SNP_GVCF}

# # Select base indel file
# 	${CONDA} gatk --java-options ${JAVA_OPTS} SelectVariants \
# 	--reference ${REF} \
# 	--V ${JOINT_GVCF} \
# 	--select-type INDEL \
# 	--O ${INDEL_GVCF}

echo "Finished selecting variants by type, now filtering SNPs: $(date +%D_%T)"
# Filter variants for SNPs
	${CONDA} gatk --java-options ${JAVA_OPTS} VariantFiltration \
	-V ${SNP_GVCF} \
	-filter "QD < 10.0" --filter-name "QD10" \
	-filter "QUAL < 50.0" --filter-name "QUAL50" \
	-filter "AN < 150" --filter-name "AN150" \
	-filter "AF < 0.05" --filter-name "AF05" \
	-filter "SOR > 3.0" --filter-name "SOR3" \
	-filter "FS > 60.0" --filter-name "FS60" \
	-filter "MQ < 40.0" --filter-name "MQ40" \
	-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
	-filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
	-O ${SNP_FILTERED_VCF}


echo "Finished filtering SNPs, now filtering indels: $(date +%D_%T)"
# Filter variants for indels
	${CONDA} gatk --java-options ${JAVA_OPTS} VariantFiltration \
	-V ${INDEL_GVCF} \
	-filter "QD < 10.0" --filter-name "QD10" \
 	-filter "QUAL < 50.0" --filter-name "QUAL50" \
	-filter "FS > 200.0" --filter-name "FS200" \
	-filter "SOR > 10.0" --filter-name "SOR10" \
	-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
	-O ${INDEL_FILTERED_VCF}

# Merge VCFs for a hardfiltered set of true variants for BQSR bootstrapping
echo "Merging filtered SNP and indel gVCFs for BQSR: $(date +%D_%T)"
echo "Writing to ${MERGED_VCF}"

	${CONDA} gatk --java-options ${JAVA_OPTS} MergeVcfs \
	--REFERENCE_SEQUENCE ${REF} \
	--INPUT ${SNP_FILTERED_VCF} \
	--INPUT ${INDEL_FILTERED_VCF} \
	--O ${MERGED_VCF}

	${CONDA} gatk --java-options ${JAVA_OPTS} SelectVariants \
	--reference ${REF} \
	--V ${MERGED_VCF} \
	--exclude-filtered true \
	--O ${MERGED_HARD_FILTERED_VCF}

# Index vcf for downstream use
	${CONDA} gatk --java-options ${JAVA_OPTS} IndexFeatureFile \
	--input ${MERGED_HARD_FILTERED_VCF}