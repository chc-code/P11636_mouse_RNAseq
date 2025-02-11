
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt/result'

set -o pipefail


 
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt/result/Project_FPAS_VS_PBS_pathway_KEGG/enrichment_results_FPAS_VS_PBS_pathway_KEGG.txt || ! -d /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt/result/Project_FPAS_VS_PBS_pathway_KEGG/enrichment_results_FPAS_VS_PBS_pathway_KEGG.txt ]]; then
  cd /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt/result 
  if [[ -f /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result/FPAS_VS_PBS_min5_fdr0.1_DESeq2_sig_genename.txt ]]; then
    if [[ -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result/FPAS_VS_PBS_min5_fdr0.1_DESeq2_sig_genename.txt ]]; then
      R --vanilla -f /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable_WebGestalt/result/P11636_RNAseq_mm10.WebGestaltR.r --args mmusculus FPAS_VS_PBS /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result/FPAS_VS_PBS_min5_fdr0.1_DESeq2_sig_genename.txt . genesymbol genome
      rm -f */*/*.zip
    else
      echo "Empty gene file" > FPAS_VS_PBS.empty
    fi 
  else
    echo "Gene file not exist: /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result/FPAS_VS_PBS_min5_fdr0.1_DESeq2_sig_genename.txt" .
  fi
fi

