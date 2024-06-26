#!/bin/bash
#SBATCH --job-name=Quast_QC_with_ref_halo_volcanii
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=48:00:00
#SBATCH --output=/path/to/your/Project/Output_and_Error_files/%x.out
#SBATCH --error=/path/to/your/Project/Output_and_Error_files/%x.err

# source home profile 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/shared 

# make an output dir to take all the quast output
mkdir /path/to/your/Project/quast_all_assembly_output_volc

## run quast on our assemblies
# kmerstats for more info, circo for plot, genefinding for more info 
# unicycler assemblies for all longread success combinations used as input
# GCF for haloferax volcanii used as ref and for annotations
quast.py --threads 8 --k-mer-stats --circos --gene-finding \
-r /path/to/your/Project/haloferax_volcanii/ncbi_dataset/data/GCF_000025685.1/GCF_000025685.1_ASM2568v1_genomic.fna \
-o /path/to/your/Project/quast_all_assembly_output_volc \
-g /path/to/your/Project/haloferax_volcanii/ncbi_dataset/data/GCF_000025685.1/genomic.gff /path/to/your/Project/unicycler_all_output/unicycler_*/*assembly.fasta  

# get job ID
echo "The Job ID for this job is: $SLURM_JOB_ID"

