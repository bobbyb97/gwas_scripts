#!/bin/bash
#SBATCH -J gatk_sort
#SBATCH -n 32
#SBATCH --time 1-023:58:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000


input_dir="your_input_dir"
output_dir="your_output_dir"

file_pairs=()

# Generating array of file names
# Separating strings for later use
for r1 in "$input_dir"/*_R1.fq.gz; do
    r2="${r1/_R1.fq.gz/_R2.fq.gz}"
    if [[ -f "$r2" ]]; then
        output="${r1/_R1.fq.gz/}"
        file_pairs+=("$r1 $r2 $output")
    else
        echo "Warning: No matching R2 file for $r1" >&2
    fi
done

for input in "${file_pairs[@]}"; do
    IFS=' ' read -r r1 r2 output <<< "$input"
gatk MarkDuplicatesSpark -I ${output_dir}${output}_fixed.bam -M ${output_dir}Metrics/${output}_dedup_metrics.txt -O ${output_dir}BAMS/${output}_sorted_dedup_reads.bam
done
