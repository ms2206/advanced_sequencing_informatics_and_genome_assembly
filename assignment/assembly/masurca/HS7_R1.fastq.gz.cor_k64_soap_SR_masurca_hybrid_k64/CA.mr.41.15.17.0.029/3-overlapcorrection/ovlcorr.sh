jobid=$SGE_TASK_ID
if [ x$jobid = x -o x$jobid = xundefined -o x$jobid = x0 ]; then
  jobid=$1
fi
if [ x$jobid = x ]; then
  echo Error: I need SGE_TASK_ID set, or a job index on the command line.
  exit 1
fi

if [ $jobid -gt 1 ] ; then
  exit
fi

jobid=`printf %04d $jobid`
frgBeg=`expr $jobid \* 100000 - 100000 + 1`
frgEnd=`expr $jobid \* 100000`
if [ $frgEnd -ge 11671 ] ; then
  frgEnd=11671
fi
frgBeg=`printf %08d $frgBeg`
frgEnd=`printf %08d $frgEnd`

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

if [ ! -e /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/3-overlapcorrection/$jobid.erate ] ; then
  $bin/correct-olaps \
    -S /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/genome.ovlStore \
    -e /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/3-overlapcorrection/$jobid.erate.WORKING \
    /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/genome.gkpStore \
    /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/3-overlapcorrection/genome.frgcorr \
    $frgBeg $frgEnd \
  &&  \
  mv /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/3-overlapcorrection/$jobid.erate.WORKING /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/assembly/masurca/HS7_R1.fastq.gz.cor_k64_soap_SR_masurca_hybrid_k64/CA.mr.41.15.17.0.029/3-overlapcorrection/$jobid.erate
fi
