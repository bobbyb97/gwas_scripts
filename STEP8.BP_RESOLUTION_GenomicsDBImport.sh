#!/bin/bash
#SBATCH -J gatk_aggregate
#SBATCH -n 8
#SBATCH --time 4-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio
FILE2=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/
FILE3=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/GenomicsDB/
TEMP=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/TEMP/
REF=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/refs/flavifrons/Bombus_flavifrons.p_ctg.purged.clean.fasta

/storage/home/tpd5366/work/gatk-4.4.0.0/gatk GenomicsDBImport -V ${FILE2}JK37_raw_variant.g.vcf.gz -V ${FILE2}JKAL36_raw_variant.g.vcf.gz -V ${FILE2}JKMIR022_raw_variant.g.vcf.gz -V ${FILE2}MIR001A_raw_variant.g.vcf.gz -V ${FILE2}TDB001_raw_variant.g.vcf.gz -V ${FILE2}TDB002_raw_variant.g.vcf.gz -V ${FILE2}TDB003_raw_variant.g.vcf.gz -V ${FILE2}TDB004_raw_variant.g.vcf.gz -V ${FILE2}TDB009_raw_variant.g.vcf.gz -V ${FILE2}TDB010_raw_variant.g.vcf.gz -V ${FILE2}TDB011_raw_variant.g.vcf.gz -V ${FILE2}TDB012_raw_variant.g.vcf.gz -V ${FILE2}TDB013_raw_variant.g.vcf.gz -V ${FILE2}TDB016_raw_variant.g.vcf.gz -V ${FILE2}TDB017_raw_variant.g.vcf.gz -V ${FILE2}TDB018_raw_variant.g.vcf.gz -V ${FILE2}TDB019_raw_variant.g.vcf.gz -V ${FILE2}TDB020_raw_variant.g.vcf.gz -V ${FILE2}TDB021_raw_variant.g.vcf.gz -V ${FILE2}TDB022_raw_variant.g.vcf.gz -V ${FILE2}TDB023_raw_variant.g.vcf.gz -V ${FILE2}TDR002_raw_variant.g.vcf.gz -V ${FILE2}TDR003_raw_variant.g.vcf.gz -V ${FILE2}TDR005_raw_variant.g.vcf.gz -V ${FILE2}TDR006_raw_variant.g.vcf.gz -V ${FILE2}TDR007_raw_variant.g.vcf.gz -V ${FILE2}TDR008_raw_variant.g.vcf.gz -V ${FILE2}TDR009_raw_variant.g.vcf.gz -V ${FILE2}TDR010_raw_variant.g.vcf.gz -V ${FILE2}TDR011_raw_variant.g.vcf.gz -V ${FILE2}TDR012_raw_variant.g.vcf.gz -V ${FILE2}TDR016_raw_variant.g.vcf.gz -V ${FILE2}TDR017_raw_variant.g.vcf.gz -V ${FILE2}TDR018_raw_variant.g.vcf.gz -V ${FILE2}TDR019_raw_variant.g.vcf.gz -V ${FILE2}TDR021_raw_variant.g.vcf.gz -V ${FILE2}TDR025_raw_variant.g.vcf.gz  --genomicsdb-workspace-path ${FILE3} --tmp-dir ${TEMP} -L intervals.intervals --batch-size 50 --merge-contigs-into-num-partitions 80 --bypass-feature-reader --merge-input-intervals
