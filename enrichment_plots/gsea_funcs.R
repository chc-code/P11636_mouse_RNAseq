library(stringr)
library(RCurl)
library(knitr)
library(ggplot2)
library(data.table)
library(htmltools)
library(kableExtra)
library(digest)
library(patchwork)
library(dplyr)
library(ComplexHeatmap)
library(grid)

library(DT)
library(ggpubr)
#library(tools)

display_webgestalt=function(files) {
  cat(paste0("  \n## WebGestalt  \n"))
  enrich_files<-files[grepl("WebGestalt_", rownames(files)),]
  enrich_files$Comparisons<-gsub("WebGestalt_GO....", "", enrich_files$V2)
  enrich_files$Comparisons<-gsub("WebGestalt_KEGG_", "", enrich_files$Comparisons)
  comparisons<-unique(enrich_files$Comparisons)
  for (j in 1:length(comparisons)){
    comparison<-comparisons[j]
    comp_files<-enrich_files[enrich_files$Comparisons == comparison,]
    cat(paste0("  \n### ", comparison, "  \n"))

    have_result = FALSE
    for (i in 1:nrow(comp_files)){
      if (!file.exists(comp_files[i,1])) {
        next;
      }
      have_result = TRUE
      ename<-rownames(comp_files)[i]
      if(grepl(".html.rds", comp_files[i,1])){
        plotData <-readRDS(comp_files[i,1])
        fdata<-plotData$enriched
        fdata<-fdata[c(1:min(nrow(fdata),5)),c(1,2,4,5,6,7,8,9,12,13)]
        print(kable(fdata, caption=tabRef(ename, ename)) %>% 
          kable_styling() %>%
          row_spec(which(fdata$geneUp > fdata$geneDown), color = "black", background = "bisque") %>% 
          row_spec(which(fdata$geneUp < fdata$geneDown), color = "black", background = "honeydew") %>%
          htmltools::HTML())
        cat("\n\n<hr>")
      }else{
        #txtFile<-gsub(".html.rds$", "", comp_files[i,1])
        #fdata<-read.table(txtFile, sep="\t", header=T, stringsAsFactors = F)
        fdata<-read.table(comp_files[i,1], sep="\t", header=T, stringsAsFactors = F)
        fdata<-fdata[c(1:min(nrow(fdata))),]
        fdata$geneSet<-paste0("[", fdata$geneSet, "](", fdata$link, "){target='_blank'}")
        fdata<-fdata[,c(1,2,4,5,6,7,8,9)]
        print(kable(fdata, caption=tabRef(ename, ename)) %>%
        kable_styling() %>%
        htmltools::HTML())
      }
    }

    if(!have_result){
      cat("\n\nNo WebGestalt result. It might caused by very limited number of differential expressed genes.\n<hr>")
    }
  }
}

processGseaTable_stale=function(gseaTableFile, maxCategoryFdr=0.05) {
  if(require('msigdbr')){
    gs<-msigdbr:::msigdbr_genesets
    gsd_map=split(gs$gs_description, gs$gs_name)
  }else{
    gsd_map=list()
  }

  rawTable<-read.delim(gseaTableFile,header=T,as.is=T)
  rawTable<-subset(rawTable, NES != "---")

  rawTable<-rawTable[rawTable$FDR.q.val<=maxCategoryFdr,,drop=F]
  if(nrow(rawTable) == 0){
    return(NULL)
  }

  rawTable$URL = paste0("http://www.gsea-msigdb.org/gsea/msigdb/geneset_page.jsp?geneSetName=",rawTable$NAME)
  # For RMD
  # rawTable$NAME_URL=unlist(apply(rawTable, 1, function(x){
  #   addLinkTag(text=x['NAME'],link=x['URL'])
  # }))
  rawTable$NAME_URL=unlist(apply(rawTable, 1, function(x){
    paste0("<a href='", x['URL'], "' target='_blank'>", gsub("_", " ", x['NAME']), "</a>")
  }))
  
  descriptions=unlist(apply(rawTable, 1, function(x){
    categoryDescription=""
    cname = x['NAME']
    if(cname %in% names(gsd_map)){
      categoryDescription=gsd_map[cname]
    }else{
      gseaUrl=x['URL']
      gseaWeb<-getURL(gseaUrl)
      if(gseaWeb != ""){
        temp<-strsplit(gseaWeb,"description|\\<td\\>")[[1]]
        j=grep("Brief",temp)
        categoryDescription<-gsub("^>","",temp[j+2])
        categoryDescription<-gsub("<\\/$","",categoryDescription)
        reg_pattern = "<a href=.+?]</a>"
        if(length(categoryDescription) > 0){
          while(grepl(reg_pattern, categoryDescription)){
            url = str_extract(categoryDescription, reg_pattern) 
            
            name=str_match(url, '\\[(.+?)]')[[2]]
            name_url=str_match(url, "<a href='(.+)'")[[2]]
            namelink=addLinkTag(name, name_url)
            
            categoryDescription<-gsub(url, namelink, fixed=TRUE, categoryDescription)
          }
        }else{
          return(NA)
        }
      }
    }
    return(categoryDescription)    
  }))

  rawTable$Description=descriptions

  rawTable$Core=round(rawTable$SIZE * as.numeric(str_extract(rawTable$LEADING.EDGE, "\\d+")) / 100)

  rawTable<-rawTable[,c("NAME", "NAME_URL", "Description", "SIZE", "NES", "FDR.q.val", "Core")]
  
  return(rawTable)
}



