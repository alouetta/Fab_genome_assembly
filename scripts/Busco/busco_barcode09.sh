#!/bin/bash
#SBATCH --job-name=busco_barcode09
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/path/to/my/Project/Output_and_Error_files/%x.out
#SBATCH --error=/path/to/my/Project/Output_and_Error_files/%x.err

# source home profile 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/busco

# make output directory for all busco output
mkdir /path/to/my/Project/all_busco_output

# make a directory to put all of our barcode09 assemblies into 
mkdir /path/to/my/Project/barcode09_assemblies_fasta

# copy all fasta files to the input assemblies directory 
# moving all barcode09 unicyler output
cp /path/to/my/Project/unicycler_all_output/unicycler_barcode09*.fasta /path/to/my/Project/barcode09_assemblies_fasta

# moving all barcode09 miniasm output
cp /path/to/my/Project/miniasm_utgassem_results/miniasm_barcode09*.fasta /path/to/my/Project/barcode09_assemblies_fasta

# moving all barcode09 Flye output
cp /path/to/my/Project/barcode09_Flye_assembly/Flye_assembly_barcode09*.fasta /path/to/my/Project/barcode09_assemblies_fasta


# run busco on all assemblies we have so far
for ASSEMBLYFILE in /path/to/my/Project/barcode09_assemblies_fasta/*
do
	# separate the full path into fields and select the seventh field with -f 7 because that is where the file name is
	OUTNAME=$(echo $ASSEMBLYFILE| cut -d '/' -f 7)

	# remove the .fasta from the file name
	OUTNAMEREAL=${OUTNAME%.*}
	
	# run the busco command on each of the assemblies 
	busco -i $ASSEMBLYFILE --lineage_dataset /shared/conda/busco_downloads/lineages/archaea_odb10 -o $OUTNAMEREAL -m genome --out_path /path/to/my/Project/all_busco_output -c 8
done

# get the job id
echo "The Job ID for this job is: $SLURM_JOB_ID"


