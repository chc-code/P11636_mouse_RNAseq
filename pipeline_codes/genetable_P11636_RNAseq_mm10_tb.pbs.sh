
cd '/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/genetable/result'

set -o pipefail



cqstools data_table -k 0 -v 6 -e --fillMissingWithZero -o ./P11636_RNAseq_mm10.count -l /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/genetable/pbs/P11636_RNAseq_mm10_tb.filelist -m /data/cqs/references/gencode/GRCm38.p6/gencode.vM25.annotation.gtf.map 

R --vanilla -f /data/cqs/softwares/ngsperl/lib/CQS/../Count/count2cpm.r --args ./P11636_RNAseq_mm10.count ./P11636_RNAseq_mm10.count 0

if [[ -e ./P11636_RNAseq_mm10.proteincoding.count ]]; then
  R --vanilla -f /data/cqs/softwares/ngsperl/lib/CQS/../Count/count2cpm.r --args ./P11636_RNAseq_mm10.proteincoding.count ./P11636_RNAseq_mm10.proteincoding.count 0
fi

