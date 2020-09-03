Pieris_napi_genome_merge.sh



# data
-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :       59,536
Maximum Contig Length :  148,845
Minimum Contig Length :        1
Average Contig Length :  9,996.6 ± 10,831.6
Median Contig Length :  10,657.5
Total Contigs Length :  595,155,545
Total Number of Non-ATGC Characters :          0
Percentage of Non-ATGC Characters :        0.000
Contigs >= 100 bp :       57,728
Contigs >= 200 bp :       57,414
Contigs >= 500 bp :       56,620
Contigs >= 1 Kbp :        55,085
Contigs >= 10 Kbp :       19,229
Contigs >= 1 Mbp :             0
N50 value :       16,210
Generated using /cerberus/projects/shared_napi_rapae/assemblies/Pieris_napi.FALCON.fasta


/data/programs/scripts/AsmQC Pieris_napi_fullAsm.fasta
-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :        2,969
Maximum Contig Length : 15,427,984
Minimum Contig Length :      109
Average Contig Length : 117,804.0 ± 1,128,208.3
Median Contig Length :   2,479.0
Total Contigs Length :  349,759,982
Total Number of Non-ATGC Characters :   78,595,876
Percentage of Non-ATGC Characters :       22.471
Contigs >= 100 bp :        2,969
Contigs >= 200 bp :        2,968
Contigs >= 500 bp :        2,968
Contigs >= 1 Kbp :         2,841
Contigs >= 10 Kbp :          581
Contigs >= 1 Mbp :            37
N50 value :     12,597,868
Generated using /cerberus/projects/shared_napi_rapae/assemblies/Pieris_napi_fullAsm.fasta

scp chrwhe@duke.zoologi.su.se:/cerberus/projects/shared_napi_rapae/assemblies/Pieris_napi_fullAsm.fasta .



# outline


1) Merge the PacBio assembly
  # Take the PacBio assembly by Falcon and run Haplomerger2

2) Combine the result of the PacBio assembly with the P. napi chromonome
  # using Metassembler with the P. napi chromonome as the primary

3) Polish using the dataset that Naomi identifies for me
  # she will check a dataset to make sure its good and an individual


# location
cd /cerberus/projects/chrwhe/Pieris_napi_merge


# assess the Falcon assembly
# on MILES
cd /mnt/griffin/chrwhe/Pieris_napi_merger
scp chrwhe@duke.zoologi.su.se:/cerberus/projects/shared_napi_rapae/assemblies/Pieris_napi.FALCON.fasta .


# define paths
export PATH=$PATH:/data/programs/bbmap_34.94/:/data/programs/augustus-3.0.1/bin:/data/programs/augustus-3.0.1/scripts
AUGUSTUS_CONFIG_PATH=/data/programs/augustus-3.0.1/config
genome=Pieris_napi.FALCON.fasta
library=/data/programs/busco/insecta_odb9
outfile=Pieris_napi.FALCON_v2das_insectaBUSCO
python /data/programs/busco/scripts/run_BUSCO.py -i $genome -l $library -m genome -o $outfile -c 64

# The lineage dataset is: insecta_odb9 (Creation date: 2016-02-13, number of species: 42, number of BUSCOs: 1658)
# To reproduce this run: python /data/programs/busco/scripts/run_BUSCO.py -i Pieris_napi.FALCON.fasta -o Pieris_napi.FALCON_v2das_insectaBUSCO -l /data/programs/busco/insecta_odb9/ -m genome -c 64 -sp fly
#
# Summarized benchmarking in BUSCO notation for file Pieris_napi.FALCON.fasta
# BUSCO was run in mode: genome

        C:83.0%[S:56.2%,D:26.8%],F:7.0%,M:10.0%,n:1658

        1377    Complete BUSCOs (C)
        932     Complete and single-copy BUSCOs (S)
        445     Complete and duplicated BUSCOs (D)
        116     Fragmented BUSCOs (F)
        165     Missing BUSCOs (M)
        1658    Total BUSCO groups searched

# a very high fraction of duplicated and complete BUSCOS - 26% .... great empiricial evidence that the PacBio assembled effectively
# the two alternative haploid genomes, given the high het of the sample.


cd /mnt/griffin/chrwhe/Pieris_napi_merger
mkdir haplomerger2
cd haplomerger2
# clean
# clean the genome
in=../Pieris_napi.FALCON.fasta
out=Pieris_napi.FALCON.cleaned.fa
cat $in | /mnt/griffin/chrwhe/software/HaploMerger2_20180603/bin/faDnaPolishing.pl --legalizing \
 --maskShortPortion=1 --noLeadingN --removeShortSeq=1 > $out

