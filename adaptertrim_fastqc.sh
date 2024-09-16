#!/bin/bash
#SBATCH -J trimmomatic_fastqc
#SBATCH -n 8
#SBATCH --time 23:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu 8000

#trimmomatic PE -phred33 -threads 20 -baseout ${A1}_trimmed.fq.gz ${A1}.fastq.gz ${A2}.fastq.gz SLIDINGWINDOW:4:25 ILLUMINACLIP:../adapters.fa:2:30:5 MINLEN:36 LEADING:3 TRAILING:3

 

## adjust script for adapter sequence ##

 
#This is the command for quality check:

fastqc $HOME/Desktop/*.cleaned.fq.gz