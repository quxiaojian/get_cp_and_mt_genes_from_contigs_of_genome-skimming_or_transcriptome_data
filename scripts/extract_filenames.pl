#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use File::Find;
use Data::Dumper;
$|=1;

my $global_options=&argument();
my $indir=&default("input","indir");
my $match=&default(".fasta","match");
my $path=&default("N","path");
my $outfilename=&default("filename.txt","outfilename");

my @filenames;
find(\&target,$indir);
sub target{
    if (/$match/){
        push @filenames,"$File::Find::name";
    }
    return;
}

open (my $output,">",$outfilename);
my (%hash1, %hash2);
foreach my $name1 (@filenames) {
	$name1=~ s/$match//g;
	$hash1{$name1}++;
	my $name2=substr ($name1,0,rindex($name1,"\/"));#dirname
	my $name3=$name1;
	$name3=~ s/$name2\///;
	$hash2{$name3}++;
}
if ($path eq "N") {
	foreach my $key (sort keys %hash2) {
		print $output "$key\n";
	}
}elsif ($path eq "Y") {
	foreach my $key (sort keys %hash1) {
		print $output "$key\n";
	}
}


sub argument{
	my @options=("help|h","indir|i:s","match|m:s","path|p:s","outfilename|o:s");
	my %options;
	GetOptions(\%options,@options);
	exec ("pod2usage $0") if ((keys %options)==0 or $options{'help'});
	if(!exists $options{'indir'}){
		print "***ERROR: No input directory are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'match'}){
		print "***ERROR: No match are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'path'}){
		print "***ERROR: No path are assigned!!!\n";
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

    extract_filenames.pl

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

    extract filename for multiple files in one directory

=head1 SYNOPSIS

    generate_bash.pl -i
    Copyright (C) 2016 Xiao-Jian Qu
    Please contact me <quxiaojian@mail.kib.ac.cn>, if you have any bugs or questions.

    [-h -help]           help information.
    [-i -indir]          input directory (default: input).
    [-m -match]          match pattern for your filename (default: .fasta).
    [-p -path]           absolute path for your filename (default: N).
    [-o -outfilename]    name of output file (default: filename.txt).

=cut
