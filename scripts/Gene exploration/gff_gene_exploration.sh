## This script looks for genes relating to genetic engineering in our Prokka annotation to test the theory that barcode02 has been created by joining parts of the 2 parent genomes together by genetic engineering.
# First, find all the hits for haloferax volcanii to get an idea of how many bp long the volcanii dna spans
# Then,use head and tail on the resulting file to find the positions of the first and last volcanii proteins 
grep '^1.*Haloferax volcanii' /path/to/my/project/prokka_output/unicycler_longread_pass_assembly/unicycler_longread_pass_assembly.gff \
    >  /path/to/my/project/prokka_output/unicycler_longread_pass_assembly/unicycler_longread_pass_chromosome1_volcanii_prts.txt

# Now we know the *ends* of volcanii in the first chromosome we can have look around there for interesting proteins to do with genetiic engineering 
# We search on google for a list of keywords related to genetic engineering and search for them
# The grep means we only look in the first chromosome protein hits for proteins that have these keywords in their name 
for word in 'endonuclease' 'target' 'ligase' 'recombinant' 'repair' 'break' 'double-strand' 'directed' 'recombination' 'polymerase'
do
    grep "^1.*$word" /path/to/my/project/prokka_output/unicycler_longread_pass_assembly/unicycler_longread_pass_assembly.gff \
    >> /path/to/my/project/prokka_output/unicycler_longread_pass_assembly/unsorted_genetic_engineering_genes.txt
	
done

# Sort out the output based on the ascending order of the chromosome sequence position
sort -t $'\t' -k 4,4n /path/to/my/project/prokka_output/unicycler_longread_pass_assembly/unsorted_genetic_engineering_genes.txt > /path/to/my/project/prokka_output/unicycler_longread_pass_assembly/genetic_engineering_genes.txt

