#!/usr/bin/perl -w
use strict;
use Getopt::Long;
#use Data::Dump;
$|=1;

my $global_options=&argument();
my $indir=&default("hit","indir");
my $outdir=&default("mafft","outdir");
my $clade=&default("ginkgo","clade");
my $refdir=&default("ref_separate_genes","refdir");
my $match=&default("_species_name.fasta","match");
my $min=&default("60","min");
my $max=&default("100","max");
my $step=&default("1","step");
my $outfile=&default("batch_mafft.sh","outfile");

my $osname=$^O;
if ($osname eq "MSWin32") {
	system("del/f/s/q $outdir\_$clade") if (-e "$outdir\_$clade");
	system("del/f/s/q $outfile") if (-e $outfile);
	system("mkdir $outdir\_$clade") if (!-e "$outdir\_$clade");
}elsif ($osname eq "cygwin") {
	system("rm -rf $outdir\_$clade") if (-e "$outdir\_$clade");
	system("rm $outfile") if (-e $outfile);
	system("mkdir $outdir\_$clade") if (!-e "$outdir\_$clade");
}elsif ($osname eq "linux") {
	system("rm -rf $outdir\_$clade") if (-e "$outdir\_$clade");
	system("rm $outfile") if (-e $outfile);
	system("mkdir $outdir\_$clade") if (!-e "$outdir\_$clade");
}elsif ($osname eq "darwin") {
	system("rm -rf $outdir\_$clade") if (-e "$outdir\_$clade");
	system("rm $outfile") if (-e $outfile);
	system("mkdir $outdir\_$clade") if (!-e "$outdir\_$clade");
}

for (my $i=$min;$i<=$max;$i+=$step) {
	$i=eval($i);
	open(my $output, ">>", $outfile);
	print $output "python mafft_noadd.py $indir/hit",$i,"/ $outdir\_$clade/hit",$i,"/ $refdir/ ",$match,"\n";
	close $output;
}
#python mafft_noadd.py hit_cycads/hit60/ mafft/cycads/hit60/ ref_separate_genes/ _Zamia_furfuracea.fasta

#function
sub argument{
	my @options=("help|h","indir|i:s","outdir|o:s","clade|c:s","refdir|r:s","match|m:s","min|n:i","max|x:i","step|s:s","outfile|f:s");
	my %options;
	GetOptions(\%options,@options);
	exec ("pod2usage $0") if ((keys %options)==0 or $options{'help'});
	if(!exists $options{'indir'}){
		print "***ERROR: No input directory are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'outdir'}){
		print "***ERROR: No output directory are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif (!exists $options{'clade'}) {
		print "***ERROR: No clade name are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'refdir'}){
		print "***ERROR: No reference directory are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'match'}){
		print "***ERROR: No match pattern are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'min'}){
		print "***ERROR: No min similarity value are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif (!exists $options{'max'}) {
		print "***ERROR: No max similarity value are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif (!exists $options{'step'}) {
		print "***ERROR: No step value are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif (!exists $options{'outfile'}) {
		print "***ERROR: No output filename are assigned!!!\n";
		exec ("pod2usage $0");
	}
	return \%options;
}

sub default{
	my ($default_value,$option)=@_;
	if(exists $global_options->{$option}){
		return $global_options->{$option};
	}
	return $default_value;
}


__DATA__

=head1 NAME

    batch_mafft.pl

=head1 COPYRIGHT

    copyright (C) 2018 Xiao-Jian Qu

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

=head1 DESCRIPTION

    batch mafft

=head1 SYNOPSIS

    batch_extract.pl -i -o -c -r -m -n -x -s -f
    Copyright (C) 2018 Xiao-Jian Qu
    Please contact me <quxiaojian@mail.kib.ac.cn>, if you have any bugs or questions.

    [-h -help]           help information.
    [-i -indir]          input directory name (default: hit).
    [-o -outdir]         output directory name (default: mafft).
    [-c -clade]          clade name (default: ginkgo).
    [-r -refdir]         reference directory name (default: ref_separate_genes).
    [-m -match]          match pattern of reference genes (default: _species_name.fasta).
    [-n -min]            min similarity value (default: 60).
    [-x -max]            max similarity value (default: 100).
    [-s -step]           step value (default: 1).
    [-f -outfile]        output file name (default: batch_mafft.sh).

=cut
