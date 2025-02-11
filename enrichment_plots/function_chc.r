library(ggplot2)
library(grid)
library(dplyr)
library(data.table)
library(cowplot)

# conda install -y bioconductor-complexheatmap r-ggextra r-patchwork
library(ggExtra)
library(ComplexHeatmap)
library(patchwork)


read_file_map<-function(file_list_path, sep="\t", header=F, do_unlist=TRUE){
  tbl=fread(file_list_path, header=header, data.table=FALSE)

  result<-split(tbl$V1, tbl$V2)
  if(do_unlist){
    result<-unlist(result)
  }
  return(result)
}

runGSEA<-function(preRankedGeneFile,resultDir=NULL,gseaJar="gsea-cli.sh",gseaDb="/data/cqs/references/gsea/v2022.1.Hs",
                  gseaCategories=c("h.all.v7.0.symbols.gmt"),
                  gseaReportTemplt="GSEAReport.Rmd",
                  makeReport=FALSE,
                  gseaChip) {
  fileToName=c(
    "h"="HallmarkGeneSets",
    "c1"="PositionalGeneSets",
    "c2"="CuratedGeneSets",
    "c3"="RegulatoryTargetGeneSets",
    "c4"="ComputationalGeneSets",
    "c5"="OntologyGeneSets",
    "c6"="OncogenicSignatureGeneSets",
    "c7"="ImmunologicSignatureGeneSets",
    "c8"="CellTypeSignatureGeneSets",
    "mh"="HallmarkGeneSets",
    "m1"="PositionalGeneSets",
    "m2"="CuratedGeneSets",
    "m3"="RegulatoryTargetGeneSets",
    "m5"="OntologyGeneSets",
    "m8"="CellTypeSignatureGeneSets")
  
  gsea_name=gsub("_min\\d+_fdr.*", "", basename(preRankedGeneFile))
  gsea_name=gsub("_GSEA.rnk", "", gsea_name)
  if (is.null(resultDir)) {
    gesaResultDir<-paste0(preRankedGeneFile,".gsea")
  } else {
    gesaResultDir<-paste0(resultDir,"/",gsea_name, ".gsea")
  }
  gesaResultDir<-str_replace_all(gesaResultDir, '[()]', '_')

  b_perform=TRUE
  if (file.exists(gesaResultDir)) {
    if(overwrite){
      warning(paste0(gesaResultDir," folder exists! Will delete all files in it and regenerate GSEA results."))
      unlink(gesaResultDir, recursive = TRUE)
    }else{
      b_perform=FALSE
    }
  }
  
  if(b_perform){
    gseaCategory=gseaCategories[1]
    for (gseaCategory in gseaCategories) {
      gseaCategoryName=strsplit(gseaCategory,"\\.")[[1]][1]
      if (gseaCategoryName %in% names(fileToName)) {
        gseaCategoryName<-fileToName[gseaCategoryName]
      }
      
      if (grepl("cli.sh", gseaJar) || (grepl("cli.bat", gseaJar))){
        runCommand=paste0(gseaJar," GseaPreranked")
      }else{
        runCommand=paste0("java -Xmx8198m -cp ",gseaJar," xtools.gsea.GseaPreranked") 
      }
      runCommand = paste0(runCommand, " -gmx ",gseaDb,"/",gseaCategory, " -rnk \"",preRankedGeneFile,"\" -rpt_label ",gseaCategoryName," -scoring_scheme weighted -make_sets true -nperm 1000 -plot_top_x 20 -set_max 500 -set_min 15 -mode Abs_max_of_probes -zip_report false -norm meandiv -create_svgs false -include_only_symbols true -rnd_seed timestamp -out \"", gesaResultDir, "\"")
      
      if(!is.na(gseaChip)){
        runCommand=paste0(runCommand, " -collapse Collapse -chip ", gseaChip)
      }else{
        runCommand=paste0(runCommand, " -collapse false")
      }
      print(runCommand)
      system(runCommand)
    }
  }

  resultDirSubs<-list.dirs(gesaResultDir,recursive=FALSE,full.names=TRUE)
  newResultDirSubs<-unlist(lapply(resultDirSubs, function(x) {
    newDir = gsub("\\.GseaPreranked.*", "", x)
    file.rename(x, newDir)
    return(newDir)
  }))
  
  dt<-data.frame(Folder=newResultDirSubs)
  #dt$GseaCategory<-gsub(paste0(gesaResultDir,"/"), "", dt$Folder)
  dt$GseaCategory<-basename(dt$Folder)
  write.csv(dt, file=paste0(gsea_name,".gsea.csv"), row.names=F)
  
  if (makeReport) {
    library('rmarkdown')
    rmarkdown::render(gseaReportTemplt,output_file=paste0(basename(preRankedGeneFile),".gsea.html"),output_dir=resultDir)
  }
  
  return(dt)
}


