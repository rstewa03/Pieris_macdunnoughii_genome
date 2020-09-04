###################
# using HaploMerger2
#
# which is merging the two haploid genomes in a genome assemlby
#
# below is
	# 1 - setup for HaploMerger2
	# 2 - a full exmaple of how to do all the steps for a proper merging (cleaning, masking, merging)
	# 3 - BUSCO and AsmQC shoudl be used to check the genome phenotype before and after
	# 4 - do not use the tandem repeate removed genome, as this is an experimental step
###################
# https://academic.oup.com/bioinformatics/article/33/16/2577/3603547
# website
https://github.com/mapleforest/HaploMerger2

###################
# setup
# a local installation is needed
#
wget https://github.com/mapleforest/HaploMerger2/releases/download/HaploMerger2_20161205/HaploMerger2_20180603.tar.gz
wget https://github.com/mapleforest/HaploMerger2/releases/download/HaploMerger2_20161205/manual.v3.6.pdf

# in your working directory
mkdir software
cd software
# get the software, uncompress, go into it
wget https://github.com/mapleforest/HaploMerger2/releases/download/HaploMerger2_20161205/HaploMerger2_20180603.tar.gz
tar -zxvf HaploMerger2_20180603.tar.gz
cd HaploMerger2_20180603

# settings.
# A - remove major misjoins from the diploid assembly
# B - create the haploid assemblies, scaffold using assembly data
# C - further scaffold the haploid assemblies using MP data
# D - remove tandem errors from the haploid assembliy (use with caution)
# E - gap fill

# gather a folder of template run files where I have increased the number of cores up to 32
cp -R /data/programs/scripts/HaploMerger2_20180603/project_template_32/ .

###################
# ignore
# for processes that can extend this far
# sudo cp -R /mnt/griffin/chrwhe/software/HaploMerger2_20180603/project_template_32/ /data/programs/scripts/HaploMerger2_20180603/project_template_32/
# /mnt/griffin/chrwhe/software/HaploMerger2_20180603/project_example2$ sudo cp run*batch /data/programs/HaploMerger2_20180603/
# sudo mv /data/programs/HaploMerger2_20180603/run_all_ed.batch /data/programs/HaploMerger2_20180603/run_ABD.batch
###################





###################
# a full exmaple of how to do all the steps for a proper merging
# go to your installation of HaploMerger2_20180603
cd /software/HaploMerger2_20180603

# make a new folder for the genome merging you want to do, here I use "new_genome", but you can use anything
mkdir new_genome
cd new_genome

###########
# clean the genome
mkdir cleaning
cd cleaning
in=../Pieris_napi.FALCON.fasta
out=Pieris_napi.FALCON.cleaned.fa
cat $in | /mnt/griffin/chrwhe/software/HaploMerger2_20180603/bin/faDnaPolishing.pl --legalizing \
 --maskShortPortion=1 --noLeadingN --removeShortSeq=1 > $out
cd ..

###########
# mask the genome using RED
mkdir masking
cd masking/
export PATH=/data/programs/RED/redUnix64/:$PATH
ingenome=../cleaning/Pieris_napi.FALCON.cleaned.fa
outgenome=Pieris_napi.FALCON.cleaned.masked.fa
python redmask.py -i $ingenome -o $outgenome > $outgenome.red_results.log
# see what you got
more *red_results.log
# ...
# Masked genome: /mnt/griffin/chrwhe/Pieris_rapae_v1/genome_fullASM/masking/Pieris_rapae_fullAsm.softmasked.fa
# Repeat BED file: /mnt/griffin/chrwhe/Pieris_rapae_v1/genome_fullASM/masking/Pieris_rapae_fullAsm.repeats.bed
# Repeat FASTA file: /mnt/griffin/chrwhe/Pieris_rapae_v1/genome_fullASM/masking/Pieris_rapae_fullAsm.repeats.fasta
# num scaffolds: 2,772
# assembly size: 323,179,347 bp
# masked repeats: 118,710,751 bp (36.73%)
cd ..

