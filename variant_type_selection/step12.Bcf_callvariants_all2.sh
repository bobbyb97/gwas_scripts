#!/bin/bash
#SBATCH -J bcf_variant2
#SBATCH -n 8
#SBATCH --time 5-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio
#SBATCH --mem-per-cpu 8000

REF=/storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/refs/flavifrons/Bombus_flavifrons.p_ctg.purged.clean.fasta
files=()

bcftools mpileup -Ou -f ${REF} "${files[@]}" | bcftools call -mv --ploidy 1 -Ov -o /storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/VCFS/Recalibrated/All_strict_variants_called_with_recalibrated_bams_via_bcftools_18black_17red.vcf
