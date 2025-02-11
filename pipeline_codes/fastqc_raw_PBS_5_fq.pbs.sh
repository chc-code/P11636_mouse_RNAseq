
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/PBS_5'

set -o pipefail



rm -f PBS_5.fastqc.failed

fastqc  --extract -t 2 -o `pwd` "/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0005_S1_L005_R1_001.fastq.gz" "/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0005_S1_L005_R2_001.fastq.gz" 2> >(tee PBS_5.fastqc.stderr.log >&2)

status=$?
if [[ $status -ne 0 ]]; then
  touch PBS_5.fastqc.failed
else
  touch PBS_5.fastqc.succeed
fi

fastqc --version | cut -d ' ' -f2 | awk '{print "FastQC,"$1}' > `pwd`/fastqc.version
