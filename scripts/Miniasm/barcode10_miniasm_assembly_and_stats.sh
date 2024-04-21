#!/bin/bash
#SBATCH --job-name=barcode10_miniasm_assembly_and_stats3
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

# decompress the barcode10 pass, fail and fail/pass files 
gunzip /path/to/your/Project/longread_mergedfiles/barcode10*merger.fastq.gz

## unitig assembly
# assemble unitigs using miniasm for barcode10 pass assembly. Put the resulting gfa file in the miniasm results folder
miniasm -f /path/to/your/Project/longread_mergedfiles/barcode10_pass_merger.fastq /path/to/your/Project/minimap_assembly_results/longread_pass_minimap.paf.gz > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_pass.gfa

# assemble unitigs using miniasm for barcode10 fail/pass assembly
miniasm -f /path/to/your/Project/longread_mergedfiles/barcode10_failpass_merger.fastq /path/to/your/Project/minimap_assembly_results/longread_failpass_minimap.paf.gz > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_failpass.gfa

# assemble unitigs using miniasm for barcode10 fail assembly
miniasm -f /path/to/your/Project/longread_mergedfiles/barcode10_fail_merger.fastq /path/to/your/Project/minimap_assembly_results/longread_fail_minimap.paf.gz > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode_fail.gfa


## create a fasta file with assembled unitigs. The $2 represents the second column in the gfa which is the name of the contig. The $3 is the actual sequence
# for longreadfail/pass
awk '/^S/ {print ">" $2 "\n" $3}' /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_failpass.gfa > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_failpass.fasta

# for longreadpass
awk '/^S/ {print ">" $2 "\n" $3}' /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_pass.gfa > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_pass.fasta

# for longread fail
awk '/^S/ {print ">" $2 "\n" $3}' /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_fail.gfa > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_fail.fasta

## recompress the files we used
gzip /path/to/your/Project/longread_mergedfiles/barcode10*merger.fastq


## get some stats with assembly stats
# get the statistics for the barcode 02 fail/pass file
assembly-stats /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_failpass.fasta > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_failpass_stats.txt 

# get the statistics for the barcode10 pass file
assembly-stats /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_pass.fasta > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_pass_stats.txt

# get the statistics for the barcode10 fail fasta file
assembly-stats /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_fail.fasta > /path/to/your/Project/miniasm_utgassem_results/miniasm_barcode10_fail_stats.txt

# get job id
echo "The Job ID for this job is: $SLURM_JOB_ID"
