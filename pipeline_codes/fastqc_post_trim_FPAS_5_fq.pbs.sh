
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/FPAS_5'

set -o pipefail



rm -f FPAS_5.fastqc.failed

fastqc  --extract -t 2 -o `pwd` "/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_5_clipped.1.fastq.gz" "/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_5_clipped.2.fastq.gz" 2> >(tee FPAS_5.fastqc.stderr.log >&2)

status=$?
if [[ $status -ne 0 ]]; then
  touch FPAS_5.fastqc.failed
else
  touch FPAS_5.fastqc.succeed
fi

fastqc --version | cut -d ' ' -f2 | awk '{print "FastQC,"$1}' > `pwd`/fastqc.version
