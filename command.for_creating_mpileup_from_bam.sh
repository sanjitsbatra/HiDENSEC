module load bcftools && for i in *.bam.sorted.bam;do bcftools mpileup -a AD -Ov -x -A --threads 6 -f hg38.fa $i > $i.mpileup &done
