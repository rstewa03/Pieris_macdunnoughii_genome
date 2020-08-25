# mtDNA genome. NCBI nucleotide search Pararge AND genome
Pierap_mtDNA.fasta
# blast search

# the bait, the mtDNA gene or genome you want to fish with in the database
query=Pierap_mtDNA.fasta

# make the database of the genome assembly in which you want to fish for the mtDNA scaffolds
ln -s /mnt/griffin/racste/PmacD_Rac4MedPurge.fasta .
database=PmacD_Rac4MedPurge.fasta

/data/programs/ncbi-blast-n-rmblast-2.2.28+/makeblastdb -in $database -dbtype nucl

# run  blast with two different output formats
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

# head Pierap_mtDNA.fasta_v_PmacD_Rac4MedPurge.fasta.tsv 
# HM156697.1	contig_5550_segment0	93.29	2175	131	12	1	2171	164719	162556	0.0	3193
# HM156697.1	contig_5550_segment0	90.47	1060	71	27	14111	15156	165763	164720	0.0	1371
# HM156697.1	contig_5286_segment0	93.16	2077	131	10	1029	3100	237889	239959	0.0	3038
# HM156697.1	contig_7627_segment0	93.33	405	20	6	13040	13440	30817	31218	3e-166	 592
# HM156697.1	contig_8_segment0	    89.34	441	41	5	9667	10107	86241	85807	2e-153	 549
# HM156697.1	contig_6069_segment0	85.79	366	30	9	12054	12416	6846	6500	5e-99	 368
# HM156697.1	contig_5325_segment0	92.43	251	19	0	3263	3513	232499	232249	3e-96	 359
# HM156697.1	contig_5613_segment0	80.43	511	52	29	5627	6137	297347	296885	3e-92	 346
# HM156697.1	contig_6032_segment0	97.85	186	2	2	8006	8190	19956	19772	2e-84	 320
# HM156697.1	contig_5718_segment0	94.66	206	9	1	3568	3771	113538	113743	6e-84	 318

# after this, one could take the scaffold in your assembly that was identified, and then blast that itself against a database.

# get your scaffold sequence out into a single fasta file that can be used to search in other databases
# fasta index and fetch using samtools
# index
genome=PmacD_Rac4MedPurge.fasta
fasta_header=contig_5550_segment0
samtools faidx $genome
# search and extract
samtools faidx $genome $fasta_header:162556-164719 > $fasta_header.164719_162556.fa
samtools faidx $genome $fasta_header:164720-165763 > $fasta_header.164720_165763.fa
fasta_header=contig_5286_segment0
samtools faidx $genome $fasta_header:237889-239959 > $fasta_header.237889_239959.fa

#### P. macdunnoughii config
query=Pmac_COI.fasta
/data/programs/ncbi-blast-n-rmblast-2.2.28+/blastn -query "$query" -db "$database" -evalue .00001 -out "$query"_v_"$database".tsv -outfmt 6 -num_threads 20
/data/programs/ncbi-blast-n-rmblast-2.2.28+/blastn -query "$query" -db "$database" -evalue .00001 -out "$query"_v_"$database".aln -outfmt 2 -num_threads 20
head Pmac_COI.fasta_v_PmacD_Rac4MedPurge.fasta.tsv 
# HQ978017.1	contig_5550_segment0	100.00	658	0	0	1	658	163246	162589	0.0	1216
# HQ978017.1	contig_5286_segment0	99.54	659	2	1	1	658	238339	238997	0.0	1199
# HQ978017.1	contig_7572_segment0	93.80	274	15	2	386	658	138786	139058	4e-113	 411
# HQ978017.1	contig_458_segment0	  96.08	102	4	0	225	326	57092	56991	9e-40	 167
# HQ978017.1	contig_4251_segment0	88.00	75	6	3	238	311	161076	161148	3e-15	86.1

fasta_header=contig_5550_segment0
samtools faidx $genome $fasta_header:162589-163246 > $fasta_header.162589_163246.fa

fasta_header=contig_5286_segment0
samtools faidx $genome $fasta_header:238339-238997 > $fasta_header.238339_238997.fa




