# or install from source
git clone https://github.com/malonge/RagTag
cd /mnt/griffin/chrwhe/software/RagTag
python3 setup.py install

# correct contigs
ragtag.py correct ref.fasta query.fasta

# scaffold contigs
ragtag.py scaffold ref.fa ragtag_output/query.corrected.fasta

cd /mnt/griffin/chrwhe/Pieris_macdunnoughii/RagTag_testing
ln -s /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/Pmac000.1_polished.fasta .
grep '>' $reference | head
>Chromosome_1
>Chromosome_2
>Chromosome_3
>Chromosome_4
>Chromosome_5
>Chromosome_6
>Chromosome_7
>Chromosome_8
>Chromosome_9
>Chromosome_10

/data/programs/exonerate-2.2.0-x86_64/bin/fastalength /mnt/griffin/Pierinae_genomes/Pieris_napi_genome_v1.1/Pieris_napi_fullAsm.fasta > Pieris_napi_fullAsm.fasta.len
more 11357067 Chromosome_1
15427984 Chromosome_2
15357576 Chromosome_3
14845049 Chromosome_4
14436900 Chromosome_5
13738639 Chromosome_6
14186557 Chromosome_7
14068971 Chromosome_8
13996725 Chromosome_9
13801688 Chromosome_10
13587546 Chromosome_11
12815933 Chromosome_12
12634055 Chromosome_13
12597868 Chromosome_14
12489475 Chromosome_15
11837383 Chromosome_16
11817185 Chromosome_17
11702215 Chromosome_18
10907953 Chromosome_19
10776756 Chromosome_20
10581609 Chromosome_21
9085402 Chromosome_22
6692213 Chromosome_23
5861113 Chromosome_24
4833285 Chromosome_25
14945 Mitochondria
1115531 modScaffold_0_1
463301 modScaffold_1_1



reference=/mnt/griffin/Pierinae_genomes/Pieris_napi_genome_v1.1/Pieris_napi_fullAsm.fasta
query=Pmac000.1_polished.fasta

grep '>' Pmac000.1_polished.fasta | head
>Sc0000000_pilon
>Sc0000001_pilon
>Sc0000002_pilon
>Sc0000003_pilon
>Sc0000004_pilon
>Sc0000005_pilon


# provide aligner. Uses minimap or nucmer
export PATH=$PATH:/data/programs/mummer-4.0.0beta2/
# run
python3 /mnt/griffin/chrwhe/software/RagTag/ragtag_scaffold.py $reference $query -o test_scaffold -t 10 --aligner nucmer
# Thu Sep 24 16:51:55 2020 --- WARNING: Without '-u' invoked, some component/object AGP pairs might share the same ID. Some external programs/databases don't like this. To ensure valid AGP format, use '-u'.

