# Before running Mutect2, add Read Groups:
module load java && module load samtools && java -jar ../Mutect2/picard.jar AddOrReplaceReadGroups I=MSB703_Melanoma.U5LP-06.hg38.sorted.bam O=MSB703_Melanoma.U5LP-06.hg38.sorted.2.bam RGID=MSB703_Melanoma RGLB=MSB703_Melanoma RGPL=illumina RGPU=MSB703_Melanoma RGSM=MSB703_Melanoma && java -jar ../Mutect2/picard.jar AddOrReplaceReadGroups I=MSB700_Metastasis.U5LP-02.hg38.sorted.bam O=MSB700_Metastasis.U5LP-02.hg38.sorted.2.bam RGID=MSB700_Metastasis RGLB=MSB700_Metastasis RGPL=illumina RGPU=MSB700_Metastasis RGSM=MSB700_Metastasis && java -jar ../Mutect2/picard.jar AddOrReplaceReadGroups I=MSB_Normal.U5LP-10.hg38.sorted.bam O=MSB_Normal.U5LP-10.hg38.sorted.2.bam RGID=MSB_Normal RGLB=MSB_Normal RGPL=illumina RGPU=MSB_Normal RGSM=MSB_Normal

# Run Mutect2
./gatk Mutect2 -R ../hg38.fa -I MB290_Nevus.bam -I MB_Normal.bam -normal MB_Normal -O MB290_Normal.somatic_Mutect2.vcf.gz

# Re-run Mutect2 on union calls
for f in MB*.somatic_Mutect2.vcf.gz;do zcat $f | awk -F $"\t" '!/^#/{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t."}' - ;done | sort -k 1,1V -k 2,2g > MB.somatic_Mutect2.force_called.vcf
cat force_called.header MSB.somatic_Mutect2.force_called.vcf > t && mv t MSB.somatic_Mutect2.force_called.vcf
../Mutect2/gatk IndexFeatureFile -I MB.somatic_Mutect2.force_called.vcf
../Mutect2/gatk Mutect2 -R ../hg38.fa -I MSB703_Melanoma.U5LP-06.hg38.sorted.bam -I MSB_Normal.U5LP-10.hg38.sorted.bam -normal MSB_Normal -O MSB703_Melanoma.U5LP-06.force_called.somatic_Mutect2.vcf.gz -alleles MSB.somatic_Mutect2.force_called.vcf 
# Then run funcotator
./gatk Funcotator --variant MB286_Normal.somatic_Mutect2.vcf --reference ../hg38.fa --ref-version hg38 --data-sources-path funcotator_dataSources.v1.7.20200521s --output MB286_Normal.somatic_Mutect2.funcotated.maf --output-file-format MAF

awk -F $"\t" 'BEGIN{OFS="\t"}{if(substr($0,1,1)=="#"){}else{print $1,$5,$6,$7,$8,$9,$10,$11,$12,$13,$35,$36,$40,$41,$42,$80,$81,$82,$83,$84,$57,$58,$60,$14,$15,$164,$66,$67}}' MSB703_Melanoma.funcotated.maf > MB703_Melanoma.funcotated.distilled.tsv

