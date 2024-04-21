#!/bin/bash
#SBATCH --job-name=barcode09_pass_Flye_assembly.sh
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/path/to/my/Project/Output_and_Error_files/%x.out
#SBATCH --error=/path/to/my/Project/Output_and_Error_files/%x.err

# source home profile
source $HOME/.bash_profile

# activate environment with all tools we need
conda activate /shared/conda/shared

# create directory for output
mkdir /path/to/my/Project/barcode09_Flye_assembly

# Unzip the merged fasta files
gunzip /path/to/my/Project/longread_mergedfiles/barcode09*

# run the Flye command 
# assemble the pass reads
flye --nano-raw /path/to/my/Project/longread_mergedfiles/barcode09_pass_merger.fastq --out-dir /$

# assemble the fail reads only
flye --nano-raw /path/to/my/Project/longread_mergedfiles/barcode09__fail_merger.fastq --out-dir /$

# assemble the failpass reads
flye --nano-raw /path/to/my/Project/longread_mergedfiles/barcode09__fail_pass_merger.fastq --out-dir /$

#Rezip the mereged fasta files
gzip /path/to/my/Project/longread_mergedfiles/barcode09*


# get job iD
echo "The Job ID for this job is: $SLURM_JOB_ID"


