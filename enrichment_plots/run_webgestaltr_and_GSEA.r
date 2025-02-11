setwd('/Users/files/work/cooperate/vivian/heather_rnaseq_redo_figure/20240801_11636_RNAseq_mouse/report')

library(knitr)
library(WebGestaltR)

options(bitmapType='cairo')
knitr::opts_chunk$set(
  include=TRUE, 
  echo=FALSE, 
  warning=FALSE, 
  message=FALSE, 
  results="asis"
)
source("WebGestaltReportFunctions.r")
source('function_chc.r')
myoptions=read_file_map("fileList3.txt", do_unlist=FALSE)
task_name=myoptions$task_name


# dir = /Users/files/work/cooperate/vivian/heather_rnaseq_redo_figure/20240801_11636_RNAseq_mouse/report
fdrthres <- 0.5
organism <- 'mmusculus'
sampleName <- 'FPAS_VS_PBS'
geneFile <- 'FPAS_VS_PBS_min5_fdr0.1_DESeq2_sig_genename.txt'
genes<-readLines(geneFile)
genes=unique(genes)

sampleName <- 'FPAS_VS_PBS'
outputDirectory = '.'
interestGeneType = 'genesymbol'
referenceSet = 'genome'

# '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result/FPAS_VS_PBS_min5_fdr0.1_DESeq2_sig_genename.txt'
enrichDatabases <- list(
        c('actin.symbols.gmt', 'Actin_Cell_Mobility', 'genesymbol'), 
        c('EMT.symbols.gmt', 'EMT', 'genesymbol'), 
        c('PI3K.symbols.gmt', 'PI3K', 'genesymbol'), 
        c('integrin.symbols.gmt', 'Integrin', 'genesymbol'), 
        c('Wnt_signaling.gmt', 'Wnt_signaling', 'genesymbol'),
        c('P53.gmt', 'P53_signaling', 'genesymbol'),
        c('Innate_immune.gmt', 'Innate_immune_response', 'genesymbol'),

        # from msigdb
        c('mh.all.v2024.1.Mm.symbols.gmt', 'HallmarkGenes', 'genesymbol'), 
        c('m2.all.v2024.1.Mm.symbols.gmt', 'CuratedGeneSets', 'genesymbol'), 
        c('m3.all.v2024.1.Mm.symbols.gmt', 'RegulatoryTargetGeneSets', 'genesymbol'),
        c('m5.all.v2024.1.Mm.symbols.gmt', 'OntologyGeneSets', 'genesymbol'),
        c('m8.all.v2024.1.Mm.symbols.gmt', 'CellTypeSignatureGeneSets', 'genesymbol'),

        # from  webgestaltR
        c('mmusculus_geneontology_Biological_Process.symbols.gmt', 'GO_BP', 'genesymbol'),
        c('mmusculus_geneontology_Cellular_Component.symbols.gmt', 'GO_CC', 'genesymbol'),
        c('mmusculus_geneontology_Molecular_Function.symbols.gmt', 'GO_MF', 'genesymbol'),
        c('mmusculus_kegg_scrapy.symbols.gmt', 'KEGG', 'genesymbol'),
        c('mmusculus_pathway_Reactome.symbols.gmt', 'Reactome', 'genesymbol'),
        c('mmusculus_pathway_Wikipathway.symbols.gmt', 'Wikipathway', 'genesymbol')
)
# enrichDatabases <- list(
#           c('mmusculus_kegg_scrapy.symbols.gmt', 'KEGG', 'genesymbol'),
#         c('mmusculus_pathway_Reactome.symbols.gmt', 'Reactome', 'genesymbol'),
#         c('mmusculus_pathway_Wikipathway.symbols.gmt', 'Wikipathway', 'genesymbol')
# )



# --args mmusculus FPAS_VS_PBS FPAS_VS_PBS_min5_fdr0.1_DESeq2_sig_genename.txt . genesymbol genome

# organism = args[1] #hsapiens
# sampleName=args[2]
# geneFile = args[3]
# outputDirectory = args[4]
# interestGeneType = args[5]
# referenceSet = args[6]


preRankedGeneFile = 'FPAS_VS_PBS_min5_fdr0.1_DESeq2_GSEA.rnk'
gseaJar <- 'gsea-cli.sh'
# enrichDatabase <- 'geneset/mmusculus_geneontology_Cellular_Component_entrezgene.gmt'
ele <- enrichDatabases[[1]]
for(ele in enrichDatabases){
    enrichDatabase <- paste0('geneset/', ele[1])
    geneset_shortname <- ele[2]
    enrichDatabaseType <- ele[3]
    
    fn_lb <- sub("\\.symbols\\.gmt$", "", enrichDatabase)
    fn_lb <- sub("_entrezgene\\.gmt$", "", fn_lb)
    fn_lb <- sub("\\.gmt$", "", fn_lb)

    enrichDatabaseDescriptionFile <- paste0(fn_lb, '_description.des')
    cat("now processing: ", enrichDatabase, "\n")

    temp=WebGestaltR(enrichMethod="ORA",organism=organism,
                enrichDatabaseFile=enrichDatabase,interestGene=genes,
                enrichDatabaseType=enrichDatabaseType,
                enrichDatabaseDescriptionFile=enrichDatabaseDescriptionFile,
                interestGeneType=interestGeneType,referenceSet=referenceSet,
                isOutput=TRUE,minNum=5,
                fdrThr=fdrthres,
                outputDirectory=outputDirectory,projectName=paste0(sampleName, "_", enrichDatabase))

    # save result to tsv file, temp is a data frame
    write.table(temp, file=paste0(outputDirectory, "/", "enrichment_",  geneset_shortname, ".tsv"), sep="\t", quote=FALSE, row.names=FALSE)

    # run the GSEA
    gesaResultDir <- 'gsea'
    runCommand=paste0(gseaJar," GseaPreranked")
    runCommand = paste0(runCommand, " -gmx ", enrichDatabase, " -rnk \"",preRankedGeneFile,"\" -rpt_label ",geneset_shortname," -scoring_scheme weighted -make_sets true -nperm 1000 -plot_top_x 20 -set_max 500 -set_min 15 -mode Abs_max_of_probes -zip_report false -norm meandiv -create_svgs false -include_only_symbols true -rnd_seed timestamp -out \"", gesaResultDir, "\"")
    # print(runCommand)
    system(runCommand)
}