processGseaTable <- function(gseaTableFile, fn_gmt, fn_desc, maxCategoryFdr=0.05) {

  rawTable<-read.delim(gseaTableFile,header=T,as.is=T)
  rawTable<-subset(rawTable, NES != "---")
  ntmp <- nrow(rawTable)

  rawTable<-rawTable[rawTable$FDR.q.val<=maxCategoryFdr,,drop=F]
  if(nrow(rawTable) == 0){
    return(NULL)
  }

  # create a new column namelower to store the lower case of NAME
  rawTable$namelower <- tolower(rawTable$NAME)
  
  lines <- readLines(fn_gmt)
  data <- do.call(rbind, lapply(lines, function(x) {
      cols <- strsplit(x, "\t")[[1]]  # Split on whitespace
      cols[1:2]  # Take first 2 columns
  }))
  gmt <- as.data.frame(data)
  colnames(gmt) <- c("NAME", "URL")
  gmt$NAME <- tolower(gmt$NAME)
  
  
  lines <- readLines(fn_desc)
  data <- do.call(rbind, lapply(lines, function(x) {
      cols <- strsplit(x, "\t")[[1]]  # Split on whitespace
      cols[1:2]  # Take first 2 columns
  }))
  desc <- as.data.frame(data)
  colnames(desc) <- c("NAME", "Description")
  desc$NAME <- tolower(desc$NAME)
  
  rawTable <- dplyr::left_join(rawTable, gmt, by = c("namelower" = 'NAME'))
  rawTable <- dplyr::left_join(rawTable, desc, by = c("namelower" = 'NAME'))
  
  rawTable$NAME_URL=unlist(apply(rawTable, 1, function(x){
    # if x['URL'] startswith "http", use below, othervise use x[NAME]
    if (grepl("^http", x['URL'])) {
      paste0("<a href='", x['URL'], "' target='_blank'>", gsub("_", " ", x['NAME']), "</a>")
    } else {
      gsub("_", " ", x['NAME'])
    }
    }))

  rawTable$Core=round(rawTable$SIZE * as.numeric(str_extract(rawTable$LEADING.EDGE, "\\d+")) / 100)

  rawTable<-rawTable[,c("NAME", "NAME_URL", "Description", "SIZE", "NES", "FDR.q.val", "Core")]
  
  return(rawTable)
}




parse_gsea_subfolder=function(gsea_dir, is_positive, fn_gmt, fn_desc){
  pstr = ifelse(is_positive, "pos", "neg")
  title = ifelse(is_positive, "Positive-regulated", "Negative-regulated")
  pattern = paste0("gsea_report_for_na_", pstr, '_\\d+\\.(tsv|xls)$')
        
  gseaTableFile<-list.files(gsea_dir,pattern=pattern,full.names=TRUE)

  if (length(gseaTableFile)!=1) {
    warning(paste("Can't find ", title, "GSEA table file in", gsea_dir))
    return(NULL)
  }
  
  rawTable<-processGseaTable(gseaTableFile, fn_gmt, fn_desc)
  if(is.null(rawTable)){
    warning(paste("Can't find significant", title, "GSEA gene set in", gsea_dir))
    return(NULL)
  }
  return(rawTable)
}

