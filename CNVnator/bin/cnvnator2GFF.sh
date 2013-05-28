echo ">> Converting output to GFF"
if [ $# -lt 2 ]
then
        echo "Usage: $0 <CNVnator.out> <CNVnator.gff>"
        exit 1
fi

minsize=50
awkopt='{feat=$4; if ($4=="deletion") feat="Deletion"; else if ($4=="duplication") feat="Duplication"; if ($5>='$minsize') print $1"\tCNVnator\t"feat"\t"$2"\t"$3"\t.\t.\t.\tSize "$5";RD "$6};'

cut -f 1,2,3,4 $1 | sed 's/\(.*\)	\(.*\):\(.*\)-\(.*\)	\(.*\)	\(.*\)/\2	\3	\4	\1	\5	\6/' | awk "$awkopt" | sort -k1,1 -k4n -k5n -u | sed '{s/chr/Chr/}' > $2

echo "*** Finished CNV Calling using Read-Depth Analysis"

