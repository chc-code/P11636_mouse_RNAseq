
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/sequencetask/result'

set -o pipefail


R --vanilla --slave -f /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/sequencetask/result/P11636_RNAseq_mm10_summary.r 
R --vanilla --slave -f /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/sequencetask/result/P11636_RNAseq_mm10_report.r 
