#!/bin/bash
#SBATCH -J gzip_vcfs
#SBATCH -n 8
#SBATCH --time 4-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

FILE2=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/

for file in ${FILE2}*.g.vcf; do
bgzip $file
done

for zip in ${FILE2}*.g.vcf.gz; do
	/storage/home/tpd5366/work/gatk-4.4.0.0/gatk IndexFeatureFile -I $zip
done
