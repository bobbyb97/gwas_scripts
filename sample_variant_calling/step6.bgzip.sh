#!/bin/bash
#SBATCH -J gzip_vcfs
#SBATCH -n 8
#SBATCH --time 4-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

input_dir="vcf_files"

# Activate conda env
source ~/.bashrc
# micromamba activate bioinfo

# bgzip all vcf files
for f in ${input_dir}/*.g.vcf; do
	echo "Zipping $f..."
	# bgzip $f
done

# activate gatk env
# micromamba activate gatk

# # index all vcf.gz files
# for f in ${input_dir}/*.g.vcf.gz; do
# 	gatk IndexFeatureFile -I $f
# done
