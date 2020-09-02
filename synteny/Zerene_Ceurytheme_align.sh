# zerene genome

cd /mnt/griffin/chrwhe/Colias_eurytheme_genome/align_Zerene_cesonia

wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/012/273/895/GCA_012273895.1_Zerene_cesonia_1.0/GCA_012273895.1_Zerene_cesonia_1.0_genomic.fna.gz

/data/programs/scripts/AsmQC GCA_012273895.1_Zerene_cesonia_1.0_genomic.fna
-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :          276
Maximum Contig Length : 12,428,619
Minimum Contig Length :      578
Average Contig Length : 965,293.9 ± 2,663,897.2
Median Contig Length :   1,822.0
Total Contigs Length :  266,421,107
Total Number of Non-ATGC Characters :   9,113,539
Percentage of Non-ATGC Characters :        3.421
Contigs >= 100 bp :          276
Contigs >= 200 bp :          276
Contigs >= 500 bp :          276
Contigs >= 1 Kbp :           272
Contigs >= 10 Kbp :           48
Contigs >= 1 Mbp :            39
N50 value :     9,214,832
Generated using /mnt/griffin/chrwhe/Colias_eurytheme_genome/align_Zerene_cesonia/GCA_012273895.1_Zerene_cesonia_1.0_genomic.fna

grep '>' GCA_012273895.1_Zerene_cesonia_1.0_genomic.fna | head
>CM022603.1 Zerene cesonia ecotype Mississippi chromosome I, whole genome shotgun sequence
>CM022604.1 Zerene cesonia ecotype Mississippi chromosome II, whole genome shotgun sequence
>CM022605.1 Zerene cesonia ecotype Mississippi chromosome III, whole genome shotgun sequence
>CM022606.1 Zerene cesonia ecotype Mississippi chromosome IV, whole genome shotgun sequence
>CM022607.1 Zerene cesonia ecotype Mississippi chromosome V, whole genome shotgun sequence
>CM022608.1 Zerene cesonia ecotype Mississippi chromosome VI, whole genome shotgun sequence
>CM022609.1 Zerene cesonia ecotype Mississippi chromosome VII, whole genome shotgun sequence
>CM022610.1 Zerene cesonia ecotype Mississippi chromosome VIII, whole genome shotgun sequence
>CM022611.1 Zerene cesonia ecotype Mississippi chromosome IX, whole genome shotgun sequence
>CM022612.1 Zerene cesonia ecotype Mississippi chromosome X, whole genome shotgun sequence
...
>JAAMXH010000271.1 Zerene cesonia Zces_u243, whole genome shotgun sequence
>JAAMXH010000272.1 Zerene cesonia Zces_u244, whole genome shotgun sequence
>JAAMXH010000273.1 Zerene cesonia Zces_u245, whole genome shotgun sequence
>JAAMXH010000274.1 Zerene cesonia Zces_u246, whole genome shotgun sequence
>JAAMXH010000275.1 Zerene cesonia Zces_u247, whole genome shotgun sequence
>CM022631.1 Zerene cesonia ecotype Mississippi mitochondrion, complete sequence, whole genome shotgun sequence

# getting header file for Zerene
grep '>' GCA_012273895.1_Zerene_cesonia_1.0_genomic.fna | cut -f1 -d ',' |\
awk '{gsub("Zerene cesonia ecotype Mississippi chromosome ","Chr_",$0); print;}' | \
awk '{gsub("Zerene cesonia ","",$0); print;}' |grep -v 'CM022631' |\
awk '{gsub(" ",",",$0); print;}' > Zerene_ID_shortname

# need to remove mitochondria and clean up scaffold names
grep '>' GCA_012273895.1_Zerene_cesonia_1.0_genomic.fna | cut -f1 -d ' ' | \
awk '{gsub(">","",$0); print;}' | grep -v 'CM022631' > Zces_scaffolds_no_mtDNA
wc -l Zces_scaffolds_no_mtDNA
275 Zces_scaffolds_no_mtDNA


