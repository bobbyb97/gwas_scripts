#!/bin/bash
#SBATCH -J gatk_markdup
#SBATCH -n 32
#SBATCH --time 3-023:58:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 24G
#SBATCH --account=hmh19_cr_default
#SBATCH --partition=standard

FQ_DIR="calferv_2025/trimmed_rd2_fastq"
BAM_DIR="calferv_bams_fixed"
OUT_DIR="sorted_dedup"
N_TASKS=2


mkdir -p ${OUT_DIR}/metrics

file_pairs=()

# Generating array of file names
# Separating strings for later use
for r1 in "$FQ_DIR"/*_R1.fq.gz; do
    r2="${r1/_R1.fq.gz/_R2.fq.gz}"
    if [[ -f "$r2" ]]; then
		output=$(basename "${r1/_R1.fq.gz/}")
        file_pairs+=("$r1 $r2 $output")
    else
        echo "Warning: No matching R2 file for $r1" >&2
    fi
done

process_pair() {
	IFS=' ' read -r r1 r2 output <<< "$1"
	echo "Processing ${r1} and ${r2}, writing to ${OUT_DIR}/${output}_sorted_dedup_reads.bam"
	micromamba run -n gatk gatk MarkDuplicatesSpark \
		-I ${BAM_DIR}/${output}_fixed.bam \
		-M ${OUT_DIR}/metrics/${output}_dedup_metrics.txt \
		-O ${OUT_DIR}/${output}_sorted_dedup_reads.bam \
		--conf 'spark.executor.cores=16' \
		--conf 'spark.executor.memory=24g'
}


export FQ_DIR BAM_DIR OUT_DIR N_TASKS 
export -f process_pair

parallel -j ${N_TASKS} process_pair ::: "${file_pairs[@]}"


## slow way ##

# for input in "${file_pairs[@]}"; do
#     IFS=' ' read -r r1 r2 output <<< "$input"
#     echo "Writing files to ${OUT_DIR}/${output}_sorted.bam"
#     echo "Writing metrics to ${OUT_DIR}/metrics/${output}_dedup_metrics.txt"
#     # gatk MarkDuplicatesSpark -I ${OUT_DIR}/${output}_fixed.bam \
# 	# -M ${OUT_DIR}/metrics/${output}_dedup_metrics.txt \
# 	# -O ${OUT_DIR}/${output}_sorted_dedup_reads.bam
# done