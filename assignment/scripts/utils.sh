# count the number of reads in the fasta file
function count_fastq_reads {
    fastq_file=$1
    cat $fastq_file | grep "^@" | wc -l
} 

