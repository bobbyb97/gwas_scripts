#!/bin/bash
#SBATCH -J merge_vcfs
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=5:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=12G
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

CONDA="micromamba run -n gatk"
JAVA_OPTS="-Xmx8g"
REF=calferv_proj/ref_genome/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna
VCF_DIR=calferv_proj/GWAS_2026/vcf/joint/v3/chunks
MERGED_GVCF=calferv_proj/GWAS_2026/vcf/joint/v3/all_scaffolds_merged.gvcf.gz


# Create list of vcf files in input directory
ls -1 ${VCF_DIR}/*.gvcf.gz > ${VCF_DIR}/vcf_file.list
cat ${VCF_DIR}/vcf_file.list

# Run GatherVcfsCloud to merge
${CONDA} gatk --java-options ${JAVA_OPTS} GatherVcfsCloud \
	--input ${VCF_DIR}/vcf_file.list \
	--output ${MERGED_GVCF}

# IndexFeatureFile to create index for merged gvcf
${CONDA} gatk --java-options ${JAVA_OPTS} IndexFeatureFile \
	--input ${MERGED_GVCF}