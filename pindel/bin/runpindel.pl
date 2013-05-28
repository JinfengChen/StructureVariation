#!/usr/bin/perl
use Getopt::Long;

GetOptions (\%opt,"bam:s","help");


my $help=<<USAGE;
perl $0 --bam
Prepare shell for pindel run on biocluster using pbs. After this script, run "qsub -q js pindel.sh".
--bam: dir of bam file to run, bam should be indexed using samtools
Note that BP is breakpoints file for which one breakpoints is not known and LI is long insertion which two breakpoint are determined but the length and insertion sequence was not known. So these kind of thing can not be usd in drawing statistic figure, but need to investigate in detail.
USAGE


if ($opt{help} or keys %opt < 0){
    print "$help\n";
    exit();
}

$opt{bam} ||= "../input";
config() unless (-e "pindel.config");

###-c ALLmeans to run all chromosome
###-T 12 means using 12 cpus
###-x 5  means detect SV < 32,000 bp,6=129,472, see pindel options
###-v 50 means report inversion > 50 bp, see pindel options
my $Shell=<<CMD;
#!/bin/sh
#PBS -l nodes=1:ppn=16
#PBS -l mem=10gb
#PBS -l walltime=100:00:00

cd \$PBS_O_WORKDIR

date

/opt/pindel/0.2.4o/bin/pindel -T 16 -c ALL -f /rhome/cjinfeng/HEG4_cjinfeng/seqlib/MSU_r7.fa -o HEG4.pindel -i pindel.config -x 6 -v 50
/rhome/cjinfeng/software/tools/SVcaller/pindel/pindel2vcf -P HEG4.pindel -r /rhome/cjinfeng/HEG4_cjinfeng/seqlib/MSU_r7.fa -R MSU7 -d 2013 -v HEG4.pindel.vcf
date
echo "Done"

CMD


open OUT, ">pindel.sh" or die "$!";
     print OUT "$Shell\n";
close OUT;


sub config
{
my @bam=glob("$opt{bam}/*.bam");
open OUT, ">pindel.config" or die "$!";
for(my $i=0;$i<@bam;$i++){
   print OUT "$bam[$i]\t500\tHEG4_500\n";
}
close OUT;
} 
