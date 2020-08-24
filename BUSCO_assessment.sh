# BUSCO assessment
on Miles. Here is an example command:
cd /mnt/griffin/chrwhe/Paeg_assembly/10x/assessment
mkdir busco
cd busco
ln -s /mnt/griffin/chrwhe/Paeg_assembly/10x/scaffolding/BESST_output/pass1/Scaffolds_pass1.fa Paeg_v2das.fa

# define paths
export PATH=$PATH:/data/programs/bbmap_34.94/:/data/programs/augustus-3.0.1/bin:/data/programs/augustus-3.0.1/scripts
AUGUSTUS_CONFIG_PATH=/data/programs/augustus-3.0.1/config
library=/data/programs/busco/insecta_odb9

# change these for your species specific run
genome=Paeg_v2das.fa
outfile=Paeg_v2das_insectaBUSCO

#run BUSCO analysis
python /data/programs/busco/scripts/run_BUSCO.py -i $genome -l $library -m genome -o $outfile -c 64

more short_summary_Paeg_v2das_insectaBUSCO.txt
# BUSCO version is: 3.0.2
# The lineage dataset is: insecta_odb9 (Creation date: 2016-02-13, number of species: 42, number of BUSCOs: 1658)
# To reproduce this run: python /data/programs/busco/scripts/run_BUSCO.py -i Paeg_v2das.fa -o Paeg_v2das_insectaBUSCO -l /data/programs/busco/insecta_odb9/ -m genome -c 64 -sp fly
#
# Summarized benchmarking in BUSCO notation for file Paeg_v2das.fa
# BUSCO was run in mode: genome

        C:86.5%[S:86.0%,D:0.5%],F:7.3%,M:6.2%,n:1658

        1434    Complete BUSCOs (C)
        1426    Complete and single-copy BUSCOs (S)
        8       Complete and duplicated BUSCOs (D)
        121     Fragmented BUSCOs (F)
        103     Missing BUSCOs (M)
        1658    Total BUSCO groups searched
