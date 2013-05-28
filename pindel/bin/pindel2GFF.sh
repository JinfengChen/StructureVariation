echo ">> Converting output to GFF"
if [ $# -lt 2 ]
then
        echo "Usage: $0 <prefix> <pindel.gff>"
        exit 1
fi

minsize=50

AWKOPT='{feat="Unknown"; if ($2=="D" || $2=="DI") feat="Deletion"; else if ($2=="I" || $2=="LI") feat="Insertion"; else if ($2=="INV") feat="Inversion"; else if ($2=="TD") feat="TandemDup"; start=$7; end=$8; if (feat!="Insertion") {start++; end--;} if ($3>='$minsize') print $5"\tPindel\t"feat"\t"start"\t"end"\t.\t.\t.\tSize "$3};'

for po in $1_[^LBT]*
do
	grep "ChrID" $po | sed 's/D \([0-9]*\)	I \([0-9]*\)/DI \1:\2/' | sed 's/S1 \([0-9]*\)	.*/S1 \1/' | sed 's/NT[^	]*//' | awk "$AWKOPT"
done | sort -k1,1 -k4n -k5n -u > $2

#echo ">> Archiving raw output"
#tar --remove-files -zcvf $p.tgz ${p}_*

echo "*** Finished calling SV using Split-Read Analysis: $PINDEL ***"
echo "LI and BP will not be present because of unknown insert size"