display_gsea=function(files, target_folder="", gsea_prefix="#", print_rmd=F) {
  if(print_rmd){
    cat(paste0("\n\n", gsea_prefix, "# GSEA\n\n"))
  }

  result = data.frame(comparison=character(),
                      data_name=character(),
                      category=character(),
                      file_key=character(),
                      file_path=character())
  
  is_singlecell<-"compName" %in% colnames(files)

  maxCategory=ifelse(is_singlecell, 10, 5)
  #maxCategory=0
  
  if(is_singlecell){
    gsea_files<-files
    gsea_files$Comparisons<-gsea_files$compName
    comparisons<-rev(unique(gsea_files$Comparisons))
  }else{
    gsea_files<-files
    gsea_files$Comparisons<-gsea_files$V2
    comparisons<-unique(gsea_files$Comparisons)
  }

  j=1
  for (j in 1:length(comparisons)){
    comparison<-comparisons[j]
    comp_files<-gsea_files[gsea_files$Comparisons == comparison,]

    if(print_rmd){
      cat(paste0("\n\n", gsea_prefix, "## ", comparison, "\n\n"))
    }else{
      cat(comparison, "\n")
    }
  
    has_enriched=FALSE

    i=1
    for (i in 1:nrow(comp_files)){
      gname=comparison
      if(is_singlecell){
        gfolders<-comp_files
      }else{
        gfolders<-read.csv(comp_files[i,1],header=T,stringsAsFactor=F, check.names=F)
      }

      k=1
      for (k in 1:nrow(gfolders)){
        gsea_dir<-gfolders$Folder[k]
        gseaCategory<-gfolders$GseaCategory[k]

        if(!print_rmd){
          cat("  ", gseaCategory, "\n")
        }

        pos = parse_gsea_subfolder(gsea_dir, gname, gseaCategory, TRUE)
        neg = parse_gsea_subfolder(gsea_dir, gname, gseaCategory, FALSE)

        if (is.null(pos) & is.null(neg)){
          next
        }

        has_enriched = TRUE

        prefix = paste0(gname, ".", gseaCategory)

        top_enriched = NULL
        if(!is.null(pos)){
          pos_file=paste0(target_folder, prefix, ".pos.csv")
          write.csv(pos[,c(2:ncol(pos))], pos_file, row.names=F)
          result[nrow(result) + 1,] = c(comparison, gname, gseaCategory, "pos_file", pos_file)
          top_enriched = head(pos, 10)
        }

        if(!is.null(neg)){
          neg_file=paste0(target_folder, prefix, ".neg.csv")
          write.csv(neg[,c(2:ncol(neg))], neg_file, row.names=F)
          result[nrow(result) + 1,] = c(comparison, gname, gseaCategory, "neg_file", neg_file)
          top_enriched = rbind(top_enriched, head(neg, 10))
        }

        enriched_file=paste0(target_folder, prefix, ".enriched.csv")
        write.csv(top_enriched, enriched_file, row.names=F)
        result[nrow(result) + 1,] = c(comparison, gname, gseaCategory, "enriched_file", enriched_file)

        top_enriched$NES = as.numeric(top_enriched$NES)
        top_enriched$Core = as.numeric(top_enriched$Core)
        top_enriched$FDR.q.val = as.numeric(top_enriched$FDR.q.val)

        enriched_png=paste0(enriched_file, ".png")
        result[nrow(result) + 1,] = c(comparison, gname, gseaCategory, "enriched_png", enriched_png)

        top_enriched<-top_enriched[order(top_enriched$NES, decreasing=T),]
        top_enriched$NAME<-factor(top_enriched$NAME, levels=top_enriched$NAME)
        g<-ggplot(top_enriched, aes(NES, NAME)) + geom_point(aes(size=Core, color=FDR.q.val)) + geom_vline(xintercept=0) + theme_bw() + ylab("") + xlab("Normalized enrichment score")

        height=max(1200, 3000/40*nrow(top_enriched))
        ncharmax=max(nchar(as.character(top_enriched$NAME)))
        width=max(3000, ncharmax * 40 + 1000)
        ggsave(enriched_png, g, width=width, height=height, dpi=300, units="px", bg="white")

        if(print_rmd){
          cat(paste0("\n\n<img src='", enriched_png, "'>\n\n"))
        }
      }

      if(is_singlecell){
        break
      }
    }  

    if(!has_enriched){
      if(print_rmd){
      	cat(paste0('\n<span style="color:red">WARNING: no geneset is significantly enriched.</span>\n\n'))
      }
    }
  }
  return(result)
}

