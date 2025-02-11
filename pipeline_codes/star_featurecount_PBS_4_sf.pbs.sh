
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result'

set -o pipefail




if [[ -e /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_4.star.failed ]]; then
  rm /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_4.star.failed
fi

if [[ -e /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_4.featureCount.failed ]]; then
  rm /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_4.featureCount.failed
fi

status=1

if [[ -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_4_clipped.1.fastq.gz ]]; then
  echo performing star ...
  STAR --twopassMode Basic --outSAMmapqUnique 60 --outSAMprimaryFlag AllBestScore --outSAMattrRGline ID:PBS_4 SM:PBS_4 LB:PBS_4 PL:ILLUMINA PU:ILLUMINA --runThreadN 8 --genomeDir /data/cqs/references/gencode/GRCm38.p6/STAR_index_2.7.8a_vM25_sjdb100 --readFilesIn /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_4_clipped.1.fastq.gz /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_4_clipped.2.fastq.gz  --readFilesCommand zcat --outFileNamePrefix PBS_4_ --outSAMtype BAM Unsorted
  status=$?
  if [[ $status -eq 0 ]]; then
    touch PBS_4.star.succeed
  else
    rm PBS_4_Aligned.out.bam
    touch PBS_4.star.failed
  fi

  STAR --version | awk '{print "STAR,v"$1}' > PBS_4.count.star.version
  rm -rf PBS_4__STARgenome PBS_4__STARpass1 PBS_4_Log.progress.out
fi

if [[ $status -eq 0 ]]; then
  echo bamStat=`date` 
  python3 /data/cqs/softwares/ngsperl/lib/Alignment/bamStat.py -i PBS_4_Aligned.out.bam -o PBS_4.bamstat
fi

if [[ $status -eq 0 ]]; then
  echo bamSort=`date` 
  samtools sort -m 5G -T PBS_4 -t 8 -o PBS_4_Aligned.sortedByCoord.out.bam PBS_4_Aligned.out.bam && touch PBS_4_Aligned.sortedByCoord.out.bam.succeed
  if [[ ! -e PBS_4_Aligned.sortedByCoord.out.bam.succeed ]]; then
    rm PBS_4_Aligned.sortedByCoord.out.bam
  else
    samtools index PBS_4_Aligned.sortedByCoord.out.bam
    samtools idxstats PBS_4_Aligned.sortedByCoord.out.bam > PBS_4_Aligned.sortedByCoord.out.bam.chromosome.count
  fi
fi  


if [[ $status -eq 0 && -s PBS_4_Aligned.sortedByCoord.out.bam ]]; then
  
  
  if [ ! -s PBS_4.splicing.bed ]; then
    awk {'if($4=="2") print ""$1"\t"$2-$9-1"\t"$3+$9"\tJUNC000"NR"\t"$7+$8"\t-\t"$2-$9-1"\t"$3+$9"\t255,0,0\t2\t"$9","$9"\t","0,"$3-$2+$9+1; else if($4=="1") print ""$1"\t"$2-$9-1"\t"$3+$9"\tJUNC000"NR"\t"$7+$8"\t+\t"$2-$9-1"\t"$3+$9"\t0,0,255\t2\t"$9","$9"\t","0,"$3-$2+$9+1'} PBS_4_SJ.out.tab > PBS_4.splicing.bed
  fi
fi

if [[ $status -eq 0 ]]; then
  echo performing featureCounts ...
  featureCounts -g gene_id -t exon -p --countReadPairs -T 8 -a /data/cqs/references/gencode/GRCm38.p6/gencode.vM25.annotation.gtf -o PBS_4.count PBS_4_Aligned.sortedByCoord.out.bam
  status=$?
  if [[ $status -eq 0 ]]; then
    touch PBS_4.featureCount.succeed
  else
    touch PBS_4.featureCount.failed
    rm PBS_4.count
  fi

  featureCounts -v 2>&1 | grep featureCounts | cut -d ' ' -f2 | awk '{print "featureCounts,"$1}' > PBS_4.count.featureCounts.version
fi 

if [[ -s PBS_4.count && -s PBS_4.bamstat ]]; then
  rm PBS_4_Aligned.out.bam 
fi
