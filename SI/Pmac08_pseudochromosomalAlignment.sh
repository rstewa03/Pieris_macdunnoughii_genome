
########################################################
#### Create pseudochromosomal alignment with RagTag ####
########################################################
# https://github.com/malonge/RagTag/wiki
cd $PM_REF/pseudochromosomal/RagTag

# note that you should use soft links into the folder you are working, as it wants to make an index file
ln -s /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/faDnaPolishing/Pieris_napi_fullAsm.cleaned.fasta .
ln -s /mnt/griffin/Pierinae_genomes/Pieris_napi_genome_v1.1/genome/Pieris_napi_fullAsm_chomoOnly.fasta Pieris_napi_fullAsm_chromoOnly.fasta
ln -s /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/Pmac000.1_unpolished.fasta .
ln -s /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/Pmac000.1_polished.fasta .
ln -s /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/PmacMums_polished.fasta .

cd $PM_REF/pseudochromosomal/RagTag
# provide aligner. Uses minimap or nucmer
export PATH=$PATH:/data/programs/mummer-4.0.0beta2/
# define reference
# reference=Pieris_napi_fullAsm.cleaned
reference=Pieris_napi_fullAsm_chromoOnly
for i in `ls -1 Pmac*fasta | sed 's/.fasta//'`
do
  #defines the query fasta(s)
  query=$i;
  #creates a unique prefix
  prefix=${i}_against_${reference}_i.80;
  #runs the ragtag script with the reference.fasta and the query.fasta and the outfile named with the prefix
  python3 /data/programs/RagTag/ragtag_scaffold.py $reference.fasta $i.fasta -o $prefix.out -t 10 --aligner nucmer -i 0.8;
  # move into the output folder
  cd $prefix.out;
  # convert the delta file into a coords table that can be used to make a circos plot
  #$TOOLS/mummer-4.0.0beta2/show-coords -r -c -l query_against_ref.delta > $prefix.coords;
  #cat $prefix.coords | sed 1,5d | tr -s ' ' | awk 'BEGIN {FS=" "; OFS=","} {;print $1,$2,$4,$5,$7,$8,$10,$12,$13,$18,$19}' > $prefix.filt.coords;
  # rename the generic ragtag output with the prefix
  for k in `ls -1 ragtag*`
  do
    mv $k $prefix.$k;
  done
  for l in `ls -1 query_against_ref* | sed 's/query_against_ref.//'`
  do
    mv query_against_ref.$l $prefix.$l;
  done
  cd ..
done


############################################
#### update annotations with ragtag agp ####
############################################
# we ended up scaffolding the assemblies using RagTag, so now we have to update the Pmac_annotations
# python3 /data/programs/RagTag/ragtag.py updategff -h

python3 /data/programs/RagTag/ragtag.py updategff PmacMums_polished_braker.gtf PmacMums_polished_against_Pieris_napi_fullAsm_chromoOnly_i.80.ragtag.scaffolds.agp > PmacMums_polished_braker_ragtagScaffolds.gtf
python3 /data/programs/RagTag/ragtag.py updategff Pmac000.1_polished_braker.gtf Pmac000.1_polished_against_Pieris_napi_fullAsm_chromoOnly_i.80.ragtag.scaffolds.agp > Pmac000.1_polished_braker_ragtagScaffolds.gtf

# create protein fasta files
annotation=PmacMums_polished_braker_ragtagScaffolds
genome=/mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/pseudochromosomal/RagTag/PmacMums_polished_against_Pieris_napi_fullAsm_chromoOnly_i.80.out/PmacMums_polished_against_Pieris_napi_fullAsm_chromoOnly_i.80.ragtag.scaffolds.fasta
/data/programs/cufflinks-2.2.1.Linux_x86_64/gffread $PM_ANNOT/RagTag_updateGFF/${annotation}.gtf -g $genome -J -w ${annotation}_goodTranscripts.fa -y ${annotation}_goodTranscripts_AA.faa
grep -c '>' *.faa
# previously 18655, now 18603

annotation=Pmac000.1_polished_braker_ragtagScaffolds
genome=/mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/pseudochromosomal/RagTag/Pmac000.1_polished_against_Pieris_napi_fullAsm_chromoOnly_i.80.out/Pmac000.1_polished_against_Pieris_napi_fullAsm_chromoOnly_i.80.ragtag.scaffolds.fasta
/data/programs/cufflinks-2.2.1.Linux_x86_64/gffread $PM_ANNOT/RagTag_updateGFF/${annotation}.gtf -g $genome -J -w ${annotation}_goodTranscripts.fa -y ${annotation}_goodTranscripts_AA.faa
# previously 19686, now 18347


######################################
#### EggNOG functional annotation ####
#####################################
# eggNOG annotation
mkdir -p $PM_ANNOT/EggNOG
cd $PM_ANNOT/EggNOG

# first need to get the fasta file into a format that is only 2 lines per sequence
# rather than the format above where the sequences are hard wrapped at 70 characters

python /data/programs/scripts/multiline_to_two_line.py /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/RagTag_updateGFF/PmacMums_polished_braker_ragtagScaffolds_goodTranscripts_AA.faa > PmacMums_polished_braker_ragtagScaffolds_goodTranscripts_AA_2line.faa

# now count the number of sequences in each file
grep -c '>' *faa


