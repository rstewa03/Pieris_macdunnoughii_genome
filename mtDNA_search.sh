# mtDNA genome. NCBI nucleotide search Pararge AND genome
https://www.ncbi.nlm.nih.gov/nuccore/635377229?report=fasta

# blast search

# the bait, the mtDNA gene or genome you want to fish with in the database
query=Paegeria_mtDNAgenome.fasta

# make the database of the genome assembly in which you want to fish for the mtDNA scaffolds
database=allpaths.contigs.fasta
#make database
/data/programs/ncbi-blast-n-rmblast-2.2.28+/makeblastdb -in $database -dbtype nucl

# run the blast with two different output formats
# blast with two output formats
/data/programs/ncbi-blast-n-rmblast-2.2.28+/blastn -query "$query" -db "$database" -evalue .00001 -out "$query"_v_"$database".tsv -outfmt 6 -num_threads 20
/data/programs/ncbi-blast-n-rmblast-2.2.28+/blastn -query "$query" -db "$database" -evalue .00001 -out "$query"_v_"$database".aln -outfmt 2 -num_threads 20

# blast columns
1          Query
2          Subject
3          %_id
4          alignment_length
5          mistmatches
6          gap_openings
7          q.start
8          q.end
9          s.start
10        s.end
11        e-value
12        bit_score


==> Paegeria_mtDNAgenome.fasta_v_allpaths.contigs.fasta.tsv <==
KJ547676.1      contig_47677    84.98   4747    634     61      7053    11749   4718    1       0.0     4747
KJ547676.1      contig_47678    87.64   3990    440     42      1       3970    4028    72      0.0     4590
KJ547676.1      contig_47679    83.94   2335    323     40      3893    6198    2319    8       0.0     2187
KJ547676.1      contig_7165     93.80   371     22      1       6770    7140    567     936     1e-155   556
KJ547676.1      contig_24104    98.70   231     3       0       738     968     5927    5697    1e-111   411
KJ547676.1      contig_54754    98.11   212     4       0       8235    8446    6867    7078    5e-100   372
KJ547676.1      contig_12130    95.18   228     11      0       1889    2116    1017    790     1e-96    361
KJ547676.1      contig_35821    95.91   220     7       2       380     598     310     528     5e-95    355
KJ547676.1      contig_10116    94.12   221     11      2       2443    2662    1042    1261    6e-89    335
KJ547676.1      contig_54801    97.89   190     4       0       4116    4305    1004    815     3e-87    329


# after this, one could take the scaffold in your assembly that was identified, and then blast that itself against a database.

# get your scaffold sequence out into a single fasta file that can be used to search in other databases
# fasta index and fetch using samtools
# index
genome=Phoebis_sennae_v1.1_-_scaffolds.fa
fasta_header=m_scaff_442
samtools faidx $genome
# search and extract
samtools faidx $genome $fasta_header > $fasta_header.fa

# BOLD database for COI gene sequences

# NCBI for whole mtDNA scaffolds.
