## Part 2 Instructions

The steps to be performed are listed below in the order they need to be executed, along with the name of the relevant scripts for each step, details of packages and the types of input and output data. All scripts for Part 2 are in the folder [scripts_part2](scripts_part2). Most packages are available on the shared conda environments on the hpc with the code for activation of the environments incorporated into each script. The only packages you may need to download are Python and Bandage, see the relevant sections below for information on downloading.


### 1) Create folders and download files
- Create a new folder to host all the files
  - mkdir /path/to/my/Project
- Create a sub-folder for output and error files
  - mkdir /path/to/my/Project/Output_and_Error_files
- Create sub-folders for all the fasta reads
  - mkdir /path/to/my/Project/all_input_reads
  - mkdir /path/to/my/Project/all_input_reads/fastq_pass
  - mkdir /path/to/my/Project/all_input_reads/fastq_fail
  - mkdir /path/to/my/Project/all_input_reads/fastq_pass/barcode02
  - mkdir /path/to/my/Project/all_input_reads/fastq_fail/barcode02
*Repeat replacing barcode02 with barcode09 and then barcode10)*
- Copy all of the reads from barcodes 02, 09 and 10 in fastq fail to our working directory 
cp -r /path/to/folder/IC/IC_199/Haloferax_10_barcodes/20231114_1133_3E_PAH51710_e2e481f9/fastq_fail/barcode02 /path/to/my/Project/all_input_reads/fastq_fail/barcode02
*Repeat for barcode09 and barcode10*
- Copy all of the reads from barcodes 02, 09 and 10 in fastq pass to our working directory
cp -r /workhere/students_2023/Matt_resources/IC/IC_199/Haloferax_10_barcodes/20231114_1133_3E_PAH51710_e2e481f9/fastq_pass/barcode02 /path/to/my/Project/all_input_reads/fastq_pass/barcode02
*Repeat for barcode09 and barcode10*
- Download the scripts folder from the github page and put it in the Projects folder using scp -r path/to/Downloads/scripts username@remote_host:/path/to/my/Project

### 2) Merge the data ready for assembly
Merge the reads for each barcode prior to assembly.

- Script = merge_all_fastq.sh
- Input data = .fastq (gzipped)
- Package/version = bash 3.2.57
- Reference/(link) = https://www.gnu.org/software/bash/
- Output data = fastq (gzipped)
- Command line code = sbatch /path/to/my/Project/scripts/Merge_data/merge_all_fastq.sh

### 3) Nanoplot assessment of reads
To get summary statistics on each set of reads e.g. mean read length, number of reads and N50, nanoplot is run on each set of data separately.

- Scripts = barcode02_nanoplot_stats.sh, barcode09_nanoplot_stats.sh, barcode10_nanoplot_stats.sh
- Data = fastq (gzipped)
- Package/version = Nanoplot 1.42
- Reference/(link) = https://doi.org/10.1093/bioinformatics/btad311) & https://github.com/wdecoster/NanoPlot
- Output data = Nanostats.txt , NanoPlot-report.html and various plots
- Command line code = sbatch path/to/your/scripts/Nanoplot/barcode02_nanoplot_stats.sh (repeat for barcode09 and barcode10 scripts)

### 4) Assembly of genomes with Unicycler
Genomes are assembled with Unicycler as this gave the best results in Part 1.

- Scripts = barcode02_unicycler_assembly.sh, barcode09_unicycler_assembly.sh, barcode10_unicycler_assembly.sh
- Input data = .fastq (gzipped)
- Package/version = Unicycler 0.5
- Reference/(link) = https://doi.org/10.1371/journal.pcbi.1005595 & https://github.com/rrwick/Unicycler 
- Output data = .fasta (assemblies) and .txt (assembly stats)
- Command line code = sbatch /path/to/my/Project/scripts/Unicycler/barcode02_unicycler_assembly.sh (repeat for barcode09 and barcode10 scripts)

### 5) Visualise the assemblies using Bandage
Upload the.gfa files obtained from the assemblers by selecting File/Load graph. Use the Unicyler pass files for best results. Click on Draw graph to get your visualisation of the assemblies.