# fasta index and fetch using samtools
# index
fasta_file=GCA_012273895.1_Zerene_cesonia_1.0_genomic.fna
ids=Zces_scaffolds_no_mtDNA
samtools faidx $fasta_file
# search and extract
while read p; do samtools faidx $fasta_file $p ; done < $ids >> Zerene_cesonia_genome_no_mtDNA.fa

grep '>' Zerene_cesonia_genome_no_mtDNA.fa | head
>CM022603.1
>CM022604.1
>CM022605.1
>CM022606.1
>CM022607.1
>CM022608.1

# # clean up scaffold names
# awk '{gsub("Zerene cesonia ecotype Mississippi chromosome ","Zces_CHR_",$0); print;}' Zerene_cesonia_genome_no_mtDNA.fa |\
# awk '{gsub(", whole genome shotgun sequence","",$0); print;}' | awk '{gsub(" Zerene cesonia","",$0); print;}' | grep '>' | more


#####
ln -s /mnt/griffin/chrwhe/Colias_eurytheme_genome/chromosome_level/agps/Ce_fixed_chromosome_assembly.fa .
grep '>' Ce_fixed_chromosome_assembly.fa | head
>CHR1
>CHR2
>CHR3
>CHR4
>CHR5

# align
# https://mummer4.github.io/manual/manual.html
/data/programs/mummer-4.0.0beta2/nucmer --mum -c 100 -t 5 -p nucmer_aln_CvZ Ce_fixed_chromosome_assembly.fa Zerene_cesonia_genome_no_mtDNA.fa
# pretty fast!
/data/programs/mummer-4.0.0beta2/show-coords -r -c -l nucmer_aln_CvZ.delta > nucmer_aln_CvZ.coords

# clean up output
head nucmer_aln_CvZ.coords
NUCMER

    [S1]     [E1]  |     [S2]     [E2]  |  [LEN 1]  [LEN 2]  |  [% IDY]  |  [LEN R]  [LEN Q]  |  [COV R]  [COV Q]  | [TAGS]
===============================================================================================================================
  140049   140750  |      695        1  |      702      695  |    95.45  | 15353925  8880244  |     0.00     0.01  | CHR1       CM022607.1
  140649   140901  |  1076386  1076639  |      253      254  |    95.67  | 15353925  6799442  |     0.00     0.00  | CHR1       CM022629.1
  140956   141404  |  6889088  6889539  |      449      452  |    94.69  | 15353925  9686145  |     0.00     0.00  | CHR1       CM022620.1

cat nucmer_aln_CvZ.coords | sed 1,5d | tr -s ' ' | awk 'BEGIN {FS=" "; OFS="\t"} {;print $1,$2,$4,$5,$7,$8,$10,$12,$13,$18,$19}' | head | column -t
140049  140750  695       1         702   695   95.45  15353925  8880244   CHR1  CM022607.1
140649  140901  1076386   1076639   253   254   95.67  15353925  6799442   CHR1  CM022629.1
140956  141404  6889088   6889539   449   452   94.69  15353925  9686145   CHR1  CM022620.1
141158  141404  551139    550890    247   250   94.00  15353925  4489607   CHR1  JAAMXH010000029.1
141233  141404  8758255   8758083   172   173   94.25  15353925  9514026   CHR1  CM022605.1
141233  141404  6618628   6618800   172   173   94.25  15353925  6750825   CHR1  CM022611.1
141233  141387  2040435   2040589   155   155   97.42  15353925  4489607   CHR1  JAAMXH010000029.1
141233  141404  798779    798608    172   172   97.67  15353925  1404085   CHR1  JAAMXH010000037.1
165801  166862  12402796  12401711  1062  1086  91.05  15353925  12428619  CHR1  CM022623.1
169466  169863  12399529  12399139  398   391   92.98  15353925  12428619  CHR1  CM022623.1

cat nucmer_aln_CvZ.coords | sed 1,5d | tr -s ' ' | awk 'BEGIN {FS=" "; OFS=","} {;print $1,$2,$4,$5,$7,$8,$10,$12,$13,$18,$19}' > nucmer_aln_CvZ.filt.coords
