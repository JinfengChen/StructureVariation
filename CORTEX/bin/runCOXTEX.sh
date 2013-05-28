#!/bin/sh
#PBS -l nodes=1:ppn=1
#PBS -l mem=100gb
#PBS -l walltime=200:00:00

cd $PBS_O_WORKDIR
script=/rhome/cjinfeng/software/tools/SVcaller/CORTEX_release_v1.0.5.15/scripts/calling/
reflist=./reference.falist
refseq=MSU_r7.fa
gsize=372000000
fastqindex=INDEX
stampyhash=ref
outvcf=test

date

echo "####build reference genome binaries, 2^23*100=800,000,000"
height=23
width=100
cortex31=/rhome/cjinfeng/software/tools/SVcaller/CORTEX_release_v1.0.5.15/bin/cortex_var_31_c1
cortex63=/rhome/cjinfeng/software/tools/SVcaller/CORTEX_release_v1.0.5.15/bin/cortex_var_63_c1
if [ ! -e ref.k31.ctx ]; then
echo "###Kmer31"
$cortex31 --kmer_size 31 --mem_height $height --mem_width $width --se_list $reflist --max_read_len 10000 --dump_binary ref.k31.ctx --sample_id REF
fi
if [ ! -e ref.k61.ctx ]; then
echo "###Kmer61"
$cortex63 --kmer_size 61 --mem_height $height --mem_width $width --se_list $reflist --max_read_len 10000 --dump_binary ref.k61.ctx --sample_id REF
fi

if [ ! -e ref.sthash ]; then
echo "###build stampy hash of the genome"
/opt/stampy/1.0.21-py2.7/stampy.py -G ref $refseq
/opt/stampy/1.0.21-py2.7/stampy.py -g ref -H ref
fi

if [ ! -d vcfs ]; then

echo "###run calls"

`perl $script/run_calls.pl --first_kmer 31\
   --last_kmer 61\
   --kmer_step 30\
   --fastaq_index $fastqindex --auto_cleaning yes\
   --bc yes --pd no\
   --outdir ./\
   --outvcf $outvcf\
   --ploidy 2\
   --stampy_hash $stampyhash\
   --stampy_bin /opt/stampy/1.0.21-py2.7/stampy.py\
   --list_ref_fasta $reflist\
   --refbindir ./\
   --genome_size $gsize\
   --qthresh 5\
   --mem_height $height --mem_width $width\
   --vcftools_dir /rhome/cjinfeng/software/tools/SVcaller/vcftools_0.1.10/\
   --do_union yes\
   --ref CoordinatesAndInCalling\
   --workflow independent\
   --logfile logfile log.txt`

fi

date

echo "Done"

