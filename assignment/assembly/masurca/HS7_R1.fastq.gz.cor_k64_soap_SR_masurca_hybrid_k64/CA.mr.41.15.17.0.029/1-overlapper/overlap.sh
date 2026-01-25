#!/bin/sh

perl='/usr/bin/env perl'

jobid=$SGE_TASK_ID
if [ x$jobid = x -o x$jobid = xundefined -o x$jobid = x0 ]; then
  jobid=$1
fi
if [ x$jobid = x ]; then
  echo Error: I need SGE_TASK_ID set, or a job index on the command line.
  exit 1
fi

bat=`head -n $jobid /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/1-overlapper/ovlbat | tail -n 1`
job=`head -n $jobid /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/1-overlapper/ovljob | tail -n 1`
opt=`head -n $jobid /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/1-overlapper/ovlopt | tail -n 1`
jid=$$

if [ ! -d /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/1-overlapper/$bat ]; then
  mkdir /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/1-overlapper/$bat
fi

if [ -e /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/1-overlapper/$bat/$job.ovb.gz ]; then
  echo Job previously completed successfully.
  exit
fi

if [ x$bat = x ]; then
  echo Error: Job index out of range.
  exit 1
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

$bin/overlapInCore  --hashbits 22 --hashload 0.75 -t 2 \
  $opt \
  -k 22 \
  -k /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/0-mercounts/genome.nmers.ovl.fasta \
  -o /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/1-overlapper/$bat/$job.ovb.WORKING.gz \
  /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/genome.gkpStore \
&& \
mv /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/1-overlapper/$bat/$job.ovb.WORKING.gz /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/1-overlapper/$bat/$job.ovb.gz

exit 0
