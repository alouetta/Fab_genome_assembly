# Bacterial Genome Investigation

## Introduction
This task is split into 2 parts. In Part 1 you are provided with Nanopore long-read and Illumina short-read sequencing data from one bacterial culture (barcode02) and tasked with assembling the reads and assessing the best methods for assembly and how the different types of read affect the assemblies. In Part 2 you are provided with Nanopore long-read data from 3 different bacterial samples. Two of the bacteria have been cultured together (barcode09 and barcode10) and the third is the resulting progeny after culturing (barcode02). The aim of Part 2 is to assemble all 3 genomes and to determine for each sample: i) the species, ii) chromosome structure, iii) genome completeness and iv) to determine what might have happened to the genomes. 

## Methods
The methods for Part 1 are given in [Part1_instructions.md](Part1_instructions.md) and the methods for Part 2 in [Part2_intructions.md](Part2_instructions.md). The scripts for each part are in separate folders [scripts_part1](scripts_part1) and [scripts_part2](scripts_part2). 

## Expected outcomes

### Part 1
1) Nanoplot results should give average read lengths of 15,344bp for long-read pass data, 13,313bp for long-read fail data and 76bp for short-read data. The total length of reads should be 824mb for long-read pass data, 124mb for long-read fail data and 2,395mb for short-read data. The N50 for long-read pass data  should be 29,000 compared to 27,292 for long-read fail data and 76 for shor-tread data.

2) Visualisation of the assemblies in Bandage should reveal a 4 Mb genome of 5 contigs, with 1 main circular chromosome and 4 smaller structures. 

3) Searching in blastN with sequence fragments should identify the species as Haloferax volcanii. 

4) Busco and Quast results should confirm that Unicycler gives better assemblies than Miniasm. With the Miniasm longread pass assembly only 7 out of 194 orthologs are found with Busco compared to 176 with the Unicycler longread pass assembly. The shortread and hybrid Unicycler assemblies should give even better results with all orthologs found. For Part 2 we discard the use of Miniasm as we know the assemblies are better with Unicycler.


### Part 2
1) Nanoplot results should give average read lengths of 6284bp for barcode02, 3774bp for barcode 09 and 4604 for barcode10. The total length of reads should be 304mb for barcode 02, 225mb for barcode10 and notably only 60,751 for barcode09. The N50 for barcode09 should only be 16,801 compared to 58,000 for barcode02.

2) Visualisation with Bandage should reveal: a 3.8 Mb genome of 4 contigs for barcode10 and a 4.07 Mb genome of 6 contigs for barcode02. Each one has one main circular chromosome with the other contigs being much smaller. The bandage graph generated for the barcode09 Unicycler assembly should show a lot of fragmented pieces rather than complete structures. The Flye assembly results should be better and the bandage graph should show a 4 Mb genome of 5 contigs, again with 1 main circular chromosome and 4 smaller structures.

3) The search on the ncbi website should give the following identities:
- barcode09 = Haloferax volcanii
- barcode10 = Haloferax mediterannei
- barcode02 = has both H.volcanii and H.mediterranei DNA

4) Quast results should conclude that the best assemblers are Unicycler for barcode02 and barcode10 and Flye for barcode09. Alignment results should show that barcode02 is predominantly H. Mediterranei (65%).

5) For the Unicycler assemblies of barcode09 and barcode10 177 of a possible 194 orthologues should be found using Busco. For barcode09 this figure reduces to 125 but the Flye assembly is a little better at 158 of a possible 194. 

6) Running the gene_exploration script should identify genes that are often used in genetic engineering, such as endonucleases, ligases and DNA repair proteins. 

