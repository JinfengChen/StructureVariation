echo ">> Converting output to GFF"
if [ $# -lt 2 ]
then
        echo "Usage: $0 <breakdancer.out> <breakdancer.gff>"
        exit 1
fi

minsize=50
awkopt='
{
        size=$8; 
        start=($2<=$5?$2:$5);
        end=($5>=$2?$5:$2);
        tx="";
        if (size<0 && $7=="INS") 
                size=-size; 
        feat=$7; 
        if ($7=="DEL") 
                feat="Deletion"; 
        else if ($7=="INS") 
                feat="Insertion"; 
        else if ($7=="INV") 
                feat="Inversion";
        else if ($7=="ITX" || $7=="CTX") {
                feat="Translocation";
                start=$2;
                end=$2;
                size=-1;
                tx=";TX "$7";TCHR "$4";TSTART "$5
        }
        if (($7!="CTX" && $1==$4) || ($7=="CTX")) {
                if (size>='$minsize') 
                        print $1"\tBreakDancer\t"feat"\t"start"\t"end"\t.\t.\t.\tSize "size tx;
        }
}'

grep -v '\#' $1 | awk "$awkopt" | sort -k1,1 -k4n -k5n -u > $2

echo "*** Finished Calling SV using Read-Pair Mapping ***"


