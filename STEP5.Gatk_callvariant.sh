#!/bin/bash
#SBATCH -J gatk_variant_2
#SBATCH -n 16
#SBATCH --time 3-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

input_dir="sorted_dedup_2"
output_dir="vcf_files"
REF="GCA_041682495.1_iyBomFerv1_genomic.fna"
file_pairs=()

# Generating array of file names
# Separating strings for later use
for r1 in "$input_dir"/*reads.bam; do
    r2="${r1/_R1.fq.gz/_R2.fq.gz}"
    if [[ -f "$r2" ]]; then
        output="${r1#${input_dir}/}"
        output="${output/_sorted_dedup_reads.bam/}"
        file_pairs+=("$r1 $r2 $output")
    else
        echo "Warning: No matching R2 file for $r1" >&2
    fi
done

for input in "${file_pairs[@]}"; do
    IFS=' ' read -r r1 r2 output <<< "$input"
    echo "Calling variants for ${output} from ${REF}, writing to ${output_dir}/${output}_raw_variant.g.vcf"
    gatk HaplotypeCaller\
     -R ${REF}\
     -I ${input_dir}/${output}_sorted_dedup_reads.bam\
     -O ${output_dir}/${output}_raw_variant.g.vcf\
     -ploidy 1\
     -ERC BP_RESOLUTION
done
