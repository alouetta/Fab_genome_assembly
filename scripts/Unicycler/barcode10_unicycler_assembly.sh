#!/bin/bash
#SBATCH --job-name=barcode10_unicycler_assembly_normalmode
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/path/to/your/Project/Output_and_Error_files/%x.out
#SBATCH --error=/path/to/your/Project/Output_and_Error_files/%x.err

# source home profile 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/shared 

# make directories to store all the unicycler output
mkdir -p /path/to/your/Project/unicycler_all_output/unicycler_barcode10_pass_output
mkdir /path/to/your/Project/unicycler_all_output/unicycler_barcode10_failpass_output
mkdir /path/to/your/Project/unicycler_all_output/unicycler_barcode10_fail_output

## run unicycler command 
# assemble the long read fail and pass reads
unicycler -l /path/to/your/Project/longread_mergedfiles/barcode10_failpass_merger.fastq.gz -o /path/to/your/Project/unicycler_all_output/unicycler_barcode10_failpass_output --keep 1 -t 8

# assemble the long read pass reads only
unicycler -l /path/to/your/Project/longread_mergedfiles/barcode10_pass_merger.fastq.gz -o /path/to/your/Project/unicycler_all_output/unicycler_barcode10_pass_output --keep 1 -t 8

# assemble the long read fail reads only
unicycler -l /path/to/your/Project/longread_mergedfiles/barcode10_fail_merger.fastq.gz -o /path/to/your/Project/unicycler_all_output/unicycler_barcode10_fail_output --keep 1 -t 8

# get some assembly stats for the unicycler assemblies using assembly-stats
# get the statistics for the longreadfail/pass file
assembly-stats \
    /path/to/your/Project/unicycler_all_output/unicycler_barcode10_failpass_output/assembly.fasta > /path/to/your/Project/unicycler_all_output/unicycler_barcode10_failpass_output/unicycler_barcode10_failpass_stats.txt 

# get the statistics for the longreadpass file
assembly-stats \
    /path/to/your/Project/unicycler_all_output/unicycler_barcode10_pass_output/assembly.fasta > /path/to/your/Project/unicycler_all_output/unicycler_barcode10_pass_output/unicycler_barcode10_pass_stats.txt 

# get the statistics for the longread fail fasta file
assembly-stats \
    /path/to/your/Project/unicycler_all_output/unicycler_barcode10_fail_output/assembly.fasta > /path/to/your/Project/unicycler_all_output/unicycler_barcode10_fail_output/unicycler_barcode10_fail_stats.txt 




# get job iD
echo "The Job ID for this job is: $SLURM_JOB_ID"
