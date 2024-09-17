#!/bin/bash
#SBATCH -J bwa_align
#SBATCH -n 8
#SBATCH --time 18-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

files=(
    "/Users/jonasbush/trimmed_fastq/420_CALI_B_trimmed_R1.fq.gz /Users/jonasbush/trimmed_fastq/420_CALI_B_trimmed_R2.fq.gz 420_CALI_B"
    "/Users/jonasbush/trimmed_fastq/499_CALI_B_trimmed_R1.fq.gz /Users/jonasbush/trimmed_fastq/499_CALI_B_trimmed_R2.fq.gz 499_CALI_B"
)
REF=/Users/jonasbush/ncbi_dataset/data/GCA_041682495.1/GCA_041682495.1_iyBomFerv1_genomic.fna

# Index the reference genome (only needs to be done once)
#bwa index ${REF}

# Function to process a single set of files
process_files() {
    r1=$1
    r2=$2
    output=$3
    # Align the files to genome
    echo "Processing $r1 $r2 $output"
    bwa mem -T 40 ${REF} "$r1" "$r2" | samtools sort > "${output}.bam"
    
}

# Export variables to the parallel environment
export -f process_files
export REF

# Use GNU Parallel to process files in parallel
parallel -j $SLURM_NTASKS --colsep ' ' process_files ::: "${files[@]}"
