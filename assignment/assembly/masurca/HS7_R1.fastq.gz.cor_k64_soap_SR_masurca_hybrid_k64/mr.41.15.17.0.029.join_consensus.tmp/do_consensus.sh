#!/bin/bash
set -o pipefail
if [ ! -e consensus.$1.success ];then
/MaSuRCA-3.2.7/bin/../CA8/Linux-amd64/bin/blasr to_blasr.$1.fa   ref.$1.fa  -nproc 16 -bestn 10 -m 5 2>blasr.err | sort -k6 -S5% | /MaSuRCA-3.2.7/bin/../CA8/Linux-amd64/bin/pbdagcon -j 8 -t 0 -c 1 /dev/stdin  2>pbdagcon.err |tee join_consensus.$1.fasta | /MaSuRCA-3.2.7/bin/nucmer --delta /dev/stdout --maxmatch -l 17 -c 51 -L 200 -t 16 to_join.$1.fa /dev/stdin | /MaSuRCA-3.2.7/bin/filter_delta_file_for_qrys.pl qrys.txt | /MaSuRCA-3.2.7/bin/show-coords -lcHq -I 88 /dev/stdin > coords.$1 && cat coords.$1 | /MaSuRCA-3.2.7/bin/extract_merges_mega-reads.pl join_consensus.$1.fasta  valid_join_pairs.txt > merges.$1.txt && touch consensus.$1.success
fi
