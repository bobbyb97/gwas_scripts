#!/bin/bash
#SBATCH -J samtools_stats
#SBATCH -n 24
#SBATCH --time 012:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 24G

IN_DIR=calferv_bams
OUT_DIR=calferv_bam_stats
REF=/storage/home/rjb6794/scratch/ncbi_dataset/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna

# make output directory if it doesn't exist
mkdir -p ${OUT_DIR}

#define stats function
stats() {
	local bam="$1"
	echo "Processing $bam, writing to ${OUT_DIR}/$(basename "${bam%.bam}")"
	#samtools stats --verbosity 1 --ref-seq ${REF} "$bam" > ${OUT_DIR}/"$(basename "${bam%.bam}.stats")"
	samtools coverage "$bam" > ${OUT_DIR}/"$(basename "${bam%.bam}.cov")"
}

#export variables and function for GNU parallel
export -f stats
export OUT_DIR
export IN_DIR
export REF

# run in parallel
parallel -j 16 stats ::: ${IN_DIR}/*.bam
