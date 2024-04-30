#!/bin/bash
#SBATCH --job-name=Quast_QC_with_ref_volc_and_med
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
mkdir /path/to/your/Project/quast_all_assembly_output_med_and_volc

# combine the fasta sequences from each of the different plasmids in haloferax and volcanii that we know is in our organism
python3 /path/to/your/Project/scripts_barcode02_assembly/combine_fasta.py \
-f /path/to/your/Project/haloferax_mediterranei/ncbi_dataset/data/GCF_005406325.1/GCF_005406325.1_ASM540632v1_genomic.fna \
-s /path/to/your/Project/haloferax_volcanii/ncbi_dataset/data/GCF_000025685.1/GCF_000025685.1_ASM2568v1_genomic.fna \
-o /path/to/your/Project/quast_all_assembly_output_med_and_volc/GCF_volc_med_combined.fna \
--first_headers '>NZ_CP039142.1','>NZ_CP039139.1' --second_headers '>NC_013968.1','>NC_013964.1','>NC_013966.1'

# combine the gff files for each of the references 
cat /path/to/your/Project/haloferax_mediterranei/ncbi_dataset/data/GCF_005406325.1/genomic.gff > /path/to/your/Project/quast_all_assembly_output_med_and_volc/volc_med_combined.gff
cat /path/to/your/Project/haloferax_volcanii/ncbi_dataset/data/GCF_000025685.1/genomic.gff >> /path/to/your/Project/quast_all_assembly_output_med_and_volc/volc_med_combined.gff

## run quast on our assemblies
# kmerstats for more info, circo for plot, genefinding for more info 
# unicycler assemblies for all longread success combinations used as input
# GCF for haloferax mediterranei used as ref and for annotations
quast.py --threads 8 --k-mer-stats --circos --gene-finding \
-r /path/to/your/Project/quast_all_assembly_output_med_and_volc/GCF_volc_med_combined.fna \
-o /path/to/your/Project/quast_all_assembly_output_med_and_volc \
-g /path/to/your/Project/quast_all_assembly_output_med_and_volc/volc_med_combined.gff  /path/to/your/Project/unicycler_all_output/unicycler_*/*assembly.fasta  

# get job ID
echo "The Job ID for this job is: $SLURM_JOB_ID"

