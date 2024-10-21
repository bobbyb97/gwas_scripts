#!/bin/bash
#SBATCH -J gatk_markdup
#SBATCH -n 32
#SBATCH --time 1-023:58:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 16000


input_dir="trimmed_fastq"
output_dir="sorted_dedup"

file_pairs=()

# Generating array of file names
# Separating strings for later use
for r1 in "$input_dir"/*_R1.fq.gz; do
    r2="${r1/_R1.fq.gz/_R2.fq.gz}"
    if [[ -f "$r2" ]]; then
        output="${r1#${input_dir}/}"
        output="${output/_R1.fq.gz/}"
        file_pairs+=("$r1 $r2 $output")
    else
        echo "Warning: No matching R2 file for $r1" >&2
    fi
done

for input in "${file_pairs[@]}"; do
    IFS=' ' read -r r1 r2 output <<< "$input"
    echo "Writing files to ${output_dir}/${output}_sorted.bam"
    echo "Writing metrics to ${output_dir}/metrics/${output}_dedup_metrics.txt"
    gatk MarkDuplicatesSpark -I ${input_dir}/${output}_fixed.bam -M ${output_dir}/metrics/${output}_dedup_metrics.txt -O ${output_dir}/${output}_sorted_dedup_reads.bam
done
