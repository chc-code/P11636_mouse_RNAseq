MYCMD="sbatch" 

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/FPAS_2/FPAS_2_clipped.1_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/FPAS_2/FPAS_2_clipped.2_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./FPAS_2_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/FPAS_3/FPAS_3_clipped.1_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/FPAS_3/FPAS_3_clipped.2_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./FPAS_3_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/FPAS_4/FPAS_4_clipped.1_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/FPAS_4/FPAS_4_clipped.2_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./FPAS_4_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/FPAS_5/FPAS_5_clipped.1_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/FPAS_5/FPAS_5_clipped.2_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./FPAS_5_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/PBS_2/PBS_2_clipped.1_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/PBS_2/PBS_2_clipped.2_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./PBS_2_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/PBS_3/PBS_3_clipped.1_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/PBS_3/PBS_3_clipped.2_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./PBS_3_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/PBS_4/PBS_4_clipped.1_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/PBS_4/PBS_4_clipped.2_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./PBS_4_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/PBS_5/PBS_5_clipped.1_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_post_trim/result/PBS_5/PBS_5_clipped.2_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./PBS_5_fq.pbs 
fi