save_gsea_rmd<-function(files, resFile, rmd_prefix=""){
  source("reportFunctions.R")
  if(nrow(files) == 0){
    return("# No geneset with FDR < 0.05 detected")
  }
  result<-""
  comparisons = unique(files$comparison)
  comparisons = comparisons[order(comparisons)]
  comparison<-comparisons[1]
  for(comparison in comparisons){
    result<-paste0(result, paste0("\n\n", rmd_prefix, "# ", comparison, "\n\n"))

    comp_files<-files[files$comparison==comparison,,drop=FALSE]

    categories = unique(comp_files$category)
    category=categories[1]
    for(category in categories){
      result<-paste0(result, paste0("\n\n", rmd_prefix, "## ", category, "\n\n"))

      cat_files<-comp_files[comp_files$category == category,,drop=F]
      file_map<-split(cat_files$file_path, cat_files$file_key)

      if(!is.null(file_map$pos_file)){
        result<-paste0(result, paste0("\n\n", rmd_prefix, "### Positive-regulated\n\n"))
        result<-paste0(result, getPagedTable(filepath=file_map$pos_file, row.names=0, escape=FALSE))
      }

      if(!is.null(file_map$neg_file)){
        result<-paste0(result, paste0("\n\n", rmd_prefix, "### Negative-regulated\n\n"))
        result<-paste0(result, getPagedTable(filepath=file_map$neg_file, row.names=0, escape=FALSE))
      }

      if(!is.null(file_map$enriched_png)){
        result<-paste0(result, paste0("\n\n", rmd_prefix, "### Top enriched gene sets\n\n"))
        result<-paste0(result, getFigure(file_map$enriched_png, out_width="100%"))
      }
    }
  }

  writeLines(result, resFile)
}

get_versions=function(){
  files<-read.delim("fileList4.txt", header=F, stringsAsFactors = F)
  df<-NULL
  curfile<-files$V1[1]
  for(curfile in files$V1){
    if(file.exists(curfile)){
      curdf<-read.csv(curfile, header=F, check.names=F)
      df<-rbind(df, curdf)
    }
  }

  if(file.exists("fileList5.txt")){
    vers<-read.delim("fileList5.txt", header=F, stringsAsFactors = F)
    vers<-vers[,c(2,1)]
    colnames(vers)<-c("V1","V2")
    df<-rbind(df, vers)
  }

  df<-unique(df)
  df<-df[order(df$V1),]
  colnames(df)<-c("Software", "Version")
  return(df)
}

display_versions=function(){
  df<-get_versions()
  print(kable(df, caption=tabRef("versionFiles", "Software versions"), row.names=F) %>%
          kable_styling() %>%
          htmltools::HTML())
  return(df)
}


get_overlapping_genes <- function(deseq2, kegg_id, fn_gmt){
  deg_df <- deseq2 %>% select(Feature_gene_name, FoldChange)
  gmt_data <- readLines(fn_gmt)
  selected_pathway <- gmt_data[grepl(paste0("^", kegg_id, "\t"), gmt_data)]
  if (length(selected_pathway) > 0) {
    pathway_genes <- unlist(strsplit(selected_pathway, "\t"))[-c(1,2)]  # Remove KEGG ID & name
  } else {
    stop("KEGG pathway not found in GMT file.")
  }  
  overlapping_genes <- deg_df %>% filter(Feature_gene_name %in% pathway_genes)
  deg_list <- setNames(overlapping_genes$FoldChange, overlapping_genes$Feature_gene_name)

  return(deg_list)
}

