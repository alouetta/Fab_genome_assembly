#!/bin/bash
#SBATCH --job-name=merge_fastqFP
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4g
#SBATCH --time=01:00:00
#SBATCH --output=/path/to/my/Project/Output_and_Error_files/%x.out
#SBATCH --error=/path/to/my/Project/Output_and_Error_files/%x.err


## make directory for the merged long read files
mkdir /path/to/my/Project/longread_mergedfiles


# merge the long read pass files for all barcodes
cat /path/to/my/Project/all_input_reads/fastq_pass/barcode09/*fastq.gz > /path/to/my/Project/longread_mergedfiles/barcode09_pass_merger.fastq.gz
cat /path/to/my/Project/all_input_reads/fastq_pass/barcode10/*fastq.gz > /path/to/my/Project/longread_mergedfiles/barcode10_pass_merger.fastq.gz
cat /path/to/my/Project/all_input_reads/fastq_pass/barcode02/*fastq.gz > /path/to/my/Project/longread_mergedfiles/barcode02_pass_merger.fastq.gz

# merge the long read fail files for all barcodes
cat /path/to/my/Project/all_input_reads/fastq_fail/barcode09/*fastq.gz > /path/to/my/Project/longread_mergedfiles/barcode09_fail_merger.fastq.gz
cat /path/to/my/Project/all_input_reads/fastq_fail/barcode10/*fastq.gz > /path/to/my/Project/longread_mergedfiles/barcode10_fail_merger.fastq.gz
cat /path/to/my/Project/all_input_reads/fastq_fail/barcode02/*fastq.gz > /path/to/my/Project/longread_mergedfiles/barcode02_fail_merger.fastq.gz

# merge the merged long read fail and pass files for all barcodes
cat /path/to/my/Project/longread_mergedfiles/*merger09.fastq.gz > /path/to/my/Project/longread_mergedfiles/barcode09_failpass_merger.fastq.gz
cat /path/to/my/Project/longread_mergedfiles/*merger10.fastq.gz > /path/to/my/Project/longread_mergedfiles/barcode10_failpass_merger.fastq.gz
cat /path/to/my/Project/longread_mergedfiles/*merger02.fastq.gz > /path/to/my/Project/longread_mergedfiles/barcode02_failpass_merger.fastq.gz

# get job id 
echo "The Job ID for this job is: $SLURM_JOB_ID"


