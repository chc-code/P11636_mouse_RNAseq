This repo contains the codes used for P11636 project.

# RNA-seq Pipeline  

This RNA-seq analysis is performed using [CQSperl](https://github.com/shengqh/cqsperl) via the `performRNASeq_gencode_mm10` function.  

The main pipeline configuration file is:  
**`20240801_11636_RNAseq_mouse.rnaseq.pl`**  

Executing this file generates analysis scripts, which can then be submitted to the **SLURM** system. All step-specific scripts are collected in the `pipeline_codes` folder.  

### Pipeline Workflow  

The pipeline consists of the following steps:  

1. **Paired-end validation** – Verifies paired-end sequencing data for each sample.  
2. **FastQC (raw)** – Quality control of raw FASTQ files.  
3. **Cutadapt** – Trims adapter sequences from reads.  
4. **Cutadapt validation** – Ensures trimming success.  
5. **FastQC (post-trimming)** – Quality control after adapter trimming.  
6. **FastQC summary** – Generates a QC report for all samples.  
7. **STAR + featureCounts** – Maps reads to the reference genome and quantifies gene expression.  
8. **Gene table generation** – Creates the gene count table.  
9. **DESeq2** – Performs differential expression analysis.  
10. **WebGestalt ORA** – Over-representation pathway enrichment analysis.  
11. **GSEA** – Gene set enrichment analysis (GSEA) using all genes from DESeq2 results.  
12. **Final report** – Compiles results into a summary report.  

---

# Additional Enrichment Analysis  

Beyond the default ORA and GSEA pathway enrichment analyses, we implemented additional enhancements. The corresponding code and dependency files are stored in the enrichment_plots folder.

### 1. Expanded Gene Sets  
Additional gene sets for pathway enrichment analysis are available in `enrichment_plots/geneset/`:  

- **Custom gene sets:**  
  - Actin_Cell_Mobility  
  - EMT  
  - PI3K  
  - Integrin  
  - Wnt_signaling  
  - P53_signaling  
  - Innate_immune_response  

- **Publicly available gene sets:**  
  - Hallmark Genes (MSigDB)  
  - Curated Gene Sets (MSigDB)  
  - Regulatory Target Gene Sets (MSigDB)  
  - Ontology Gene Sets (MSigDB)  
  - Cell Type Signature Gene Sets (MSigDB)  
  - GO_BP, GO_CC, GO_MF (WebGestaltR)  
  - KEGG (WebGestaltR)  
  - Reactome (WebGestaltR)  
  - WikiPathways (WebGestaltR)  

### 2. Figure Style Enhancements  
Figures have been optimized for clarity and presentation.  

### 3. Pathway Visualization (Pathview)  
Pathway-specific visualizations are generated for:  

- **mmu04310** – Wnt signaling pathway  
- **mmu04810** – Regulation of actin cytoskeleton  
- **mmu04151** – PI3K-Akt signaling pathway  
- **mmu04115** – p53 signaling pathway  

### Running the Enrichment Analysis  

1. Run **`run_webgestaltr_and_GSEA.r`** to generate ORA and GSEA results.  
2. Render **`enrichment_plots/heather_report.rmd`** to generate an HTML report.  

