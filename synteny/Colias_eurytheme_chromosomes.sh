#
cd /cerberus/projects/chrwhe/Colias_eurytheme/martin_delivery
#
cd /cerberus/projects/chrwhe/Colias_eurytheme/martin_delivery/agps
ls *agp > agp_files_local


# the sorted in editor for this
chr1.agp
chr2.agp
chr3.agp
chr4.agp
chr5.agp
chr6.agp
chr7.agp
chr8.agp
chr9.agp
chr10.agp
chr11.agp
chr12.agp
chr13.agp
chr14.agp
chr15.agp
chr16.agp
chr17.agp
chr18.agp
chr19.agp
chr20.agp
chr21.agp
chr22.agp
chr23.agp
chr24.agp
chr25.agp
chr26.agp
chr27.agp
chr28.agp
chr29.agp
chr30.agp
chr31.agp

# pasting the above into this file
nano agp_files_local_sorted

# using the genome from Martin
gunzip Ce_fixed.fa.gz
cd /cerberus/projects/chrwhe/Colias_eurytheme/agps
ln -s /cerberus/projects/chrwhe/Colias_eurytheme/Ce_fixed.fa .

grep '>' Ce_fixed.fa | head
>Sc0000000
>Sc0000001
>Sc0000002
>Sc0000003
>Sc0000004
>Sc0000005
>Sc0000006
>Sc0000007
>Sc0000008
>Sc0000009

more chr1.agp
CHR1    1       5464688 1       W       Sc0000019       1       5464688 +
CHR1    5464689 5464788 2       U       100     contig  no      na
CHR1    5464789 12925950        3       W       Sc0000009       1       7461162 -
CHR1    12925951        12926050        4       U       100     contig  no      na
CHR1    12926051        15353925        5       W       Sc0000052       1       2427875 +

# zip for transfer to MILES
zip -r agp_colias.zip agps/
# move to MILES
scp agp_colias.zip chrwhe@miles.zoologi.su.se:/mnt/griffin/chrwhe/Colias_eurytheme_genome/chromosome_level

# using Lep-Anchor, usage:
# awk -f makefasta.awk file.fasta file_V2.agp >file_V2.fasta
# test
awk -f /mnt/griffin/chrwhe/software/scritps/makefasta.awk Ce_fixed.fa chr1.agp > chr1.fasta

# scale up to full genome
# run
while read p; do awk -f /mnt/griffin/chrwhe/software/scritps/makefasta.awk Ce_fixed.fa $p >> Ce_fixed_chromosome_assembly.fa ; done < agp_files_local_sorted

# fix headers
awk '{gsub(">","\n>",$0); print;}' Ce_fixed_chromosome_assembly.fa | sed 1d > Ce_fixed_chromosome_assembly_ed.fa
grep '>' Ce_fixed_chromosome_assembly_ed.fa
mv Ce_fixed_chromosome_assembly_ed.fa Ce_fixed_chromosome_assembly.fa
/data/programs/scripts/AsmQC Ce_fixed_chromosome_assembly.fa

-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :           31
Maximum Contig Length : 15,353,925
Minimum Contig Length : 6,007,853
Average Contig Length : 10,599,114.4 ± 2,286,390.5
Median Contig Length :  9,965,339.0
Total Contigs Length :  328,572,545
Total Number of Non-ATGC Characters :      7,500
Percentage of Non-ATGC Characters :        0.002
Contigs >= 100 bp :           31
Contigs >= 200 bp :           31
Contigs >= 500 bp :           31
Contigs >= 1 Kbp :            31
Contigs >= 10 Kbp :           31
Contigs >= 1 Mbp :            31
N50 value :     11,452,351
Generated using /mnt/griffin/chrwhe/Colias_eurytheme_genome/chromosome_level/agps/Ce_fixed_chromosome_assembly.fa






#
