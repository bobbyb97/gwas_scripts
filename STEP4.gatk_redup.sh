#!/bin/bash
#SBATCH -J gatk_sort
#SBATCH -n 32
#SBATCH --time 1-023:58:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000


input_dir="trimmed_fastq"
output_dir="redup_reads/"

file_pairs=()

##--NOTHING BELOW THIS LINE SHOULD BE MODIFIED--##

# Generating array of file names
# Separating strings for later use
for r1 in "$input_dir"/*_R1.fq.gz; do
    r2="${r1/_R1.fq.gz/_R2.fq.gz}"
    if [[ -f "$r2" ]]; then
        output="$(basename "${r1/_R1.fq.gz/}")"
        file_pairs+=("$r1 $r2 $output")
    else
        echo "Warning: No matching R2 file for $r1" >&2
    fi
done

for input in "${file_pairs[@]}"; do
    IFS=' ' read -r r1 r2 output <<< "$input"
    echo ${r1} ${r2} ${output}
    gatk MarkDuplicatesSpark -I ${input_dir}/${output}_fixed.bam -M ${input_dir}/${output_dir}/${output}_dedup_metrics.txt -O $input_dir/${output_dir}/${output}_sorted_dedup_reads.bam
done
