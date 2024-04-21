#!/bin/bash
#SBATCH --job-name=barcode02_miniasm_assembly_and_stats3
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/path/to/your/Project/Output_and_Error_files/%x.out
#SBATCH --error=/path/to/your/Project/Output_and_Error_files/%x.err

# activate conda 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/shared 

# create directory for miniasm output
mkdir /path/to/your/Project/miniasm_utgassem_results

# decompress the barcode02 pass, fail and fail/pass files 
gunzip /path/to/your/Project/longread_mergedfiles/barcode02*merger.fastq.gz

## unitig assembly
# assemble unitigs using miniasm for barcode02 pass assembly. Put the resulting gfa file in the miniasm results folder
miniasm -f /path/to/your/Project/longread_mergedfiles/barcode02_pass_merger.fastq /path/to/your/Project/minimap_assembly_results/longread_pass_minimap.paf.gz > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_pass.gfa

# assemble unitigs using miniasm for barcode02 fail/pass assembly
miniasm -f /path/to/your/Project/longread_mergedfiles/barcode02_failpass_merger.fastq /path/to/your/Project/minimap_assembly_results/longread_failpass_minimap.paf.gz > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_failpass.gfa

# assemble unitigs using miniasm for barcode02 fail assembly
miniasm -f /path/to/your/Project/longread_mergedfiles/barcode02_fail_merger.fastq /path/to/your/Project/minimap_assembly_results/longread_fail_minimap.paf.gz > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode_fail.gfa


## create a fasta file with assembled unitigs. The $2 represents the second column in the gfa which is the name of the contig. The $3 is the actual sequence
# for longreadfail/pass
awk '/^S/ {print ">" $2 "\n" $3}' /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_failpass.gfa > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_failpass.fasta

# for longreadpass
awk '/^S/ {print ">" $2 "\n" $3}' /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_pass.gfa > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_pass.fasta

# for longread fail
awk '/^S/ {print ">" $2 "\n" $3}' /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_fail.gfa > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_fail.fasta

## recompress the files we used
gzip /path/to/your/Project/longread_mergedfiles/barcode02*merger.fastq


## get some stats with assembly stats
# get the statistics for the barcode 02 fail/pass file
assembly-stats /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_failpass.fasta > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_failpass_stats.txt 

# get the statistics for the barcode02 pass file
assembly-stats /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_pass.fasta > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_pass_stats.txt

# get the statistics for the barcode02 fail fasta file
assembly-stats /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_fail.fasta > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode02_fail_stats.txt

# get job id
echo "The Job ID for this job is: $SLURM_JOB_ID"
