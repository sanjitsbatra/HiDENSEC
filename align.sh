#!/bin/bash

# Job name:
#SBATCH --job-name=bam2hic
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


module load gnu-parallel/2019.03.22
module load java

HiDENSEC_Code_Folder="/global/scratch/projects/fc_songlab/sanjitsbatra/Rokhsar_Lab_Collaborations/Dirk_Cancer_HiC/USFC_OmniC/Code/"

input_BAM=$1
outputprefix=$2
tmpdir=${outputprefix}".tmpdir"

# Step-1: Align fastq files to reference and create a BAM file
# ./bwa/bwa mem -5SP -T0 -t 32 hg38_n_EBV.fa $1 $2 | samtools view -@ 32 -Sb - > ${bam}


# Step-2: Convert the BAM file into a pairs file
mkdir -p ${tmpdir}
python ${HiDENSEC_Code_Folder}convert_alignments_to_tsv.py ${input_BAM} \
    | sort -k2,2d -k6,6d -T ${tmpdir} --parallel=16 \
	    > ${outputprefix}".short"

# Step-3: Convert the pairs file into a long pairs file
awk -F $"\t" '{s="";for(i=1;i<=NF;i++){s=s" "$i}s=s" 60 Cigar1 R1 60 Cigar2 R2 Id1 Id2";print substr(s,2)}' ${outputprefix}".short" > ${outputprefix}".mnd"

# Step-4: Remove lines that contain erroneous number of fields
awk '{if(NF==16){print}}' ${outputprefix}".mnd" > ${outputprefix}".mnd.16_fields.txt"

# Step-5: Create an hg38 Hi-C file
mkdir -p ${outputprefix}".juicebox_tmp_dir.hg38" && java -Xms100g -Xmx100g -jar ${HiDENSEC_Code_Folder}"juicer_tools.jar" pre -t ${outputprefix}".juicebox_tmp_dir.hg38" -n -r 1250000,500000,250000,100000,50000,25000 ${outputprefix}".mnd.16_fields.txt" ${outputprefix}".hg38.hic" hg38 

# Step-6: Prepare inputs for creating an assembly Hi-C file
ln -s ${HiDENSEC_Code_Folder}"hg38.cprops" ${outputprefix}.cprops
ln -s ${HiDENSEC_Code_Folder}"hg38.asm" ${outputprefix}.asm

# Step-7: Create an assembly Hi-C file 
bash ${HiDENSEC_Code_Folder}"3d-dna/visualize/run-asm-visualizer.sh" -q 0 -n -r 1250000,500000,250000,100000,50000,25000,10000 ${outputprefix}.cprops ${outputprefix}.asm ${outputprefix}".mnd.16_fields.txt"

# mkdir -p ${outputprefix}".juicebox_tmp_dir.assembly" && java -Xms100g -Xmx100g -jar ${HiDENSEC_Code_Folder}"juicer_tools.jar" pre -t ${outputprefix}".juicebox_tmp_dir.assembly" -n -r 1250000,500000,250000,100000,50000,25000 temp.${outputprefix}.asm_mnd.txt ${outputprefix}".assembly.hic" assembly

exit

