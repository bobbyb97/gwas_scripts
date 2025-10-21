#!/bin/bash
#SBATCH -J samtools_stats
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --cpus-per-task=1
#SBATCH --time 9:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 4G
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

IN_DIR=/storage/home/rjb6794/scratch/calferv_2025/chr_level_bams
OUT_DIR=/storage/home/rjb6794/scratch/calferv_2025/samtools_stats_chr_level_bams
REF=/storage/home/rjb6794/scratch/ncbi_dataset/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna

# make output directory if it doesn't exist
mkdir -p ${OUT_DIR}

# define stats function
stats() {
	local bam="$1"
	echo "Processing $bam, writing to ${OUT_DIR}/$(basename "${bam%.bam}")"
	micromamba run -n bioinfosamtools stats --verbosity 1 --ref-seq ${REF} "$bam" > ${OUT_DIR}/"$(basename "${bam%.bam}.stats")"
	micromamba run -n bioinfo samtools coverage "$bam" > ${OUT_DIR}/"$(basename "${bam%.bam}.cov")"
}

# export variables and function for GNU parallel
export -f stats
export OUT_DIR
export IN_DIR
export REF

# run in parallel
micromamba run -n bioinfo parallel -j ${SLURM_CPUS_PER_TASK} stats ::: ${IN_DIR}/*.bam