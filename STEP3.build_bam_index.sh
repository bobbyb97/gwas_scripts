#!/bin/bash
#SBATCH -J samtobam
#SBATCH -n 8
#SBATCH --time 18-023:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --account=HMH19_sc
#SBATCH --partition=sla-prio

input_dir="trimmed_fastq"

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

for input in "${file_pairs[@]}"; do

    # Extract RGPU
    RGPU=$(zcat ${input} | head -1 | grep '^@' | sed 's/:/\t/g' | sed 's/.1/\t/'| cut -f1 | sed 's/@//')
    echo ${RGPU} ${input}
    # Add read groups with picard
    # picard AddOrReplaceReadGroups \
    # INPUT=${input}.bam \
    # OUTPUT=${input}_fixed.bam \
    # VALIDATION_STRINGENCY=LENIENT \
    # RGID=${input}_RGID \
    # RGLB=lib1 \
    # RGPL=illumina \
    # RGPU=${RGPU} \
    # RGSM=${input}

    # Build BAM index with sambamba
    # sambamba index /storage/home/tpd5366/scratch/NGS/230310_VH00707_75_AAC2C2GHV/fastq/02.Alignment/BAMS/${input}_fixed.bam
done
