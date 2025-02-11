
res_dir='/nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/fastq_len/result'
tmp_dir=$(mktemp -d -t ci-$(date +%Y-%m-%d-%H-%M-%S)-XXXXXXXXXX)

tmp_cleaner()
{
rm -rf ${tmp_dir}
exit -1
}
trap 'tmp_cleaner' TERM

echo using tmp_dir=$tmp_dir
cd $tmp_dir


set -o pipefail



echo localize start at `date`

echo /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.gz      
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.gz ]]; then
  echo file not exists: /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.gz
  touch $res_dir/FPAS_3_clipped.1.fastq.gz.not.exist
  rm FPAS_3_clipped.1.fastq.gz
  exit 1
fi

for i in {1..5}; do 
  echo iteration $i ...
  cp -fL /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.gz FPAS_3_clipped.1.fastq.gz
  diff /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.gz FPAS_3_clipped.1.fastq.gz
  status=$?
  if [[ $status -eq 0 ]]; then
    break
  fi
done

if [[ $status -ne 0 ]]; then
  echo file copied is not idential to original file, quit.
  touch $res_dir/FPAS_3_clipped.1.fastq.gz.copy.failed
  rm FPAS_3_clipped.1.fastq.gz
  exit 1
fi

echo /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.2.fastq.gz      
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.2.fastq.gz ]]; then
  echo file not exists: /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.2.fastq.gz
  touch $res_dir/FPAS_3_clipped.2.fastq.gz.not.exist
  rm FPAS_3_clipped.1.fastq.gz FPAS_3_clipped.2.fastq.gz
  exit 1
fi

for i in {1..5}; do 
  echo iteration $i ...
  cp -fL /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.2.fastq.gz FPAS_3_clipped.2.fastq.gz
  diff /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.2.fastq.gz FPAS_3_clipped.2.fastq.gz
  status=$?
  if [[ $status -eq 0 ]]; then
    break
  fi
done

if [[ $status -ne 0 ]]; then
  echo file copied is not idential to original file, quit.
  touch $res_dir/FPAS_3_clipped.2.fastq.gz.copy.failed
  rm FPAS_3_clipped.1.fastq.gz FPAS_3_clipped.2.fastq.gz
  exit 1
fi

echo /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.short.gz      
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.short.gz ]]; then
  echo file not exists: /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.short.gz
  touch $res_dir/FPAS_3_clipped.1.fastq.short.gz.not.exist
  rm FPAS_3_clipped.1.fastq.gz FPAS_3_clipped.2.fastq.gz FPAS_3_clipped.1.fastq.short.gz
  exit 1
fi

for i in {1..5}; do 
  echo iteration $i ...
  cp -fL /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.short.gz FPAS_3_clipped.1.fastq.short.gz
  diff /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.1.fastq.short.gz FPAS_3_clipped.1.fastq.short.gz
  status=$?
  if [[ $status -eq 0 ]]; then
    break
  fi
done

if [[ $status -ne 0 ]]; then
  echo file copied is not idential to original file, quit.
  touch $res_dir/FPAS_3_clipped.1.fastq.short.gz.copy.failed
  rm FPAS_3_clipped.1.fastq.gz FPAS_3_clipped.2.fastq.gz FPAS_3_clipped.1.fastq.short.gz
  exit 1
fi

echo /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.2.fastq.short.gz      
if [[ ! -s /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.2.fastq.short.gz ]]; then
  echo file not exists: /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.2.fastq.short.gz
  touch $res_dir/FPAS_3_clipped.2.fastq.short.gz.not.exist
  rm FPAS_3_clipped.1.fastq.gz FPAS_3_clipped.2.fastq.gz FPAS_3_clipped.1.fastq.short.gz FPAS_3_clipped.2.fastq.short.gz
  exit 1
fi

for i in {1..5}; do 
  echo iteration $i ...
  cp -fL /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.2.fastq.short.gz FPAS_3_clipped.2.fastq.short.gz
  diff /nobackup/h_vivian_weiss_lab/20240801_11636_RNAseq_mouse/cutadapt/result/FPAS_3_clipped.2.fastq.short.gz FPAS_3_clipped.2.fastq.short.gz
  status=$?
  if [[ $status -eq 0 ]]; then
    break
  fi
done

if [[ $status -ne 0 ]]; then
  echo file copied is not idential to original file, quit.
  touch $res_dir/FPAS_3_clipped.2.fastq.short.gz.copy.failed
  rm FPAS_3_clipped.1.fastq.gz FPAS_3_clipped.2.fastq.gz FPAS_3_clipped.1.fastq.short.gz FPAS_3_clipped.2.fastq.short.gz
  exit 1
fi

ls *
echo localize end at `date`


    

python3 /data/cqs/softwares/ngsperl/lib/CQS/../QC/fastq_len.py  -i FPAS_3_clipped.1.fastq.gz,FPAS_3_clipped.2.fastq.gz,FPAS_3_clipped.1.fastq.short.gz,FPAS_3_clipped.2.fastq.short.gz -o FPAS_3.len



rm FPAS_3_clipped.1.fastq.gz FPAS_3_clipped.2.fastq.gz FPAS_3_clipped.1.fastq.short.gz FPAS_3_clipped.2.fastq.short.gz

if [[ -d $tmp_dir && $tmp_dir != '/' ]]; then
  echo copy result from $tmp_dir to $res_dir
  #if the pbs was generated again during task is running, copy may be unpredictable. 
  #make sure to change to tmp_dir before copy result

  cd $tmp_dir
  cd $tmp_dir
  cd $tmp_dir
  cd $tmp_dir
  cd $tmp_dir
  cd $tmp_dir
  cd $tmp_dir
  cd $tmp_dir
  cd $tmp_dir
  cd $tmp_dir

  cp -p -r * $res_dir
  cd $res_dir
  echo delete tmp folder $tmp_dir
  rm -rf $tmp_dir
  echo move file and clean tmp folder done.
fi
