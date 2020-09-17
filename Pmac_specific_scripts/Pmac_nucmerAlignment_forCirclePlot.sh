#############################################
#### Align Pmac genome versions to Pnapi ####
#############################################

export TOOLS=/data/programs
export PM_READS=/mnt/griffin/Reads/Pieris_macdounghii_data
export PM_HOME=/mnt/griffin/racste/P_macdunnoughii
export PM_DATA=$PM_HOME/Pmac_data
export PM_ALIGN=$PM_HOME/Pmac_alignments
export PM_REF=$PM_HOME/Pmac_genome_versions
export PM_ANNOT=$PM_HOME/Pmac_annotations
# export PM_POLISHED=$PM_ALIGN/NGM_genome/PmacD_qmRac4MedPur.cleaned.masked/qmRac4MedPur.cleaned.masked_polish
export PM_POLISHED=$PM_REF

mkdir -p $PM_POLISHED/align_Pnapi
cd $PM_POLISHED/align_Pnapi

mkdir -p $PM_REF/align_Pnapi
cd $PM_REF/align_Pnapi

# Pnapi path
# /mnt/griffin/Pierinae_genomes/Pieris_napi_genome_v1.1/Pieris_napi_fullAsm.fasta
Reference=/mnt/griffin/Pierinae_genomes/Pieris_napi_genome_v1.1/Pieris_napi_fullAsm.fasta
/data/programs/scripts/AsmQC $Reference
# -------------------------------
#     AssemblyQC Result  
# -------------------------------
# Contigs Generated :         2969
# Maximum Contig Length : 15427984
# Minimum Contig Length :      109
# Average Contig Length : 117804.0 ± 1128208.3
# Median Contig Length :    2479.0
# Total Contigs Length :  349759982
# Total Number of Non-ATGC Characters :   78595876
# Percentage of Non-ATGC Characters :       22.471
# Contigs >= 100 bp :         2969
# Contigs >= 200 bp :         2968
# Contigs >= 500 bp :         2968
# Contigs >= 1 Kbp :          2841
# Contigs >= 10 Kbp :          581
# Contigs >= 1 Mbp :            37
# N50 value :     12597868

grep '>' $Reference | head
# >Chromosome_1
# >Chromosome_2
# >Chromosome_3
# >Chromosome_4
# >Chromosome_5
# >Chromosome_6
# >Chromosome_7
# >Chromosome_8
# >Chromosome_9
# >Chromosome_10
# ...
# >modScaffold_2994_1
# >modScaffold_2995_1
# >modScaffold_2996_1
# >modScaffold_2997_1
# >modScaffold_2998_1
# >modScaffold_2999_1
# >modScaffold_3000_1
# >modScaffold_3001_1
# >modScaffold_3002_1
# >modScaffold_3003_1
grep '>' $Reference | sed 's/>//' > Pnap_contigs.txt

#samtools faidx Pieris_napi_fullAsm.fasta   
# NAME          Name of this reference sequence
# LENGTH      Total length of this reference sequence, in bases
# OFFSET      Offset in the FASTA/FASTQ file of this sequence's first base
# LINEBASES     The number of bases on each line
# LINEWIDTH     The number of bytes in each line, including the newline
# QUALOFFSET  Offset of sequence's first quality within the FASTQ file
# Name            LENGTH          Offset          LINEBASES       linewidth         qualoffset
# Chromosome_1    11357067        14              11357067        11357068
# Chromosome_2    15427984        11357096        15427984        15427985
# Chromosome_3    15357576        26785095        15357576        15357577
# Chromosome_4    14845049        42142686        14845049        14845050
# Chromosome_5    14436900        56987750        14436900        14436901
# Chromosome_6    13738639        71424665        13738639        13738640
# Chromosome_7    14186557        85163319        14186557        14186558
# Chromosome_8    14068971        99349891        14068971        14068972
# Chromosome_9    13996725        113418877       13996725        13996726
# Chromosome_10   13801688        127415618       13801688        13801689

####
# Pmac genome polished with Pmac000.1
 Query=$PM_POLISHED/Pmac000.1_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.pilon.polish.fasta

# compare to quickmerged flye+NECAT assembly 
# Query=$PM_POLISHED/PmacD_qmRac4MedPur.fasta

/data/programs/scripts/AsmQC $Query

