#!/usr/bin/perl
use strict;
use warnings;

use CQS::ClassFactory;
use CQS::FileUtils;
use CQS::SystemUtils;
use CQS::ConfigUtils;
use CQS::PerformRNAseq;

my $def = {

  #define task name, this name will be used as prefix of a few result, such as read count table file name.
  task_name => "P11636_RNAseq_mm10",

  #target dir which will be automatically created and used to save code and result, you need to change it for each project.
  target_dir  => "/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse",
  aligner    => "star",

  perform_cutadapt => 1, 
  cutadapt_option => "-q 20 -a AGATCGGAAGAGCACACGTC -A AGATCGGAAGAGCGTCGTGT",
  is_paired_end => 1,
  min_read_length => 30,
  
  #Since we have most of figure, we don't need multiqc anymore. But if you want, you can set it to 1.
  perform_multiqc => 1,
  
  #We use webgestalt to do gene enrichment analysis using differential expressed genes.
  perform_webgestalt => 1,
  webgestalt_organism => "mmusculus",

  #We use GSEA for gene set enrichment analysis.
  perform_gsea => 1,
  perform_report => 1,
  DE_fold_change => 1.5,
  DE_pvalue => 0.1,

  #Call variant using GATK pipeline
  # perform_call_variants => 1,

  #source files, it's a hashmap with key (sample name) points to array of files. For single end data, the array should contains one file only.

  files => {
    # "FPAS_1" => ['/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0006_S1_L005_R1_001.fastq.gz', '/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0006_S1_L005_R2_001.fastq.gz'],
    "FPAS_2" => ['/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0007_S1_L005_R1_001.fastq.gz', '/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0007_S1_L005_R2_001.fastq.gz'],
    "FPAS_3" => ['/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0008_S1_L005_R1_001.fastq.gz', '/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0008_S1_L005_R2_001.fastq.gz'],
    "FPAS_4" => ['/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0009_S1_L005_R1_001.fastq.gz', '/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0009_S1_L005_R2_001.fastq.gz'],
    "FPAS_5" => ['/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0010_S1_L005_R1_001.fastq.gz', '/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0010_S1_L005_R2_001.fastq.gz'],
    # "PBS_1" => ['/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0001_S1_L005_R1_001.fastq.gz', '/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0001_S1_L005_R2_001.fastq.gz'],
    "PBS_2" => ['/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0002_S1_L005_R1_001.fastq.gz', '/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0002_S1_L005_R2_001.fastq.gz'],
    "PBS_3" => ['/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0003_S1_L005_R1_001.fastq.gz', '/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0003_S1_L005_R2_001.fastq.gz'],
    "PBS_4" => ['/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0004_S1_L005_R1_001.fastq.gz', '/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0004_S1_L005_R2_001.fastq.gz'],
    "PBS_5" => ['/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0005_S1_L005_R1_001.fastq.gz', '/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0005_S1_L005_R2_001.fastq.gz'],
  },

  #group definition, group name points to array of sample name defined in files.
  groups_pattern => "(.+)_",

  #comparison definition, comparison name points to array of group name defined in groups.
  #for each comparison, only two group names allowed while the first group will be used as control.
  pairs => {
    "FPAS_VS_PBS" => ['PBS', 'FPAS'],
  },
};

my $config = performRNASeq_gencode_mm10($def); 
1;



