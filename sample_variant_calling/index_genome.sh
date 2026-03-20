#!/bin/bash
#SBATCH -J index
#SBATCH -n 4
#SBATCH --time 00-006:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=16G

REF="ncbi_dataset/data/GCF_041682495.2/GCF_041682495.2_iyBomFerv1_genomic.fna"

#Build bwa index for reference genome
#bwa index ${REF} >> bwa.log.txt
#Build IGV index for the reference genome
samtools faidx ${REF}
# Build sequence dictionary for the reference genome
micromamba run -n gatk gatk CreateSequenceDictionary -R ${REF}