
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt_validation/result'

set -o pipefail



    

python3 /data/cqs/softwares/ngsperl/lib/CQS/../QC/validatePairendFastq.py  -i /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_2_clipped.1.fastq.gz,/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_2_clipped.2.fastq.gz -o PBS_2.txt


