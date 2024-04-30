#!/bin/bash
#SBATCH --job-name=miniasm_longread_assembly
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=20g
#SBATCH --time=24:00:00
#SBATCH --output=/path/to/my/Part_1/Output_and_Error/%x.out
#SBATCH --error=/path/to/my/Part_1/Output_and_Error/%x.err

# activate conda 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/shared 

# create directory for miniasm output
mkdir /path/to/my/Part_1/barcode02/miniasm_utgassem_results

# decompress the longreadpass file and longreadfail/pass file we need 
gunzip /path/to/my/Part_1/barcode02/longread_merged_files/longread_fail_pass_merger.fastq.gz
gunzip /path/to/my/Part_1/barcode02/longread_merged_files/longread_pass_merger.fastq.gz 


## unitig assembly
# assemble unitigs using miniasm for longread pass assembly
miniasm -f /path/to/my/Part_1/barcode02/longread_merged_files/longread_pass_merger.fastq /path/to/my/Part_1/barcode02/minimap_assembly_results/longreadpass_minimap.paf.gz > /path/to/my/Part_1/barcode02/miniasm_utgassem_results/miniasm_longreadpass.gfa

# assemble unitigs using miniasm for longread fail/pass assembly
miniasm -f /path/to/my/Part_1/barcode02/longread_merged_files/longread_fail_pass_merger.fastq /path/to/my/Part_1/barcode02/minimap_assembly_results/longreadfail_pass_minimap.paf.gz > /path/to/my/Part_1/barcode02/miniasm_utgassem_results/miniasm_longread_fail_pass.gfa

## create a fasta file with assembled unitigs
# longreadfail/pass
awk '/^S/ {print ">" $2 "\n" $3}' /path/to/my/Part_1/barcode02/miniasm_utgassem_results/miniasm_longread_fail_pass.gfa > /path/to/my/Part_1/barcode02/miniasm_utgassem_results/miniasm_longread_fail_pass.fasta

# longreadpass
awk '/^S/ {print ">" $2 "\n" $3}' /path/to/my/Part_1/barcode02/miniasm_utgassem_results/miniasm_longreadpass.gfa > /path/to/my/Part_1/barcode02/miniasm_utgassem_results/miniasm_longreadpass.fasta


# recompress the files we used
gzip /path/to/my/Part_1/barcode02/longread_merged_files/longread_fail_pass_merger.fastq
gzip /path/to/my/Part_1/barcode02/longread_merged_files/longread_pass_merger.fastq


# get the job id
echo "The Job ID for this job is: $SLURM_JOB_ID"



