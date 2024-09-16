#!/bin/bash
#SBATCH -J gatk_genotypegvcf
#SBATCH -n 8
#SBATCH --time 6-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

FILE1=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/
FILE2=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/GenomicsDB/
FILE3=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Raw/TEMP/
REF=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/refs/flavifrons/Bombus_flavifrons.p_ctg.purged.clean.fasta

/storage/home/tpd5366/work/gatk-4.4.0.0/gatk GenotypeGVCFs -R ${REF} -V gendb://${FILE2} -O ${FILE1}Vcfcall_from_genomicsdb_bpresolution_strict_alignment.vcf.gz --tmp-dir ${FILE3}
