#!/usr/bin/perl -w
# comparedirs.pl
# 	Compare files from source with dest and show what files are missing.

use strict;
use Getopt::Long;

## Global variables
my ($o_verb, $o_help, $o_source, $o_dest);

## Funtions
sub check_options {
	Getopt::Long::Configure ("bundling");
	GetOptions(
		'v'     => \$o_verb,            'verbose'	=> \$o_verb,
		'h'     => \$o_help,            'help'	=> \$o_help,
		's:s'     => \$o_source,            'source:s'	=> \$o_source,
		'd:s'     => \$o_dest,            'dest:s'	=> \$o_dest,
	);

	if(defined ($o_help)){
		help();
		exit 1;
	}

	if(!defined($o_source) && !defined($o_dest)){
		print "Need to define source (-s) and destination (-d) directories\n";
		exit;
	}
}

sub help() {
	print "$0\n";
        print <<EOT;
-v, --verbose
        print extra debugging information
-h, --help
	print this help message
-s, --source=dir
	Source directory
-d, --dest=dir
	Destination directory
EOT
}

sub print_usage() {
        print "Usage: $0 [-v] -s dir -d dir]\n";
}

## Main
check_options();

my $cmd = "cd $o_source ; /usr/bin/find * -type f";
open(F, "$cmd|");
while(<F>){
	chomp($_);
	my $dst_file = $o_dest."/".$_;
	if(!-e $dst_file){
		print "File not found ".$_." in (".$dst_file.")\n";
	}
}
close(F);
