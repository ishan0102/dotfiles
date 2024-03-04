stats () {
        if [ $# -eq 0 ]
        then
                awk '{print $0; sum += $NF; squared_sum += $NF * $NF;} END {print "==Stats=="; print "Total:\t" NR; print "Sum:\t" sum; print "Mean:\t" sum / NR; print "Stdev:\t" sqrt(squared_sum / NR - (sum / NR) * (sum / NR));}'
        else
                field=$1 
                awk -v num=$field '{print $0; sum += $num; squared_sum += $num * $num} END {print "==Stats=="; print "Total:\t" NR; print "Sum:\t" sum; print "Mean:\t" sum / NR; print "Stdev:\t" sqrt(squared_sum / NR - (sum / NR) * (sum / NR)); }'
        fi
}