print1 <- function(...){
  tmpstr <- c("\n", c(...), "\n")
  cat(paste0(tmpstr, collapse = ""))
}

print0 <- function(...){
  return (paste0(c(...), collapse = ""))
}


add_img <- function(fno, width=900){
    cat("![](", fno, "){ width=", width, " }\n\n", sep = "")
}

plot_ora <- function(fno, enriched){

  topBy <- "FDR"
  colorBy <- "NegLog10pAdj"
  colorTitle <- "-log10(FDR)"
  top <- min(10, nrow(enriched))


  dataForPlotFrameP <- enriched %>%
    dplyr::mutate(coverage = overlap / size, NegLog10pAdj = -log10(FDR)) %>%
    dplyr::arrange(desc(topBy)) %>% 
    head(top) %>%
    dplyr::arrange(desc(coverage)) %>%
    as.data.frame()

  max_value <- max(dataForPlotFrameP[[colorBy]][is.finite(dataForPlotFrameP[[colorBy]])], na.rm = TRUE)


  # create a new column, if the lenght of the description is greater than 50,  use "geneSet" column othervise, use description column

  dataForPlotFrameP$description_new <- ifelse(
    is.na(dataForPlotFrameP$description) | nchar(as.character(dataForPlotFrameP$description)) > 100 | nchar(as.character(dataForPlotFrameP$description)) < 5, 
    dataForPlotFrameP$geneSet, 
    dataForPlotFrameP$description
  )
  
  dataForPlotFrameP$description_new <- gsub("\\[.*", "", dataForPlotFrameP$description_new)
  # trim the trailing non-work chars, including white space and dot and other symbols
  dataForPlotFrameP$description_new <- gsub("[^[:alnum:]]+$", "", dataForPlotFrameP$description_new)

  seen <- list()
  dataForPlotFrameP <- dataForPlotFrameP %>%
  mutate(description_new = sapply(description_new, function(x) {
      if (x %in% names(seen)) {
      seen[[x]] <<- seen[[x]] + 1
      new_x <- paste0(x, strrep(" ", seen[[x]]))  # Append zero-width spaces dynamically
      return(as.character(new_x))
      } else {
      seen[[x]] <<-  0
      return(as.character(x))
      }
  }))

  dataForPlotFrameP$description_new <- sprintf("%60s", substr(as.character(dataForPlotFrameP$description_new), 1, 60))

  # uniq_levels <- unique(dataForPlotFrameP$description_new)
  dataForPlotFrameP$description_new <- factor(dataForPlotFrameP$description_new, levels = rev(dataForPlotFrameP$description_new))


  xmin <- min(dataForPlotFrameP$coverage, na.rm = TRUE)
  xmax <- max(dataForPlotFrameP$coverage,na.rm = TRUE)
  gap <- xmax - xmin
  xmin <- xmin - gap * 0.2
  xmax <- xmax + gap * 0.1

  p <- ggplot(dataForPlotFrameP, aes(x = description_new, y = coverage, colour = !!sym(colorBy))) +
    geom_point(aes(size = size)) + 
    scale_y_continuous(limits = c(xmin, xmax)) +
    coord_flip() +
    xlab("") +
    ylab("Gene Ratio")+
    guides(color = guide_colorbar(
        title = colorTitle,
        title.position = "top",
      ),
      size = guide_legend(
        title = "Count",
        title.position = "top",
        size=1
      )
    )  +
    scale_colour_continuous(
      limits = c(0, max_value),
      low = '#f0998a', high = '#3fd8c7',
      guide = guide_colorbar(
        title.position = "top",
        title.hjust = 0.5,
        barwidth = 8,
        barheight = 0.4
      )
    ) +
    theme_bw() +
    theme(
      panel.grid.major = element_line(color = "gray80", linewidth = 0.3),  # Add major grid lines
      panel.grid.minor = element_blank(),  # Remove minor grid lines
      axis.title = element_text(face = "bold"),
      axis.text.y = element_text(face = "bold", size = 5),
      axis.text.x = element_text(face = "bold", size = 7),
      legend.text = element_text(size = 6),
      legend.title = element_text(size = 6),
      legend.key.height= unit(0.3, "cm"),
      legend.key.width= unit(0.2, "cm"),
      
      # legend.position = c(1.3, 0.5),
      legend.justification = c(1, 0.5),
      legend.box = "vertical",
      legend.background = element_rect(fill = "transparent", colour = NA),
    )

  n_pw <- nrow(dataForPlotFrameP)
  height <- 0.3 * n_pw + 2
  ggsave(fno, p, width = 6, height = height)
}


# source('function_chc.r')
