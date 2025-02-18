library(ggplot2)
library(scales)
library(dplyr)
library(EnhancedVolcano) # used to add more annotations

# the working path of volcano plot in ACCRE is /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result

comparisonNames <- 'FPAS_VS_PBS'
enhanced_volcano_red_blue_only=FALSE
title_in_volcano=TRUE
caption_in_volcano=TRUE

fn_deseq2 <- 'FPAS_VS_PBS_min5_fdr0.1_DESeq2.csv'
tbb <- read.delim(fn_deseq2, header=T, row.names=1, check.names=F, sep=",", stringsAsFactors = F)

#volcano plot
useRawPvalue<-0
pvalue<-0.1
foldChange<-1.5
minMedianInGroup<-5
prefix <- 'FPAS_VS_PBS_min5_fdr0.1'

changeColours<-c(grey="grey",blue="blue",red="red")
diffResult<-as.data.frame(tbb)
diffResult$log10BaseMean<-log10(diffResult$baseMean)
diffResult$colour<-"grey"
if (useRawPvalue==1) {
  diffResult<-subset(diffResult, !is.na(pvalue))
  diffResult$colour[which(diffResult$pvalue<=pvalue & diffResult$log2FoldChange>=log2(foldChange))]<-"red"
  diffResult$colour[which(diffResult$pvalue<=pvalue & diffResult$log2FoldChange<=-log2(foldChange))]<-"blue"
} else {
  diffResult<-subset(diffResult, !is.na(padj))
  diffResult$colour[which(diffResult$padj<=pvalue & diffResult$log2FoldChange>=log2(foldChange))]<-"red"
  diffResult$colour[which(diffResult$padj<=pvalue & diffResult$log2FoldChange<=-log2(foldChange))]<-"blue"
}

diffResult$colour=factor(diffResult$colour,levels=c("grey","blue","red"))
diffResult$log10pvalue=-log10(diffResult$pvalue)
diffResult<-diffResult[order(diffResult$colour),]
diffResult$colour<-as.character(diffResult$colour)

# save to file
# write.csv(diffResult, file=paste0(prefix, "_DESeq2_volcanoPlot.csv"))

xname=bquote(log[2](fold~change))
yname=bquote(-log[10](p~value))


if(!("Feature_gene_name" %in% colnames(diffResult))){
    diffResult$Feature_gene_name=rownames(diffResult)
}

if(enhanced_volcano_red_blue_only){
    keyvals.colour=diffResult$colour
    names(keyvals.colour)[keyvals.colour == 'red'] <- 'Up'
    names(keyvals.colour)[keyvals.colour == 'grey'] <- 'NS'
    names(keyvals.colour)[keyvals.colour == 'blue'] <- 'Down'
}else{
    keyvals.colour=NULL
}

if(title_in_volcano){
    title=gsub("_VS_", " vs ", comparisonNames)
}else{
    title=NULL
}

if(caption_in_volcano){
    caption=paste0("total = ", nrow(diffResult), " variables")
}else{
    caption=NULL
}

diffResult$Short_name<-gsub(";.+","", diffResult$Feature_gene_name)

if(useRawPvalue == 1){
pCutoffCol="pvalue"
}else{
pCutoffCol="padj"
}

diffResult <- diffResult %>%
    mutate(logP = -log10(pvalue))
    
top_up <- diffResult %>% 
    filter(log2FoldChange > log2(foldChange)) %>%
    arrange(desc(logP)) %>%
    head(10)

top_down <- diffResult %>% 
    filter(log2FoldChange < -log2(foldChange)) %>%
    arrange(desc(logP)) %>%
    head(10)
selected_genes <- bind_rows(top_up, top_down)

# Generate the volcano plot with default annotation disabled
p <- EnhancedVolcano(
    diffResult,
    lab = NA,  # Disable default labels
    x = 'log2FoldChange',
    y = 'pvalue',
    pCutoff = pvalue,
    pCutoffCol = pCutoffCol,
    FCcutoff = log2(foldChange),
    pointSize = 1,
    labSize = 6.0,
    colCustom = keyvals.colour,
    colAlpha = 1,
    title = title,
    subtitle = NULL,
    caption = caption,
    drawConnectors = TRUE,
    widthConnectors = 0.5
) + 
    ylab(yname) + 
    xlab(xname) +
    theme(plot.title = element_text(hjust = 0.5))
    
    
# Add labels for the most significant 10 upregulated & 10 downregulated genes
pnew <- p + 
    geom_label_repel(
        data = selected_genes, 
        aes(x = log2FoldChange, y = logP, label = Short_name),
        size = 2.5,
        nudge_y = 2,  
        nudge_x = 0.5,  
        direction = "both",  
        segment.color = "black",  
        segment.size = 0.3,  
        box.padding = 0.5,  
        point.padding = 0.3,  
        max.overlaps = Inf,  # Ensure all selected genes are labeled
        force = 3,
        min.segment.length = 0.2
    )
    
# Save the improved plot
filePrefix <- paste0(prefix, "_DESeq2_volcanoEnhanced")
drawPlot(filePrefix, outputFormat, 7, 7, pnew, "Volcano")
