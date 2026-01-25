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

# Sanity checks
if [[ ! -s "${SOAP_ASSEMBELLY}" ]]; then
    echo "ERROR: Contigs file not found or empty: ${SOAP_ASSEMBELLY}" 
    exit 1
fi

if [[ ! -s "${PACBIO_READS}" ]]; then
    echo "ERROR: PacBio reads file not found or empty: ${PACBIO_READS}" 
    exit 1
fi

# Main code 
# ========================
echo "Running DBG2OLC for sample ${sample} with kmer size ${kmer}"
echo "Results will be saved to: ${output_dir}"

# Unzip reads
zcat "${PACBIO_READS}" > "HS7_pacbioData.fasta"


# Run DBG2OLC using my soapdenovo2 assembly
singularity exec ${SINGULARITY} \
    "${DBG2OLC}/DBG2OLC" \
    -k ${kmer} \
    AdaptiveTh 0.0001 \
    KmerCovTh 2 \
    MinOverlap 20 \
    RemoveChimera 1 \
    Contigs "${SOAP_ASSEMBELLY}" \
    f "HS7_pacbioData.fasta"

# remove intermediate file


echo "DBG2OLC assembly completed."

# consensus stage
echo "Preparing reads in single fasta..."
cat "${SOAP_ASSEMBELLY}" "HS7_pacbioData.fasta" > "DBG2OLC_contigs_plus_pacbio.fasta"

# Enable the use of my_split_nrun_sparc and pitchfork
echo "Setting up environment for Sparc polishing..."
singularity exec ${SINGULARITY} \
    bash -c "source ${WORKING_FOLDER}/scripts/my_split_nrun_sparc.sh \
    && source /pitchfork/setup-env.sh"


echo "Running my_split_nrun_sparc.sh..."
singularity exec "${SINGULARITY}" \
    ./my_split_nrun_sparc.sh \
    backbone_raw.fasta \
    DBG2OLC_Consensus_info.txt \
    DBG2OLC_contigs_plus_pacbio.fasta \
    consensus_output 2


# clean up intermediate files
rm "HS7_pacbioData.fasta"
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
