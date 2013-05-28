echo "prepare input file of reference genome sequence and individaul Single or Pair-end reads"
ln -s /rhome/cjinfeng/Rice/HEG4_clean_reads/HEG4_2.1_pair1.cor.fastq ./
ln -s /rhome/cjinfeng/Rice/HEG4_clean_reads/HEG4_2.1_pair2.cor.fastq ./
ln -s /rhome/cjinfeng/HEG4_cjinfeng/seqlib/MSU_r7.fa ./

ls `pwd`/MSU_r7.fa | sed 's/@//' > reference.falist
ls `pwd`/HEG4_2.1_pair1* | sed 's/@//' > read_pe1
ls `pwd`/HEG4_2.1_pair2* | sed 's/@//' > read_pe2
echo -e "HEG4\t.\tread_pe1\tread_pe2" > INDEX


#echo "build reference genome binaries"
#cortex31=/rhome/cjinfeng/software/tools/SVcaller/CORTEX_release_v1.0.5.15/bin/cortex_var_31_c1
#cortex63=/rhome/cjinfeng/software/tools/SVcaller/CORTEX_release_v1.0.5.15/bin/cortex_var_63_c1
#$cortex31 --kmer_size 31 --mem_height 17 --mem_width 100 --se_list reference.falist --max_read_len 10000 --dump_binary ref.k31.ctx --sample_id REF
#$cortex63 --kmer_size 61 --mem_height 17 --mem_width 100 --se_list reference.falist --max_read_len 10000 --dump_binary ref.k61.ctx --sample_id REF

#echo "build stampy hash of the genome"
#/opt/stampy/1.0.21-py2.7/stampy.py -G ref MSU_r7.fa
#/opt/stampy/1.0.21-py2.7/stampy.py -g ref -H ref

#echo "run SV call"
#qsub runCOXTEX.sh

