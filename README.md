# get_cp_and_mt_genes_from_contigs_of_genome-skimming_or_transcriptome_data<br />

1. extract blast hits from spades or trinity contigs<br />
```
perl batch_extract.pl -i 60 -a 100 -s 1 -c cycads -d hit -f batch_extract_cycads.sh
perl extract_blast_hits_from_trinity_contigs.pl -r reference/cycads -t trinity/cycads -s 60 -l 60 -e 1e-25 -n 2 -o hit_cycads/hit60
...
perl extract_blast_hits_from_trinity_contigs.pl -r reference/cycads -t trinity/cycads -s 100 -l 60 -e 1e-25 -n 2 -o hit_cycads/hit100
```

2. extract consensus based on converage and diverage with reference<br />
```
perl batch_mafft.pl -i hit_cycads -o mafft -c cycads -r ref_separate_genes/Zamia_furfuracea -m _Zamia_furfuracea.fasta -n 60 -x 100 -s 1 -f batch_mafft_cycads.sh
python mafft_noadd.py hit_cycads/hit60/ mafft_cycads/hit60/ ref_separate_genes/Zamia_furfuracea/ _Zamia_furfuracea.fasta
...
python mafft_noadd.py hit_cycads/hit100/ mafft_cycads/hit100/ ref_separate_genes/Zamia_furfuracea/ _Zamia_furfuracea.fasta
```

3. retain consensus without degenerate bases and with most ATGC<br />
```
python retain_consensus_without_degenerate_bases_and_with_most_ATGC.py mafft_cycads consensus_cycads
```

4. add outgroups and remove duplicated sequences<br />
```
perl combine_files.pl -i db_coding -m .fasta -o db_coding.fasta
```

5. generate gene matrix and alignment<br />
```
perl extract_filenames.pl -i db_coding -m .fasta -p N -o genename_coding.txt
perl generate_gene_matrix_from_one_fasta_file.pl -f db_coding.fasta -g genename_coding.txt -o input_coding
python run_mafft.py input_coding alignment_coding
```
