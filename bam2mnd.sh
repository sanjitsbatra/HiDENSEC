#$ -cwd
#$ -N CPuORFs
#$ -j y
#$ -l h_vmem=30g
#$ -l mem_free=30g

bam=$1
tmpdir=$2
outputfile=$3

mkdir -p ${tmpdir}

python /illumina/scratch/deep_learning/sbatra/dirk/Code/convert_alignments_to_tsv.py ${bam} \
    | sort -k2,2d -k6,6d -T ${tmpdir} --parallel=16 \
    > ${outputfile}".short"

awk -F $"\t" '{s="";for(i=1;i<=NF;i++){s=s" "$i}s=s" 60 Cigar1 R1 60 Cigar2 R2 Id1 Id2";print substr(s,2)}' ${outputfile}".short" > ${outputfile}


#    | awk '{if ($2 > $6) {print $1"\t"$6"\t"$7"\t"$8"\t"$5"\t"$2"\t"$3"\t"$4} else {print}}' \
