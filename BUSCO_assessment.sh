# on MILES

################################

24 August 2020 working

# standard run with insect SCO genes

genome=PmacD_assembly.fasta
library=insecta_odb9
outfile=PmacD_assembly_v_lepidoptera_odb10

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
