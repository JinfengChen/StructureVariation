echo ">> Converting output to TABLE"
if [ $# -lt 2 ]
then
        echo "Usage: $0 <meerkat.variants.filtered> <meerkat.table>"
        exit 1
fi

minsize=50
awkopt='
{
        feat=$1;
        if ($1!="transl_inter"){
           if ($1~/ins/){
              feat="Insertion";
           }else if ($1~/del/){
              feat="Deletion";
           }else if ($1~/inv/){
              feat="Inversion";
           }else if ($1~/tandem/){
              feat="Tamdem";
           }
           if ($7 > $8){
              tmp=$7;
              $7=$8;
              $8=tmp;
           }
           if ($9 < 500000 && feat!="Tamdem" && feat!="Inversion"){
              if ($10~/Chr/){
                  print $6"\t"$7"\t"$8"\t"$10"\t"$11"\t"$12;
              }else{
                  print $6"\t"$7"\t"$8;
              }
           }
        }
       
}'

#grep -v '\#' $1 | awk "$awkopt" | sort -k1,1 -k4n -k5n -u > $2
grep -v '\#' $1 | awk "$awkopt" | sort -k1,1 -k2n > $2

echo "*** Finished Calling SV using Read-Pair Mapping ***"