- Input data = .gfa
- Package/version = Bandage 0.81 (Download the Bandage package from (https://rrwick.github.io/Bandage/) If on a Mac you receive a warning stating that Bandage 'can't be opened because it is from an unidentified developer, go to System Settings/Privacy and Security and under security select the button 'Open anyway').
- Reference/(link) = http://rrwick.github.io/Bandage/
- Output data = .png (assembly graph)

###  6) Assembly of barcode09 with Flye
Barcode09 does not assemble well with Unicycler and not at all with Miniasm (see busco and bandage results) so carry out a further assembly of barcode09 with Flye to produce better results. Repeat Bandage graph with the assembly.gfa to see the difference with the Unicycler assembly.

- Script = Flye_assembly_barcode09.sh
- Input data = .fastq (gzipped)
- Package/version = 2.9.3
- Reference/(link) = https://doi.org/10.1038/s41592-020-00971-x
- Output data = .fasta, .gfa, .txt
- Command line code = sbatch /path/to/my/Project/scripts/Flye/Flye_assembly_barcode09.sh

### 7) Get sequence fragments to search the ncbi website for species identification
Fragments of 100,000bp are extracted from each unicycler pass assembly to search on the ncbi website to identify species. The script is written in Python, to download Python vist (https://www.python.org/downloads/) and follow the instructions. The script will extract one fragment per contig.
- Scripts = specific_fasta_grab.py 
- Input data = .fasta 
- Package/version = Python 3.11.4
- Reference/(link) = https://www.python.org/about/
- Output data = .fna
- Command line code = python3 /path/to/my/Project/scripts/Sequence_grab/specific_fasta_grab.py -f /path/to/my/Project/unicycler_all_output/unicycler_longread_pass_output/unicycler_barcode02_pass_assembly.fasta -o /path/to/my/Project/blast_search_fasta_sequences/unicycler_barcode02_pass --fragment_length 100000 (repeat for barcode09 and barcode10 unicycler pass assemblies, altering the filenames as necessary in the command line code)

### 8) Search the ncbi database 
- Download your sequence fragments using scp -pr username@host:/path/to/your/Project/blast_search_fasta_sequences /Users/name/Downloads.
- Go to the blastn suite at (https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&BLAST_SPEC=GeoBlast&PAGE_TYPE=BlastSearch) and upload your sequences one by one and click on BLAST to search the database.

### 9) Download the H.mediterranei reference genome
Reference genomes will be used in subsequent analyses e.g. Quast and Busco.
- Create a new folder to store the reference genomes Haloferax mediterranei
  - mkdir /path/to/my/Project/haloferax_mediterranei
- use the following links to get to the reference files and download Annotation Features gff, genome sequences fasta and protein fasta 
  - H.medi: (https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_005406325.1/)
- unzip the folders using your local file manager tool and upload them to the hcp using: 
  - scp -r path/to/Downloads/folder username@remote_host:/path/to/my/Project
- copy the H.volcanii reference files from our Part1 folder using cp r /path/to/my/Part_1/haloferax_volcanii /path/to/my/Project/

### 10) Align to references with Quast
To see where barcode02 aligns to the references, to see how much of each of the 2 species is in barcode02, to get assembly stats and compare assembly methods use Quast. Repeat Quast for both reference genomes and do a final quast with both references combined.

- Scripts = quast_all_longread_QC_med.sh, quast_all_longread_QC_volc.sh & quast_all_longread_QC_volc_and_med.sh
- Input data = .fasta (query assemblies) & .fna (reference files from ncbi website)
- Package/version = Quast 5.2
- Reference/(link) = https://github.com/ablab/quast
- Output data = plots and reports in .pdf, .txt, .html (report.html is the most useful)
- Command line code =
  - using haloferax mediterannei as a reference: sbatch /path/to/my/Project/scripts/Quast/quast_all_longread_QC_med.sh
  - using haloferax volcanii as a reference: sbatch /path/to/my/Project/scripts/Quast/quast_all_longread_QC_volc.sh
  - using both haloferax mediterannei and haloferax volcanii as a reference: sbatch /path/to/my/Project/scripts/Quast/quast_all_longread_QC_volc_and_med.sh

### 11) Evaluate completeness of the assemblies using Busco
The presence of common orthologous genes against a relevant dataset, in this case archaea odb10, is assessed for all assemblies.

- Scripts = busco_barcode02.sh, busco_barcode09.sh, busco_barcode10.sh
- Input data = .fasta 
- Package/version = Busco 5.6
- Reference/(link) = https://doi.org/10.1093/molbev/msab199
- Output data = .txt, .tsv & .log
- Command line code = sbatch /path/to/my/Project/scripts/Busco/busco_barcode02.sh (repeat for barcode09 and barcode10 scripts)


### 12) Annotate the barcode02 genome with Prokka
To see which genes from which of the two species are in barcode02 data annotate with Prokka.

- Script = prokka_annotation.sh
- Input data = .fasta and .faa
- Package/version = 1.14.5
- Reference/(link) = https://doi.org/10.1093/bioinformatics/btu153
- Output data = .gff, .fna, .faa and others
- Command line code = sbatch /path/to/my/Project/scripts/Prokka/prokka_annotation.sh

### 13) Visualise the barcode02 genome with GenoVi
Visualise the prokka annotation using GenoVi.

- Script = genovi_annotation.sh
- Input data = .gbk (prokka output)
- Package/version = GenoVi 0.2.16
- Reference/(link) = https://doi.org/10.1371/journal.pcbi.1010998
- Output data = .png & .svg
- Command line code = sbatch /path/to/my/Project/scripts/GenoVi/genovi_annotation.sh

### 14) Check for genes coding for genetic engineering enzymes
To test the theory that chromosome 1 having mediterannei and volcanii genetic material is due to genetic engineering we will check for genes related to genetic engineering at the 'ends' of where the mediterannei chromosome becomes volcanii

- Script = gff_gene_exploration.sh
- Input data = .gff (Prokka output)
- Package/version = bash 3.2.57
- Reference/(link) = https://www.gnu.org/software/bash/
- Output data = .txt
- Command line code = bash /path/to/my/Project/scripts/gff_gene_exploration     
