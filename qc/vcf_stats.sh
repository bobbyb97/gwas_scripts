#!/bin/bash
#SBATCH -J bcftools_stats
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --time 9:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=1G
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err


IN_DIR=/storage/home/rjb6794/scratch/calferv_2025/calferv25_vcf_files
OUT_DIR=/storage/home/rjb6794/scratch/calferv_2025/calferv25_vcf_files/vcf_stats
REF=/storage/home/rjb6794/scratch/ncbi_dataset/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna

# make output directory if it doesn't exist
mkdir -p ${OUT_DIR}

# define stats function
stats() {
	local vcf="$1"
	echo "Processing $vcf, writing to ${OUT_DIR}/$(basename "${vcf%.vcf.gz}")"
	bcftools stats $vcf > ${OUT_DIR}/$(basename "${vcf%.vcf.gz}").vcf.stats
}

plot_stats() {
	local stats_file="$1"
	echo "Plotting $stats_file, writing to ${OUT_DIR}/plots/$(basename ${stats_file})_plots"
	plot-vcfstats -p ${OUT_DIR}/plots/$(basename ${stats_file})_plots $stats_file
}

# export variables and function for GNU parallel
export -f stats
export -f plot_stats
export OUT_DIR
export IN_DIR

# run in parallel
# parallel -j 30 stats ::: ${IN_DIR}/*.vcf.gz

parallel -j 30 plot_stats ::: ${OUT_DIR}/*.vcf.stats