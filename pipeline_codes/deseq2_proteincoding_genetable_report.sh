
cd /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result

Rscript --vanilla -e "library('rmarkdown');rmarkdown::render('DESeq2.rmd',output_file='P11636_RNAseq_mm10.deseq2.html')"
