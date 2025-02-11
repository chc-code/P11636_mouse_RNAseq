# RNAseq pipeline
The RNAseq is performed by [CQSperl](https://github.com/shengqh/cqsperl) using function of `performRNASeq_gencode_mm10`
The main pipeline config file is `20240801_11636_RNAseq_mouse.rnaseq.pl`

After executing the config file, the scripts will be created and ready to be submitted to the SLURM system.
The scripts of each step were collected to `pipeline_codes` folder.

Basically, the pipeline includes below steps
1. paired_end_validation for each sample
2. fastqc_raw: QC step for each sample
3. cutadapt: trimming the adapter sequence from fastq files
4. cutadapt result validation
5. fastqc after the cutadapt step
6. fastqc_raw_summary: building QC report for all samples
7. star_featurecount:  mapping the reads to reference genome features
8. genetable: create the gene count table
9. DESeq2: differential analysis
10. WebGestalt: ORA pathway enrichment
11. GSEA: gene set enrichment analysis using all genes from the DESeq2 results
12. Final Report


# Extra Enrichment Analysis
In addition to the default pathway enrichment (ORA and GSEA) from above pipeline, we added below items
1. More GeneSets from multiple sources are included (the gmt and description files are under `enrichment_plots/geneset`)
        - Actin_Cell_Mobility (customized)
        - EMT (customized)
        - PI3K (customized)
        - Integrin (customized)
        - Wnt_signaling (customized)
        - P53_signaling (customized)
        - Innate_immune_response (customized)
        - HallmarkGenes (from msigdb)
        - CuratedGeneSets (from msigdb)
        - RegulatoryTargetGeneSets (from msigdb)
        - OntologyGeneSets (from msigdb)
        - CellTypeSignatureGeneSets (from msigdb)
        - GO_BP (from webgestaltR)
        - GO_CC (from webgestaltR)
        - GO_MF (from webgestaltR)
        - KEGG (from webgestaltR)
        - Reactome (from webgestaltR)
        - Wikipathway (from webgestaltR)
2. Style adjustment for the figures
3. PathView plots for
    1. 'mmu04310', 'Wnt signaling pathway'
    2. 'mmu04810', 'Regulation of actin cytoskeleton'
    3. 'mmu04151', 'PI3K-Akt signaling pathway'
    4. 'mmu04115', 'p53 signaling pathway'


First, `run_webgestaltr_and_GSEA.r` need to be performed to generate the ORA and GSEA results for each dataset.
After that, `enrichment_plots/heather_report.rmd` can be rendered to build the html report file.
