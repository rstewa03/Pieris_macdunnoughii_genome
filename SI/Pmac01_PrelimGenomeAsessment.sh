########################################
#### Genome versions from Vogel lab ####
########################################
cd $PM_REF
/mnt/griffin/racste/Software/seqkit stats *fasta -a
# file                                format  type  num_seqs      sum_len  min_len      avg_len     max_len       Q1         Q2         Q3  sum_gap        N50  Q20(%)  Q30(%)
# PmacD_Flye.fasta                    FASTA   DNA     10,567  431,942,183       15     40,876.5   8,259,670    2,579      6,532     41,446        0    143,108       0       0
# PmacD_Flye_Polished_Purged.fasta    FASTA   DNA     3,147  320,914,943       46    101,974.9   8,281,812    7,791     60,490    128,479        0    198,669       0       0
# PmacD_flyeRac4Med.fasta             FASTA   DNA     11,791  421,858,107       66       35,778   8,295,014    1,170      4,061     30,635        0    149,789       0       0
# PmacD_flyeRac4MedPur.fasta          FASTA   DNA      3,415  324,675,409       67     95,073.3   8,295,014    6,073     54,018    122,453        0    197,436       0       0
# PmacD_necatRac4Med.fasta            FASTA   DNA      1,109  477,314,139       82    430,400.5   6,456,938    1,359     59,554    515,543        0  1,491,164       0       0
# PmacD_necatRac4MedPur.fasta         FASTA   DNA        293  346,761,953      125  1,183,487.9   6,456,938  176,422  1,009,322  1,878,252        0  2,086,740       0       0
# PmacD_qmRac4MedPur.fasta            FASTA   DNA        238  348,220,470      125  1,463,111.2  14,659,823  274,922  1,147,999  2,200,014        0  2,535,264       0       0

####################################
#### BUSCO of original versions ####
####################################
# define configs
export BUSCO_CONFIG_FILE=/data/programs/busco-4.1.2/config/config.ini

# Run multiple
library=lepidoptera_odb10
for i in `ls -1 *.fasta | sed 's/.fasta//'`
do
genome=$i.fasta;
outfile=${i}_v_lepidoptera_odb10;
python3 /data/programs/busco-4.1.2/bin/busco -i $genome -l $library -m genome -o $outfile -c 30;
done

# Make plots
# Move/copy all the short summaries into a single directory
# move into that directory, or run the script referencing that directory
python3 /data/programs/busco-4.1.2/scripts/generate_plot.py -wd .
