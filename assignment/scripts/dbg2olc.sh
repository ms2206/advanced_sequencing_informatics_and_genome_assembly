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

#PBS -N dbg2olc
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
# get sample name
sample=$(basename "${COR_ILLUMINA_SR_READ_1}" .pair_1.fq.gz)

# dynamically get kmer size from SOAP assembly path
kmer=${input_kmer_size}

# Create output directory and change to it
output_dir="${DBG2OLC_DIR}/${sample}_k${kmer}"
mkdir -p "${output_dir}"
cd "${output_dir}"
    
# Main code 
# ========================
echo "Running DBG2OLC for sample ${sample} with kmer size ${kmer}"
echo "Results will be saved to: ${output_dir}"

# Run DBG2OLC
singularity exec ${SINGULARITY} \
    "${DBG2OLC}/SparseAssembler" \
    GS 15000000 \
    NodeCovTh 1 \
    EdgeCovTh 1 \
    k ${kmer} \
    g 1 \
    f "${COR_ILLUMINA_SR_READ_1} ${COR_ILLUMINA_SR_READ_2}" 

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