options(figcap.prefix = "Figure", figcap.sep = ":", figcap.prefix.highlight = "**")
options(tabcap.prefix = "Table", tabcap.sep = ":", tabcap.prefix.highlight = "**")

addHtmlLinkTag<-function(text,link) {
  result<-paste0("<a href='",link,"' target='_blank'>",text,"</a>")
  return(result)
}

addLinkTag<-function(text,link) {
  result<-paste0("[", text, "](", link, ")")
  return(result)
}

figRef <- local({
  tag <- numeric()
  created <- logical()
  used <- logical()
  function(label, caption, prefix = options("figcap.prefix"), 
           sep = options("figcap.sep"), prefix.highlight = options("figcap.prefix.highlight"), trunk.eval=TRUE) {
    if(trunk.eval){ 
      i <- which(names(tag) == label)
      if (length(i) == 0) {
        i <- length(tag) + 1
        tag <<- c(tag, i)
        names(tag)[length(tag)] <<- label
        used <<- c(used, FALSE)
        names(used)[length(used)] <<- label
        created <<- c(created, FALSE)
        names(created)[length(created)] <<- label
      }
      if (!missing(caption)) {
        created[label] <<- TRUE
        paste0(prefix.highlight, prefix, " ", i, sep, prefix.highlight, 
               " ", caption)
      } else {
        used[label] <<- TRUE
        paste(prefix, tag[label])
      }
    }
  }
})

tabRef <- local({
  tag <- numeric()
  created <- logical()
  used <- logical()
  function(label, caption, prefix = options("tabcap.prefix"), 
           sep = options("tabcap.sep"), prefix.highlight = options("tabcap.prefix.highlight"), trunk.eval=TRUE) {
    if(trunk.eval){
      i <- which(names(tag) == label)
      if (length(i) == 0) {
        i <- length(tag) + 1
        tag <<- c(tag, i)
        names(tag)[length(tag)] <<- label
        used <<- c(used, FALSE)
        names(used)[length(used)] <<- label
        created <<- c(created, FALSE)
        names(created)[length(created)] <<- label
      }
      if (!missing(caption)) {
        created[label] <<- TRUE
        paste0(prefix.highlight, prefix, " ", i, sep, prefix.highlight, 
              " ", caption)
      } else {
        used[label] <<- TRUE
        paste(prefix, tag[label])
      }
    }
  }
})

is_file_exists<-function(filename){
  if(is.null(filename)){
    return(FALSE)
  }

  if(is.na(filename)){
    return(FALSE)
  }

  return(file.exists(filename))
}

check_and_include_graphics<-function(graphicFile) {
  if (is_file_exists(graphicFile[1])) {
    include_graphics(graphicFile)
  }
}

output_table<-function(tbl, caption=NULL, description=NULL){
  if(!is.null(caption)){
    new_caption = tabRef(caption, description)
  }else{
    new_caption = NULL
  }

  kable(tbl, caption= new_caption) %>%
    kable_styling() %>%
    htmltools::HTML()
}

print_table_from_file<-function(filepath, row.names=1, caption=NULL, description=NULL){
  if(row.names > 0){
    tbl<-data.frame(fread(filepath, check.names=F), row.names=row.names)
  }else{
    tbl<-data.frame(fread(filepath, check.names=F))
  }

  output_table(tbl, caption, description)
}

print_table<-function(tbl, round_value=3, byDT=FALSE, row.names=TRUE){
  if(round_value > 0){
    tbl <- tbl %>% dplyr::mutate(across(where(is.numeric), round, round_value))
  }
  if(byDT){
    DT::datatable(tbl, rownames = row.names, extensions = "Buttons", options = list(dom = "Bfrtip", buttons = c("excel", "csv")))
  }else{
    print(kable(tbl, row.names = row.names))
  }
}


get_table_description<-function(category, filepath, description){
  result = "\n```{r,echo=FALSE,results='asis'}\n"
  result = paste0(result, "print_table_from_file('", filepath, "', ", row.names, ",'", category, "','", description, "')\n```\n\n")
  return(result)
}

