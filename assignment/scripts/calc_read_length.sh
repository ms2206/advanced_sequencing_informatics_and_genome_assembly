read_len=$(zcat $1 | awk 'NR % 4 == 2' | head -n1 | awk '{print length}')

echo "Read Length of ${1}: ${read_len}"