###########
# haplomerger2 run
# you should now be in your new project folder within /software/HaploMerger2_20180603
# that is
# you should be, within this example in /software/HaploMerger2_20180603/new_genome
# where you have the older folders of cleaning and maksing

# now copy necessary scripts for running scripts A, B and D
cp ../project_template_32/hm.batchB* ./ ; cp ../project_template_32/hm.batchA* ./ ; cp ../project_template_32/hm.batchD* ./
# copy necessary scripts for other parts of program
cp ../project_template/all_lastz.ctl ./ ; cp ../project_template/scoreMatrix.q ./
# copy a control script for running batches ABD
cp /data/programs/HaploMerger2_20180603/run_ABD.batch ./


# copy your cleaned and masked genome here and rename it to genome.fa.
# this is because the internal haplomerger2 scripts are written to only use
# a file name "genome.fa", and I have not changed this
cat ../masking/Pieris_napi.FALCON.cleaned.masked.fa > genome.fa
# zip it
gzip genome.fa
# run haplomerger2 ....
sh ./run_ABD.batch >run_all_ed.log 2>&1


# you should find these output files, among many others
# they are:

# genome_A.fa.gz ## the diploid assembly with misjoins removed
# genome_A_ref.fa.gz ## the reference haploid assembly
# genome_A_alt.fa.gz ## the alternative haploid assembly
# genome_A_ref_D.fa.gz ## the reference haploid assembly with tandems removed (use only with caution)

# you can expand these files to a more appropriate naming, which for my example would be:
zcat genome_A.fa.gz > Pieris_napi.FALCON.cleaned.masked.misjoins_rm.fa
zcat genome_A_ref.fa.gz > Pieris_napi.FALCON.cleaned.masked.haploidA.fa
zcat genome_A_ref_D.fa.gz > Pieris_napi.FALCON.cleaned.masked.haploidA.tndrm.fa
# original
zcat genome.fa.gz > Pieris_napi.FALCON.cleaned.masked.fa

###########
# assess merger
# e.g.
/data/programs/scripts/AsmQC Pieris_napi.FALCON.cleaned.masked.fa
/data/programs/scripts/AsmQC Pieris_napi.FALCON.cleaned.masked.misjoins_rm.fa
/data/programs/scripts/AsmQC Pieris_napi.FALCON.cleaned.masked.haploidA.fa

# for example
/data/programs/scripts/AsmQC Pieris_napi.FALCON.cleaned.masked.fa
-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :       55,093
Maximum Contig Length :  148,845
Minimum Contig Length :      338
Average Contig Length : 10,775.3 ± 10,892.6
Median Contig Length :  11,366.0
Total Contigs Length :  593,645,160
Total Number of Non-ATGC Characters :          0
Percentage of Non-ATGC Characters :        0.000
Contigs >= 100 bp :       55,093
Contigs >= 200 bp :       55,093
Contigs >= 500 bp :       55,090
Contigs >= 1 Kbp :        55,085
Contigs >= 10 Kbp :       19,229
Contigs >= 1 Mbp :             0
N50 value :       16,267
Generated using /mnt/griffin/chrwhe/testing/haplomerger2/HaploMerger2_20180603/test_run/Pieris_napi.FALCON.cleaned.masked.fa

/data/programs/scripts/AsmQC Pieris_napi.FALCON.cleaned.masked.haploidA.fa
-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :       47,986
Maximum Contig Length :  148,845
Minimum Contig Length :      537
Average Contig Length : 11,613.9 ± 11,363.2
Median Contig Length :   7,835.5
Total Contigs Length :  557,302,899
Total Number of Non-ATGC Characters :          0
Percentage of Non-ATGC Characters :        0.000
Contigs >= 100 bp :       47,986
Contigs >= 200 bp :       47,986
Contigs >= 500 bp :       47,986
Contigs >= 1 Kbp :        47,975
Contigs >= 10 Kbp :       18,478
Contigs >= 1 Mbp :             0
N50 value :       17,311
Generated using /mnt/griffin/chrwhe/testing/haplomerger2/HaploMerger2_20180603/test_run/Pieris_napi.FALCON.cleaned.masked.haploidA.fa

# and also use BUSCO.
