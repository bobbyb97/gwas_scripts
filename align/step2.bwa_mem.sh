#!/bin/bash
#SBATCH -J bwa_align2
#SBATCH -n 1
#SBATCH --mem-per-cpu 24G
#SBATCH --time 23:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=hmh19_cr_default
#SBATCH --partition=standard

# Define the input directory and reference genome
input_dir=/storage/home/rjb6794/scratch/calferv_2025/trimmed_rd2_fastq_step2_batch6_24SEP
REF=/storage/home/rjb6794/scratch/ncbi_dataset/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna
OUTDIR=/storage/home/rjb6794/scratch/calferv_bam_batch6_24SEP

# Index the reference genome (only needs to be done once)
#bwa index ${REF}

##--NOTHING BELOW THIS LINE SHOULD BE MODIFIED--##
mkdir -p ${OUTDIR}

# Define the function to process a single set of files
align_reads() {
    # Assign variables in the function
    local r1="$1"
    local r2="$2"
    local output="$3"
    # Align the files to genome
    echo "Processing $r1 $r2 $output"
    bwa mem -T 16 ${REF} "$r1" "$r2" | samtools view -b | samtools sort > ${OUTDIR}/"${output}.bam"
}

# Generate the array of file pairs
file_pairs=()
for r1 in "$input_dir"/*_R1.fq.gz; do
    r2="${r1/_R1.fq.gz/_R2.fq.gz}"
    if [[ -f "$r2" ]]; then
        output=$(basename "${r1/_R1.fq.gz/}")
        file_pairs+=("$r1 $r2 $output")
    else
        echo "Warning: No matching R2 file for $r1" >&2
    fi
done

# Replace the for loop with GNU Parallel
export REF
export OUTDIR
export input_dir
export file_pairs
export -f align_reads

# Use GNU Parallel to process file pairs
printf "%s\n" "${file_pairs[@]}" | parallel -j 16 --colsep ' ' align_reads {1} {2} {3}


# -- slow way if GNU does not work -- ##
#for x in "${file_pairs[@]}"; do
#align_reads $x;
#done
