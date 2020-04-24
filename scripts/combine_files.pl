#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Find;
use Data::Dumper;
$|=1;

my $global_options=&argument();
my $indir=&default("input","indir");
my $match=&default(".fasta","match");
my $outfile=&default("db.fasta","outfile");

my @filenames;
find(\&target,$indir);
sub target{
    if (/$match/){
        push @filenames,"$File::Find::name";
    }
    return;
}

open (my $output,">>",$outfile);
foreach my $name (@filenames) {
	open(my $input,"<",$name);
	while (<$input>) {
		print $output $_;
	}
}
close $output;


sub argument{
	my @options=("help|h","indir|i:s","match|m:s","path|p:s","outfile|o:s");
	my %options;
	GetOptions(\%options,@options);
	exec ("pod2usage $0") if ((keys %options)==0 or $options{'help'});
	if(!exists $options{'indir'}){
		print "***ERROR: No input directory are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'match'}){
		print "***ERROR: No match are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'outfile'}){
		print "***ERROR: No output file name are assigned!!!\n";
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

    combine_files.pl

=head1 COPYRIGHT

    copyright (C) 2016 Xiao-Jian Qu

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

    combine_files

=head1 SYNOPSIS

    combine_files.pl -i -m -o
    Copyright (C) 2016 Xiao-Jian Qu
    Please contact me <quxiaojian@mail.kib.ac.cn>, if you have any bugs or questions.

    [-h -help]           help information.
    [-i -indir]          input directory (default: input).
    [-m -match]          match pattern for your filename (default: .fasta).
    [-o -outfile]        name of output file (default: filename.fasta).

=cut
