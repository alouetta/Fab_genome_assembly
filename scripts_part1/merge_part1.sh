#!/bin/bash
#SBATCH --job-name=merging_data_barcode02
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=4g
#SBATCH --time=01:00:00
#SBATCH --output=/path/to/my/Part_1/Output_and_Error/%x.out
#SBATCH --error=/path/to/my/Part_1/Output_and_Error/%x.err


## make directory for the merged long read files
mkdir /path/to/my/Part_1/barcode02/longread_merged_files 

## long reads
# merge the long read pass files
cat /path/to/my/Part_1/barcode02/fastq_pass/*fastq.gz > /path/to/my/Part_1/barcode02/longread_merged_files/longread_pass_merger.fastq.gz

# merge the long read fail files
cat /path/to/my/Part_1/barcode02/fastq_fail/*fastq.gz > /path/to/my/Part_1/barcode02/longread_merged_files/longread_fail_merger.fastq.gz

# merge the merged long read fail and pass files.
# looks in both fastq files for the merged pass and fail files then writes the output to a new file
cat /path/to/my/Part_1/barcode02/longread_merged_files/*merger.fastq.gz > /path/to/my/Part_1/barcode02/longread_merged_files/longread_fail_pass_merger.fastq.gz


## make directory for the merged files
mkdir /path/to/my/Part_1/shortread_merged_files


## short reads
# merge the R1 short read files
cat /path/to/my/Part_1/short_read_illumina/*R1*fastq.gz > /path/to/my/Part_1/shortread_merged_files/R1_shortread_merger.fastq.gz

# merge the R2 short read files
cat /path/to/my/Part_1/short_read_illumina/*R2*fastq.gz > /path/to/my/Part_1/shortread_merged_files/R2_shortread_merger.fastq.gz

# get the job id
echo "The Job ID for this job is: $SLURM_JOB_ID"