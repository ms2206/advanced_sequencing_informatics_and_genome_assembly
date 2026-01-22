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
 
# calculate read length from fastq file
function calculate_read_length {
    fastq_file=$1
    read_len=$(zcat $fastq_file | awk 'NR % 4 == 2' | head -n1 | awk '{print length}')
    echo $read_len
}

# count the number of reads in the fastq file not zipped
function unziped_count_fastq_reads {
    fastq_file=$1
    cat $fastq_file | grep "^@" | wc -l
} 

# count the number of bases in the fastq file not zipped
function unziped_count_fastq_bases {
    fastq_file=$1
    cat $fastq_file | grep -v "^@\|+" | awk '{if(NR%2==1) {print}}' | awk '{total += length($1)} END {print "Sum: "total}'
}
 
# calculate read length from fastq file not zipped
function unziped_calculate_read_length {
    fastq_file=$1
    read_len=$(cat $fastq_file | awk 'NR % 4 == 2' | head -n1 | awk '{print length}')
    echo $read_len
}

# calculate the number of reads in fastq with a length greater than a specified threshold
function count_reads_above_length {
    fastq_file=$1
    length_threshold=$2
    count=$(zcat $fastq_file | awk 'NR % 4 == 2' | awk '{print length($0)}' | awk -v threshold=$length_threshold '$1 > threshold' | wc -l)
}