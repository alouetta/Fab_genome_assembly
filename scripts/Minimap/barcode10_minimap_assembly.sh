#!/bin/bash
#SBATCH --job-name=barcode10_minimap_assembly
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/workhere/students_2023/Group_2_VDJ/VM_02/Output_and_Error_files/%x.out
#SBATCH --error=/workhere/students_2023/Group_2_VDJ/VM_02/Output_and_Error_files/%x.err

# source profile
source $HOME/.bash_profile

# activate conda environment
conda activate /shared/conda/shared

# make directories for longread pass/fail assembly , and longread pass assembly
mkdir /workhere/students_2023/Group_2_VDJ/VM_02/minimap_assembly_results

# run minimap2 on barcode10 pass data
minimap2 -x ava-ont /workhere/students_2023/Group_2_VDJ/VM_02/longread_mergedfiles/barcode10_pass_merger.fastq.gz /workhere/students_2023/Group_2_VDJ/VM_02/longread_mergedfiles/barcode10_pass_merger.fastq.gz | gzip -1 > /workhere/students_2023/Group_2_VDJ/VM_02/minimap_assembly_results/barcode10_pass_minimap.paf.gz

# run minimap2 on barcode10 pass/fail data 
minimap2 -x ava-ont /workhere/students_2023/Group_2_VDJ/VM_02/longread_mergedfiles/barcode10_failpass_merger.fastq.gz /workhere/students_2023/Group_2_VDJ/VM_02/longread_mergedfiles/barcode10_failpass_merger.fastq.gz | gzip -1 > /workhere/students_2023/Group_2_VDJ/VM_02/minimap_assembly_results/barcode10_failpass_minimap.paf.gz

# run minimap2 on barcode10 fail data
minimap2 -x ava-ont /workhere/students_2023/Group_2_VDJ/VM_02/longread_mergedfiles/barcode10_fail_merger.fastq.gz /workhere/students_2023/Group_2_VDJ/VM_02/longread_mergedfiles/barcode10_fail_merger.fastq.gz | gzip -1 > /workhere/students_2023/Group_2_VDJ/VM_02/minimap_assembly_results/barcode10_fail_minimap.paf.gz

# get job id
echo "The Job ID for this job is: $SLURM_JOB_ID"
