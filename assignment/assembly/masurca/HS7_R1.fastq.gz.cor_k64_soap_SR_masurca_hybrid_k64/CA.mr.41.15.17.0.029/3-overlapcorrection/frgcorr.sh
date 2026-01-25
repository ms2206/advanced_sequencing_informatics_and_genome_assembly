#!/bin/sh

jobid=$SGE_TASK_ID
if [ x$jobid = x -o x$jobid = xundefined -o x$jobid = x0 ]; then
  jobid=$1
fi
if [ x$jobid = x ]; then
  echo Error: I need SGE_TASK_ID set, or a job index on the command line.
  exit 1
fi

jobid=`printf %04d $jobid`
minid=`expr $jobid \* 200000 - 200000 + 1`
maxid=`expr $jobid \* 200000`
runid=$$

if [ $maxid -gt 11671 ] ; then
  maxid=11671
fi
if [ $minid -gt $maxid ] ; then
  echo Job partitioning error -- minid=$minid maxid=$maxid.
  exit
fi

AS_OVL_ERROR_RATE=0.1
AS_CNS_ERROR_RATE=0.1
AS_CGW_ERROR_RATE=0.15
AS_OVERLAP_MIN_LEN=250
AS_READ_MIN_LEN=64
export AS_OVL_ERROR_RATE AS_CNS_ERROR_RATE AS_CGW_ERROR_RATE AS_OVERLAP_MIN_LEN AS_READ_MIN_LEN

if [ -e /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/3-overlapcorrection/$jobid.frgcorr ] ; then
  echo Job previously completed successfully.
  exit
fi

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

$bin/correct-frags \
  -t 16 \
  -S /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/genome.ovlStore \
  -o /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/3-overlapcorrection/$jobid.frgcorr.WORKING \
  /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/genome.gkpStore \
  $minid $maxid \
&& \
mv /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/3-overlapcorrection/$jobid.frgcorr.WORKING /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/3-overlapcorrection/$jobid.frgcorr
