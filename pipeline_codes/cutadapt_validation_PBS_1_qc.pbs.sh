
cd '/nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/cutadapt_validation/result'

set -o pipefail



    

python3 /data/cqs/softwares/ngsperl/lib/CQS/../QC/validatePairendFastq.py  -i /nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_1_clipped.1.fastq.gz,/nobackup/h_vangard_1/chenh19/vivian_weiss/20240801_11636_RNAseq_mouse/cutadapt/result/PBS_1_clipped.2.fastq.gz -o PBS_1.txt


