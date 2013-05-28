#!/bin/sh
#PBS -t 1-12
#PBS -l walltime=100:00:00

export ROOTSYS=/rhome/cjinfeng/software/tools/SVcaller/ROOT/root
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ROOTSYS}/lib

reference=../input/MSU_r7.fa

cd $PBS_O_WORKDIR
date
echo "Prepare reference and bam for CNVnator, as they prefer Chr to be chr"
if [ ! -e $reference.1.fa ]; then
sed 's/Chr/chr/' $reference > $reference.1.fa
fi
if [ ! -e ../input/HEG4.MSU7_BWA.Chr$PBS_ARRAYID.1.bam ]; then
samtools view -h ../input/HEG4.MSU7_BWA.Chr$PBS_ARRAYID.bam | sed 's/Chr/chr/' | samtools view -bS -o ../input/HEG4.MSU7_BWA.Chr$PBS_ARRAYID.1.bam -
fi
date
perl run_cnvnator_on_assembly.pl $reference.1.fa ../input/HEG4.MSU7_BWA.Chr$PBS_ARRAYID.1.bam HEG4.MSU7_BWA.Chr$PBS_ARRAYID.1.CNVnator.out ./ /rhome/cjinfeng/software/tools/SVcaller/CNVnator_v0.2.7/ 100
cat *.CNVnator.out | sed '{s/chr/Chr/}' > HEG4.MSU7_BWA.CNVnator.out
perl /rhome/cjinfeng/software/tools/SVcaller/CNVnator_v0.2.7/cnvnator2VCF.pl HEG4.MSU7_BWA.CNVnator.out > HEG4.MSU7_BWA.CNVnator.vcf
bash cnvnator2GFF.sh HEG4.MSU7_BWA.CNVnator.out HEG4.MSU7_BWA.CNVnator.gff
date
echo "Done"

