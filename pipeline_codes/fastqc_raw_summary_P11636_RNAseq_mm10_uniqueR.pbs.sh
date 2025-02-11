
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastqc_raw_summary/result'

set -o pipefail



python3 /data/cqs/softwares/ngsperl/lib/QC/fastQCSummary.py -i fileList1.txt -o P11636_RNAseq_mm10.FastQC      


Rscript --vanilla  P11636_RNAseq_mm10.r

Rscript --vanilla  -e "library('rmarkdown');rmarkdown::render('fastQCSummary.Rmd',output_file='P11636_RNAseq_mm10.FastQC.html')"





