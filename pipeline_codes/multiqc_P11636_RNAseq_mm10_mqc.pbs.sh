
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/multiqc/result'

set -o pipefail



if [[ -s P11636_RNAseq_mm10.html ]]; then
  rm -rf P11636_RNAseq_mm10_data P11636_RNAseq_mm10_plots P11636_RNAseq_mm10.html
fi

multiqc  -f -p -n P11636_RNAseq_mm10.html /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse 
