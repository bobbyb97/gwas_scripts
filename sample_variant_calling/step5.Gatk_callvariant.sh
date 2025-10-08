#!/bin/bash
#SBATCH -J gatk_variant_2
#SBATCH -n 24
#SBATCH --time 3-23:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 24G
#SBATCH --account=hmh19_cr_default
#SBATCH --partition=standard

FQ_DIR="calferv_2025/trimmed_rd2_fastq"
input_dir="sorted_dedup"
output_dir="calferv25_vcf_files"
REF="/storage/home/rjb6794/scratch/ncbi_dataset/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna"

file_pairs=()
mkdir -p ${output_dir}


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

call_var() {
	IFS=' ' read -r r1 r2 output <<< "$1"
	echo "Calling variants for ${output}, writing to ${output_dir}/${output}_raw_variant.g.vcf"
	micromamba run -n gatk gatk HaplotypeCaller\
		-R ${REF}\
		-I ${input_dir}/${output}_sorted_dedup_reads.bam\
		-O ${output_dir}/${output}_raw_variant.g.vcf\
		-ploidy 2\
		-ERC BP_RESOLUTION
}

# export files for parallel
export -f call_var
export FQ_DIR input_dir output_dir REF


parallel -j 24 call_var ::: "${file_pairs[@]}"


# for input in "${file_pairs[@]}"; do
#     IFS=' ' read -r r1 r2 output <<< "$input"
#     echo "Calling variants for ${output} from ${REF}, writing to ${output_dir}/${output}_raw_variant.g.vcf"
#     gatk HaplotypeCaller\
#      -R ${REF}\
#      -I ${input_dir}/${output}_sorted_dedup_reads.bam\
#      -O ${output_dir}/${output}_raw_variant.g.vcf\
#      -ploidy 2\
#      -ERC BP_RESOLUTION
# done
