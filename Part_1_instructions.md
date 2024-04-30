## Part 1 Instructions

The steps to be performed are listed below in the order they need to be executed, along with the name of the relevant scripts for each step, details of packages and the types of input and output data. All scripts for Part 1 are in the folder [scripts_part1](scripts_part1). Most packages are available on the shared conda environments on the hpc with the code for activation of the environments incorporated into each script. The only packages you may need to download are Python and Bandage, see the relevant sections below for information on downloading.


### 1) Create folders and download files
- Create a new folder to host all the files
  - mkdir /path/to/my/Part_1
- Create a sub-folder for output and error files
  - mkdir /path/to/my/Part_1/Output_and_Error_files
- Create sub-folders for all the fasta reads
  - mkdir /path/to/my/Part_1/all_input_reads
  - mkdir /path/to/my/Part_1/all_input_reads/fastq_pass
  - mkdir /path/to/my/Part_1/all_input_reads/fastq_fail
  - mkdir /path/to/my/Part_1/all_input_reads/fastq_pass/barcode02
  - mkdir /path/to/my/Part_1/all_input_reads/fastq_fail/barcode02
  - mkdir /path/to/my/Part_1/all_input_reads/short_reads 
- Copy all of the reads from barcodes 02 in fastq fail to our working directory 
cp -r /path/to/folder/long_reads/fastq_fail/barcode02 /path/to/my/Part_1/all_input_reads/fastq_fail/barcode02
- Copy all of the reads from barcode 02 in fastq pass to our working directory
cp -r /path/to/folder/long_reads/fastq_pass/barcode02 /path/to/my/Part_1/all_input_reads/fastq_pass/barcode02
- Copy all of the Illumina shortreads from barcode 02 to our working directory
cp -r /path/to/folder/short_reads/fastq/*s* /path/to/my/Part_1/all_input_reads/short_reads
- Download the scripts folder from the github page and put it in the Part_1 folder using scp -r path/to/Downloads/scripts_part1 username@remote_host:/path/to/my/Project

### 2) Merge the data ready for assembly
Merge the reads prior to assembly.
- Script = merge_part1.sh
- Input data = .fastq (gzipped)
- Package/version = bash 3.2.57
- Reference/(link) = https://www.gnu.org/software/bash/
- Output data = fastq (gzipped)
- Command line code = sbatch /path/to/my/scripts_part1/merge_part1.sh

### 3) Nanoplot assessment of reads
To get summary statistics on each set of reads e.g. mean read length, number of reads and N50, run nanoplot on each set of data.

- Script = Part1_nanoplot_allreads
- Data = fastq (gzipped)
- Package/version = Nanoplot 1.42
- Reference/(link) = https://doi.org/10.1093/bioinformatics/btad311) & https://github.com/wdecoster/NanoPlot
- Output data = Nanostats.txt , NanoPlot-report.html and various plots
- Command line code = sbatch path/to/my/scripts_part1/Part1_nanoplot_allreads.sh 

### 4) Assembly of genomes
For our genome carry out a longread assembly, a short-read assembly and a hybrid assembly.
Two assemblers are used for comparison purposes; Miniasm and Unicycler. The short-read and hybrid data are assembled with Unicycler only and the longread data are assembled with both Miniasm and Unicycler.

#### 4.1) Create .paf files using Minimap
To assemble with Miniasm, .paf files must first be created with Minimap (see below for a description of this file type):

- Scripts = minimap_longread_assembly.sh, 
- Input data = .fastq (gzipped)
- Package/version = Minimap 0.2
- Reference/(link) =(https://doi.org/10.1093/bioinformatics/bty191 & https://github.com/lh3/minimap
- Output data = .paf ("Pairwise mApping Format" - used to show pairwise sequence alignments. Each line has details of 1 alignment e.g. name, length, start/end positions & alignment score)
- Command line code = sbatch /path/to/my/Part_1/scripts_part1/minimap_assembly.sh 
  
#### 4.2) Miniasm assembly

- Scripts =  miniasm_longread_assembly.sh
- Input data = .fastq (gzipped)
- Package/version = Miniasm 0.3 
- Reference/(link) =  https://github.com/lh3/miniasm
- Output data = .gfa 
- Command line code = sbatch /path/to/my/Part_1/scripts_part1/miniasm_longread_assembly.sh

#### 4.3) Unicycler assembly

- Scripts = unicycler_longread_assembly.sh, unicycler_shortread_assembly.sh, unicycler_hybrid_assembly.sh
- Input data = .fastq (gzipped)
- Package/version = Unicycler 0.5
- Reference/(link) = https://doi.org/10.1371/journal.pcbi.1005595 & https://github.com/rrwick/Unicycler 
- Output data = .fasta (assemblies) and .txt (assembly stats)
- Command line code = sbatch /path/to/my/Part_1/scripts_part1/unicycler_longread_assembly.sh (repeat for shortread and hybrid scripts)

### 5) Visualise the assemblies using Bandage
Upload the.gfa files obtained from the assemblers by selecting File/Load graph. Use the Unicyler pass files for best results. Click on Draw graph to get your visualisation of the assemblies.

- Input data = .gfa
- Package/version = Bandage 0.81 (Download the Bandage package from (https://rrwick.github.io/Bandage/) If on a Mac you receive a warning stating that Bandage 'can't be opened because it is from an unidentified developer, go to System Settings/Privacy and Security and under security select the button 'Open anyway').
- Reference/(link) = http://rrwick.github.io/Bandage/
- Output data = .png (assembly graph)

### 6) Get sequence fragments to search the ncbi website for species identification
Fragments of 100,000bp are extracted from our longread unicycler pass assembly to search on the ncbi website to identify species. The script is written in Python, to download Python vist (https://www.python.org/downloads/) and follow the instructions. The script will extract one fragment per contig.
- Scripts = specific_fasta_grab.py 
- Input data = .fasta 
- Package/version = Python 3.11.4
- Reference/(link) = https://www.python.org/about/
- Output data = .fna
- Command line code = python3 /path/to/my/Part_1/scripts_part1/specific_fasta_grab.py -f /path/to/my/Part_1/barcode02/unicycler_longreadpass_output/unicycler_barcode02_pass_assembly.fasta -o /path/to/my/Part_1/blast_search_fasta_sequences/unicycler_barcode02_pass --fragment_length 100000 

### 7) Search the ncbi database 
- Download sequence fragments using scp -pr username@host:/path/to/your/Part_1/blast_search_fasta_sequences /Users/name/Downloads.
- Go to the blastn suite at (https://blast.ncbi.nlm.nih.gov/Blast.cgi?PROGRAM=blastn&BLAST_SPEC=GeoBlast&PAGE_TYPE=BlastSearch) and upload your sequences one by one and click on BLAST to search the database.

### 8) Evaluate completeness of all assemblies using Busco
The presence of common orthologous genes against a relevant dataset, in this case archaea odb10, is assessed for all assemblies.

- Scripts = busco_part1_allassemblies.sh
- Input data = .fasta 
- Package/version = Busco 5.6
- Reference/(link) = https://doi.org/10.1093/molbev/msab199
- Output data = .txt, .tsv & .log
- Command line code = sbatch /path/to/my/Part_1/scripts_part1/busco_part1_allassemblies.sh

### 9) Download the reference genome (for use with Quast)
- Create a folder to store the reference genome Haloferax volcanii
  - mkdir /path/to/my/Part_1/haloferax_volcanii
- use the following link to get to the reference files and download Annotation Features gff, genome sequences fasta and protein fasta
  - H.volcanii:(https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_000025685.1/)
- unzip the folders using your local file manager tool and upload them to the hcp using: 
  - scp -r path/to/Downloads/folder username@remote_host:/path/to/my/Part_1

### 9) Get assembly stats with Quast
To get assembly stats and compare assembly methods use Quast, including the reference genome H.volcanii. 

- Scripts = quast_all_longread_QC_volc.sh 
- Input data = .fasta (query assemblies) & .fna (reference files from ncbi website)
- Package/version = Quast 5.2
- Reference/(link) = https://github.com/ablab/quast
- Output data = plots and reports in .pdf, .txt, .html (report.html is the most useful)
- Command line code = sbatch /path/to/my/Part_1/scripts_part1/quast_all_longread_QC_volc.sh
  

