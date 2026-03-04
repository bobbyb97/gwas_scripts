#!/bin/bash
#SBATCH -J bwa_align_array
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=12:00:00
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
IN_DIR=/storage/home/rjb6794/scratch/pen_proj/trimmed_fastq_2
OUT_DIR=/storage/home/rjb6794/scratch/pen_proj/bam_files/bwa_v2_Feb27

REF=/storage/home/rjb6794/scratch/pen_proj/ref_genome/data/GCA_051853225.1/GCA_051853225.1_iyBomPens1_principal_genomic.fna


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
	bwa mem -t $SLURM_CPUS_PER_TASK ${REF} ${IN_DIR}/${R1} ${IN_DIR}/${R2}\
	-R "@RG\tID:${RG_ID}\tLB:${RG_LB}\tPL:${RG_PL}\tPU:${RG_PU}\tSM:${RG_SM}" \
	| samtools view -u \
	| samtools sort -o ${OUT_DIR}/${SAMPLE_NAME}_sorted.bam




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











########### VERSION USING GNU PARALLEL ############
## Much less efficient ##

# # Index the reference genome (only needs to be done once)
# bwa index ${REF}

# ##--NOTHING BELOW THIS LINE SHOULD BE MODIFIED--##
# mkdir -p ${OUTDIR}

# # Define the function to process a single set of files
# align_reads() {
#     # Assign variables in the function
#     local r1="$1"
#     local r2="$2"
#     local output="$3"
#     # Align the files to genome
#     echo "Processing $r1 $r2, writing to ${OUTDIR}/${output}.bam"
#     # bwa mem -T 16 ${REF} "$r1" "$r2" | samtools view -b | samtools sort > ${OUTDIR}/"${output}.bam"
# }

# # Generate the array of file pairs
# file_pairs=()
# for r1 in "$input_dir"/*_R1.fq.gz; do
#     r2="${r1/_R1.fq.gz/_R2.fq.gz}"
#     if [[ -f "$r2" ]]; then
#         output=$(basename "${r1/_R1.fq.gz/}")
#         file_pairs+=("$r1 $r2 $output")
#     else
#         echo "Warning: No matching R2 file for $r1" >&2
#     fi
# done

# # Replace the for loop with GNU Parallel
# export REF
# export OUTDIR
# export input_dir
# export file_pairs
# export -f align_reads

# # Use GNU Parallel to process file pairs
# printf "%s\n" "${file_pairs[@]}" | parallel -j 16 --colsep ' ' align_reads {1} {2} {3}


# # -- slowest  way if GNU does not work -- ##
# #for x in "${file_pairs[@]}"; do
# #align_reads $x;
# #done
