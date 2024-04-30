#!/bin/bash
#SBATCH --job-name=Part1_nanoplot_allreads
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=2
#SBATCH --mem=10g
#SBATCH --time=12:00:00
#SBATCH --output=/path/to/my/Project/Output_and_Error_files/%x.out
#SBATCH --error=/path/to/my/Project/Output_and_Error_files/%x.err


# source home profile 
source $HOME/.bash_profile

# activate environment with nanoplot. This allows us to use NanoPlot 
conda activate /shared/conda/shared 

## make a directory for nanoplot stats
# directory for just pass data
mkdir -p /path/to/my/Part_1/nanoplot_output_stats/longread_pass_output

# directory for just fail data
mkdir /path/to/my/Part_1/nanoplot_output_stats/longread_fail_output

# directory for fail pass data
mkdir /path/to/my/Part_1/nanoplot_output_stats/longread_failpass_output

# directory for shortread data
mkdir /path/to/my/Part_1/nanoplot_output_stats/shortread_output

# run nanoplot on all the barcode02 pass data
# N50 flag adds the a mark for the N50 in the read length histogram
NanoPlot -t 8 --fastq /path/to/my/Part_1/all_input_reads/fastq_pass/barcode02/*.fastq.gz --maxlength 40000 --plots dot --N50 -o /path/to/my/Part_1/nanoplot_output_stats/barcode02_pass_nanoplot

# run nanoplot on all of the barcode02 fail data
NanoPlot -t 8 --fastq /path/to/my/Part_1/all_input_reads/fastq_fail/barcode02/*.fastq.gz --maxlength 40000 --plots dot --N50 -o /path/to/my/Part_1/nanoplot_output_stats/barcode02_fail_nanoplot

# run nanoplot on the combined barcode02 fail pass data
NanoPlot -t 8 --fastq /path/to/my/Part_1/barcode02/longread_mergedfiles/longread_failpass_merger.fastq.gz --maxlength 40000 --plots dot --N50 -o /path/to/my/Part_1/nanoplot_output_stats/barcode02_failpass_nanoplot

# run nanoplot on the shortread data
NanoPlot -t 8 --fastq /path/to/my/Part_1/all_input_reads/short_reads/*.fastq.gz --maxlength 40000 --plots dot --N50 -o /path/to/my/Part_1/nanoplot_output_stats/shortread_outpu

# get job id
echo "The Job ID for this job is: $SLURM_JOB_ID"
