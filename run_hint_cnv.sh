#!/bin/bash

# Job name:
#SBATCH --job-name=hint_cnv
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
#SBATCH --time=06:00:00
#
# Memory required:
#SBATCH --mem=20G
#
## Command(s) to run (example):

hic_name=$1
# conda activate /global/scratch/sanjitsbatra/conda_env
hint cnv -m MSB${hic_name}.hg38.hic -f juicer --refdir hg38 -r 50 -g hg38 --bicseq BICseq2-seg_v0.7.3 -e DpnII -n MSB${hic_name}_hg38_cnv -o MSB${hic_name}_hg38_cnv_out


# python quantize_bigwig.py $1

# echo "test_savio"

