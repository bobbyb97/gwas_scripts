#!/bin/bash
#SBATCH -J bwa_mem_array
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time=1:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --array=0-20%10
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err


# --account=hmh19_cr_default
# --partition=standard

eval "$(micromamba shell hook --shell bash)"

micromamba activate bioinfo


####--debugging--#####
## assign SLURM_ARRAY_TASK_ID for testing
#echo "Found ${NUM_SAMPLES} samples in ${IN_DIR}"
#echo "${SAMPLE_NAMES[@]}"
#NUM_SAMPLES=${#SAMPLES[@]}


# Define the input, output directories and reference genome
IN_DIR=pen_proj/trimmed_fastq_2
OUT_DIR=pen_proj/bam_files/bwa_v2_Feb27

REF=pen_proj/ref_genome/data/GCA_051853225.1/GCA_051853225.1_iyBomPens1_principal_genomic.fna


#### ---- NOTHING BELOW THIS LINE SHOULD BE MODIFIED ---- ####

# Create output directory
mkdir -p ${OUT_DIR}

## Indexing check ##
if [[ ! -f "${REF}.sa" ]]; then
    if [[ "$SLURM_ARRAY_TASK_ID" -eq 0 ]]; then
        echo "Index not found. Indexing ${REF}..."
        micromamba run -n bioinfo bwa index ${REF}
    else
        echo "Waiting for Task 0 to complete indexing..."
        until [[ -f "${REF}.sa" ]]; do sleep 30; done
    fi
fi


###### Create variables ######

	# Read full sample paths into array
		SAMPLES=(${IN_DIR}/*_R1.fq.gz)

	# Define sample basenames
		SAMPLE_NAMES=("${SAMPLES[@]##*/}")
		SAMPLE_NAMES=("${SAMPLE_NAMES[@]%_R1.fq.gz}") 

	# Grab specific sample from array 
		SAMPLE_NAME=${SAMPLE_NAMES[$SLURM_ARRAY_TASK_ID]} 

	# Define R1 and R2 file names off of specific sample name
		R1="${SAMPLE_NAME}_R1.fq.gz"
		R2="${SAMPLE_NAME}_R2.fq.gz"

	# Extract the first line of the FASTQ
    HEADER=$(zcat "${IN_DIR}/${SAMPLE_NAME}_R1.fq.gz" | head -n 1)


 ### Define Read Group variables explicitly

	FLOWCELL=$(echo "$HEADER" | awk -F':' '{print $3}')
	LANE=$(echo "$HEADER" | awk -F':' '{print $4}')


	RG_ID="${FLOWCELL}.${LANE}.${SAMPLE_NAME}"
	RG_LB="${SAMPLE_NAME}_lib1"
	RG_PL="ILLUMINA"
	RG_PU="${FLOWCELL}.${LANE}.${SAMPLE_NAME}"
    RG_SM="${SAMPLE_NAME}"

	# Echo slurm array task ID and sample name for debugging
		echo "Task ID $SLURM_ARRAY_TASK_ID: Aligning $SAMPLE_NAME, with RGID: ${RG_ID}"




##### MAIN COMMAND #####
# Align the reads to the reference genome, convert to BAM, and sort
	# bwa aln -t $SLURM_CPUS_PER_TASK ${REF} ${IN_DIR}/${R1} ${IN_DIR}/${R2}\
	# -R "@RG\tID:${RG_ID}\tLB:${RG_LB}\tPL:${RG_PL}\tPU:${RG_PU}\tSM:${RG_SM}" \
	# | samtools view -u \
	# | samtools sort -o ${OUT_DIR}/${SAMPLE_NAME}_sorted.bam




### Error check ###
EXIT_CODE=${PIPESTATUS[0]}  # Capture bwa mem exit code specifically

if [[ $EXIT_CODE -ne 0 ]]; then
    echo "ERROR: bwa mem failed for $SAMPLE_NAME with exit code $EXIT_CODE" >&2
    exit $EXIT_CODE
fi

# Verify output file exists
if [[ ! -s "${OUT_DIR}/${SAMPLE_NAME}_sorted.bam" ]]; then
    echo "ERROR: Output BAM file is missing or empty for $SAMPLE_NAME" >&2
    exit 1
fi

# Complete message
echo "SUCCESS: Finished aligning $SAMPLE_NAME"
echo "  Output: ${OUT_DIR}/${SAMPLE_NAME}_sorted.bam"
echo "  Size: $(du -sh ${OUT_DIR}/${SAMPLE_NAME}_sorted.bam | cut -f1)"