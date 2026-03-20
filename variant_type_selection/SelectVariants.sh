#!/bin/bash
#SBATCH -J gatk_select_variants
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

CONDA="micromamba run -n gatk"
REF=

JOINT_GVCF=
SNP_GVCF=
INDEL_GVCF=

MERGED_GVCF=

# Select base SNP file
	${CONDA} gatk SelectVariants \
	--REFERENCE_SEQUENCE ${REF} \
	--V ${JOINT_GVCF} \
	--select-type SNP \
	--O ${SNP_GVCF}

# Select base indel file
	${CONDA} gatk SelectVariants \
	--REFERENCE_SEQUENCE ${REF} \
	--V ${JOINT_GVCF} \
	--select-type INDEL \
	--O ${INDEL_GVCF}

# Filter variants for SNPs
	${CONDA} gatk VariantFiltration \
	-V ${SNP_GVCF} \
	-filter "QD < 2.0" --filter-name "QD2" \
	-filter "QUAL < 30.0" --filter-name "QUAL30" \
	-filter "SOR > 3.0" --filter-name "SOR3" \
	-filter "FS > 60.0" --filter-name "FS60" \
	-filter "MQ < 40.0" --filter-name "MQ40" \
	-filter "MQRankSum < -12.5" --filter-name "MQRankSum-12.5" \
	-filter "ReadPosRankSum < -8.0" --filter-name "ReadPosRankSum-8" \
	-O ${SNP_FILTERED_GVCF}

# Filter variants for indels
	${CONDA} gatk VariantFiltration \
	-V indels.vcf.gz \
	-filter "QD < 2.0" --filter-name "QD2" \
 	-filter "QUAL < 30.0" --filter-name "QUAL30" \
	-filter "FS > 200.0" --filter-name "FS200" \
	-filter "ReadPosRankSum < -20.0" --filter-name "ReadPosRankSum-20" \
	-O indels_filtered.vcf.gz


# Merge VCFs for a hardfiltered set of true variants for BQSR bootstrapping

	${CONDA} gatk MergeVcfs \
	--REFERENCE_SEQUENCE ${REF} \
	--INPUT ${SNP_FILTERED_GVCF} \
	--INPUT ${INDEL_FILTERED_GVCF} \
	--O ${MERGED_GVCF}