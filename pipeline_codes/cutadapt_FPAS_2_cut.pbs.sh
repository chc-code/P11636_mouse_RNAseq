
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result'

set -o pipefail



cutadapt -j 2 -q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT -n 1 --trim-n --poly-a -o FPAS_2_clipped.1.fastq.gz -p FPAS_2_clipped.2.fastq.gz  -m 30  --too-short-output=FPAS_2_clipped.1.fastq.short.gz --too-short-paired-output=FPAS_2_clipped.2.fastq.short.gz /data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0007_S1_L005_R1_001.fastq.gz /data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0007_S1_L005_R2_001.fastq.gz
status=$?
if [[ $status -eq 0 ]]; then
  touch FPAS_2.succeed
  md5sum FPAS_2_clipped.1.fastq.gz > FPAS_2_clipped.1.fastq.gz.md5
  md5sum FPAS_2_clipped.2.fastq.gz > FPAS_2_clipped.2.fastq.gz.md5
else
  rm FPAS_2_clipped.1.fastq.gz FPAS_2_clipped.2.fastq.gz  FPAS_2_clipped.1.fastq.short.gz FPAS_2_clipped.2.fastq.short.gz
  touch FPAS_2.failed
fi


cutadapt --version 2>&1 | awk '{print "Cutadapt,v"$1}' > FPAS_2.version
