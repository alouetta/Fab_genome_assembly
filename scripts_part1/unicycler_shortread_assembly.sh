#!/bin/bash
#SBATCH --job-name=shortread_unicycler
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-node=1
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/path/to/my/Part_1/Output_and_Error/%x.out
#SBATCH --error=/path/to/my/Part_1/Output_and_Error/%x.err


# activate conda
source $HOME/.bash_profile

# activate shared environment 
conda activate /shared/conda/shared

# create directories for shortread assembly results
#mkdir /path/to/my/Part_1/assembly_results
#mkdir /path/to/my/Part_1/assembly_results/unicycler_shortread_results

# run command with file path to the short read data-
unicycler --kmers 25,55,71 -t 8 -1 /path/to/my/Part_1/all_input_reads/short_reads/H3929_S2_L001_R1_001.fastq.gz -2 /path/to/my/Part_1/short_read_illumina/H3929_S2_L001_R2_001.fastq.gz -o /path/to/my/Part_1/assembly_results/unicycler_short_read_results

# get the job id
echo "The Job ID for this job is: $SLURM_JOB_ID"