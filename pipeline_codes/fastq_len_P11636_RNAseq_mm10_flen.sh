MYCMD="sbatch" 

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastq_len/result/FPAS_2.len ]]; then
  $MYCMD ./FPAS_2_flen.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastq_len/result/FPAS_3.len ]]; then
  $MYCMD ./FPAS_3_flen.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastq_len/result/FPAS_4.len ]]; then
  $MYCMD ./FPAS_4_flen.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastq_len/result/FPAS_5.len ]]; then
  $MYCMD ./FPAS_5_flen.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastq_len/result/PBS_2.len ]]; then
  $MYCMD ./PBS_2_flen.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastq_len/result/PBS_3.len ]]; then
  $MYCMD ./PBS_3_flen.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastq_len/result/PBS_4.len ]]; then
  $MYCMD ./PBS_4_flen.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastq_len/result/PBS_5.len ]]; then
  $MYCMD ./PBS_5_flen.pbs 
fi
