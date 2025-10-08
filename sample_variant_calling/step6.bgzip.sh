#!/bin/bash
#SBATCH -J gzip_vcfs
#SBATCH -n 8
#SBATCH --time 23:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000


input_dir="calferv25_vcf_files"

# bgzip all vcf files
for f in ${input_dir}/*.g.vcf; do
	echo "Zipping $f..."
	micromamba run -n bioinfo bgzip $f
done


# # index all vcf.gz files
for f in ${input_dir}/*.g.vcf.gz; do
	echo "Indexing $f..."
	micromamba run -n gatk gatk IndexFeatureFile -I $f
done
