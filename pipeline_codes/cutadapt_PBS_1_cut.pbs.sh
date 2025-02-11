
cd '/nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/cutadapt/result'

set -o pipefail



cutadapt -j 2 -q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT -n 1 --trim-n --poly-a -o PBS_1_clipped.1.fastq.gz -p PBS_1_clipped.2.fastq.gz  -m 30  --too-short-output=PBS_1_clipped.1.fastq.short.gz --too-short-paired-output=PBS_1_clipped.2.fastq.short.gz /data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0001_S1_L005_R1_001.fastq.gz /data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0001_S1_L005_R2_001.fastq.gz
status=$?
if [[ $status -eq 0 ]]; then
  touch PBS_1.succeed
  md5sum PBS_1_clipped.1.fastq.gz > PBS_1_clipped.1.fastq.gz.md5
  md5sum PBS_1_clipped.2.fastq.gz > PBS_1_clipped.2.fastq.gz.md5
else
  rm PBS_1_clipped.1.fastq.gz PBS_1_clipped.2.fastq.gz  PBS_1_clipped.1.fastq.short.gz PBS_1_clipped.2.fastq.short.gz
  touch PBS_1.failed
fi


cutadapt --version 2>&1 | awk '{print "Cutadapt,v"$1}' > PBS_1.version
