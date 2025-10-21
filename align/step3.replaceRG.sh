#!/bin/bash
#SBATCH -J replace_RG
#SBATCH -n 1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=8G
#SBATCH --time 1-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794

IN_DIR="calferv_2024/trimmed_fastq"
BAM_DIR="calferv_2024/bam_files"
OUT_DIR="calferv_2024/calferv_bams_fixed"

##--NOTHING BELOW THIS LINE SHOULD BE MODIFIED--##

# create output directory if it doesn't exist
mkdir -p ${OUT_DIR}

# Generate the array of file pairs
file_pairs=()

# Separating file strings for later use
for r1 in "$IN_DIR"/*_R1.fq.gz; do
    r2="${r1/_R1.fq.gz/_R2.fq.gz}"
    if [[ -f "$r2" ]]; then
        output=$(basename "${r1/_R1.fq.gz/}")
        file_pairs+=("$r1 $r2 $output")
    else
        echo "Warning: No matching R2 file for $r1" >&2
    fi
done

for input in "${file_pairs[@]}"; do
    # Split the input into r1, r2, and output
    IFS=' ' read -r r1 r2 output <<< "$input"

    # Extract RGPU
    RGPU=$(zcat "${r1}" | head -1 | grep '^@' | sed 's/:/\t/g' | sed 's/.1/\t/' | cut -f1 | sed 's/@//')

    # Echo RGPU and output to verify the function is reading the correct values
    # Included for debugging purposes
    echo "Processing ${BAM_DIR}/${output}.bam... "
    echo "Replacing ${RGPU} with ${output}, writing to ${OUT_DIR}/${output}_fixed.bam"
	echo "----------------------------------------"

    # Add read groups with picard
    picard AddOrReplaceReadGroups \
        INPUT="${BAM_DIR}/${output}.bam" \
        OUTPUT="${OUT_DIR}/${output}_fixed.bam" \
        VALIDATION_STRINGENCY=LENIENT \
        RGID="${output}_RGID" \
        RGLB=lib1 \
        RGPL=illumina \
        RGPU="${RGPU}" \
        RGSM="${output}"
done

