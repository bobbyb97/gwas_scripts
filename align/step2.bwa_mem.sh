#!/bin/bash
#SBATCH -J bwa_align2
#SBATCH -n 8
#SBATCH --mem-per-cpu 16G
#SBATCH --time 6-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

# Define the input directory and reference genome
input_dir=./trimmed_fastq_2
REF=./GCA_041682495.1_iyBomFerv1_genomic.fna

# Index the reference genome (only needs to be done once)
bwa index ${REF}

##--NOTHING BELOW THIS LINE SHOULD BE MODIFIED--##

# Define the function to process a single set of files
align_reads() {
    # Assign variables in the function
    local r1="$1"
    local r2="$2"
    local output="$3"
    # Align the files to genome
    echo "Processing $r1 $r2 $output"
    bwa mem -T 40 ${REF} "$r1" "$r2" | samtools view -b | samtools sort > "${output}.bam"
}
# Generate the array of file pairs
file_pairs=()
for r1 in "$input_dir"/*_R1.fq.gz; do
    r2="${r1/_R1.fq.gz/_R2.fq.gz}"
    if [[ -f "$r2" ]]; then
        output="${r1/_R1.fq.gz/}"
        file_pairs+=("$r1 $r2 $output")
    else
        echo "Warning: No matching R2 file for $r1" >&2
    fi
done

for x in "${file_pairs[@]}"; do
align_reads $x;
done
