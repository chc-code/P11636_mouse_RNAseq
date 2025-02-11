
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result'

set -o pipefail




if [[ -e /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/FPAS_2.star.failed ]]; then
  rm /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/FPAS_2.star.failed
fi

if [[ -e /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/FPAS_2.featureCount.failed ]]; then
  rm /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/FPAS_2.featureCount.failed
fi

status=1

if [[ -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_2_clipped.1.fastq.gz ]]; then
  echo performing star ...
  STAR --twopassMode Basic --outSAMmapqUnique 60 --outSAMprimaryFlag AllBestScore --outSAMattrRGline ID:FPAS_2 SM:FPAS_2 LB:FPAS_2 PL:ILLUMINA PU:ILLUMINA --runThreadN 8 --genomeDir /data/cqs/references/gencode/GRCm38.p6/STAR_index_2.7.8a_vM25_sjdb100 --readFilesIn /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_2_clipped.1.fastq.gz /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_2_clipped.2.fastq.gz  --readFilesCommand zcat --outFileNamePrefix FPAS_2_ --outSAMtype BAM Unsorted
  status=$?
  if [[ $status -eq 0 ]]; then
    touch FPAS_2.star.succeed
  else
    rm FPAS_2_Aligned.out.bam
    touch FPAS_2.star.failed
  fi

  STAR --version | awk '{print "STAR,v"$1}' > FPAS_2.count.star.version
  rm -rf FPAS_2__STARgenome FPAS_2__STARpass1 FPAS_2_Log.progress.out
fi

if [[ $status -eq 0 ]]; then
  echo bamStat=`date` 
  python3 /data/cqs/softwares/ngsperl/lib/Alignment/bamStat.py -i FPAS_2_Aligned.out.bam -o FPAS_2.bamstat
fi

if [[ $status -eq 0 ]]; then
  echo bamSort=`date` 
  samtools sort -m 5G -T FPAS_2 -t 8 -o FPAS_2_Aligned.sortedByCoord.out.bam FPAS_2_Aligned.out.bam && touch FPAS_2_Aligned.sortedByCoord.out.bam.succeed
  if [[ ! -e FPAS_2_Aligned.sortedByCoord.out.bam.succeed ]]; then
    rm FPAS_2_Aligned.sortedByCoord.out.bam
  else
    samtools index FPAS_2_Aligned.sortedByCoord.out.bam
    samtools idxstats FPAS_2_Aligned.sortedByCoord.out.bam > FPAS_2_Aligned.sortedByCoord.out.bam.chromosome.count
  fi
fi  


if [[ $status -eq 0 && -s FPAS_2_Aligned.sortedByCoord.out.bam ]]; then
  
  
  if [ ! -s FPAS_2.splicing.bed ]; then
    awk {'if($4=="2") print ""$1"\t"$2-$9-1"\t"$3+$9"\tJUNC000"NR"\t"$7+$8"\t-\t"$2-$9-1"\t"$3+$9"\t255,0,0\t2\t"$9","$9"\t","0,"$3-$2+$9+1; else if($4=="1") print ""$1"\t"$2-$9-1"\t"$3+$9"\tJUNC000"NR"\t"$7+$8"\t+\t"$2-$9-1"\t"$3+$9"\t0,0,255\t2\t"$9","$9"\t","0,"$3-$2+$9+1'} FPAS_2_SJ.out.tab > FPAS_2.splicing.bed
  fi
fi

if [[ $status -eq 0 ]]; then
  echo performing featureCounts ...
  featureCounts -g gene_id -t exon -p --countReadPairs -T 8 -a /data/cqs/references/gencode/GRCm38.p6/gencode.vM25.annotation.gtf -o FPAS_2.count FPAS_2_Aligned.sortedByCoord.out.bam
  status=$?
  if [[ $status -eq 0 ]]; then
    touch FPAS_2.featureCount.succeed
  else
    touch FPAS_2.featureCount.failed
    rm FPAS_2.count
  fi

  featureCounts -v 2>&1 | grep featureCounts | cut -d ' ' -f2 | awk '{print "featureCounts,"$1}' > FPAS_2.count.featureCounts.version
fi 

if [[ -s FPAS_2.count && -s FPAS_2.bamstat ]]; then
  rm FPAS_2_Aligned.out.bam 
fi
