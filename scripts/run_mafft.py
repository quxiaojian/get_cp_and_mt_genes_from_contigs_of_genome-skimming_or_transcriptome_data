#!/usr/bin/python3
import os,sys,argparse

parser = argparse.ArgumentParser(formatter_class = argparse.RawTextHelpFormatter, description = "This script can do mafft alignment!")
parser.add_argument("input_dir", metavar = "input_dir", type = str, default = "input", help = "(Default: input) the path to alignment input")
parser.add_argument("output_dir", metavar = "output_dir", type = str, default = "output", help = "(Default: output) the path to alignment output")
args = parser.parse_args()

if args.input_dir is not None and args.output_dir is not None:
    cwd_path=os.path.abspath(".")
    args.input_dir = os.path.join(cwd_path, args.input_dir)
    args.output_dir = os.path.join(cwd_path, args.output_dir)
    if not os.path.exists(args.output_dir):
        os.makedirs(args.output_dir)
    elif os.path.exists(args.output_dir):
            for i in os.listdir(args.output_dir):
                os.remove(os.path.join(args.output_dir, i))
            os.removedirs(args.output_dir)

    input_files=os.listdir(args.input_dir)
    for input_file in input_files:
        input_full_path = os.path.join(args.input_dir, input_file)
        output_full_path = os.path.join(args.output_dir, input_file)
        run_mafft="mafft-linsi --thread 4  " + input_full_path + " > " + output_full_path
        os.system(run_mafft)
        print("Running:" + run_mafft)
