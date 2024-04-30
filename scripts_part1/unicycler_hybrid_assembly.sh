#!/bin/bash
#SBATCH --job-name=unicycler_hybrid_assembly
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=48:00:00
#SBATCH --output=/path/to/my/Part_1/Output_and_Error/%x.out
#SBATCH --error=/path/to/my/Part_1/Output_and_Error/%x.err

# source home profile 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/shared

# create a directory for the results
mkdir /workhere/students_2023/Group_2_VDJ/barcode02/hybrid_results

#run unicycler on all four pairs of files. use the long read merge file and put results into separate folder

unicycler --kmers 25,55,71 -t 8 -1 /path/to/my/Part_1/short_read_illumina/H3929_S2_L002_R1_001.fastq.gz -2 /path/to/my/Part_1/short_read_illumina/H3929_S2_L002_R2_001.fastq.gz -l /path/to/my/Part_1/barcode02/longread_merged_files/longread_pass_merger.fastq.gz -o /path/to/my/Part_1/barcode02/hybrid_results

# get the job id
echo "The Job ID for this job is: $SLURM_JOB_ID"

#announce when complete
echo "I'm finished!"
