#!/bin/bash

# Job name:
#SBATCH --job-name=bam2SFS
#
# Account:
#SBATCH --account=co_songlab
#
# QoS:
#SBATCH --qos=songlab_htc3_normal
#
# Partition:
#SBATCH --partition=savio3_htc
#
# Number of nodes:
#SBATCH --nodes=1
#
# Number of tasks needed for use case (example):
#SBATCH --ntasks=1
#
# Processors per task:
#SBATCH --cpus-per-task=1
#
# Wall clock limit:
#SBATCH --time=40:00:00
#
# Memory required:
#SBATCH --mem=200G


module load bcftools 

Code_Path="/global/scratch/projects/fc_songlab/sanjitsbatra/Rokhsar_Lab_Collaborations/Dirk_Cancer_HiC/USFC_OmniC/Code/"

BAM_file=$1
TG_f=$2
output_prefix=$3

bcftools mpileup -a AD -Ov -x -A --threads 6 -f ${Code_Path}"hg38.fa" ${BAM_file} > ${output_prefix}".mpileup" 

awk -f ${Code_Path}"mpileup2SFS.awk" ${TG_f} ${output_prefix}".mpileup" > ${output_prefix}".SFS"

awk -F $"\t" 'BEGIN{bin_size=50000}{chrom=$1;pos=$2;start=int(pos/bin_size);if(($3+$4)>20){print chrom"\t"(start*bin_size)"\t"$3"\t"$4}}' ${output_prefix}".SFS" > ${output_prefix}".more_than_20_reads_per_position.SFS"

