cd /Users/files/work/cooperate/vivian/heather_rnaseq_redo_figure/20240801_11636_RNAseq_mouse/report/geneset
python /Users/files/jb/database/go_pathway/subset_go.py "actin" "@cell mobil" "@cell adhesion" "@cytosckel" -o "actin"

python /Users/files/jb/database/go_pathway/subset_go.py "PI3K" -o PI3K

python /Users/files/jb/database/go_pathway/subset_go.py "@integrins?\b" -o integrin

python /Users/files/jb/database/go_pathway/subset_go.py "EMT" -o EMT
python /Users/files/jb/database/go_pathway/subset_go.py "P53" -o P53
python /Users/files/jb/database/go_pathway/subset_go.py -org mouse -o Wnt_signaling 'wnt'
python /Users/files/jb/database/go_pathway/subset_go.py -org mouse -o "Innate_immune"  "@innate immune"
