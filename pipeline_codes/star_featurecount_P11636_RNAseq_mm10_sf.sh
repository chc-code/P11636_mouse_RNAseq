MYCMD="sbatch" 

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/FPAS_2.count ]]; then
  $MYCMD ./FPAS_2_sf.pbs 
fi

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/FPAS_3.count ]]; then
  $MYCMD ./FPAS_3_sf.pbs 
fi

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/FPAS_4.count ]]; then
  $MYCMD ./FPAS_4_sf.pbs 
fi

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/FPAS_5.count ]]; then
  $MYCMD ./FPAS_5_sf.pbs 
fi

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_2.count ]]; then
  $MYCMD ./PBS_2_sf.pbs 
fi

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_3.count ]]; then
  $MYCMD ./PBS_3_sf.pbs 
fi

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_4.count ]]; then
  $MYCMD ./PBS_4_sf.pbs 
fi

if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/star_featurecount/result/PBS_5.count ]]; then
  $MYCMD ./PBS_5_sf.pbs 
fi
exit 0
