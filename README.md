# HiDENSEC
This repository contains scripts for performing HiDENSEC analysis given a Hi-C BAM file. 

1. Convert BAM files into .hic files and matrices
We provide a bam2hic.sh script to convert a Hi-C BAM file into .assembly.hic and .hg38.hic files.

2. Convert Hi-C data into rowsums and sparse matrix format
We provide a bam2rowsums.sh custom script that uses HiNT to generate rowsums for any .hic file. We also provide jbdump.sh to convert into sparse matrix format.

3. Allele frequency analysis 
We first obtained all the SNVs from 1000G that have population Allele Frequencies in [0.4, 0.6]. 
For each BAM file we then provide the bam2sfs.sh script that performs alle frequency analysis on the BAM file.

4. HiDENSEC analysis
Given the rowsums and Hi-C data in sparse matrix format, we perform HiDENSEC analysis to generate a Hi-C map, to infer genome-wide absolute copy number profiles and infer tumor purity. All associated scripts are within the HiDENSEC_Mathematica folder.

4. CNVkit copy number calling
Our custom script run_CNVkit.sh provides a recipe to perform copy number calling using short-read sequencing data
that we apply to UCSF500 and Exome sequencing data using CNVkit. 

5. Mutect2 somatic variant calling
Our custom script run_Mutect2.sh (a wrapper around Mutect2 distributed within gatk-4.1.9.0) provides a recipe to perform somatic variant calling using patient short-read sequencing data. We use the resulting somatic MAF files to apply filter_Mutect2.sh to get rid of false-positive somatic variant calls.
Following this, we plot the Minor Allele Frequency of each pair of samples within each patient considered and draw a phylogenetic tree for each patient using the number of somatic variants seen from the resulting files and annotate the trees with known oncogenic variants. Additionally, we estimate the tumor cellularity as twice the minor allele frequency of the BRAF V600E mutation.
