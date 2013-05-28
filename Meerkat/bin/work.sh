qsub meerkat.sh
awk '$2!~/TEI/ && $NP~/TE/' ../input/bam/HEG4.merge.variants | less -S
awk '$2!~/TEI/ && $NP~/TE/' ../input/bam/HEG4.merge.variants | sort -k1,1 -k6,6 -k7,7n | less -S
awk '$2!~/TEI/ && $NP~/TE/' ../input/bam/HEG4.merge.variants.filtered | sort -k1,1 -k6,6 -k7,7n > ../input/bam/HEG4.merge.variants.filtered.TEass.txt


