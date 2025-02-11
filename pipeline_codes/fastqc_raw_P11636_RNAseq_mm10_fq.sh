MYCMD="sbatch" 

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/FPAS_2/11636-CP-0007_S1_L005_R1_001_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/FPAS_2/11636-CP-0007_S1_L005_R2_001_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./FPAS_2_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/FPAS_3/11636-CP-0008_S1_L005_R1_001_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/FPAS_3/11636-CP-0008_S1_L005_R2_001_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./FPAS_3_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/FPAS_4/11636-CP-0009_S1_L005_R1_001_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/FPAS_4/11636-CP-0009_S1_L005_R2_001_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./FPAS_4_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/FPAS_5/11636-CP-0010_S1_L005_R1_001_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/FPAS_5/11636-CP-0010_S1_L005_R2_001_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./FPAS_5_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/PBS_2/11636-CP-0002_S1_L005_R1_001_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/PBS_2/11636-CP-0002_S1_L005_R2_001_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./PBS_2_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/PBS_3/11636-CP-0003_S1_L005_R1_001_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/PBS_3/11636-CP-0003_S1_L005_R2_001_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./PBS_3_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/PBS_4/11636-CP-0004_S1_L005_R1_001_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/PBS_4/11636-CP-0004_S1_L005_R2_001_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./PBS_4_fq.pbs 
fi


if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/PBS_5/11636-CP-0005_S1_L005_R1_001_fastqc/fastqc_data.txt || ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw/result/PBS_5/11636-CP-0005_S1_L005_R2_001_fastqc/fastqc_data.txt ]]; then
  $MYCMD ./PBS_5_fq.pbs 
fi

