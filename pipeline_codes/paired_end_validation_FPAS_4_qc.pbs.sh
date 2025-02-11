
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/paired_end_validation/result'

set -o pipefail



    

python3 /data/cqs/softwares/ngsperl/lib/CQS/../QC/validatePairendFastq.py  -i /data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0009_S1_L005_R1_001.fastq.gz,/data/h_vivian_weiss/20240801_11636_RNAseq_mouse/fastq/11636-CP-0009_S1_L005_R2_001.fastq.gz -o FPAS_4.txt


