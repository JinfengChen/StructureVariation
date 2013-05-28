#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=10gb
#PBS -l walltime=100:00:00


export ROOTSYS=/rhome/cjinfeng/software/tools/SVcaller/ROOT/root
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${ROOTSYS}/lib

reference=../input/MSU_r7.fa
bam=../input/HEG4_2.3.MSU7_BWA.bam
output=HEG4.CNVnator.out
#vcf=HEG4.CNVnator.vcf
gff=HEG4.CNVnator.gff

cd $PBS_O_WORKDIR
date
echo "Prepare reference and bam for CNVnator, as they prefer Chr to be chr"
if [ ! -e $reference.1.fa ]; then
sed 's/Chr/chr/' $reference > $reference.1.fa
fi
if [ ! -e $bam.1.bam ]; then
samtools view -h $bam | sed 's/Chr/chr/' | samtools view -bS -o $bam.1.bam -
fi
date
perl run_cnvnator_on_assembly.pl $reference.1.fa $bam.1.bam $output ./ /rhome/cjinfeng/software/tools/SVcaller/CNVnator_v0.2.7/ 100
#perl /rhome/cjinfeng/software/tools/SVcaller/CNVnator_v0.2.7/cnvnator2VCF.pl $output > $output.vcf
cat $output | sed '{s/chr/Chr/}' > $output.tmp
bash cnvnator2GFF.sh $output.tmp $gff
date
echo "Done"

