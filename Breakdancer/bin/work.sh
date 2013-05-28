echo "run first"
perl runBreakdancer.pl
qsub bd.sh

echo "run by Split Chr"
perl runBreakdancerChr.pl --bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/
qsub bd.sh

echo "run by Multi bam"
perl runBreakdancer.pl --bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome


