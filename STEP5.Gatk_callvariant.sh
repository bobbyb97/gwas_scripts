#!/bin/bash
#SBATCH -J gatk_variant
#SBATCH -n 8
#SBATCH --time 12-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

input_dir="sorted_dedup"
output_dir=""

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
    echo "Calling variants for ${output}_sorted_dedup_reads.bam"
    gatk HaplotypeCaller -R ${REF} -I ${FILE}${1}_sorted_dedup_reads.bam -O ${FILE2}${1}_raw_variant.g.vcf -ploidy 1 -ERC BP_RESOLUTION
done
