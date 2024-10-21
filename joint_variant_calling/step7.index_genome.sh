#!/bin/bash
#SBATCH -J index
#SBATCH -n 4
#SBATCH --time 00-006:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
REF="GCA_041682495.1_iyBomFerv1_genomic.fna"

#Build bwa index for reference genome
bwa index ${REF} >> bwa.log.txt
#Build IGV index for the reference genome
samtools faidx ${REF}