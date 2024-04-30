#!/bin/bash
#SBATCH --job-name=unicycler_longread_assembly
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=20g
#SBATCH --time=24:00:00
#SBATCH --output=/path/to/my/Part_1/Output_and_Error/%x.out
#SBATCH --error=/path/to/my/Part_1/Output_and_Error/%x.err

# source home profile 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/shared 

# make directories
mkdir /path/to/my/Part_1/barcode02/unicycler_longreadpass_output
mkdir /path/to/my/Part_1/barcode02/unicycler_longreadfail_pass_output

# decompress read files
gunzip /path/to/my/Part_1/barcode02/longread_merged_files/longread_fail_pass_merger.fastq.gz
gunzip /path/to/my/Part_1/barcode02/longread_merged_files/longread_pass_merger.fastq.gz

## run unicycler command 
# longreadfail_pass
unicycler -l /path/to/my/Part_1/barcode02/longread_merged_files/longread_fail_pass_merger.fastq -o /path/to/my/Part_1/barcode02/unicycler_longreadfail_pass_output --keep 1

# longreadpass
unicycler -l /path/to/my/Part_1/barcode02/longread_merged_files/longread_pass_merger.fastq -o /path/to/my/Part_1/barcode02/unicycler_longreadpass_output --keep 1

# recompress read files
gzip /path/to/my/Part_1/barcode02/longread_merged_files/longread_fail_pass_merger.fastq
gzip /path/to/my/Part_1/barcode02/longread_merged_files/longread_pass_merger.fastq

# get the job id
echo "The Job ID for this job is: $SLURM_JOB_ID"