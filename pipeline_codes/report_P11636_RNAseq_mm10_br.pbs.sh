
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/report/result'

set -o pipefail


cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result/FPAS_VS_PBS_min5_fdr0.1_DESeq2-vsd.csv P11636_RNAseq_mm10 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result/FPAS_VS_PBS_min5_fdr0.1_DESeq2.csv P11636_RNAseq_mm10 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result/FPAS_VS_PBS_min5_fdr0.1_DESeq2_sig.csv P11636_RNAseq_mm10 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_GSEA_Hs/result/FPAS_VS_PBS.gsea P11636_RNAseq_mm10/gsea 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt/result/Project_FPAS_VS_PBS_geneontology_Biological_Process P11636_RNAseq_mm10/webGestalt 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt/result/Project_FPAS_VS_PBS_geneontology_Cellular_Component P11636_RNAseq_mm10/webGestalt 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt/result/Project_FPAS_VS_PBS_geneontology_Molecular_Function P11636_RNAseq_mm10/webGestalt 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt/result/Project_FPAS_VS_PBS_pathway_KEGG P11636_RNAseq_mm10/webGestalt 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt_link_deseq2/result/P11636_RNAseq_mm10.webgestalt.html P11636_RNAseq_mm10/webGestalt 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/genetable/result/P11636_RNAseq_mm10.count P11636_RNAseq_mm10 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/genetable/result/P11636_RNAseq_mm10.fpkm.tsv P11636_RNAseq_mm10 
cp -r -u /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/genetable/result/P11636_RNAseq_mm10.proteincoding.count P11636_RNAseq_mm10 

R -e "library(knitr);rmarkdown::render('P11636_RNAseq_mm10.Rmd');"
