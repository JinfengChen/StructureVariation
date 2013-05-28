#!/bin/sh
#PBS -l nodes=1:ppn=12
#PBS -l mem=10gb
#PBS -l walltime=100:00:00

cd $PBS_O_WORKDIR

date

/opt/pindel/0.2.4o/bin/pindel -T 12 -c ALL -f /rhome/cjinfeng/HEG4_cjinfeng/seqlib/MSU_r7.fa -o HEG4.pindel -i pindel.config -x 6 -v 50
/rhome/cjinfeng/software/tools/SVcaller/pindel/pindel2vcf -P HEG4.pindel -r /rhome/cjinfeng/HEG4_cjinfeng/seqlib/MSU_r7.fa -R MSU7 -d 2013 -v HEG4.pindel.vcf
date
echo "Done"


