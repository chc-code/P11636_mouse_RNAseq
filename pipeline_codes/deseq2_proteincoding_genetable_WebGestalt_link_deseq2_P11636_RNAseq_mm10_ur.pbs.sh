
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt_link_deseq2/result'

set -o pipefail



R -e "library(knitr);rmarkdown::render('P11636_RNAseq_mm10.webgestalt.rmd');"
