
updateEnrichedTable<-function(enriched){
	rowCount<-nrow(enriched)

	enriched$tblShortCaption<-apply(enriched, 1, function(x){tabRef(paste0("enriched ",x["geneSet"]))})
	enriched$tblLongCaption<-apply(enriched, 1, function(x){tabRef(paste0("enriched ",x["geneSet"]), paste0("Significantly differential expressed genes in ",x["description"]))})
	enriched$tblLink<-tolower(gsub(' ','', enriched$tblShortCaption))

	for(idx in c(1:rowCount)){
		entry<-enriched[idx,]
		enriched$link[idx]<-paste0("[", entry$tblShortCaption, "](#", entry$tblLink, ")")
	}

	return(enriched)
}

readFilesAndFormat=function(compDeseq2File) {
  library(data.table)
  library(dplyr)
  library(tibble)
  deseq2<-data.frame(fread(compDeseq2File, header=T), row.names=1)
  
  deseq2_columns = c("Feature_gene_name", "baseMean", "pvalue", "padj", "FoldChange")
  if (all(deseq2_columns %in% colnames(deseq2))) { #DESeq2 result format
    deseq2<-deseq2[,deseq2_columns ]
  }else if(all(c("logFC", "logCPM", "PValue", "FDR") %in% colnames(deseq2))) { #edgeR result format
    deseq2 = deseq2 %>% tibble::rownames_to_column(var="GENE") %>%
              dplyr::mutate(FoldChange = 2**logFC) %>%
              dplyr::select(GENE, everything())              
  }
  return(deseq2)
}

getDiffCol=function(deseq2) {
  result=list()
  if ("FoldChange" %in% colnames(deseq2)) {
    result[["colName"]]="FoldChange"
    result[["centerValue"]]=1
  } else if ("meth.diff" %in% colnames(deseq2)) {
    result[["colName"]]="meth.diff"
    result[["centerValue"]]=0
  } else {
    stop("Can't find diff column")
  }
  return(result)
}

getGeneCol=function(deseq2) { #try to find gene column
  result=list()
  
  result[["colName"]]=-1
  if (ncol(deseq2)==1) {
    result[["colName"]]=1
  } else if ("Feature_gene_name" %in% colnames(deseq2)) { #deseq2 result format
    result[["colName"]]="Feature_gene_name"
  } else if ("Hugo_Symbol" %in% colnames(deseq2)) { #maf file
    result[["colName"]]="Hugo_Symbol"
  } else { #other formats
    geneInd=grep("Gene|gene|GENE",colnames(deseq2))
    if (length(geneInd)>0) { #first column name with "gene"
      result[["colName"]]=geneInd[1]
    } else { 
      colClass<-sapply(deseq2, class)
      countNotNumIndex<-which((colClass!="numeric" & colClass!="integer"))
      if(length(countNotNumIndex)>0) {
        result[["colName"]]=countNotNumIndex[1]
      }else{
        result[["colName"]]=-1
      }
    }
  }
  return(result)
}

readFilesAndFormat=function(compDeseq2File) {
  if (grepl(".csv$",basename(compDeseq2File))) { #csv file
    readFun<-function(...) read.csv(...)
  } else {
    readFun<-function(...) read.table(...,sep="\t")
  }
  deseq2<-try(readFun(compDeseq2File, header=T, row.names=1, stringsAsFactors = F),silent=TRUE)
  if (class(deseq2)=="try-error") {
    deseq2<-try(readFun(compDeseq2File, header=T, stringsAsFactors = F))
  }
  
  if (all(c("Feature_gene_name", "baseMean", "pvalue", "padj", "FoldChange") %in% colnames(deseq2))) { #DESeq2 result format
    deseq2<-deseq2[,c("Feature_gene_name", "baseMean", "pvalue", "padj", "FoldChange") ]
  }else if(all(c("logFC", "logCPM", "F", "PValue", "FDR") %in% colnames(deseq2))) {
    deseq2$GENE<-rownames(deseq2)
    deseq2$FoldChange=2**deseq2$logFC
    deseq2=deseq2[c("GENE", "logFC", "logCPM", "F", "PValue", "FDR", "FoldChange")]
  }
  return(deseq2)
}

getDiffCol=function(deseq2) {
  result=list()
  if ("FoldChange" %in% colnames(deseq2)) {
    result[["colName"]]="FoldChange"
    result[["centerValue"]]=1
  } else if ("meth.diff" %in% colnames(deseq2)) {
    result[["colName"]]="meth.diff"
    result[["centerValue"]]=0
  }
  return(result)
}


