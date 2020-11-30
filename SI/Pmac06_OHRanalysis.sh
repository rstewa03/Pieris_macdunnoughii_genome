######################
#### OHR analysis ####
######################
mkdir -p $PM_COMP/OHR_analysis
cd $PM_COMP/OHR_analysis

#### prepare you  protein annotations ###

# prefix of your braker GTF
# I have renamed my braker.gtf to PmacMums_polished_braker.gtf
# path: $PM_ANNOT/braker2_mumsPol/PmacMums_polished_braker.gtf
annotation=PmacMums_polished_braker
# genome=$PM_REF/faDnaPolishing/masking/Pmac000.1_polished.cleaned.softmasked.fa
genome=$PM_REF/faDnaPolishing/masking/PmacMums_polished.cleaned.softmasked.fa

# collect all good amino acid transcripts from gffread
# e.g.  /data/programs/cufflinks-2.2.1.Linux_x86_64/gffread /path/to/your/${annotation}.gtf -g $genome -J -w ${annotation}_goodTranscripts.fa -y ${annotation}_goodTranscripts_AA.faa
/data/programs/cufflinks-2.2.1.Linux_x86_64/gffread $PM_ANNOT/braker2_mumsPol/${annotation}.gtf -g $genome -J -w ${annotation}_goodTranscripts.fa -y ${annotation}_goodTranscripts_AA.faa

# you can run the following on multple .fa files at a time, just put them all in the same directory

#### collapse proteins with CD-hit ###
# ====== CD-HIT version 4.8.1 (built on Jun  6 2019) ======
for i in *Transcripts_AA_t1.faa
do /data/programs/cdhit/cd-hit -i $i -o ${i%.faa}_cd90.faa -c 0.9 -T 16 -aS 0.8 -M 0
done


### create blast database ###
#    Application to create BLAST databases, version 2.5.0+

for i in *Transcripts_AA_cd90.faa
do /data/programs/ncbi-blast-2.5.0+/bin/makeblastdb -dbtype prot -in $i
done

### blast B. mori proteins against your annotation database using parallel script below ###
# Download the B. mori protein file and collapse the proteins as above
# wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/151/625/GCF_000151625.1_ASM15162v1/GCF_000151625.1_ASM15162v1_protein.faa.gz
# /data/programs/cdhit/cd-hit -i Bmori_ASM15162v1_protein.faa -o Bmori_ASM15162v1_protein_cd90.faa -c 0.9 -T 16 -aS 0.8 -M 0

# For each protein in bmori, how many hits are there in my genome annotation blast database
protein_file=Bmori_ASM15162v1_protein_cd90.faa
for i in *Transcripts_AA_cd90.faa
do cat $protein_file | parallel --block 10k -k --recstart '>' --pipe "/data/programs/ncbi-blast-2.5.0+/bin/blastp -evalue 0.00001 -outfmt '6 qseqid sseqid qlen length slen qstart qend sstart send evalue bitscore pident' -db $i -query - " > Bmori90_v_${i%faa}tsv
done

# you can aslo do the reverse
# For each protein in my genome annotation, how many hits are there in the bmori blast database
#/data/programs/ncbi-blast-2.5.0+/bin/makeblastdb -dbtype prot -in $protein_file
# for i in *Transcripts_AA_cd90.faa
# do cat $i | parallel --block 10k -k --recstart '>' --pipe "/data/programs/ncbi-blast-2.5.0+/bin/blastp -evalue 0.00001 \
# -outfmt '6 qseqid sseqid qlen length slen qstart qend sstart send evalue bitscore pident' -db Bmori_ASM15162v1_protein_cd90.faa -query - " > ${i%.faa}_v_Bmori90.tsv
# done


### convert Blast output into tab format ###

# crunch using in-house python code
# python /mnt/griffin/racste/Software/OHR/coverage_table.py -x your_output.tsv -c 2

python /mnt/griffin/racste/Software/OHR/coverage_table.py -x Bmori90_v_Pmac000.1_polished_braker_goodTranscripts_AA_cd90.tsv -c 2
#if you have also run the reverse:
# python /mnt/griffin/racste/Software/OHR/coverage_table.py -x Pmac000.1_polished_braker_goodTranscripts_AA_cd90_v_Bmori90.tsv -c 2

python /mnt/griffin/racste/Software/OHR/coverage_table.py -x Bmori90_v_Pmac000.1_unpolished_braker_goodTranscripts_AA_cd90.tsv -c 2
# python /mnt/griffin/racste/Software/OHR/coverage_table.py -x Pmac000.1_unpolished_braker_goodTranscripts_AA_cd90_v_Bmori90.tsv -c 2

python /mnt/griffin/racste/Software/OHR/coverage_table.py -x Bmori90_v_PmacMums_polished_braker_goodTranscripts_AA_cd90.tsv -c 2
# python /mnt/griffin/racste/Software/OHR/coverage_table.py -x PmacMums_polished_braker_goodTranscripts_AA_cd90_v_Bmori90.tsv -c 2

### output files of coverage_table.py ###
# The script calculates the ortholog homology ratio, which is the proportion of the query protein that is homologous to hits in the reference blast database
# Bmori90_v_PmacMums_polished_braker_goodTranscripts_AA_cd90.blasttab
# columns:
# Gene/Protein_id
# Contig_id
# Length_of_Gene/Protein
# Number_of_transcripts_that_hit_subject_gene/protein_seq
# Sum_of_OHR's
# Longest_OHR
# Identity

# Focus onthe Longest OHR, which is the proportion of the query protein that is homologous to the longest hit in the reference blast database
# Sum of OHRs is the proportion ofthe query protein that is "covered" by all homologous orthologs in the reference blast database (evalue less than 10e-5), which might not be as informative as we had hoped.

Bmori90_v_PmacMums_polished_braker_goodTranscripts_AA_cd90.pdf
# this file contains a summary table and histogram of the OHR ratio of longest OHRs and Sum of OHRs
Bmori90_v_PmacMums_polished_braker_goodTranscripts_AA_cd90.temp
# this is a temp file used to produce the .blasttab output

# Analyse using Pmac06_OHRanalysis.R
