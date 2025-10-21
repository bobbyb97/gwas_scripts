#!/bin/bash
#SBATCH -J gatk_markdup
#SBATCH --nodes 1
#SBATCH --ntasks 16
#SBATCH --cpus-per-task=1
#SBATCH --time 1-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8G
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err

# --account=hmh19_cr_default
#--partition=standard

BAM_DIR="calferv_2024/calferv_bams_fixed"
OUT_DIR="calferv_2024/sorted_dedup"
N_TASKS=16


mkdir -p ${OUT_DIR}/metrics

file_pairs=()

# Generating array of file names
# Separating strings for later use
for file in "$BAM_DIR"/*_trimmed_fixed.bam; do
		output=$(basename "${file/_trimmed_fixed.bam/}")
		file_pairs+=("$output")
done

process_pair() {
	bam_file=$1
	echo "Processing ${bam_file}, writing to ${OUT_DIR}/${bam_file}_sorted_dedup_reads.bam"
	micromamba run -n gatk gatk MarkDuplicatesSpark \
		-I ${BAM_DIR}/${bam_file}_trimmed_fixed.bam \
		-M ${OUT_DIR}/metrics/${bam_file}_dedup_metrics.txt \
		-O ${OUT_DIR}/${bam_file}_sorted_dedup_reads.bam \
		--conf 'spark.executor.cores=16' \
		--conf 'spark.executor.memory=4g'
}


export BAM_DIR OUT_DIR N_TASKS
export file_pairs
export -f process_pair

micromamba run -n bioinfo parallel -j ${N_TASKS} process_pair ::: "${file_pairs[@]}"


## slow way ##

# for input in "${file_pairs[@]}"; do
#     IFS=' ' read -r r1 r2 output <<< "$input"
#     echo "Writing files to ${OUT_DIR}/${output}_sorted.bam"
#     echo "Writing metrics to ${OUT_DIR}/metrics/${output}_dedup_metrics.txt"
#     # gatk MarkDuplicatesSpark -I ${OUT_DIR}/${output}_fixed.bam \
# 	# -M ${OUT_DIR}/metrics/${output}_dedup_metrics.txt \
# 	# -O ${OUT_DIR}/${output}_sorted_dedup_reads.bam
# done