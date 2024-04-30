#!/bin/bash
#SBATCH --job-name=busco_allassem_part1
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/path/to/my/Part_1/Output_and_Error/%x.out
#SBATCH --error=/path/to/my/Part_1/Output_and_Error/%x.err

# source home profile 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/busco

# make output directory for all busco output
mkdir /path/to/my/Part_1/all_busco_output

# run busco on all assemblies we have so far
# longreadfailpass unicycler assembly
busco -i /path/to/my/Part_1/barcode02/all_unicycler_longread_output/unicycler_longreadfail_pass_output/longreadfailpass_uni_assembly.fasta --lineage_dataset /shared/conda/busco_downloads/lineages/archaea_odb10 -o longreadfail_pass_unicycler -m genome --out_path /path/to/my/Part_1/all_busco_output -c 8

# longreadpass unicycler assembly
busco -i /path/to/my/Part_1/barcode02/all_unicycler_longread_output/unicycler_longreadpass_output/longreadpass_uni_assembly.fasta \
--lineage_dataset /shared/conda/busco_downloads/lineages/archaea_odb10 \
-o longreadpass_unicycler \
-m genome \
--out_path /path/to/my/Part_1/all_busco_output \
-c 8

# longreadfailpass miniasm assmbly
busco -i /path/to/my/Part_1/barcode02/miniasm_utgassem_results/miniasm_longread_fail_pass.fasta \
--lineage_dataset /shared/conda/busco_downloads/lineages/archaea_odb10	\
-o longreadfail_pass_miniasm \
-m genome \
--out_path /path/to/my/Part_1/all_busco_output \
-c 8

# longreadpass miniasm assembly
busco -i /path/to/my/Part_1/barcode02/miniasm_utgassem_results/miniasm_longreadpass.fasta \
--lineage_dataset /shared/conda/busco_downloads/lineages/archaea_odb10	\
-o longreadpass_miniasm \
-m genome \
--out_path /path/to/my/Part_1/all_busco_output \
-c 8

# short read unicycler assembly
busco -i /path/to/my/Part_1/short_read_illumina/unicycler_assembly_results/shortread_uni_assembly.fasta \
--lineage_dataset /shared/conda/busco_downloads/lineages/archaea_odb10 \
-o shortread_unicycler \
-m genome \
--out_path /path/to/my/Part_1/all_busco_output \
-c 8

# hybrid assembly
busco -i /path/to/my/Part_1/barcode02/hybrid_results/assembly.fasta \
--lineage_dataset /shared/conda/busco_downloads/lineages/archaea_odb10 \
-o hybrid_unicycler \
-m genome \
--out_path /path/to/my/Part_1/all_busco_output \
-c 8


# get the job id
echo "The Job ID for this job is: $SLURM_JOB_ID"
