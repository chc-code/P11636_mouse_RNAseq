
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/PBS_2'

set -o pipefail



rm -f PBS_2.fastqc.failed

fastqc  --extract -t 2 -o `pwd` "/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_2_clipped.1.fastq.gz" "/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_2_clipped.2.fastq.gz" 2> >(tee PBS_2.fastqc.stderr.log >&2)

status=$?
if [[ $status -ne 0 ]]; then
  touch PBS_2.fastqc.failed
else
  touch PBS_2.fastqc.succeed
fi

fastqc --version | cut -d ' ' -f2 | awk '{print "FastQC,"$1}' > `pwd`/fastqc.version
