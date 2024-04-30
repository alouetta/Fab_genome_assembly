import os 
import argparse
import re

# Examble run command
# python3 specific_fasta_grab.py -f path_to_fasta_youwant_aspecific_seq_from -o name_of_your_output_file -s sequence_number_you_want_to_grab --fragment_length 100000 
# if you leave out s the code will grab a sequence from each contig
my_parser = argparse.ArgumentParser(description='Taking a fasta file and output file name')

my_parser.add_argument('-f','--fasta', type=str, metavar='give the fasta file with multiple sequences', required=True, help='give the path to fasta file',dest='fasta')

my_parser.add_argument('-o','--out',dest='out', type=str, metavar='output file name prefix', required=True, help='specifiy your output file prefix. If information from all fasta sequences are grabbed then the prefix will be followed by the string "seq" and the sequence number i.e "unicycler_output_seq1.fasta". Here, you should specify the path to the directory for your output file and then give the output file prefix at the end of it')

my_parser.add_argument('-s','--sequence_number', type=str, metavar='assembled chromosome/sequence', required=False,
                        help='sequence number you want to grab from the fasta. Indexing starts at 1',default='all', dest='sequence_number')

my_parser.add_argument('-l','--fragment_length',dest='fragment_length',type=int, metavar='length of sequence you want to grab',required=False,
                       help='specify the squence length that you want to grab',default=0)



my_files = my_parser.parse_args()

# create function that will find the index the data that gets written out depending on which sequence is being asked for
def locate_indexes(sequence_number,header_names,fasta_data,fragment_length):

    if sequence_number < len(header_names) - 1:
            
        # select the sequence they chose 
        seq_choice = header_names[sequence_number]

        # now select the sequence that comes after it
        ending_string = header_names[sequence_number + 1]

        # now find out where each start and end, we want the ending position of the header for the sequence they do want
        # and the starting position of the header for the sequence that comes after. That way we get the full seq
        ending_index_header = re.search(f'{seq_choice}',fasta_data).end()

        # the starting index for the header right after what they want. (up to but not including)
        starting_index_header = re.search(f"{ending_string}",fasta_data).start()

            
        # otherwise if the sequence they want is the last sequence in the fasta
    elif sequence_number == len(header_names) - 1:

        # then we just need the ending index for the header and we write all the way to the end of the file
        seq_choice = header_names[sequence_number].rstrip('\n')

        ending_index_header = re.search(f'{seq_choice}',fasta_data).end()

        # the start/where to write up to will just be the end of the file
        starting_index_header = len(fasta_data)

    # if the default value is passed then just grab the whole sequence 
    if fragment_length == 0:
        info = all_fasta[ending_index_header:starting_index_header].lstrip('\n')

    # if they specify a number then grab that amount of seuqnece instead
    elif fragment_length != 0:
        info = all_fasta[ending_index_header:(ending_index_header + fragment_length)].lstrip('\n')

    return seq_choice,info

# open our fasta and output files
with open(my_files.fasta,'r+') as input_fasta:

    # store all fasta data in a variable
    all_fasta = input_fasta.read()

    # we will save all the different names and put them in a list so the number sequence they want is equal to position in list
    diff_seqs = re.findall('>.*',all_fasta)

    # fact check the number of sequences 
    for head in diff_seqs:
        print(re.search(f'{head}',all_fasta))

    # if they specify an actual sequence they want to grab
    if my_files.sequence_number != 'all':

        # get values for the starting and ending index for the fasta seq they want to grab
        # subtract one to get the actual python index of the fasta sequence they want 
        chosen_seq_header,info_to_write = locate_indexes(sequence_number=int(my_files.sequence_number)-1,header_names=diff_seqs,fasta_data=all_fasta,fragment_length=my_files.fragment_length)

        # open output file
        out_fasta = open(f'{my_files.out}_seq{my_files.sequence_number}.fna','w+') 

        # start building output file
        out_fasta.write(f"{chosen_seq_header}\n{info_to_write}")
    
    elif my_files.sequence_number == 'all':
        
        # go through every sequence there is in the fasta file
        for seq_num in range(len(diff_seqs)):

            # get values for the starting and ending index for the fasta seq they want to grab
            chosen_seq_header,info_to_write = locate_indexes(sequence_number=seq_num,header_names=diff_seqs,fasta_data=all_fasta,fragment_length=my_files.fragment_length)
            
            # open output file and number it based on which sequence has been grabbed
            # add one so instead of seq_0 we get seq1 in the output 
            out_fasta = open(f'{my_files.out}_seq{seq_num+1}.fna','w+') 

            # start building output file
            out_fasta.write(f"{chosen_seq_header}\n{info_to_write}")
            
          
   
    

    
    