# so now submit this sequence to
http://eggnog-mapper.embl.de/
# on a local computer
# and run on the default settings
# the commands that were run
emapper.py --cpu 6 -i /data/shared/emapper_jobs/user_data/MM_0ga8708_/query_seqs.fa --output query_seqs.fa --output_dir /data/shared/emapper_jobs/user_data/MM_0ga8708_ -m diamond -d none --tax_scope auto --go_evidence non-electronic --target_orthologs all --seed_ortholog_evalue 0.001 --seed_ortholog_score 60 --query-cover 20 --subject-cover 0 --override --temp_dir /data/shared/emapper_jobs/user_data/MM_0ga8708_
# be sure to go into the email from eggnog and click on the link "Click to manage your job"
# then at the website, you have to submit the job!!!!
# you only know things are running if you go back to the homepage and in the queue of jobs you see your ID.
# download the queyr_seqs.fa and query_seqs.fa.emapper.annotations files

# once you get this back, it will be a large table.
# columns for eggnog v2 (which are different from v1) are:
# 1. query_name
# 2. seed eggNOG ortholog
# 3. seed ortholog evalue
# 4. seed ortholog score
# 5. Predicted taxonomic group
# 6. Predicted protein name
# 7. Gene Ontology terms
# 8. EC number
# 9. KEGG_ko
# 10. KEGG_Pathway
# 11. KEGG_Module
# 12. KEGG_Reaction
# 13. KEGG_rclass
# 14. BRITE
# 15. KEGG_TC
# 16. CAZy
# 17. BiGG Reaction
# 18. tax_scope: eggNOG taxonomic level used for annotation
# 19. eggNOG OGs
# 20. bestOG (deprecated, use smallest from eggnog OGs)
# 21. COG Functional Category
# 22. eggNOG free text description

#query_name	seed_eggNOG_ortholog	seed_ortholog_evalue	seed_ortholog_score	best_tax_level	Preferred_name	GOs	EC	KEGG_ko	KEGG_Pathway	KEGG_Module	KEGG_Reaction	KEGG_rclass	BRITE	KEGG_TC	CAZy	BiGG_Reaction

# all lines of annotation with "#" as they are metadata, delete
sed '/^#/d' PmacMums_polished_braker_ragtagScaffolds_EggNOG.emapper.annotations > PmacMums_polished_braker_ragtagScaffolds_EggNOG.emapper.annotations.tsv

cut -f4 PmacMums_polished_braker_ragtagScaffolds_EggNOG.emapper.annotations.tsv | csvstat
# Smallest value:        60.1
# Largest value:         20,599.7
# Sum:                   9,823,956.9
# Mean:                  600.34
# Median:                424.1
# StDev:                 709.296

# filter out any seed ortholog scores below 100
awk -F"\t" '{if ($4 > 100) print $0}' PmacMums_polished_braker_ragtagScaffolds_EggNOG.emapper.annotations.tsv > PmacMums_polished_braker_ragtagScaffolds_EggNOG.emapper.annotations.filter.tsv
wc -l *tsv
# 15392 PmacMums_polished_braker_ragtagScaffolds_EggNOG.emapper.annotations.filter.tsv
# 16365 PmacMums_polished_braker_ragtagScaffolds_EggNOG.emapper.annotations.tsv
# still lots of gene annotations

# extracting results out to different tables, as indicated by their resulting file name output
annotation_file=PmacMums_polished_braker_ragtagScaffolds_EggNOG.emapper.annotations.filter.tsv
prefix=PmacMums_polished_braker_ragtagScaffolds
awk 'BEGIN {FS="\t";OFS=""} {split($1,a,";");print a[1],"\t",$7}' $annotation_file > $prefix.GO.eggNOG.tsv
awk 'BEGIN {FS="\t";OFS=""} {split($1,a,";");print a[1],"\t",$9}' $annotation_file > $prefix.KEGG.eggNOG.tsv
awk 'BEGIN {FS="\t";OFS=""} {split($1,a,";");print a[1],"\t",$6}' $annotation_file > $prefix.gene_name.eggNOG.tsv
awk 'BEGIN {FS="\t";OFS=""} {split($1,a,";");print a[1],"\t",$6,"\t",$22}' $annotation_file > $prefix.gene_name.gene_function.eggNOG.tsv


#################################################
#### Update naming conventions for all files ####
#################################################
# Rename chromosomes in each of the three main chromosomes
cat Pmac000.1_unpolished.fasta | sed 's/>/>Pmacd_v0.08_/g' > Pmacd_v0.08.fasta
cat Pmac000.1_polished.fasta | sed 's/>/>Pmacd_v0.09_/g' > Pmacd_v0.09.fasta
cat PmacMums_polished.fasta | sed 's/>/>Pmacd_v0.10_/g' > Pmacd_v0.10.fasta

cat PmacMums_polished_against_Pieris_napi_fullAsm_chromoOnly_i.80.ragtag.scaffolds.agp | sed 's/Chromosome/Pmacd_v0.10_Chromosome/g' > Pmacd_v0.10_RagTagscaffolds.agp

cat PmacMums_polished_braker.gtf | sed 's/Sc/Pmacd_v0.10_Sc/g'| sed 's/xfPmacd_v0.10_Sc/Pmacd_v0.10_xfSc/g'|sed 's/xpPmacd_v0.10_Sc/Pmacd_v0.10_xpSc/g'| sed 's/file_1_file_1/Augustus/g' | sed 's/file_1_file_2/GeneMark/g' > Pmacd_v0.10_braker.gtf



