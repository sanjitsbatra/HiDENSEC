#!/bin/bash

# Job name:
#SBATCH --job-name=BAM2SFS
#
# Account:
#SBATCH --account=fc_songlab
#
# QoS:
#SBATCH --qos=savio_normal
#
# Partition:
#SBATCH --partition=savio
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
#SBATCH --time=12:00:00
#
# Memory required:
#SBATCH --mem=30G
#
## Command(s) to run (example):


module load java
module load samtools
module load gnu-parallel
module load bcftools


######################################################
# Step-0: Input files

BAM=$1
output_prefix=$2

######################################################


# ######################################################
# # NOTE: Performing this step makes the SFS ragged!
# # Step-1: Deduplication
# 
# ./gatk MarkDuplicates \
# --INPUT ${BAM} \
# --OUTPUT ${output_prefix}.Deduplicated.bam \
# --REMOVE_DUPLICATES true \
# --CREATE_INDEX true \
# --VALIDATION_STRINGENCY SILENT \
# --METRICS_FILE ${output_prefix}.Deduplicated.metrics \
# --ASSUME_SORT_ORDER coordinate
# 
# ######################################################


# ######################################################
# # Step-1: Sort and index BAM file
# samtools sort -@ 8 ${BAM} > ${output_prefix}.sorted.bam
# samtools index -@ 8 ${output_prefix}.sorted.bam
# 
# ######################################################


######################################################
# Step-2: Create mpileup

bcftools mpileup -a AD -Ov -x -A --threads 6 -f hg38.fa -R 1000G.AF_0.4_0.6.bed ${output_prefix}.sorted.bam > ${output_prefix}.without_Deduplication.1000G.AF_0.4_0.6.mpileup

######################################################


######################################################
# Step-3: Create SFS

awk -F $"\t" '!/^#/{split($NF,a,":");n=split(a[2],b,",");if((n==3)&&(b[n]==0)){split($5,c,",");print $1"\t"$2"\t"$4"\t"c[1]"\t"b[1]"\t"b[2]}}' ${output_prefix}.without_Deduplication.1000G.AF_0.4_0.6.mpileup > ${output_prefix}.without_Deduplication.1000G.AF_0.4_0.6.SFS

######################################################


exit +1
