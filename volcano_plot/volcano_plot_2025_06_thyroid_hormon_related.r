library(ggplot2)
library(scales)
library(dplyr)
library(EnhancedVolcano) # used to add more annotations
library(ggrepel)


# the working path of volcano plot in ACCRE is /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/deseq2_proteincoding_genetable/result
setwd('/Users/files/work/cooperate/vivian/heather_rnaseq_redo_figure/20240801_11636_RNAseq_mouse/volcano_plot')
comparisonNames <- 'FPAS_VS_PBS'
enhanced_volcano_red_blue_only=TRUE
title_in_volcano=TRUE
caption_in_volcano=TRUE

fn_deseq2 <- 'FPAS_VS_PBS_min5_fdr0.1_DESeq2.csv'
tbb <- read.delim(fn_deseq2, header=T, row.names=1, check.names=F, sep=",", stringsAsFactors = F)

#volcano plot
useRawPvalue<-0
pvalue<-0.1
foldChange<-1.5
minMedianInGroup<-5
# prefix <- 'FPAS_VS_PBS_min5_fdr0.1'
prefix <- 'FPAS_VS_PBS'

if(useRawPvalue == 1){
pCutoffCol="pvalue"
}else{
pCutoffCol="padj"
}

thyroid_hormon_related_genes <- c("Atp1b2", "Ghr", "Six1", "Rdx", "Pfkm")

changeColours<-c(grey="grey",blue="blue",red="red")
diffResult<-as.data.frame(tbb)
diffResult$log10BaseMean<-log10(diffResult$baseMean)
diffResult$colour<-"grey"



hormone_genes_color <- 'green'
diffResult<-subset(diffResult, !is.na(diffResult[[pCutoffCol]]))
diffResult$colour[which(diffResult[[pCutoffCol]]<=pvalue & diffResult$log2FoldChange>=log2(foldChange))]<-"red"
diffResult$colour[which(diffResult[[pCutoffCol]]<=pvalue & diffResult$log2FoldChange<=-log2(foldChange))]<-"blue"
# for the genes in thyroid_hormon_related_genes, set color to hormone_genes_color
diffResult$colour[which(diffResult$Feature_gene_name %in% thyroid_hormon_related_genes)] <- hormone_genes_color


diffResult$colour=factor(diffResult$colour,levels=c("grey","blue","red", hormone_genes_color))
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
    names(keyvals.colour)[keyvals.colour == hormone_genes_color] <- 'Thyroid Hormone Related'
}else{
    keyvals.colour=NULL
}

if(title_in_volcano){
    title=gsub("_VS_", " vs ", comparisonNames)
    title <- paste0(title, '\nThyroid Hormone Related Genes')
}else{
    title=NULL
}

if(caption_in_volcano){
    caption=paste0("total = ", nrow(diffResult), " variables")
}else{
    caption=NULL
}

diffResult$Short_name<-gsub(";.+","", diffResult$Feature_gene_name)


diffResult <- diffResult %>%
    mutate(logP = -log10(pvalue))
    
top_up <- diffResult %>% 
    filter(log2FoldChange > log2(foldChange)) %>%
    arrange(desc(logP)) %>%
    head(5)

top_down <- diffResult %>% 
    filter(log2FoldChange < -log2(foldChange)) %>%
    arrange(desc(logP)) %>%
    head(5)
# add KLHL23 to the top_up
klh = diffResult %>% filter(Feature_gene_name == "Klhl23")
thyroid_hormon_rows = diffResult %>% filter(Feature_gene_name %in% thyroid_hormon_related_genes)
# selected_genes <- bind_rows(top_up, top_down, klh, thyroid_hormon_rows)
selected_genes <- thyroid_hormon_rows


# functions
openPlot<-function(filePrefix, format, width_inch, height_inch, figureName){
  fileName<-paste0(filePrefix, ".", tolower(format))
  if(format == "PDF"){
    pdf(fileName, width=width_inch, height=height_inch, useDingbats=FALSE)
  }else if(format == "TIFF"){
    tiff(filename=fileName, width=width_inch, height=height_inch, units="in", res=300)
  }else {
    png(filename=fileName, width=width_inch, height=height_inch, units="in", res=300)
  }
  cat("saving", figureName, "to ", fileName, "\n")
}

drawPlot<-function(filePrefix, outputFormat, width_inch, height_inch, p, figureName){
  for(format in outputFormat){  
    openPlot(filePrefix, format, width_inch, height_inch, figureName)  
    print(p)
    dev.off()
  }
}

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
    labSize = 9.0,
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
      # change x and y axis font size
    theme(plot.title = element_text(hjust = 0.5), axis.text.x = element_text(size = 22), axis.text.y = element_text(size = 22))
  

# Add labels for the most significant 10 upregulated & 10 downregulated genes
pnew <- p + 
    geom_label_repel(
        data = selected_genes, 
        aes(x = log2FoldChange, y = logP, label = Short_name),
        size = 7,
        nudge_y = 2,  
        nudge_x = 0.5,  
        direction = "both",  
        segment.color = "black",  
        segment.size = 0.3,  
        box.padding = 0.5,  
        point.padding = 0.3,  
        max.overlaps = Inf,  # Ensure all selected genes are labeled
        force = 4,
        min.segment.length = 0.2
    )



# Save the improved plot
outputFormat <- c("PDF", "TIFF")
filePrefix <- paste0(prefix, "_Thyroid_Hormone_Related_Genes.volcano")
drawPlot(filePrefix, outputFormat, 7, 7, pnew, "Volcano")


# draw dotplot for thyroid hormone related genes, dot size = log10P, x axis = log2FC, y = feature gene name
# sort by log2FoldChange
dotplot_data <- diffResult %>%
    filter(Feature_gene_name %in% thyroid_hormon_related_genes) %>%
    mutate(logP = -log10(pvalue)) %>%
    arrange(log2FoldChange)    

dotplot_data$Short_name <- factor(dotplot_data$Short_name, levels = rev(unique(dotplot_data$Short_name)))

dotplot <- ggplot(dotplot_data, aes(x = log2FoldChange, y = Short_name)) +
    geom_point(aes(size = logP), color="blue", alpha = 0.7) +
    scale_size_continuous(range = c(1, 10)) +  # Adjust size range as needed
    # scale_color_manual(values = changeColours) +
    labs(title = "Thyroid Hormone Related Genes",
         x = xname,
         y = "Gene Name",
         size = "-log10(p-value)") +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5),
          axis.text.x = element_text(size = 14),
          axis.text.y = element_text(size = 14))
# Save the dotplot
dotplot_filePrefix <- paste0(prefix, "_Thyroid_Hormone_Related_Genes.dotplot")
drawPlot(dotplot_filePrefix, outputFormat, 7, 7, dotplot, "Thyroid Hormone Related Genes Dotplot")