getGeneCol=function(deseq2) { #try to find gene column
  result=list()
  
  if (ncol(deseq2)==1) {
    result[["colName"]]=1
  } else if ("Feature_gene_name" %in% colnames(deseq2)) { #deseq2 result format
    result[["colName"]]="Feature_gene_name"
  } else if ("Hugo_Symbol" %in% colnames(deseq2)) { #maf file
    result[["colName"]]="Hugo_Symbol"
  } else { #otehr formats
    geneInd=grep("Gene|gene|GENE",colnames(deseq2))
    if (length(geneInd)>0) { #first column name with "gene"
      result[["colName"]]=geneInd[1]
    } else { 
      #guess gene column, by contents with both number and character (so not all numeric data, can be gene IDs)
      #also want column with many unique values (so that won't be columns like sample names)
      geneInd=which.max(apply(deseq2[-1,],2,function(x) 
        min(length(intersect(grep("[a-zA-Z][a-zA-Z]",x),grep("[0-9]",x))),length(unique(x)))
        ))
      result[["colName"]]=geneInd[1]
    }
  }
  return(result)
}
options(bitmapType='cairo')

library(WebGestaltR)

httr::set_config(httr::config(ssl_verifypeer = FALSE))

args = commandArgs(trailingOnly=TRUE)
organism = args[1] #hsapiens
sampleName=args[2]
geneFile = args[3]
outputDirectory = args[4]
interestGeneType = args[5]
referenceSet = args[6]

cat("organism=", organism, "\n")
cat("sampleName=", sampleName, "\n")
cat("geneFile=", geneFile, "\n")
cat("outputDirectory=", outputDirectory, "\n")

if(!exists("interestGeneType")){
  interestGeneType="genesymbol"
}

if(!exists("referenceSet")){
  referenceSet="genome"
}
cat("interestGeneType=", interestGeneType, "\n")
cat("referenceSet=", referenceSet, "\n")

info = file.info(geneFile)
if (all(is.na(info$size))) {
  stop(paste0("Gene file is not exist: ", geneFile, "\n"))
}

if (all(info$size == 0)) {
  stop(paste0("Gene file is empty: ", geneFile, "\n"))
}

if (grepl(".csv$",basename(geneFile))) { #csv file
  geneList<-read.csv(geneFile,header=TRUE,stringsAsFactors=FALSE)
} else {
  geneList<-read.table(geneFile,header=TRUE,sep="\t",stringsAsFactors=FALSE)
}

if (ncol(geneList)==1) {
  genes<-readLines(geneFile)
} else { #try to find gene column
  geneCol=getGeneCol(geneList)[["colName"]]
  genes<-geneList[,geneCol]
}
genes=unique(genes)

if(length(genes) < 10){
  writeLines("Less than 10 DE genes, ignored.", paste0(sampleName, ".empty"))
}else{
  enrichDatabases<-c("geneontology_Biological_Process", 
                    "geneontology_Cellular_Component", 
                    "geneontology_Molecular_Function",
                    "pathway_KEGG" 
                    #"pathway_Wikipathway", 
                    #"network_miRNA_target",
                    #"network_PPI_BIOGRID", 
                    #"network_Transcription_Factor_target"
  )

  for(enrichDatabase in enrichDatabases){
    temp=WebGestaltR(enrichMethod="ORA",organism=organism,
              enrichDatabase=enrichDatabase,interestGene=genes,
              interestGeneType=interestGeneType,referenceSet=referenceSet,
              isOutput=TRUE,minNum=5,
              outputDirectory=outputDirectory,projectName=paste0(sampleName, "_", enrichDatabase))
    if (is.null(temp)) { #no enrichment. report top 5 categories
      warning(paste0("No significant category (FDR<=0.05) identified in ",enrichDatabase,", reporting top 10 categories instead."))
      temp=WebGestaltR(enrichMethod="ORA",organism=organism,
                      enrichDatabase=enrichDatabase,interestGene=genes,
                      interestGeneType=interestGeneType,referenceSet=referenceSet,
                      isOutput=TRUE,minNum=5,
                      outputDirectory=outputDirectory,projectName=paste0(sampleName, "_", enrichDatabase),
                      sigMethod="top",topThr=10)
    }
  }
}

webGestaltR_version<-paste0('WebGestaltR,v', packageVersion('WebGestaltR'))
writeLines(webGestaltR_version, 'WebGestaltR.version')
