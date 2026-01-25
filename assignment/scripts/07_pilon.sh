#!/bin/bash
# Boilerplate qsub script template
# Version 1.0.0, 17Jan2025
# Matthew Spriggs

# Crescent2 script
# Note: this script should be run on a compute node
# Note: output and error logs will be stored in the logs folder, this folder must exist
# qsub script.sh

# PBS directives
#---------------

#PBS -N pilon
#PBS -l nodes=1:ncpus=4
#PBS -l walltime=00:30:00
#PBS -q half_hour
#PBS -m abe
#PBS -M Matthew.Spriggs.452@cranfield.ac.uk
#PBS -o /mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/logs

#===============
#PBS -j oe
#PBS -v "CUDA_VISIBLE_DEVICES="
#PBS -W sandbox=PRIVATE
#PBS -k n
ln -s $PWD $PBS_O_WORKDIR/$PBS_JOBID
## Change to working directory
cd $PBS_O_WORKDIR
## Calculate number of CPUs and GPUs
export cpus=`cat $PBS_NODEFILE | wc -l`
## Load production modules
module use /apps/modules/all

##  Load the default application environment
## Purge existing apps
module purge all
# module load <YOUR_REQUIRED_MODULES>
## =============

# --- Your code starts here --- #

# Stop at runtime errors
set -e

# Start message (this is an example, change it!)
echo "Started script"
date
echo ""

# Load required modules (this is an example, change it if needed!)
module load Singularity/3.11.0-1-system
singularity --version

# Working folder (this is an example, change it if needed!)
WORKING_FOLDER="/mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/assignment/"
cd "${WORKING_FOLDER}"


# Load static file paths 
source "${WORKING_FOLDER}/scripts/filepaths.txt"

# Any additional variables or paths can be added here
# Any additional variables or paths can be added here
# get sample name
sample=$(basename "${COR_ILLUMINA_SR_READ_1}" .pair_1.fq.gz)

# get kmer size from user input
kmer=${input_kmer_size}

# get assembly tool that generated the assembly to be polished
assembly_tool=${input_assembly_tool}

# Create output directory and change to it
output_dir="${PILON_DIR}"/"${sample}_k${kmer}_${assembly_tool}"
mkdir -p "${output_dir}"
cd "${output_dir}"

   
# Main code 
# ========================
# Run Pilon
# Make symlink to final assembly in current directory
# skip if already exists
if [[ ! -e "final_assembly.fasta" ]]; then
    ln -s "${DBG2OLC_DIR}/${sample}_k${kmer}"/consensus_output/final_assembly.fasta .
fi

# Index the assembly
singularity exec ${SINGULARITY} \
    bwa index final_assembly.fasta

# Align the Illumina reads to the assembly
singularity exec ${SINGULARITY} \
    bash -c "\
    bwa mem -t ${cpus} final_assembly.fasta \
    "${COR_ILLUMINA_SR_READ_1}" "${COR_ILLUMINA_SR_READ_2}" | \
    samtools view -bS - > aligned_reads.bam"

singularity exec ${SINGULARITY} \
    bash -c "\
    samtools sort aligned_reads.bam -o aligned_reads_sorted.bam \
    && samtools index aligned_reads_sorted.bam"

singularity exec ${SINGULARITY} \
    java -jar /usr/local/bin/pilon-1.22.jar \
    --unpaired aligned_reads_sorted.bam \
    --genome final_assembly.fasta \
    --output pilon_polished \
    --tracks > pilon_output.log

# Completion message
echo "Done"
date

# Do not forget to update the header and PBS directives:
# e.g. the job name, e-mail address,
# num of cores, required time and cluster queue, 
# Also, do not to forget to load and check the required modules.

## Tidy up
## =========================
rm $PBS_O_WORKDIR/$PBS_JOBID
