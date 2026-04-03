#!/bin/bash
#SBATCH -J run_busco
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=1G
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err

DATASET="hymenoptera_odb12"
DATA_DIR=calferv_proj/GWAS_2026/assemblies/busco/datasets
MODE=genome
THREADS=${SLURM_CPUS_PER_TASK:-4}

IN=calferv_proj/GWAS_2026/assemblies/spades/contigs.fasta
OUT=spades_cali_JBUK202_203_hap

micromamba run -n busco busco \
	--in ${IN} \
	--out ${OUT} \
	--cpu ${THREADS} \
	--mode ${MODE} \
	--download_path ${DATA_DIR} \
	--lineage_dataset ${DATASET} \
	--offline