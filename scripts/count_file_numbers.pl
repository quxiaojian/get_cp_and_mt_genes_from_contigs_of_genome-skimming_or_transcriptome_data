#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Cwd "abs_path";
use File::Find;
$|=1;

my $global_options=&argument();
my $path=&default("hit","path");
my $match=&default("hit","match");
my $filenumbers=&default("file_numbers.txt","output");

my @folders;
my $abs_path=abs_path($path);
find(\&target,$abs_path);
sub target{
    if (-d $File::Find::name){
        push @folders,"$File::Find::name";
    }
    return;
}

open(my $output,">",$filenumbers);
foreach my $i (@folders) {
	my $last = substr ($i,rindex($i,"\/")+1);
	if ($last =~ /$match/) {
		print $output "$last\n";
	}elsif ($last !~ /$match/) {
		opendir (my $dir,$i);
		my @filenames=grep{!/^\./}readdir($dir);
		closedir $dir;
		my $cnt = 0;
		foreach my $filename (@filenames) {
			$cnt++;
		}
		print $output "$last\t$cnt\n";
	}
}
close $output;


########################################
##subroutines
########################################

sub argument{
	my @options=("help|h","path|p:s","match|m:s","output|o:s");
	my %options;
	GetOptions(\%options,@options);
	exec ("pod2usage $0") if ((keys %options)==0 or $options{'h'} or $options{'help'});
	if(!exists $options{'path'}){
		print "***ERROR: No path directory is assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'match'}){
		print "***ERROR: No match are assigned!!!\n";
		exec ("pod2usage $0");
	}elsif(!exists $options{'output'}){
		print "***ERROR: No output filename is assigned!!!\n";
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

    count_file_numbers.pl

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

    count_file_numbers

=head1 SYNOPSIS

    count_file_numbers.pl -p -m -o
    Copyright (C) 2018 Xiao-Jian Qu
    Please contact <quxiaojian@mail.kib.ac.cn>, if you have any bugs or questions.

    [-h -help]         help information.
    [-p -path]         required: (default: hit) input path directory.
    [-m -match]        required: (default: hit) match pattern for your directory name.
    [-o -output]       required: (default: file_numbers.txt) output filename for file numbers.

=cut
