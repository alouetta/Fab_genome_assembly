#!/bin/bash
#SBATCH --job-name=all_readQC_with_ref2
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=48:00:00
#SBATCH --output=/path/to/my/Part_1/Output_and_Error/%x.out
#SBATCH --error=/path/to/my/Part_1/Output_and_Error/%x.err

# source home profile 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/shared 

# make an output dir
# longreadpassinput - make dir for using GCA as the ref
mkdir /path/to/my/Part_1/quast_output_allassem



# run quast on our assemblies
# for long read fail pass first --kmerstats for more info, -circo for plot, --genefinding for more info 

###longread failpass quast
# command for longreadfailpass GCA ref
quast.py --threads 8 --k-mer-stats --circos --gene-finding \
-r /path/to/my/Part_1/barcode02/haloferax_volcanii_gffandfasta/ncbi_dataset/data/GCF_000025685.1/GCF_000025685.1_ASM2568v1_genomic.fna \
-o /path/to/my/Part_1/quast_output_allassem_with_hybrid \
-g /path/to/my/Part_1/barcode02/haloferax_volcanii_gffandfasta/ncbi_dataset/data/GCF_000025685.1/genomic.gff /path/to/my/Part_1/barcode02/all_unicycler_longread_output/unicycler_longreadfail_pass_output/longreadfailpass_uni_assembly.fasta /path/to/my/Part_1/barcode02/all_unicycler_longread_output/unicycler_longreadpass_output/longreadpass_uni_assembly.fasta /path/to/my/Part_1/barcode02/miniasm_utgassem_results/miniasm_longread_fail_pass.fasta /path/to/my/Part_1/barcode02/miniasm_utgassem_results/miniasm_longreadpass.fasta /path/to/my/Part_1/short_read_illumina/unicycler_assembly_results/shortread_uni_assembly.fasta /path/to/my/Part_1/barcode02/hybrid_results/assembly.fasta

# get the job id
echo "The Job ID for this job is: $SLURM_JOB_ID"