# -------------------------------
#     AssemblyQC Result  
# -------------------------------
# Contigs Generated :          106
# Maximum Contig Length : 14783675
# Minimum Contig Length :      644
# Average Contig Length : 2981766.7 ± 3035767.2
# Median Contig Length :  1085499.5
# Total Contigs Length :  316067271
# Total Number of Non-ATGC Characters :          0
# Percentage of Non-ATGC Characters :        0.000
# Contigs >= 100 bp :          106
# Contigs >= 200 bp :          106
# Contigs >= 500 bp :          106
# Contigs >= 1 Kbp :           104
# Contigs >= 10 Kbp :           99
# Contigs >= 1 Mbp :            75
# N50 value :      5174956

grep '>' $Query |head
# >Sc0000000_pilon
# >Sc0000001_pilon
# >Sc0000002_pilon
# >Sc0000003_pilon
# >Sc0000004_pilon
# >Sc0000005_pilon
# >Sc0000006_pilon
# >Sc0000007_pilon
# >Sc0000008_pilon
# >Sc0000009_pilon
# ...
# >xfSc0000059_pilon
# >xfSc0000060_pilon
# >xpSc0000064_pilon
# >xpSc0000072_pilon
# >xpSc0000074_pilon
# >xpSc0000080_pilon
# >xpSc0000082_pilon
# >xpSc0000085_pilon
# >xpSc0000087_pilon
# >xpSc0000102_pilon
grep '>' $Query | sed 's/>//' > Pmac_contigs.txt

# ==> Pmac000.1_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.pilon.polish.fasta.fai <==
# Sc0000000_pilon 14783675        17              80      81
# Sc0000001_pilon 12381485        14968505        80      81
# Sc0000002_pilon 11695350        27504776        80      81
# Sc0000003_pilon 11559160        39346335        80      81
# Sc0000004_pilon 11137120        51050002        80      81
# Sc0000005_pilon 8942979         62326353        80      81
# Sc0000006_pilon 7688508         71381137        80      81
# Sc0000007_pilon 7442657         79165769        80      81
# Sc0000008_pilon 6814364         86701477        80      81
# Sc0000009_pilon 6304136         93601038        80      81

# align
# https://mummer4.github.io/manual/manual.html
# list reference genome first, then query genome
# Prefix=nucmer_aln_Pnap_v_Pmac000.1polish
Prefix=nucmer_aln_Pnap_v_Pmacqm
/data/programs/mummer-4.0.0beta2/nucmer --mum -c 100 -t 5 -p $Prefix $Reference $Query

# Options (default value in (), *required):
#      --mum                                Use anchor matches that are unique in both the reference and query (false)
#      --maxmatch                           Use all anchor matches regardless of their uniqueness (false)
#  -b, --breaklen=uint32                    Set the distance an alignment extension will attempt to extend poor scoring regions before giving up (200)
#  -c, --mincluster=uint32                  Sets the minimum length of a cluster of matches (65)
#  -D, --diagdiff=uint32                    Set the maximum diagonal difference between two adjacent anchors in a cluster (5)
#  -d, --diagfactor=double                  Set the maximum diagonal difference between two adjacent anchors in a cluster as a differential fraction of the gap length (0.12)
#      --noextend                           Do not perform cluster extension step (false)
#  -f, --forward                            Use only the forward strand of the Query sequences (false)
#  -g, --maxgap=uint32                      Set the maximum gap between two adjacent matches in a cluster (90)
#  -l, --minmatch=uint32                    Set the minimum length of a single exact match (20)
#  -L, --minalign=uint32                    Minimum length of an alignment, after clustering and extension (0)
#      --nooptimize                         No alignment score optimization, i.e. if an alignment extension reaches the end of a sequence, it will not backtrack to optimize the alignment score and instead terminate the alignment at the end of the sequence (false)
#  -r, --reverse                            Use only the reverse complement of the Query sequences (false)
#      --nosimplify                         Don't simplify alignments by removing shadowed clusters. Use this option when aligning a sequence to itself to look for repeats (false)
#  -p, --prefix=PREFIX                      Write output to PREFIX.delta (out)
#      --delta=PATH                         Output delta file to PATH (instead of PREFIX.delta)
#      --sam-short=PATH                     Output SAM file to PATH, short format
#      --sam-long=PATH                      Output SAM file to PATH, long format
#      --save=PREFIX                        Save suffix array to files starting with PREFIX
#      --load=PREFIX                        Load suffix array from file starting with PREFIX
#      --batch=BASES                        Proceed by batch of chunks of BASES from the reference
#  -t, --threads=NUM                        Use NUM threads (# of cores)
#  -U, --usage                              Usage
#  -h, --help                               This message
#      --full-help                          Detailed help
#  -V, --version                            Version

