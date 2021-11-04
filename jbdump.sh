#!/bin/bash

# Job name:
#SBATCH --job-name=hic2jbdump
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
#SBATCH --time=4:00:00
#
# Memory required:
#SBATCH --mem=200G


module load java

HiDENSEC_Code_Folder="/global/scratch/projects/fc_songlab/sanjitsbatra/Rokhsar_Lab_Collaborations/Dirk_Cancer_HiC/USFC_OmniC/Code/"

input_hic=$1
output_prefix=$2

java -jar ${HiDENSEC_Code_Folder}"juicer_tools.jar" dump observed NONE ${input_hic} assembly assembly BP 25000 | tail -n+2 | awk -F $"\t" '{print $1*2"\t"$2*2"\t"$3}' > ${output_prefix}.50Kb.jbdump

awk -F $"\t" '{if($3>5){print}}' ${output_prefix}".50Kb.jbdump" | awk -F $"\t" '{print (($1/50000)+1)"\t"(($2/50000)+1)"\t"$3}' > ${output_prefix}".more_than_5_per_bin.50Kb.jbdump"


