# BUSCO assessment
# on Miles:
mkdir busco
cd busco

# symb. link to genome
ln -s /mnt/griffin/racste/Pmac_genome_versions/PmacD_assembly.fasta PmacD_assembly.fasta
ln -s /mnt/griffin/racste/Pmac_genome_versions/PmacD_Rac4MedPurge.fasta PmacD_Rac4MedPurge.fasta

# configure environment
export BUSCO_CONFIG_FILE=/data/programs/busco-4.1.2/config/config.ini

# define parameters, unpolished PmacD_assembly
genome=PmacD_assembly.fasta
library=lepidoptera_odb10
outfile=PmacD_assembly_v_lepidoptera_odb10

# Run BUSCO
python3 /data/programs/busco-4.1.2/bin/busco -i $genome -l $library -m genome -o $outfile -c 30
# --------------------------------------------------
#       |Results from dataset lepidoptera_odb10           |
#       --------------------------------------------------
#       |C:90.4%[S:75.1%,D:15.3%],F:5.6%,M:4.0%,n:5286    |
#       |4778   Complete BUSCOs (C)                       |
#       |3969   Complete and single-copy BUSCOs (S)       |
#       |809    Complete and duplicated BUSCOs (D)        |
#       |295    Fragmented BUSCOs (F)                     |
#       |213    Missing BUSCOs (M)                        |
#       |5286   Total BUSCO groups searched               |
#       --------------------------------------------------

# define parameters, polished PmacD_Rac4MedPurge
genome=PmacD_Rac4MedPurge.fasta
library=lepidoptera_odb10
outfile=PmacD_Rac4MedPurge_v_lepidoptera_odb10

# Run BUSCO
python3 /data/programs/busco-4.1.2/bin/busco -i $genome -l $library -m genome -o $outfile -c 30
# --------------------------------------------------
#   |Results from dataset lepidoptera_odb10           |
#   --------------------------------------------------
#   |C:94.8%[S:93.5%,D:1.3%],F:2.7%,M:2.5%,n:5286     |
#   |5013   Complete BUSCOs (C)                       |
#   |4943   Complete and single-copy BUSCOs (S)       |
#   |70     Complete and duplicated BUSCOs (D)        |
#   |144    Fragmented BUSCOs (F)                     |
#   |129    Missing BUSCOs (M)                        |
#   |5286   Total BUSCO groups searched               |
#   --------------------------------------------------
# plotting
https://busco.ezlab.org/busco_userguide.html#companion-scripts

# note that you can generate some simple plots that might be nice for comparing among different assemblies
# during the process of polishing, etc.

python3 /data/programs/busco-4.1.2/scripts/generate_plot.py -wd /mnt/griffin/racste/Pmac_busco/BUSCO_summaries
