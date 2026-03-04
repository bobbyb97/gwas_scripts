#!/bin/bash
#SBATCH -J replace_RG
#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G
#SBATCH --time 6:59:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794
#SBATCH --array=0-19%10
#SBATCH --output=%x_%A_%a.out
#SBATCH --error=%x_%A_%a.err



###debugging###
## assign SLURM_ARRAY_TASK_ID for testing

IN_DIR="calferv_proj/calferv_26/trimmed_fastq_2"
BAM_DIR="calferv_proj/calferv_26/bam_files"
OUT_DIR="${BAM_DIR}/bam_with_RG"

##--NOTHING BELOW THIS LINE SHOULD BE MODIFIED--##

# create output directory if it doesn't exist
mkdir -p ${OUT_DIR}

# Create variables

	# Read full sample paths into array
		SAMPLES=(${IN_DIR}/*_R1.fq.gz)

	# Define sample basenames
		SAMPLE_NAMES=("${SAMPLES[@]##*/}")
		SAMPLE_NAMES=("${SAMPLE_NAMES[@]%_trimmed_R1.fq.gz}") 

	# Grab specific sample from array 
		SAMPLE_NAME=${SAMPLE_NAMES[$SLURM_ARRAY_TASK_ID]} 

# Extract the first line of the FASTQ
    #HEADER=$(zcat "${IN_DIR}/${SAMPLE_NAME}" | head -n 1)
	FASTQ=$(ls ${IN_DIR}/${SAMPLE_NAME}_trimmed_R1.fq.gz)
    # Extract the first line of the FASTQ
    HEADER=$(zcat "${FASTQ}" | head -n 1)

    # Parse the NovaSeq header (@Instrument:Run:Flowcell:Lane:...)
    # We use awk to split by colon and grab the 3rd (Flowcell) and 4th (Lane) fields
    FLOWCELL=$(echo "$HEADER" | awk -F':' '{print $3}')
    LANE=$(echo "$HEADER" | awk -F':' '{print $4}')

    # Define all Picard Read Group variables explicitly
    # Adding the sample ID ($output) to ID and PU ensures uniqueness
    RG_ID="${FLOWCELL}.${LANE}.${SAMPLE_NAME}"
    RG_LB="${SAMPLE_NAME}_lib2"
    RG_PL="ILLUMINA"
    RG_PU="${FLOWCELL}.${LANE}.${SAMPLE_NAME}"
    RG_SM="${SAMPLE_NAME}"

    echo "Processing ${BAM_DIR}/${SAMPLE_NAME}_trimmed_sorted.bam..."
    echo "Applying RGID: ${RG_ID}, RGLB: ${RG_LB}, RGPL: ${RG_PL}, RGPU: ${RG_PU}, RGSM: ${RG_SM}"
    
    # Run Picard
    micromamba run -n bioinfo picard AddOrReplaceReadGroups \
        INPUT="${BAM_DIR}/${SAMPLE_NAME}_trimmed_sorted.bam" \
        OUTPUT="${OUT_DIR}/${SAMPLE_NAME}_trimmed_sorted_RG.bam" \
        VALIDATION_STRINGENCY=LENIENT \
        RGID="${RG_ID}" \
        RGLB="${RG_LB}" \
        RGPL="${RG_PL}" \
        RGPU="${RG_PU}" \
        RGSM="${RG_SM}"

