
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result'

set -o pipefail




if [[ -e /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_3.star.failed ]]; then
  rm /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_3.star.failed
fi

if [[ -e /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_3.featureCount.failed ]]; then
  rm /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_3.featureCount.failed
fi

status=1

if [[ -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_3_clipped.1.fastq.gz ]]; then
  echo performing star ...
  STAR --twopassMode Basic --outSAMmapqUnique 60 --outSAMprimaryFlag AllBestScore --outSAMattrRGline ID:PBS_3 SM:PBS_3 LB:PBS_3 PL:ILLUMINA PU:ILLUMINA --runThreadN 8 --genomeDir /data/cqs/references/gencode/GRCm38.p6/STAR_index_2.7.8a_vM25_sjdb100 --readFilesIn /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_3_clipped.1.fastq.gz /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_3_clipped.2.fastq.gz  --readFilesCommand zcat --outFileNamePrefix PBS_3_ --outSAMtype BAM Unsorted
  status=$?
  if [[ $status -eq 0 ]]; then
    touch PBS_3.star.succeed
  else
    rm PBS_3_Aligned.out.bam
    touch PBS_3.star.failed
  fi

  STAR --version | awk '{print "STAR,v"$1}' > PBS_3.count.star.version
  rm -rf PBS_3__STARgenome PBS_3__STARpass1 PBS_3_Log.progress.out
fi

if [[ $status -eq 0 ]]; then
  echo bamStat=`date` 
  python3 /data/cqs/softwares/ngsperl/lib/Alignment/bamStat.py -i PBS_3_Aligned.out.bam -o PBS_3.bamstat
fi

if [[ $status -eq 0 ]]; then
  echo bamSort=`date` 
  samtools sort -m 5G -T PBS_3 -t 8 -o PBS_3_Aligned.sortedByCoord.out.bam PBS_3_Aligned.out.bam && touch PBS_3_Aligned.sortedByCoord.out.bam.succeed
  if [[ ! -e PBS_3_Aligned.sortedByCoord.out.bam.succeed ]]; then
    rm PBS_3_Aligned.sortedByCoord.out.bam
  else
    samtools index PBS_3_Aligned.sortedByCoord.out.bam
    samtools idxstats PBS_3_Aligned.sortedByCoord.out.bam > PBS_3_Aligned.sortedByCoord.out.bam.chromosome.count
  fi
fi  


if [[ $status -eq 0 && -s PBS_3_Aligned.sortedByCoord.out.bam ]]; then
  
  
  if [ ! -s PBS_3.splicing.bed ]; then
    awk {'if($4=="2") print ""$1"\t"$2-$9-1"\t"$3+$9"\tJUNC000"NR"\t"$7+$8"\t-\t"$2-$9-1"\t"$3+$9"\t255,0,0\t2\t"$9","$9"\t","0,"$3-$2+$9+1; else if($4=="1") print ""$1"\t"$2-$9-1"\t"$3+$9"\tJUNC000"NR"\t"$7+$8"\t+\t"$2-$9-1"\t"$3+$9"\t0,0,255\t2\t"$9","$9"\t","0,"$3-$2+$9+1'} PBS_3_SJ.out.tab > PBS_3.splicing.bed
  fi
fi

if [[ $status -eq 0 ]]; then
  echo performing featureCounts ...
  featureCounts -g gene_id -t exon -p --countReadPairs -T 8 -a /data/cqs/references/gencode/GRCm38.p6/gencode.vM25.annotation.gtf -o PBS_3.count PBS_3_Aligned.sortedByCoord.out.bam
  status=$?
  if [[ $status -eq 0 ]]; then
    touch PBS_3.featureCount.succeed
  else
    touch PBS_3.featureCount.failed
    rm PBS_3.count
  fi

  featureCounts -v 2>&1 | grep featureCounts | cut -d ' ' -f2 | awk '{print "featureCounts,"$1}' > PBS_3.count.featureCounts.version
fi 

if [[ -s PBS_3.count && -s PBS_3.bamstat ]]; then
  rm PBS_3_Aligned.out.bam 
fi
