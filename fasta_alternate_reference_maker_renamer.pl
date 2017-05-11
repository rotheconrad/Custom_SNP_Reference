#!/usr/bin/perl -w

$usage = "perl <name_of_script> <name_of_file_to_look_through>";

# This script is designed to look throuht the output of GATK's fasta_alternare_reference_maker
# and change the names back to the original names in for each scaffold.   

$fastafile = $ARGV[0];

open IN, "<$fastafile" or die "\n\n$fastafile not found program terminated\n\nusage: $usage\n\n";
open OUT, ">$fastafile.renamed";

while (<IN>)
	{	$line =$_;
		if ($line =~ /^>(\S+)\s+(\S+):\d+/)
			{	print OUT ">$2\n";	}
		else {	print OUT "$line";	}
	}
	
close IN;
close OUT;
