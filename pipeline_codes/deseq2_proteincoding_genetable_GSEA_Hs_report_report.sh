
cd /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_GSEA_Hs_report/result

Rscript --vanilla  -e "library('rmarkdown');rmarkdown::render('GSEAReport.Rmd',output_file='P11636_RNAseq_mm10.gsea.html')"

