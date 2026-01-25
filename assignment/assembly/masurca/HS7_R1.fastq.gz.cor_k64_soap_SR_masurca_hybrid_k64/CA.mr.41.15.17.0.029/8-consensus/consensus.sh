#!/bin/sh

jobid=$SGE_TASK_ID
if [ x$jobid = x -o x$jobid = xundefined -o x$jobid = x0 ]; then
  jobid=$1
fi
if [ x$jobid = x ]; then
  echo Error: I need SGE_TASK_ID set, or a job index on the command line.
  exit 1
fi
if [ $jobid -gt 2 ]; then
  echo Error: Only 2 partitions, you asked for $jobid.
  exit 1
fi

jobid=`printf %03d $jobid`

if [ -e /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/8-consensus/genome_$jobid.success ] ; then
  exit 0
fi

AS_OVL_ERROR_RATE=0.1
AS_CNS_ERROR_RATE=0.1
AS_CGW_ERROR_RATE=0.15
AS_OVERLAP_MIN_LEN=250
AS_READ_MIN_LEN=64
export AS_OVL_ERROR_RATE AS_CNS_ERROR_RATE AS_CGW_ERROR_RATE AS_OVERLAP_MIN_LEN AS_READ_MIN_LEN

syst=`uname -s`
arch=`uname -m`
name=`uname -n`

if [ "$arch" = "x86_64" ] ; then
  arch="amd64"
fi
if [ "$arch" = "Power Macintosh" ] ; then
  arch="ppc"
fi

bin="/MaSuRCA-3.2.7/CA8/$syst-$arch/bin"

$bin/ctgcns \
  -g /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/genome.gkpStore \
  -t /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/genome.tigStore 11 $jobid \
  -P 0 \
  -U \
 > /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/8-consensus/genome_$jobid.err 2>&1 \
&& \
touch /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/8-consensus/genome_$jobid.success
exit 0
