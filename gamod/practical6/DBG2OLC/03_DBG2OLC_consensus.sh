#!/bin/bash
# Example of a script for Crescent2 batch job submission 
# Matthew Spriggs, 14Jan2026

# Crescent2 script
# Note: this script should be run on a compute node
# qsub script.sh

# PBS directives
#---------------

#PBS -N 03_DBG2OLC_consensus
#PBS -l nodes=1:ncpus=4
#PBS -l walltime=00:30:00
#PBS -q half_hour
#PBS -m abe
#PBS -M Matthew.Spriggs.452@cranfield.ac.uk
#PBS -o logs/

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
working_folder="/mnt/beegfs/home/s430452/advanced_sequencing_informatics_and_genome_assembly/gamod/"
DBG2OLC_dir="${working_folder}/practical6/DBG2OLC"

# File names (this is an example, change it if needed!)
input_fasta="${working_folder}/data/ecoli/NormalTwoDirectionReads.fasta"
input_contigs="${DBG2OLC_dir}/Contigs.txt"

# DBG2OLC build de-bruijn assembly
cd ${DBG2OLC_dir}

# Run job in singularity container (this is an example, change it if needed!)
singularity exec ${working_folder}/gamod.simg \
    bash -c "source /pitchfork/setup-env.sh && \
    cat ${input_contigs} > ${DBG2OLC_dir}/ctg_pb.fasta && \
    ${DBG2OLC_dir}/my_split_nrun_sparch.sh \
    ${DBG2OLC_dir}/backbone_raw.fasta \
    ${DBG2OLC_dir}/DBG2OLC_Consensus_info.txt \
    ${DBG2OLC_dir}/ctg_pb.fasta \
    ${DBG2OLC_dir}/consensusOUT 2"

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

