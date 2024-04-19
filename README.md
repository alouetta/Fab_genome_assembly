# Bacterial Genome Investigation

## Introduction
We were provided with Nanopore long-read data from 3 different bacterial samples. Two of the bacteria had been cultured together (barcode09 and barcode10) and the third was the resulting progeny after culturing (barcode02). The aim of the project was to identify the species of each sample, to look at the differences between the samples and to determine what might have happened to them to produce the differences. 

## Expected outcome




## Methods
The steps performed are listed below in the order they need to be executed, along with the name of the relevant scripts for each step, details of packages used and the types of input and output data. Most packages are available on the shared conda environments on the hpc and the code for activation of the environments is incorporated into each script. The only packages you may need to download are Python and Bandage and details of where to find them are in the relevant sections below.


### 1) Create folders and download files
- Create a new folder to host all the files
  - mkdir /path/to/my/Project
- Create a sub-folder for output and error files
  - mkdir /path/to/my/Project/Output_and_Error_files
- Create sub-folders for all the fasta reads
  - mkdir /path/to/my/Project/all_input_reads
  - mkdir /path/to/my/Project/all_input_reads/fastq_pass
  - mkdir /path/to/my/Project/all_input_reads/fastq_fail
*Repeat replacing barcode09 with barcode10 and then barcode02)*
- Copy all of the reads from barcodes 02, 09 and 10 in fastq fail to our working directory 
cp -r /path/to/folder/IC/IC_199/Haloferax_10_barcodes/20231114_1133_3E_PAH51710_e2e481f9/fastq_fail/barcode09 /path/to/my/Project/barcode02/all_input_reads/fastq_fail 

*Repeat for barcode09 and barcode10*
- Copy all of the reads from barcodes 02, 09 and 10 in fastq pass to our working directory
cp -r /workhere/students_2023/Matt_resources/IC/IC_199/Haloferax_10_barcodes/20231114_1133_3E_PAH51710_e2e481f9/fastq_pass/barcode02 /path/to/my/Project/all_input_reads/fastq_pass 

*Repeat for barcode09 and barcode10*

- Download the scripts folder from the github page and put it in the Projects folder using scp -r path/to/Downloads/scripts username@remote_host:/path/to/my/Project

### 2)Nanoplot assessment of reads
To get summary statistics on each set of reads e.g. mean read length, N50, nanoplot is run on each set of data separately.

- Scripts = barcode09_nanoplot_stats.sh, barcode10_nanoplot_stats.sh, barcode02_nanoplot_stats.sh
- Data = fastq (gzipped)
- Package/version = Nanoplot 1.42
- Reference/(link) = https://doi.org/10.1093/bioinformatics/btad311)/(https://github.com/wdecoster/NanoPlot)
- Output data = Nanostats.txt , NanoPlot-report.html and various plots
- Command line code = sbatch path/to/your/scripts/Nanoplot/barcode02_nanoplot_stats.sh (repeat for barcode09 and barcode10 scripts)

### 3) Merge the data ready for assembly
Merge the reads for each barcode using 1 bash code script prior to assembly.

- Script = merge_all_fastq.sh
- Input data = .fastq (gzipped)
- Package/version = bash
- Reference/(link) = n/a
- Output data = fastq (gzipped)
- Command line code = sbatch /path/to/my/Project/scripts/Merge_data/merge_all_fastq.sh

### 4) Assembly of genomes
Two assemblers are used: Miniasm and Unicycler  

