
cd '/nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/star_featurecount/result'

set -o pipefail




if [[ -e /nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_1.star.failed ]]; then
  rm /nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_1.star.failed
fi

if [[ -e /nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_1.featureCount.failed ]]; then
  rm /nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_1.featureCount.failed
fi

status=1

if [[ -s /nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_1_clipped.1.fastq.gz ]]; then
  echo performing star ...
  STAR --twopassMode Basic --outSAMmapqUnique 60 --outSAMprimaryFlag AllBestScore --outSAMattrRGline ID:PBS_1 SM:PBS_1 LB:PBS_1 PL:ILLUMINA PU:ILLUMINA --runThreadN 8 --genomeDir /data/cqs/references/gencode/GRCm38.p6/STAR_index_2.7.8a_vM25_sjdb100 --readFilesIn /nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_1_clipped.1.fastq.gz /nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_1_clipped.2.fastq.gz  --readFilesCommand zcat --outFileNamePrefix PBS_1_ --outSAMtype BAM Unsorted
  status=$?
  if [[ $status -eq 0 ]]; then
    touch PBS_1.star.succeed
  else
    rm PBS_1_Aligned.out.bam
    touch PBS_1.star.failed
  fi

  STAR --version | awk '{print "STAR,v"$1}' > PBS_1.count.star.version
  rm -rf PBS_1__STARgenome PBS_1__STARpass1 PBS_1_Log.progress.out
fi

if [[ $status -eq 0 ]]; then
  echo bamStat=`date` 
  python3 /data/cqs/softwares/ngsperl/lib/Alignment/bamStat.py -i PBS_1_Aligned.out.bam -o PBS_1.bamstat
fi

if [[ $status -eq 0 ]]; then
  echo bamSort=`date` 
  samtools sort -m 5G -T PBS_1 -t 8 -o PBS_1_Aligned.sortedByCoord.out.bam PBS_1_Aligned.out.bam && touch PBS_1_Aligned.sortedByCoord.out.bam.succeed
  if [[ ! -e PBS_1_Aligned.sortedByCoord.out.bam.succeed ]]; then
    rm PBS_1_Aligned.sortedByCoord.out.bam
  else
    samtools index PBS_1_Aligned.sortedByCoord.out.bam
    samtools idxstats PBS_1_Aligned.sortedByCoord.out.bam > PBS_1_Aligned.sortedByCoord.out.bam.chromosome.count
  fi
fi  


if [[ $status -eq 0 && -s PBS_1_Aligned.sortedByCoord.out.bam ]]; then
  
  
  if [ ! -s PBS_1.splicing.bed ]; then
    awk {'if($4=="2") print ""$1"\t"$2-$9-1"\t"$3+$9"\tJUNC000"NR"\t"$7+$8"\t-\t"$2-$9-1"\t"$3+$9"\t255,0,0\t2\t"$9","$9"\t","0,"$3-$2+$9+1; else if($4=="1") print ""$1"\t"$2-$9-1"\t"$3+$9"\tJUNC000"NR"\t"$7+$8"\t+\t"$2-$9-1"\t"$3+$9"\t0,0,255\t2\t"$9","$9"\t","0,"$3-$2+$9+1'} PBS_1_SJ.out.tab > PBS_1.splicing.bed
  fi
fi

if [[ $status -eq 0 ]]; then
  echo performing featureCounts ...
  featureCounts -g gene_id -t exon -p --countReadPairs -T 8 -a /data/cqs/references/gencode/GRCm38.p6/gencode.vM25.annotation.gtf -o PBS_1.count PBS_1_Aligned.sortedByCoord.out.bam
  status=$?
  if [[ $status -eq 0 ]]; then
    touch PBS_1.featureCount.succeed
  else
    touch PBS_1.featureCount.failed
    rm PBS_1.count
  fi

  featureCounts -v 2>&1 | grep featureCounts | cut -d ' ' -f2 | awk '{print "featureCounts,"$1}' > PBS_1.count.featureCounts.version
fi 

if [[ -s PBS_1.count && -s PBS_1.bamstat ]]; then
  rm PBS_1_Aligned.out.bam 
fi
