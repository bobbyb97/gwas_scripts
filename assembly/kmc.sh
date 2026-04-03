#!/bin/bash
#SBATCH -J kmc
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --mem-per-cpu=2G
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err


IN_FQ_DIR=calferv_proj/fastq/trimmed/kmc
THREADS=${SLURM_CPUS_PER_TASK:-8}
OUT_DIR=calferv_proj/GWAS_2026/assemblies/kmc
KMER_SIZE=21
PREFIX=${OUT_DIR}/cali_${KMER_SIZE}mers
TMP_DIR=${OUT_DIR}/cali_${KMER_SIZE}mers_tmp

# create list of your input files
ls ${IN_FQ_DIR}/*.fq.gz > ${PREFIX}_input_files.txt

mkdir -p ${OUT_DIR}
mkdir -p ${TMP_DIR}

# Run KMC
micromamba run -n kmc \
	kmc -k${KMER_SIZE} \
	-m16 \
	-ci10 \
	-t${THREADS} \
	@${PREFIX}_input_files.txt \
	${PREFIX} \
	${TMP_DIR}

# create histogram for genomescope
micromamba run -n kmc kmc_tools \
	transform ${PREFIX} histogram ${PREFIX}.histo