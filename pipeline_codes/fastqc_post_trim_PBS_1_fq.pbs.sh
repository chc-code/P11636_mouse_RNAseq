
cd '/nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/PBS_1'

set -o pipefail



rm -f PBS_1.fastqc.failed

fastqc  --extract -t 2 -o `pwd` "/nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_1_clipped.1.fastq.gz" "/nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_1_clipped.2.fastq.gz" 2> >(tee PBS_1.fastqc.stderr.log >&2)

status=$?
if [[ $status -ne 0 ]]; then
  touch PBS_1.fastqc.failed
else
  touch PBS_1.fastqc.succeed
fi

fastqc --version | cut -d ' ' -f2 | awk '{print "FastQC,"$1}' > `pwd`/fastqc.version
