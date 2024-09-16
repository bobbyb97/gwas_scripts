#!/bin/bash
#SBATCH -J bwa_align2
#SBATCH -n 8
#SBATCH --time 18-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

files=()
REF=

# Index the reference genome (only needs to be done once)
bwa index ${REF}

# Function to process a single set of files
process_files() {
    local input="$1"
    set -- $input
    # Align the files to genome
    bwa mem -T 40 ${REF} ${1}.gz ${2}.gz | samtools sort > ${3}.bam
}


export -f process_files
export REF

# Use GNU Parallel to process files in parallel
parallel -j $SLURM_NTASKS process_files ::: "${files[@]}"
