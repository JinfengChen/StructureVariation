echo "indel bam"
cd ../input
qsub indexbam.sh

echo "generate config and shell for pbs"
perl runpindel.pl

echo "modify pindel.config if need"

echo "run pindel"
qsub pindel.sh

echo "convert GFF"
bash pindel2GFF.sh HEG4.pindel HEG4.pindel.gff


