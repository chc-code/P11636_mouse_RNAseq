MYCMD="sbatch" 
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_2_clipped.1.fastq.gz ]]; then
  $MYCMD ./FPAS_2_cut.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.gz ]]; then
  $MYCMD ./FPAS_3_cut.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_4_clipped.1.fastq.gz ]]; then
  $MYCMD ./FPAS_4_cut.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_5_clipped.1.fastq.gz ]]; then
  $MYCMD ./FPAS_5_cut.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_2_clipped.1.fastq.gz ]]; then
  $MYCMD ./PBS_2_cut.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_3_clipped.1.fastq.gz ]]; then
  $MYCMD ./PBS_3_cut.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_4_clipped.1.fastq.gz ]]; then
  $MYCMD ./PBS_4_cut.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_5_clipped.1.fastq.gz ]]; then
  $MYCMD ./PBS_5_cut.pbs 
fi
