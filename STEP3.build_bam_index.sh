#!/bin/bash
#SBATCH -J build_bam_index
#SBATCH -n 8
#SBATCH --time 3-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

input_dir="trimmed_fastq"

##--NOTHING BELOW THIS LINE SHOULD BE MODIFIED--##

# Generate the array of file pairs
file_pairs=()

# Separating file strings for later use
for r1 in "$input_dir"/*_R1.fq.gz; do
    r2="${r1/_R1.fq.gz/_R2.fq.gz}"
    if [[ -f "$r2" ]]; then
        output="${r1/_R1.fq.gz/}"
        file_pairs+=("$r1 $r2 $output")
        echo ${r1}
    else
        echo "Warning: No matching R2 file for $r1" >&2
    fi
done

for input in "${file_pairs[@]}"; do
    # Split the input into r1, r2, and output
    IFS=' ' read -r r1 r2 output <<< "$input"
    echo "Processing file: ${r1}"
    # Extract RGPU
    RGPU=$(gunzip -c "${r1}" | head -1 | grep '^@' | sed 's/:/\t/g' | sed 's/.1/\t/' | cut -f1 | sed 's/@//')

    # Echo RGPU and output to verify the function is reading the correct values
    # Included for
    echo "${RGPU} ${output} ${r1} ${r2}"

    # Add read groups with picard
    picard AddOrReplaceReadGroups \
        INPUT="${output}.bam" \
        OUTPUT="${output}_fixed.bam" \
        VALIDATION_STRINGENCY=LENIENT \
        RGID="${output}_RGID" \
        RGLB=lib1 \
        RGPL=illumina \
        RGPU="${RGPU}" \
        RGSM="${output}"
done