/data/programs/mummer-4.0.0beta2/show-coords -r -c -l $Prefix.delta > $Prefix.coords
# clean up output
head $Prefix.coords
# NUCMER
# 
#     [S1]     [E1]  |     [S2]     [E2]  |  [LEN 1]  [LEN 2]  |  [% IDY]  |  [LEN R]  [LEN Q]  |  [COV R]  [COV Q]  | [TAGS]
# ===============================================================================================================================
#        1      525  | 12350468 12349944  |      525      525  |    98.67  | 11357067 12381485  |     0.00     0.00  | Chromosome_1       Sc0000001_pilon
#        1      525  |    70293    70816  |      525      524  |    98.48  | 11357067  6176668  |     0.00     0.01  | Chromosome_1       Sc0000010_pilon
#        1      525  |    81545    82070  |      525      526  |    98.10  | 11357067  4131511  |     0.00     0.01  | Chromosome_1       Sc0000025_pilon
#        1      525  |  2650798  2650275  |      525      524  |    98.29  | 11357067  2683253  |     0.00     0.02  | Chromosome_1       Sc0000034_pilon
#        1      525  |  2449780  2449257  |      525      524  |    98.29  | 11357067  2488271  |     0.00     0.02  | Chromosome_1       Sc0000037_pilon


cat $Prefix.coords | sed 1,5d | tr -s ' ' | awk 'BEGIN {FS=" "; OFS="\t"} {;print $1,$2,$4,$5,$7,$8,$10,$12,$13,$18,$19}' | head | column -t
# 1  525  12350468  12349944  525  525  98.67  11357067  12381485  Chromosome_1  Sc0000001_pilon
# 1  525  70293     70816     525  524  98.48  11357067  6176668   Chromosome_1  Sc0000010_pilon
# 1  525  81545     82070     525  526  98.10  11357067  4131511   Chromosome_1  Sc0000025_pilon
# 1  525  2650798   2650275   525  524  98.29  11357067  2683253   Chromosome_1  Sc0000034_pilon
# 1  525  2449780   2449257   525  524  98.29  11357067  2488271   Chromosome_1  Sc0000037_pilon
# 1  525  4011      4535      525  525  98.48  11357067  6410227   Chromosome_1  xfSc0000001_pilon
# 1  482  664194    663713    482  482  98.13  11357067  5174956   Chromosome_1  xfSc0000002_pilon
# 1  525  1777215   1776691   525  525  98.48  11357067  1954889   Chromosome_1  xfSc0000011_pilon
# 1  525  32388     32912     525  525  98.48  11357067  1762511   Chromosome_1  xfSc0000015_pilon
# 1  525  1294769   1294245   525  525  98.48  11357067  1379005   Chromosome_1  xfSc0000016_pilon

cat $Prefix.coords | sed 1,5d | tr -s ' ' | awk 'BEGIN {FS=" "; OFS=","} {;print $1,$2,$4,$5,$7,$8,$10,$12,$13,$18,$19}' > $Prefix.filt.coords


#### alternative alignment method allows for filtering before plotting, produces tsv-style output
$TOOLS/mummer-4.0.0beta2/nucmer --mum -c 100 Pieris_napi_fullAsm.fasta $PM_POLISHED/Pmac000.1_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.pilon.polish.fasta -p alt_Pmac00.1_Pnap_nucmer -t 30
$TOOLS/mummer-4.0.0beta2/delta-filter -l 1000 -q alt_Pmac00.1_Pnap_nucmer.delta > alt_Pmac00.1_Pnap_nucmer_filter.delta
$TOOLS/mummer-4.0.0beta2/show-coords -c -l -L 1000 -r -T alt_Pmac00.1_Pnap_nucmer_filter.delta > alt_Pmac00.1_Pnap_nucmer_filter_coords.txt