### 4.1 Create .paf files using Minimap
pairwise mapping file
- Scripts = barcode02_minimap_assembly.sh, barcode09_minimap_assembly.sh, barcode010_minimap_assembly.sh
- Input data = .fastq (gzipped)
- Package/version = Minimap 0.2
- Reference/(link) = (https://github.com/lh3/minimap)
- Output data = .paf
- Command line code = sbatch /path/to/my/Project/scripts/Minimap/barcode02_minimap__assembly.sh (repeat for barcode09 and barcode10 scripts)
  
### 4.1 Miniasm assembly

- Scripts =  barcode02_miniasm_assembly.sh, barcode09_miniasm_assembly.sh, barcode010_miniasm_assembly.sh-
- Input data = fastq (gzipped)
- Package/version = Miniasm 0.3 
- Reference/(link) =  (https://github.com/lh3/miniasm)
- Output data = .gfa 
- Command line code = sbatch /path/to/my/Project/scripts/Miniasm/barcode02_miniasm_assembly_and_stats.sh (repeat for barcode09 and barcode10 scripts)

### 4.2 Unicycler

- Scripts = barcode02_unicycler_assembly.sh, barcode09_unicycler_assembly.sh, barcode10_unicycler_assembly.sh
- Input data = fastq (gzipped)
- Package/version = Unicycler 0.5
- Reference/(link) = https://doi.org/10.1371/journal.pcbi.1005595)/https://github.com/rrwick/Unicycler) 
- Output data = .fasta (assemblies) and .txt (assembly stats)
- Command line code = sbatch /path/to/my/Project/scripts/Unicycler/barcode02_unicycler_assembly.sh (repeat for barcode09 and barcode10 scripts)

### 5) Visualise the assembly using Bandage

Download the Bandage package from (https://rrwick.github.io/Bandage/) If you have a Mac you may receive a warning stating that Bandage 'can't be opened because it is from an unidentified developer, go to System Settings/Privacy and Security and under security the package will be listed with a button to select titled 'Open anyway'.

- Input data = .gfa
- Package/version = Bandage 0.81
- Reference/(link) = http://rrwick.github.io/Bandage/
- Output data = .png (assembly graph)

### 6) Get sequence fragments to put into ncbi website for species identification
Fragments of 100,000bp are extracted from each unicycler pass assembly for carrying out searches on the ncbi website to identify species. A Python script is used, to download Python vist (https://www.python.org/downloads/) and follow the instructions. The script will extract one fragment per contig.
- Scripts = specific_fasta_grab.py 
- Input data = .fasta 
- Package/version = Python 3.11.4
- Reference/(link) = (https://www.python.org/about/)
- Output data = .fna
- Command line code = python3 /path/to/my/Project/scripts/Sequence_grag/specific_fasta_grab.py -f /path/to/my/Project/unicycler_all_output/unicycler_longread_pass_output/unicycler_barcode02_pass_assembly.fasta -o /path/to/my/Project/blast_search_fasta_sequences/unicycler_barcode02_pass --fragment_length 100000 (repeat for barcode09 and barcode10 unicycler pass assemblies, altering the filenames as necessary)

### 7) Do search of ncbi database 
- Download your sequence fragments using scp -pr username@host:/path/to/your/Project/blast_search_fasta_sequences /Users/name/Downloads.
- Go to the blastn suite at (https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&BLAST_SPEC=GeoBlast&PAGE_TYPE=BlastSearch) and upload your sequences one by one and click on BLAST to search the database.

### 8) Download the reference genomes

- Create new folders to store the reference genomes Haloferax volcanii and Haloferax mediterranei
  - mkdir /path/to/my/Project/haloferax_volcanii
  - mkdir /path/to/my/Project/haloferax_mediterranei
- use the following links to get to the reference files and download Annotation Features gff, genome sequences fasta and protein fasta
  - H.volcanii:(https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000025685.1/)
  - H.medi: (https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_005406325.1/)
- unzip the folders using your file manager and upload them to the hcp using 
  - scp -r path/to/Downloads/folder username@remote_host:/path/to/my/Project

### 9) Assembly stats with Quast
To assess assembly quality, compare assembly methods and compare assemblies against reference genomes. Repeat quast for both reference genomes and do a final quast with both references.

- Scripts = quast_all_longread_QC_med.sh, quast_all_longread_QC_volc.sh & quast_all_longread_QC_volc_and_med.sh
- Input data = .fasta (query assemblies) & .fna (reference files from ncbi website)
- Package/version = Quast 5.2
- Reference/(link) = https://github.com/ablab/quast
- Output data = plots and reports in .pdf, .txt, .html
- Command line code =
  - using haloferax mediterannei as a reference: sbatch /path/to/my/Project/scripts/Quast/quast_all_longread_QC_med.sh
  - using haloferax volcanii as a reference: sbatch /path/to/my/Project/scripts/Quast/quast_all_longread_QC_volc.sh
  - using both haloferax mediterannei and haloferax volcanii as a reference: sbatch /path/to/my/Project/scripts/Quast/quast_all_longread_QC_volc_and_med.sh

### 8) Evaluate orthologs in the barcode02 assembly using Busco
The presence of common orthologous genes against a relevant dataset, in this case archaea odb10, is assessed for each of the barcode02 assemblies.

- Script = busco_barcode02.sh
- Input data = .fasta 
- Package/version = Busco 5.6
- Reference/(link) = https://doi.org/10.1093/molbev/msab199
- Output data = .txt, .tsv & .log
- Command line code = sbatch /path/to/my/Project/scripts/Busco/busco_barcode02.sh

### 9) Annotate the barcode02 genome with Prokka
To see which genes from which of the two species are in barcode02 data annotate with Prokka.
- Script = prokka_annotation.sh
- Input data = .fasta and .faa
- Package/version = 1.14.5
- Reference/(link) = https://doi.org/10.1093/bioinformatics/btu153
- Output data = .gff, .fna, .faa and others
- Command line code = sbatch /path/to/my/Project/scripts/Prokka/prokka_annotation.sh

### 12) Visualise the barcode02 genome with GenoVi
Script = genovi_annotation.sh
Input data = .gbk (prokka output)
Package/version = GenoVi 0.2.16
Reference/(link) = https://doi.org/10.1371/journal.pcbi.1010998
Output data = .png & .svg
Command line code = sbatch /path/to/my/Project/scripts/GenoVi/genovi_annotation.sh

### 14) Check for genes due to genetic engineering

- Script =
- Input data =
- Package/version =
- Reference/(link) =
- Output data =
- Command line code =
      