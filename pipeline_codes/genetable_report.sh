
cd /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/genetable/result

Rscript --vanilla  -e "library('rmarkdown');rmarkdown::render('CountTableGroupCorrelation.Rmd',output_file='P11636_RNAseq_mm10.html')"