# mask genome
# using RED
mkdir masking
cd masking/
export PATH=/data/programs/RED/redUnix64:/data/programs/RED/redmask-master:$PATH
ingenome=../Pieris_napi.FALCON.cleaned.fa
outgenome=Pieris_napi.FALCON.cleaned.masked.fa
redmask.py -i $ingenome -o $outgenome

# results
Masked genome: /mnt/griffin/chrwhe/Pieris_napi_merger/haplomerger2/masking/Pieris_napi.FALCON.cleaned.masked.fa.softmasked.fa
num scaffolds: 59,438
assembly size: 595,155,447 bp
masked repeats: 256,057,279 bp (43.02%)


# set up haplomerger run
# do this in my software folder as paths are done, and these are a bit complicated
cd /mnt/griffin/chrwhe/software/HaploMerger2_20180603
mkdir Pnap_merge_haploidify
cd Pnap_merge_haploidify
cp ../project_template/hm.batchB* ./ ; cp ../project_template/hm.batchA* ./ ; cp ../project_template/hm.batchD* ./
# changed all these that could be changed, from core = 1 to core = 32
cp ../project_template/all_lastz.ctl ./ ; cp ../project_template/scoreMatrix.q ./ ; cp ../project_example2/run_all_ed.batch ./

# get the masked genome and rename genome.fa
cat /mnt/griffin/chrwhe/Pieris_napi_merger/haplomerger2/masking/Pieris_napi.FALCON.cleaned.masked.fa.softmasked.fa > genome.fa
# zip it
gzip genome.fa
# run
sh ./run_all_ed.batch >run_all_ed.log 2>&1

# genome_A.fa.gz ## the diploid assembly with misjoins removed
# genome_A_ref.fa.gz ## the reference haploid assembly
# genome_A_alt.fa.gz ## the alternative haploid assembly
# genome_A_ref_D.fa.gz ## the reference haploid assembly with tandems removed

cd /mnt/griffin/chrwhe/Pieris_napi_merger/haplomerger2
zcat /mnt/griffin/chrwhe/software/HaploMerger2_20180603/Pnap_merge_haploidify/genome_A_ref.fa.gz > Pieris_napi.FALCON.cleaned.masked.softmasked.haploidA.fa
zcat /mnt/griffin/chrwhe/software/HaploMerger2_20180603/Pnap_merge_haploidify/genome_A_ref_D.fa.gz > Pieris_napi.FALCON.cleaned.masked.softmasked.haploidA.tndrm.fa
zcat /mnt/griffin/chrwhe/software/HaploMerger2_20180603/Pnap_merge_haploidify/genome.fa.gz > Pieris_napi.FALCON.cleaned.masked.softmasked.fa

# assess merger of Falcon
/data/programs/scripts/AsmQC Pieris_napi.FALCON.cleaned.masked.softmasked.haploidA.fa  │····
-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :       24,843
Maximum Contig Length :  172,617
Minimum Contig Length :      503
Average Contig Length : 15,694.8 ± 16,133.8
Median Contig Length :   4,593.0
Total Contigs Length :  389,905,419
Total Number of Non-ATGC Characters :          0
Percentage of Non-ATGC Characters :        0.000
Contigs >= 100 bp :       24,843
Contigs >= 200 bp :       24,843
Contigs >= 500 bp :       24,843
Contigs >= 1 Kbp :        24,641
Contigs >= 10 Kbp :       12,188
Contigs >= 1 Mbp :             0
N50 value :       26,338
Generated using /mnt/griffin/chrwhe/Pieris_napi_merger/haplomerger2_FALCON/Pieris_napi.FALCON.cleaned.masked.softmasked.haploidA.tndrm.fa
# this is great, just about halved the number of contigs, and have a total assembly that is
# closer to the expected level.

# haplomerger2 on Pieris_napi_fullAsm
ln -s /mnt/griffin/chrwhe/software/HaploMerger2_20180603/Pnap_haploidify/Pieris_napi_fullAsm.cleaned.masked.haploidA.tndrm.fa .
-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :        1,478
Maximum Contig Length : 15,377,620
Minimum Contig Length :      548
Average Contig Length : 230,216.3 ± 1,580,553.8
Median Contig Length :   5,902.5
Total Contigs Length :  340,259,761
Total Number of Non-ATGC Characters :   74,846,293
Percentage of Non-ATGC Characters :       21.997
Contigs >= 100 bp :        1,478
Contigs >= 200 bp :        1,478
Contigs >= 500 bp :        1,478
Contigs >= 1 Kbp :         1,418
Contigs >= 10 Kbp :          355
Contigs >= 1 Mbp :            38
N50 value :     12,541,812
Generated using /mnt/griffin/chrwhe/Pnap_haplomerger/Pieris_napi_fullAsm.cleaned.masked.haploidA.tndrm.fa
