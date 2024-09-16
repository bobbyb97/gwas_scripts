#!/bin/bash
#SBATCH -J fastp_trim
#SBATCH -n 32
#SBATCH --time 01-023:00:00
#SBATCH --mail-type=ALL,TIME_LIMIT_80
#SBATCH --mail-user=rjb6794


INPUT_PATH=/storage/home/rjb6794/scratch/fastq/
OUTPUT_PATH=/storage/home/rjb6794/scratch/trimmed_fastq/

# Generate the list of file names. This solution is slightly specific to the file names 
#generated in the sequencing run, tweak the extensions and sed command to fit your file names

input_files=($(ls ${INPUT_PATH}*_R1_001.fastq.gz | sed -e 's/_R1_001.fastq.gz$//' -e 's/.*\///'))
input_files+=($(ls ${INPUT_PATH}*_R2_001.fastq.gz | sed -e 's/_R2_001.fastq.gz$//' -e 's/.*\///'))


##--NOTHING BELOW THIS LINE SHOULD BE MODIFIED--##

# Iterate over files to extract the common part of the forward and reverse reads
for file in "${input_files[@]}"; do
  # Extract the common part of the filename (removing "_R1_001" or "_R2_001" and "S8" or "S69")
  input_name="${file%%_R[12]_001}"

  # Define the corresponding R1 and R2 input files
  in1="${INPUT_PATH}${input_name}_R1_001.fastq.gz"
  in2="${INPUT_PATH}${input_name}_R2_001.fastq.gz"

  # Create the output name by stripping extra characters away besides the sample name 
  output_name="${input_name%%_S[0-9]*}"

  # Sanity check
  echo $output_name

  # Trimming command, see https://github.com/OpenGene/fastp?tab=readme-ov-file#fastp for full usage description
  fastp --thread 20 \
        --in1 "$in1" \
        --in2 "$in2" \
        --out1 "${OUTPUT_PATH}${output_name2}_trimmed_R1.fq.gz" \
        --out2 "${OUTPUT_PATH}${output_name2}_trimmed_R2.fq.gz" \
        -g \
       	--detect_adapter_for_pe \
       	-q 30 \
       	-u 40 
done