output_paged_table<-function(tbl, rownames=TRUE, escape=TRUE, digits=0, nsmall=0){
  if(digits > 0){
    tbl <- tbl %>% dplyr::mutate_if(is.numeric, format, digits=digits, nsmall=nsmall)
  }

  DT::datatable(tbl, 
                rownames = rownames, 
                escape = escape,
                extensions = "Buttons", 
                options = list( dom = "Bfrtip", 
                                buttons = c("excel", "csv")))
}

printPagedTable<-function(filepath, row.names=1, escape=TRUE, digits=0, nsmall=0){
  if(row.names > 0){
    tbl<-data.frame(fread(filepath, check.names=F), check.names=FALSE, row.names=row.names)
  }else{
    tbl<-data.frame(fread(filepath, check.names=F), check.names=FALSE)
  }

  output_paged_table( tbl=tbl,
                      rownames=row.names > 0,
                      escape=escape,
                      digits=digits, 
                      nsmall=nsmall)
}

getPagedTable<-function(filepath, row.names=1, escape=TRUE, digits=0, nsmall=0){
  return(paste0("\n```{r,echo=FALSE,results='asis'}\nprintPagedTable(filepath='", filepath, "', row.names=", row.names, ", escape=", escape, ", digits=", digits, ", nsmall=", nsmall, ")\n```\n\n"))
}

getTable<-function(filepath, row.names=1){
  return(paste0("\n```{r,echo=FALSE,results='asis'}\nprint_table_from_file('", filepath, "', ", row.names, ")\n```\n\n"))
}

getFigure<-function(filepath, in_details=FALSE, out_width=NULL){
  if(!is.null(out_width)){
    result = paste0("\n```{r,echo=FALSE,results='asis',out.width='", out_width,  "'}\n")
  }else{
    result = "\n```{r,echo=FALSE,results='asis'}\n"
  }
  if(in_details){
    return(paste0(result, "check_and_include_graphics('details/", filepath, "')\n```\n\n"))
  }else{
    return(paste0(result, "check_and_include_graphics('", filepath, "')\n```\n\n"))
  }
}

getFigure_width_height<-function(filepath, in_details=FALSE, fig.width=NULL, fig.height=NULL){
  if(!is.null(fig.width)){
    if(!is.null(fig.height)){
      result = paste0("\n```{r,echo=FALSE,results='asis',fig.width=", fig.width, ",fig.height=", fig.height, "}\n")
    }else{
      result = paste0("\n```{r,echo=FALSE,results='asis',fig.width=", fig.width, "}\n")
    }
  }else{
    if(!is.null(fig.height)){
      result = paste0("\n```{r,echo=FALSE,results='asis',fig.height=", fig.height, "}\n")
    }else{
      result = paste0("\n```{r,echo=FALSE,results='asis'}\n")
    }
  }
  if(in_details){
    return(paste0(result, "check_and_include_graphics('details/", filepath, "')\n```\n\n"))
  }else{
    return(paste0(result, "check_and_include_graphics('", filepath, "')\n```\n\n"))
  }
}

get_figure_description<-function(category, filepath, description){
  return(paste0("```{r,echo=FALSE,results='asis', fig.align='center', fig.cap=figRef('", category, "', '",gsub("_", " ", description), "', trunk.eval=file.exists('", filepath, "'))}\n",
"  check_and_include_graphics('", filepath, "')\n```\n"))
}

find_module_folder=function(files,pattern) {
  moduleFolders=sapply(strsplit(files[,1],"\\/"), function(x) {ind=which(x=="result");x[ind-1]})
  interestedModuleInd=grep(pattern,moduleFolders)
  return(interestedModuleInd)
}

get_date_str = function(){
  format(Sys.time(), "%Y%m%d")
}

check_md5<-function(filepath, expect_md5, return_md5=FALSE){
  if(!file.exists(filepath)){
    stop("File not exists: ", filepath)
  }
  md5=tools::md5sum(filepath)

  if(expect_md5 == ""){
    if(return_md5){
      return(md5)
    }else{
      cat(basename(filepath), "md5=", md5, "\n")
    }
  }else{
    if(md5 != expect_md5){
      stop("md5 not match, expect ", expect_md5, " but got ", md5, " for file ", filepath)
    }
  }
}

theme_rotate_x_axis_label <- function() {
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
}

