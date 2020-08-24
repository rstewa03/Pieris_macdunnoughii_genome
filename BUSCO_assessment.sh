# on MILES

################################

24 August 2020 working

# standard run with insect SCO genes

genome=PmacD_assembly.fasta
library=insecta_odb9
outfile=PmacD_assembly_v_insecta_odb9

# parameters
export BUSCO_CONFIG_FILE=/data/programs/busco-4.1.2/config/config.ini
python3 /data/programs/busco-4.1.2/bin/busco -i $genome -l $library -m genome -o $outfile -c 30

################################
# depending upon the species, you should also run with Lep specific buscos

genome=PmacD_assembly.fasta
library=lepidoptera_odb10
outfile=PmacD_assembly_v_lepidoptera_odb10
# parameters
export BUSCO_CONFIG_FILE=/data/programs/busco-4.1.2/config/config.ini
python3 /data/programs/busco-4.1.2/bin/busco -i $genome -l $library -m genome -o $outfile -c 30


# plotting
https://busco.ezlab.org/busco_userguide.html#companion-scripts

# note that you can generate some simple plots that might be nice for comparing among different assemblies
# during the process of polishing, etc.


# results from short_summar*
# insecta_odb9
# BUSCO version is: 5.beta
# The lineage dataset is: insecta_odb10 (Creation date: 2020-08-05, number of species: 75, number of BUSCOs: 1367)
# Summarized benchmarking in BUSCO notation for file /mnt/griffin/chrwhe/Pieris_macdunnoughii/busco/PmacD_assembly.fasta
# BUSCO was run in mode: genome

        ***** Results: *****

        C:92.4%[S:76.3%,D:16.1%],F:4.6%,M:3.0%,n:1367
        1263    Complete BUSCOs (C)
        1043    Complete and single-copy BUSCOs (S)
        220     Complete and duplicated BUSCOs (D)
        63      Fragmented BUSCOs (F)
        41      Missing BUSCOs (M)
        1367    Total BUSCO groups searched

# lep_obd10
# BUSCO version is: 5.beta
# The lineage dataset is: lepidoptera_odb10 (Creation date: 2020-08-05, number of species: 16, number of BUSCOs: 5286)
# Summarized benchmarking in BUSCO notation for file /mnt/griffin/chrwhe/Pieris_macdunnoughii/busco/PmacD_assembly.fasta
# BUSCO was run in mode: genome

        ***** Results: *****

        C:90.4%[S:75.1%,D:15.3%],F:5.6%,M:4.0%,n:5286
        4778    Complete BUSCOs (C)
        3969    Complete and single-copy BUSCOs (S)
        809     Complete and duplicated BUSCOs (D)
        295     Fragmented BUSCOs (F)
        213     Missing BUSCOs (M)
        5286    Total BUSCO groups searched
