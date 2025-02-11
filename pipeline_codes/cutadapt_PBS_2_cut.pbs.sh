
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result'

set -o pipefail



cutadapt -j 2 -q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT -n 1 --trim-n --poly-a -o PBS_2_clipped.1.fastq.gz -p PBS_2_clipped.2.fastq.gz  -m 30  --too-short-output=PBS_2_clipped.1.fastq.short.gz --too-short-paired-output=PBS_2_clipped.2.fastq.short.gz /data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0002_S1_L005_R1_001.fastq.gz /data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0002_S1_L005_R2_001.fastq.gz
status=$?
if [[ $status -eq 0 ]]; then
  touch PBS_2.succeed
  md5sum PBS_2_clipped.1.fastq.gz > PBS_2_clipped.1.fastq.gz.md5
  md5sum PBS_2_clipped.2.fastq.gz > PBS_2_clipped.2.fastq.gz.md5
else
  rm PBS_2_clipped.1.fastq.gz PBS_2_clipped.2.fastq.gz  PBS_2_clipped.1.fastq.short.gz PBS_2_clipped.2.fastq.short.gz
  touch PBS_2.failed
fi


cutadapt --version 2>&1 | awk '{print "Cutadapt,v"$1}' > PBS_2.version
