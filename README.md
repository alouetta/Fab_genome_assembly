# Bacterial Genome Investigation

## Introduction
We were provided with Nanopore long-read data from 3 different bacterial samples. Two of the bacteria had been cultured together (barcode09 and barcode10) and the third was the resulting progeny after culturing (barcode02). The aim of the project was to identify the species of each sample, to look at the differences between the samples and to determine what might have happened to them to produce the differences. 

## Expected outcome




## Methods
The steps performed are listed below in the order they need to be executed, along with the name of the relevant scripts for each step, details of packages used and the types of input and output data. All packages are available on the shared conda environments on the hpc and the code for activation of the environments is incorporated into each script. There is no need §


### 1) Create folders and download files
- Create a new folder to host all the files: mkdir /path/to/my/Project
- Create a sub-folder for output and error files:
mkdir /path/to/my/Project/Output_and_Error_files
- Create sub-folders for all the fasta reads
mkdir /path/to/my/Project/all_input_reads
mkdir /path/to/my/Project/all_input_reads/fastq_pass
mkdir /path/to/my/Project/all_input_reads/fastq_fail
*Repeat replacing barcode09 with barcode10 and then barcode02)*
- Copy all of the reads in fastq fail to our working directory 
cp -r /workhere/students_2023/Matt_resources/IC/IC_199/Haloferax_10_barcodes/20231114_1133_3E_PAH51710_e2e481f9/fastq_fail/barcode09 /path/to/my/Project/barcode09/all_input_reads/fastq_fail 

*Repeat for barcode10 and barcode02*
- Copy all of the reads in fastq pass to our working directory
cp -r /workhere/students_2023/Matt_resources/IC/IC_199/Haloferax_10_barcodes/20231114_1133_3E_PAH51710_e2e481f9/fastq_pass/barcode09 /path/to/my/Project/all_input_reads/fastq_pass 

*Repeat for barcode10 and barcode02*
- Download the scripts folder from the github page and put it in the Projects folder using scp -r path/to/Downloads/scripts username@remote_host:/path/to/my/Project

### 2)Nanoplot assessment of reads
To get summary statistics on each set of reads e.g. mean read length, N50, nanoplot is run on each set of data separately.

- Scripts = barcode09_nanoplot_stats.sh, barcode10_nanoplot_stats.sh, barcode02_nanoplot_stats.sh
- Data = fastq (gzipped)
- Package/version = Nanoplot 1.42
- Reference/(link) = https://doi.org/10.1093/bioinformatics/btad311)/(https://github.com/wdecoster/NanoPlot)
- Output data = Nanostats.txt , NanoPlot-report.html and various plots
- Command line code = sbatch path/to/your/scripts/Nanoplot/barcode*_nanoplot_stats.sh (replace * with barcodde number corresponding to script)

### 3) Merge the data ready for assembly
The reads for each barcode are merged using bash code.

Script = merge_all_fastq.sh
Input data = .fastq (gzipped)
Package/version = bash
Reference/(link) = n/a
Output data = fastq (gzipped)
Command line code = sbatch /path/to/my/Project/scripts/Merge_data/merge_all_fastq.sh
