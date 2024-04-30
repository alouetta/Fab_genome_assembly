#!/bin/bash
#SBATCH --job-name=Part_1_halo_volcanii
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=48:00:00
#SBATCH --output=/workhere/students_2023/Group_2_VDJ/DR_individual_assembly_barcode02/Output_and_Error_barcode02_assembly/%x.out
#SBATCH --error=/workhere/students_2023/Group_2_VDJ/DR_individual_assembly_barcode02/Output_and_Error_barcode02_assembly/%x.err

# source home profile 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/shared 

# make an output dir to take all the quast output
mkdir /workhere/students_2023/Group_2_VDJ/VM_02/quast_all_assembly_output_volc

## run quast on our assemblies
# kmerstats for more info, circo for plot, genefinding for more info 
# minimap and unicycler assemblies for all longread success combinations used as input
# GCF for haloferax volcanii used as ref and for annotations
quast.py --threads 8 --k-mer-stats --circos --gene-finding \
-r /workhere/students_2023/Group_2_VDJ/DR_individual_assembly_barcode02/haloferax_volcanii/ncbi_dataset/data/GCF_000025685.1/GCF_000025685.1_ASM2568v1_genomic.fna \
-o /workhere/students_2023/Group_2_VDJ/VM_02/quast_all_assembly_output_volc \
-g /workhere/students_2023/Group_2_VDJ/DR_individual_assembly_barcode02/haloferax_volcanii/ncbi_dataset/data/GCF_000025685.1/genomic.gff /workhere/students_2023/barcode02/miniasm_utgassem_results/*.fasta /workhere/students_2023/Group_2_VDJ/barcode02/all_unicycler_longread_output/unicycler_longreadpass_output/assembly.fasta  /workhere/students_2023/Group_2_VDJ/barcode02/hybrid_results/assembly.fasta /workhere/students_2023/Group_2_VDJ/short_read_illumina/unicycler_assembly_results/assembly.fasta 


# get job ID
echo "The Job ID for this job is: $SLURM_JOB_ID"

