#!/bin/bash
#SBATCH --job-name=annotating_barcode02_w_prokka
#SBATCH --partition=hpc
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/path/to/your/Project/Output_and_Error_files/%x.out
#SBATCH --error=/path/to/your/Project/Output_and_Error_files/%x.err

# source home profile 
source $HOME/.bash_profile

# activate environment with all tools we need 
conda activate /shared/conda/shared 

# make directory for all of prokka output
mkdir /path/to/your/Project/prokka_output

# concatenate the two haleforax species files (mediterannei and volcanii)
cat /path/to/your/Project/haloferax*i/ncbi_dataset/data/GCF*/protein.faa \
> /path/to/your/Project/combined_volcii_mediterri_proteins.faa

# run prokka commands on all assemblies
# loop through all assembly files which are in the folder labelled all busco output
for ASSEMBLYFILE in /path/to/your/Project/all_assemblies_fasta/*
do
	# separate the full path into fields and select the seventh field with -f 7 because that is where the file name is
	OUTNAME=$(echo $ASSEMBLYFILE| cut -d '/' -f 7)
	
	# remove the .fasta from the file name
	OUTNAMEREAL=${OUTNAME%.*}
	
	# run prokka command. -prefix gives the output files a new name using the name of the fasta file
	prokka --outdir /path/to/your/Project/prokka_output/$OUTNAMEREAL --prefix $OUTNAMEREAL --proteins /path/to/your/Project/combined_volcii_mediterri_proteins.faa --kingdom Bacteria $ASSEMBLYFILE

done

# get job id 
echo "The Job ID for this job is: $SLURM_JOB_ID"




