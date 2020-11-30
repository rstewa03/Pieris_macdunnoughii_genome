
#####################################
#### Set up Haplomerger 2 folder ####
#####################################

# HaploMerger2 installed locally
cd /mnt/griffin/racste/Software/HaploMerger2_20180603

# settings.
# A - remove major misjoins from the diploid assembly
# B - create the haploid assemblies, scaffold using assembly data
# C - further scaffold the haploid assemblies using MP data
# D - remove tandem errors from the haploid assembliy (use with caution)
# E - gap fill

# gather a folder of template run files where I have increased the number of cores up to 32
cp -R /data/programs/scripts/HaploMerger2_20180603/project_template_32/ . # make sure it isn't nested

# make a new folder for the genome merging you want to do, here I use "new_genome", but you can use anything
mkdir HAC_qmerge #aka new_genome in examples
export HM_DIR=/mnt/griffin/racste/Software/HaploMerger2_20180603/HAC_qmerge/
cd $HM_DIR

###############################################
#### Clean and maks the quickmerged genome ####
###############################################
###########
# Cleaning
mkdir -p $HM_DIR/cleaning
cd $HM_DIR/cleaning
in=$PM_REF/PmacD_qmRac4MedPur.fasta
out=PmacD_qmRac4MedPur.cleaned.fa
cat $in | /mnt/griffin/racste/Software/HaploMerger2_20180603/bin/faDnaPolishing.pl --legalizing --maskShortPortion=1 --noLeadingN --removeShortSeq=1 > $out
cd ..

###########
# mask the genome using RED
mkdir -p $HM_DIR/masking
cd $HM_DIR/masking/
ingenome=$HM_DIR/cleaning/PmacD_qmRac4MedPur.cleaned.fa
outgenome=.
/data/programs/RED/redUnix64/Red -gnm $ingenome -msk $outgenome -rpt $outgenome -tbl red_results.txt
# output : PmacD_qmRac4MedPur.cleaned.msk

#############################################
#### Remove duplicates with Haplomerger2 ####
#############################################
# haplomerger2 run
# you should be, within this example in /software/HaploMerger2_20180603/new_genome
# where you have the older folders of cleaning and maksing
cd $HM_DIR/

# now copy necessary scripts for running scripts A, B and D
cp ../project_template_32/hm.batchB* ./ ; cp ../project_template_32/hm.batchA* ./ ; cp ../project_template_32/hm.batchD* ./
# copy necessary scripts for other parts of program
cp ../project_template/all_lastz.ctl ./ ; cp ../project_template/scoreMatrix.q ./
# copy a control script for running batches ABD
cp /data/programs/HaploMerger2_20180603/run_ABD.batch ./


# copy your cleaned and masked genome here and rename it to genome.fa.
# this is because the internal haplomerger2 scripts are written to only use
# a file name "genome.fa", and I have not changed this
cat $HM_DIR/masking/PmacD_qmRac4MedPur.cleaned.msk > genome.fa

# run haplomerger2 on the zipped, masked, cleaned genome
gzip genome.fa
sh ./run_ABD.batch >run_all_ed.log 2>&1


# haplomerger output files:
# (there will be many)

# genome_A.fa.gz ## the diploid assembly with misjoins removed
# genome_A_ref.fa.gz ## the reference haploid assembly
# genome_A_alt.fa.gz ## the alternative haploid assembly
# genome_A_ref_D.fa.gz ## the reference haploid assembly with tandems removed (use only with caution)

# you can expand these files to a more appropriate naming, which for my example would be:
zcat genome_A.fa.gz > PmacD_qmRac4MedPur.cleaned.masked.misjoins_rm.fa
zcat genome_A_ref.fa.gz > PmacD_qmRac4MedPur.cleaned.masked.haploidA.fa
zcat genome_A_ref_D.fa.gz > PmacD_qmRac4MedPur.cleaned.masked.haploidA.tndrm.fa
# original
zcat genome.fa.gz > PmacD_qmRac4MedPur.cleaned.masked.fa

mkdir final_genomes
mv PmacD_qmRac4MedPur*fa final_genomes/

cd $HM_DIR/final_genomes

# check quality
/mnt/griffin/racste/Software/seqkit stats PmacD*fa -a
# file                                                 format  type  num_seqs      sum_len  min_len      avg_len     max_len       Q1         Q2         Q3  sum_gap        N50  Q20(%)  Q30(%)
# PmacD_qmRac4MedPur.cleaned.masked.fa                 FASTA   DNA        238  348,220,470      125  1,463,111.2  14,659,823  274,922  1,147,999  2,200,014        0  2,535,264       0       0
# PmacD_qmRac4MedPur.cleaned.masked.haploidA.fa        FASTA   DNA        106  319,093,312      644  3,010,314.3  14,890,372  557,969  2,096,183  4,606,427        0  5,239,500       0       0
# PmacD_qmRac4MedPur.cleaned.masked.haploidA.tndrm.fa  FASTA   DNA        106  318,207,461      644  3,001,957.2  14,856,236  545,962  2,096,183  4,593,171        0  5,178,737       0       0
# PmacD_qmRac4MedPur.cleaned.masked.misjoins_rm.fa     FASTA   DNA        246  348,220,002      314  1,415,528.5  14,659,823  261,958  1,128,227  2,050,900        0  2,421,914       0       0

# Run BUSCO
export BUSCO_CONFIG_FILE=/data/programs/busco-4.1.2/config/config.ini
library=lepidoptera_odb10
for i in `ls -1 *fa | sed 's/.fa//'`
do
genome=$i.fa;
outfile=${i}_v_lepidoptera_odb10;
python3 /data/programs/busco-4.1.2/bin/busco -i $genome -l $library -m genome -o $outfile -c 30;
done


mkdir BUSCO_summaries
# Move short summaries into BUSCO_summaries
python3 /data/programs/busco-4.1.2/scripts/generate_plot.py -wd .
