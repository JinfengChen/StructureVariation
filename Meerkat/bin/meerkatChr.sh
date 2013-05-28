#!/bin/sh
#PBS -t 1-12
#PBS -l walltime=100:00:00

export LD_LIBRARY_PATH=/rhome/cjinfeng/software/tools/SVcaller/Meerkat/src/mybamtools/lib:${LD_LIBRARY_PATH}:${ROOTSYS}/lib
export PERL5LIB=/rhome/cjinfeng/software/tools/Perl_lib/lib/perl5/x86_64-linux-gnu-thread-multi:$PERL5LIB
cd $PBS_O_WORKDIR

echo "is: extract unmapped, clipped reads"
perl /rhome/cjinfeng/software/tools/SVcaller/Meerkat/scripts/pre_process.pl -b /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/bam/HEG4.MSU7_BWA.Chr$PBS_ARRAYID.bam -I /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/reference/MSU7_bwa_idx/MSU_r7.fa -A /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/reference/MSU_r7.fa.fai -S /opt/samtools/0.1.18/bin/ -W /opt/bwa/0.6.2/bin/ -P is 

echo "cl:map soft clipped reads"
perl /rhome/cjinfeng/software/tools/SVcaller/Meerkat/scripts/pre_process.pl -b /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/bam/HEG4.MSU7_BWA.Chr$PBS_ARRAYID.bam -I /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/reference/MSU7_bwa_idx/MSU_r7.fa -A /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/reference/MSU_r7.fa.fai -S /opt/samtools/0.1.18/bin/ -W /opt/bwa/0.6.2/bin/ -P cl


echo "meerkat"
perl /rhome/cjinfeng/software/tools/SVcaller/Meerkat/scripts/meerkat.pl -b /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/bam/HEG4.MSU7_BWA.Chr$PBS_ARRAYID.bam -F /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/reference/MSU7_fasta/ -S /opt/samtools/0.1.18/bin/ -W /opt/bwa/0.6.2/bin/ -B /usr/bin/ 

echo "mechanism classify"
perl /rhome/cjinfeng/software/tools/SVcaller/Meerkat/scripts/mechanism.pl -b /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/bam/HEG4.MSU7_BWA.Chr$PBS_ARRAYID.bam -R /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/reference/rmsk-MSU7.txt 

echo "filter variant"
perl /rhome/cjinfeng/software/tools/SVcaller/Meerkat/scripts/filter_normal.pl -i /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/bam/HEG4.MSU7_BWA.Chr$PBS_ARRAYID.variants -o /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/bam/HEG4.MSU7_BWA.Chr$PBS_ARRAYID.variants.filtered -R /rhome/cjinfeng/HEG4_cjinfeng/Variations/SV/Meerkat/input/reference/rmsk-MSU7.txt

echo "Done"
 