head ragtag.scaffolds.agp
## agp-version 2.1
# AGP created by RagTag
Chromosome_1_RagTag     1       14783675        1       W       Sc0000000_pilon 1       14783675        +
Chromosome_10_RagTag    1       1958188 1       W       xfSc0000012_pilon       1       1958188 -
Chromosome_10_RagTag    1958189 1958288 2       U       100     scaffold        yes     align_genus
Chromosome_10_RagTag    1958289 2362628 3       W       xfSc0000024_pilon       1       404340  -
Chromosome_10_RagTag    2362629 2362728 4       U       100     scaffold        yes     align_genus
Chromosome_10_RagTag    2362729 8091037 5       W       Sc0000014_pilon 1       5728309 -
Chromosome_10_RagTag    8091038 8091137 6       U       100     scaffold        yes     align_genus
Chromosome_10_RagTag    8091138 10530117        7       W       Sc0000040_pilon 1       2438980 +
....
Chromosome_9_RagTag     7442758 13578981        3       W       Sc0000013_pilon 1       6136224 -
Mitochondria_RagTag     1       542297  1       W       Sc0000056_pilon 1       542297  +
Mitochondria_RagTag     542298  542397  2       U       100     scaffold        yes     align_genus
Mitochondria_RagTag     542398  543272  3       W       xfSc0000060_pilon       1       875     -
modScaffold_13_2_RagTag 1       2683253 1       W       Sc0000034_pilon 1       2683253 +
modScaffold_274_1_RagTag        1       232498  1       W       xfSc0000029_pilon       1       232498  -
modScaffold_37_1_RagTag 1       2529180 1       W       xfSc0000007_pilon       1       2529180 -
modScaffold_65_1_RagTag 1       3796043 1       W       xfSc0000003_pilon       1       3796043 -
modScaffold_80_1_RagTag 1       2687699 1       W       xfSc0000006_pilon       1       2687699 +
modScaffold_96_1_RagTag 1       1663520 1       W       Sc0000046_pilon 1       1663520 +
modScaffold_98_1_RagTag 1       1379005 1       W       xfSc0000016_pilon       1       1379005 -
Sc0000052_pilon 1       1242929 1       W       Sc0000052_pilon 1       1242929 +
xfSc0000023_pilon       1       517527  1       W       xfSc0000023_pilon       1       517527  +
xfSc0000030_pilon       1       173345  1       W       xfSc0000030_pilon       1       173345  +
xfSc0000032_pilon       1       159224  1       W       xfSc0000032_pilon       1       159224  +
xfSc0000045_pilon       1       56165   1       W       xfSc0000045_pilon       1       56165   +
xfSc0000054_pilon       1       21081   1       W       xfSc0000054_pilon       1       21081   +
xfSc0000059_pilon       1       2337    1       W       xfSc0000059_pilon       1       2337    +
xpSc0000074_pilon       1       44819   1       W       xpSc0000074_pilon       1       44819   +
xpSc0000080_pilon       1       7203    1       W       xpSc0000080_pilon       1       7203    +
xpSc0000082_pilon       1       6117    1       W       xpSc0000082_pilon       1       6117    +
xpSc0000085_pilon       1       3253    1       W       xpSc0000085_pilon       1       3253    +
xpSc0000102_pilon       1       644     1       W       xpSc0000102_pilon       1       644     +

Pnapi 17_1 and 95_1 should have been on the Z, based upon Pmac. The were left out ... I guess because we are using
Pnapi as the refernece.

what is strange is what happened with the mtDNA .... also, for all of the modscaffolds found, there was
no scaffolding.

this suggests we should only run this with the large chromosomal scaffolds of Pnapi.



-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :           44
Maximum Contig Length : 16,113,070
Minimum Contig Length :      644
Average Contig Length : 7,183,488.0 ± 6,076,428.1
Median Contig Length :  13,348,964.0
Total Contigs Length :  316,073,471
Total Number of Non-ATGC Characters :      6,200
Percentage of Non-ATGC Characters :        0.002
Contigs >= 100 bp :           44
Contigs >= 200 bp :           44
Contigs >= 500 bp :           44
Contigs >= 1 Kbp :            43
Contigs >= 10 Kbp :           39
Contigs >= 1 Mbp :            31
N50 value :     12,928,009
Generated using /mnt/griffin/chrwhe/Pieris_macdunnoughii/RagTag_testing/test_scaffold/ragtag.scaffolds.fasta

-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :          106
Maximum Contig Length : 14,783,675
Minimum Contig Length :      644
Average Contig Length : 2,981,766.7 ± 3,035,767.2
Median Contig Length :  1,085,499.5
Total Contigs Length :  316,067,271
Total Number of Non-ATGC Characters :          0
Percentage of Non-ATGC Characters :        0.000
Contigs >= 100 bp :          106
Contigs >= 200 bp :          106
Contigs >= 500 bp :          106
Contigs >= 1 Kbp :           104
Contigs >= 10 Kbp :           99
Contigs >= 1 Mbp :            75
N50 value :     5,174,956
Generated using /data/programs/scripts/AsmQC /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/Pmac000.1_polished.fasta