theme_bw3 <- function (axis.x.rotate=F) { 
  result = theme_bw() +
    theme(
      strip.background = element_rect(fill = NA, colour = 'black'),
      panel.border = element_rect(fill = NA, color = "black"),			
      axis.line = element_line(colour = "black", linewidth = 0.5),
      plot.title = element_text(hjust = 0.5)
    )
  if (axis.x.rotate){
    result = result + theme_rotate_x_axis_label()
  }
  
  return(result)
}

get_hist_density<-function(data, x, title=x, bins=20){
  ggplot(data, aes(x=!!sym(x))) + geom_histogram(aes(y = ..density..), colour = 1, fill = "white", bins=bins) + geom_density() + ggtitle(title) + theme_bw3()
}

show_descriptive_statistics<-function(data){
  dd = data
  dd$fakevar = 1
  dd$fakevar <- factor(dd$fakevar, levels = c(1), labels = c("Subject"))
  label(dd$fakevar) <- "Subject"

  dd_formula = paste0(paste0(colnames(data), collapse=" + "), " ~ fakevar")
  print_descriptive_statistics(as.formula(dd_formula), dd, test = FALSE)
}

print_descriptive_statistics<-function(formula, data, test = TRUE, overall = FALSE, continuous = 5, ...){
  output <- summaryM(formula = formula,
                      data = data, 
                      test = test, 
                      overall = overall, 
                      continuous = continuous, ...)
  latex_tbl = latex(output, html=TRUE, width=0.8 )
  cat(latex_tbl)
}

factor_by_count<-function(vec){
  tbl=table(vec)
  tbl=tbl[tbl > 0]
  tbl=tbl[order(tbl, decreasing=T)]
  res=factor(vec, levels=names(tbl))
  return(res)
}

get_log_cpm<-function(counts, prefix=NULL, filterCPM=TRUE, transform=TRUE){
  library(edgeR)
  
  dge <- DGEList(counts)
  dge <- calcNormFactors(dge)

  cpm <- cpm(dge, normalized.lib.sizes = TRUE, log = F)
  if(!is.null(prefix)){
    write.csv(cpm, paste0(prefix, ".cpm.csv"))
  }

  if(filterCPM){
    ncpm1=rowSums(cpm >= 1)
    keep=ncpm1 > floor(ncol(cpm)/2)
    dge <- dge[keep, ,keep.lib.sizes=TRUE]
  }

  logcpm <- cpm(dge, normalized.lib.sizes = TRUE, log = T, prior.count = 2)
  if(!is.null(prefix)){
    write.csv(logcpm, paste0(prefix,".logcpm.csv"))
  }

  if(transform){
    logcpmt <- t(logcpm)
    return(logcpmt)
  }else{
    return(logcpm)
  }
}

read_file_map<-function(file_list_path, sep="\t", header=F, do_unlist=TRUE){
  tbl=fread(file_list_path, header=header, data.table=FALSE)

  result<-split(tbl$V1, tbl$V2)
  if(do_unlist){
    result<-unlist(result)
  }
  return(result)
}

get_legend_width <- function(g, by="max") {
  gg <- ggplotGrob(g)
  
  # Find the legend element and extract its width
  legend_grob <- gg$grobs[[which(sapply(gg$grobs, function(x) {x$name}) == "guide-box")]]
  if(by=="max"){
    legend_width <- ceiling(convertWidth(max(legend_grob$width), "in", valueOnly = TRUE))
  }else{
    legend_width <- ceiling(convertWidth(sum(legend_grob$width), "in", valueOnly = TRUE))
  }

  return(legend_width)
}

get_freq_table<-function(df, column){
df |> 
  dplyr::count(!!sym(column)) |> 
  dplyr::arrange(desc(n)) |>
  dplyr::rename("count"="n")
}

cluster_dotplot<-function(gdata, column1="features.plot", column2="id", value_column="avg.exp.scaled", dim="both"){
  load_install("textshape")

  mdata=acast(gdata, as.formula(paste0(column1, "~", column2)), value.var=value_column)

  mdata=cluster_matrix(mdata, dim=dim, method="ward.D2")
  gdata[,column1]=factor(gdata[,column1], levels=rownames(mdata))
  gdata[,column2]=factor(gdata[,column2], levels=colnames(mdata))

  return(gdata)
}

###################################
#report functions end
###################################

