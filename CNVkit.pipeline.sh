cnvkit.py target Exome.Targets.hg38.bed --split -o Exome.Targets.split.hg38.bed 

cnvkit.py access ../../hg38.fa -x ../../CNVkit/Anshul.hg38.BlackListed.ENCFF356LFX.bed -o Long_gaps_and_Anshul_Blacklisted.hg38.bed

cnvkit.py antitarget Exome.Targets.split.hg38.bed --access Long_gaps_and_Anshul_Blacklisted.hg38.bed -o Exome.AntiTargets.hg38.bed

cnvkit.py batch -n MB_Normal.DLP-07.hg38.Deduplicated.bam --output-reference MB.reference.cnn -t Exome.Targets.split.hg38.bed -a Exome.AntiTargets.hg38.bed -f ../../hg38.fa --access Long_gaps_and_Anshul_Blacklisted.hg38.bed

cnvkit.py batch MB_Normal.DLP-07.hg38.Deduplicated.bam -r MB.reference.cnn -d MB_Normal.DLP-07.hg38.Deduplicated.CNVkit_results
