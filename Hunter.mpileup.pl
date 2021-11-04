#!/usr/bin/env perl

use strict;
use warnings;

my $InputVariants = $ARGV[0];
my $InputBam = $ARGV[1];
my $Output = $ARGV[2];

open (LOGOUTPUT, ">", "$Output");
open (LOG, "$InputVariants") || die "Could not open input file";

<LOG>; # Skip header line

print LOGOUTPUT "Chr\tStart\tRef\tMut\tTotal_Depth\tRef_Depth\tAlt_Depth\tmpileup_read\n";

while (<LOG>) {
	my @line = split/\t/;
	my $samtoolsoutput = `samtools mpileup -f ../hg38.fa "$InputBam" -r "$line[5]":"$line[6]"-"$line[6]" 2> stderr.txt`;
	chomp $samtoolsoutput;

	my @Pileup = split(/\t/,$samtoolsoutput);
	my @tempsubstring = split(//,$Pileup[4]);

	my $Refcounter = 0;
	my $Mutcounter = 0;
	foreach my $a (@tempsubstring) {
		if (($a =~ m/\./) || ($a =~ m/,/)) {
			$Refcounter++;
			}
		if ($a =~ m/$line[13]/i) {
			$Mutcounter++;
			}		
		}
	# if (($line[6] eq "-") || ($line[7] eq "-") || (length($line[6]) > 1) || (length($line[7]) > 1)) {
		# $Refcounter = "Manually Inspect";
		# $Mutcounter = "Manually Inspect";
		# }
	print LOGOUTPUT "$line[5]\t$line[6]\t$line[12]\t$line[13]\t$Pileup[3]\t$Refcounter\t$Mutcounter\t$Pileup[4]\n";
	}
close (LOG);
close (LOGOUTPUT);
