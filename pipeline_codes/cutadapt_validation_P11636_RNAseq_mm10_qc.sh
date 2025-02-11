MYCMD="sbatch" 

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt_validation/result/FPAS_2.txt ]]; then
  $MYCMD ./FPAS_2_qc.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt_validation/result/FPAS_3.txt ]]; then
  $MYCMD ./FPAS_3_qc.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt_validation/result/FPAS_4.txt ]]; then
  $MYCMD ./FPAS_4_qc.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt_validation/result/FPAS_5.txt ]]; then
  $MYCMD ./FPAS_5_qc.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt_validation/result/PBS_2.txt ]]; then
  $MYCMD ./PBS_2_qc.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt_validation/result/PBS_3.txt ]]; then
  $MYCMD ./PBS_3_qc.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt_validation/result/PBS_4.txt ]]; then
  $MYCMD ./PBS_4_qc.pbs 
fi
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt_validation/result/PBS_5.txt ]]; then
  $MYCMD ./PBS_5_qc.pbs 
fi
