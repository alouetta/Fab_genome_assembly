#!/bin/bash
#SBATCH --job-name=minimap_assembly_longread
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=20g
#SBATCH --time=24:00:00
#SBATCH --output=/path/to/my/Part_1/Output_and_Error/%x.out
#SBATCH --error=/path/to/my/Part_1/Output_and_Error/%x.err

# source profile
source $HOME/.bash_profile

# activate conda environment
conda activate /shared/conda/shared

# make directories for longread pass/fail assembly , and longread pass assembly
mkdir /path/to/my/Part_1/barcode02/minimap_assembly_results

# run minimap2 on longread pass data
minimap2 -x ava-ont /path/to/my/Part_1/barcode02/longread_merged_files/longread_pass_merger.fastq.gz /path/to/my/Part_1/barcode02/longread_merged_files/longread_pass_merger.fastq.gz | gzip -1 > /path/to/my/Part_1/barcode02/minimap_assembly_results/longreadpass_minimap.paf.gz

# run minimap2 on longread pass/fail data 
minimap2 -x ava-ont /path/to/my/Part_1/barcode02/longread_merged_files/longread_fail_pass_merger.fastq.gz /path/to/my/Part_1/barcode02/longread_merged_files/longread_fail_pass_merger.fastq.gz | gzip -1 > /path/to/my/Part_1/barcode02/minimap_assembly_results/longreadfail_pass_minimap.paf.gz


# get the job id
echo "The Job ID for this job is: $SLURM_JOB_ID"