while read line
do
    echo "$line"
    cp $line /out/
done < "${1:-/dev/stdin}"
