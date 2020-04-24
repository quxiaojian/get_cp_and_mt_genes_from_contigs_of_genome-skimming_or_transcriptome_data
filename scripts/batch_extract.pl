#!/usr/bin/perl -w
use strict;
use Getopt::Long;
#use Data::Dump;
$|=1;

my $global_options=&argument();
my $min=&default("60","min");
my $max=&default("100","max");
my $step=&default("1","step");
my $clade=&default("ginkgo","clade");
my $outdir=&default("hit","outdir");
my $outfile=&default("batch_extract.sh","outfile");
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
	print $output "perl extract_blast_hits_from_trinity_contigs.pl -r reference/$clade -t trinity/$clade -s $i -l 60 -e 1e-25 -n 2 -o $outdir\_$clade/hit$i\n";
	close $output;
}
#extract_blast_hits_from_trinity_contigs.pl -r t [-s -l -e -n -o]

#function
sub argument{
	my @options=("help|h","min|i:i","max|a:i","step|s:s","clade|c:s","outdir|d:s","outfile|f:s");
	my %options;
	GetOptions(\%options,@options);
	exec ("pod2usage $0") if ((keys %options)==0 or $options{'help'});
	if(!exists $options{'min'}){
		print "***ERROR: No min similarity value are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif (!exists $options{'max'}) {
		print "***ERROR: No max similarity value are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif (!exists $options{'step'}) {
		print "***ERROR: No step value are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif (!exists $options{'clade'}) {
		print "***ERROR: No clade name are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'outdir'}){
		print "***ERROR: No output directory are assigned!!!\n";
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

    batch_extract.pl

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

    batch extract.

=head1 SYNOPSIS

    batch_extract.pl -i -a -s -c -d -f
    Copyright (C) 2018 Xiao-Jian Qu
    Please contact me <quxiaojian@mail.kib.ac.cn>, if you have any bugs or questions.

    [-h -help]           help information.
    [-i -min]            min similarity value (default: 80).
    [-a -max]            max similarity value (default: 100).
    [-s -step]           step value (default: 0.1).
    [-c -clade]          clade name (default: ginkgo).
    [-d -outdir]         output directory name (default: hit).
    [-f -outfile]        output file name (default: batch_extract.sh).

=cut
