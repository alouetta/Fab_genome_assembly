#!/bin/bash
#SBATCH --job-name=genovi_barcode02_annotaton
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
conda activate /shared/conda/genovi

# make dir for genovi output
mkdir /path/to/your/Project/genovi_output

# run genovi command on all prokka output
# loop through each gbk file we get from the prokka output from each of our assemblies 
for GBKFILE in /path/to/your/Project/prokka_output/*longread*/*.gbk
do
	# separate the full path into fields and select the eight field with -f 8 because that is where the file name is
	OUTNAME=$(echo $GBKFILE| cut -d '/' -f 8)
	
	# remove the .fasta from the file name
	OUTNAMEREAL=${OUTNAME%.*}
	
	# make a new directory for each of the output
	mkdir /path/to/your/Project/genovi_output/$OUTNAMEREAL

	# change directory to the specific directory we want the output to be in (i.e if we are using the prokka gbk for unicycler long read pass we want to be
	# in the directory for long read pass)
	cd /path/to/your/Project/genovi_output/$OUTNAMEREAL
	
	# run genovi command. -t gives the plot a title depending on which assembly we are looking at. -cs is a colour scheme for the plot
	genovi -i $GBKFILE -o $OUTNAMEREAL -s complete --size -cs forest -t $OUTNAMEREAL --title_position center

done

# get job id 
echo "The Job ID for this job is: $SLURM_JOB_ID"





