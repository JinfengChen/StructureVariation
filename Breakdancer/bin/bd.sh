#!/bin/sh
#PBS -l nodes=1:ppn=12
#PBS -l mem=10gb
#PBS -t 1-12
#PBS -l walltime=100:00:00

NUM=12

cd $PBS_O_WORKDIR

date
if [ ! -e HEG4.config ]; then
echo "Config"
/rhome/cjinfeng/software/tools/SVcaller/breakdancer-1.1.2/bin/bam2cfg.pl -c 7 -n 10000 /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/FC52_7.MSU7_BWA.bam.group.bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/FC52_8.MSU7_BWA.bam.group.bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/FC67_1.MSU7_BWA.bam.group.bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/FC67_2.MSU7_BWA.bam.group.bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/FC70_1.MSU7_BWA.bam.group.bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/FC70_2.MSU7_BWA.bam.group.bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/FC70_3.MSU7_BWA.bam.group.bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/HEG4_2.1.MSU7_BWA.bam.group.bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/HEG4_2.2.MSU7_BWA.bam.group.bam /rhome/cjinfeng/HEG4_cjinfeng/MappingReads/bin/MSU7_BWA/Chromosome/HEG4_2.3.MSU7_BWA.bam.group.bam > HEG4.config
fi
date
echo "Max"
/rhome/cjinfeng/software/tools/SVcaller/breakdancer-1.1.2/bin/breakdancer-max -o Chr$PBS_ARRAYID -c 7 -m 1000000 -q 20 HEG4.config > HEG4.Chr$PBS_ARRAYID.max
date
echo "Done"


