#!/usr/bin/perl

use FindBin qw ($Bin);
use Getopt::Long;


GetOptions(\%opt,"help:s");

my $help=<<USAGE;
Get fasta sequences for ids in a list file
perl $0 input_fasta listfile outputdir seqfile > log  

USAGE

if (exists $opt{help} or @ARGV < 4){
   print $help;
   exit;
}

my $input_fasta=$ARGV[0];
my $listfile=$ARGV[1];
my $outputdir=$ARGV[2];
my $seqfile=$ARGV[3];


### store id into hash %id
my %id;
open IN, "$listfile" or die "$!";
while(<IN>){
    chomp $_;
    next if ($_ eq "");
    $id{$_}=1;    
}
close IN;


### read fasta file and output fasta if id is found in list file
$/=">";
open IN,"$input_fasta" or die "$!";
open OUT, ">$outputdir/$seqfile" or die "$!";
while (<IN>){
    next if (length $_ < 2);
    my @unit=split("\n",$_);
    my $head=shift @unit;
    my $seq=join("\n",@unit);
    $seq=~s/\>//g;
    if (exists $id{$head}){
      print OUT ">$head\n$seq\n";
    }
}
close OUT;
close IN;
$/="\n";


