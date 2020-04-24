#!/usr/bin/python3
import os
import sys
import argparse

parser = argparse.ArgumentParser(formatter_class = argparse.RawTextHelpFormatter, description = "This script can do mafft alignment!")
parser.add_argument("Contig_path", metavar = "Contig_path", type = str, default = "hit/", help = "(Default: hit/) the path to blast hit")
parser.add_argument("Output_path", metavar = "Output_path", type = str, default = "mafft/", help = "(Default: mafft/) the path to mafft output")
parser.add_argument("Ref_path", metavar = "Ref_path", type = str, default = "ref_separate_genes/", help = "(Default: ref_separate_genes/) the path to reference genes")
parser.add_argument("Ref_file_ending", metavar = "Ref_file_ending", type = str, default = "_species_name.fasta", help = "(Default: _species_name.fasta) text at end of reference file names")
args = parser.parse_args()

#Contig_path = '/data/quxiaojian/documents/test/hit/'
#Output_path = '/data/quxiaojian/documents/test/mafft/'
#Ref_path = '/data/quxiaojian/documents/test/ref_separate_genes/'
#Ref_file_ending = '_Calocedrus_decurrens.fasta' # Text at end of refernce file names

if args.Contig_path is not None and args.Output_path is not None and args.Ref_path is not None and args.Ref_file_ending is not None:
    cwd_path=os.path.abspath(".")
    args.Contig_path = os.path.join(cwd_path, args.Contig_path)
    args.Output_path = os.path.join(cwd_path, args.Output_path)
    if not os.path.exists(args.Output_path):
        os.makedirs(args.Output_path)
    elif os.path.exists(args.Output_path):
        Output_subdirs = os.listdir(args.Output_path)
        if Output_subdirs:
            for Output_subdir in Output_subdirs:
                for i in os.listdir(os.path.join(args.Output_path, Output_subdir)):
                    os.remove(os.path.join(args.Output_path, Output_subdir, i))
            os.removedirs(os.path.join(args.Output_path, Output_subdir))
    args.Ref_path = os.path.join(cwd_path, args.Ref_path)

    Subdirs=os.listdir(args.Contig_path)
    for Subdir in Subdirs:
        Contig_files=os.listdir(args.Contig_path + Subdir)
        for File in Contig_files:
            Gene=File.split('.fa')[0] # Split filename on "." and take the 1st part=gene name
            Gene_full_path = os.path.join(args.Contig_path, Subdir, File)

            # Get path to reference sequence for this gene
            Ref_file = os.path.join(args.Ref_path, Gene) + args.Ref_file_ending

            # Combine the reference and contig files into one file.
            if not os.path.exists(os.path.join(args.Output_path, Subdir)):
                os.makedirs(os.path.join(args.Output_path, Subdir))

            Combined_file = args.Output_path + Subdir + '/' + Gene + '_wref.fasta'
            Cat_command = 'cat ' + Ref_file + ' ' + Gene_full_path + ' > ' + Combined_file
            print('Running: ' + Cat_command)
            os.system(Cat_command)
        
            # Generate Mafft commandline
            RunMafft="mafft-linsi --thread 4  " + Combined_file + " > " + args.Output_path + Subdir + "/" + Gene + "_mafft.fasta"
            print("Running:" + RunMafft)
    
            # Run mafft
            os.system(RunMafft)
    
            # Generate Perl script commandline
            perl_path=sys.path[0]
            RunPerl='perl ' + perl_path + '/10_create_mafft_scaffold_MG.fixed.mvref.pl '
            Summary_file= os.path.join(args.Output_path, Subdir, Gene) + '_summary.out '
            Input_file = os.path.join(args.Output_path, Subdir, Gene) + "_mafft.fasta "
            Consensus_file = os.path.join(args.Output_path, Subdir, Gene) + "_consensus.fasta "
            Temp_path = args.Output_path + Subdir + " "
            Divergent_file = os.path.join(args.Output_path, Subdir, Gene) + "_divergent.fasta"
    
            RunPerl += Summary_file + Input_file + Consensus_file + Temp_path + Divergent_file
            print ("Running: " + RunPerl)
    
            # Run Perl script
            os.system(RunPerl)
