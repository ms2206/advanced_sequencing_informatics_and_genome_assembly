# count the number of reads in the fastq file
function count_fastq_reads {
    fastq_file=$1
    zcat $fastq_file | grep "^@" | wc -l
} 

# count the number of bases in the fastq file
function count_fastq_bases {
    fastq_file=$1
    zcat $fastq_file | grep -v "^@\|+" | awk '{if(NR%2==1) {print}}' | awk '{total += length($1)} END {print "Sum: "total}'
}
 
