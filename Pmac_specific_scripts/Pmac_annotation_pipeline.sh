#####################
#### Environment ####
#####################

# Set environment

######################
#### Softmasking ####
######################
# Soft and hardmasked cleaned files are located in
# $PM_REF/faDnaPolishing/masking/Pmac000.1_polished.cleaned.softmasked.fa
# $PM_REF/faDnaPolishing/masking/Pmac000.1_unpolished.cleaned.softmasked.fa

######################################
#### Braker2 annotation: Polished ####
######################################
cd $PM_ANNOT
mkdir braker2_polished
# We recommend to use a relevant portion of OrthoDB protein database as the source of reference protein sequences.
# For example, if your genome of interest is an insect, download arthropoda proteins:
wget https://v100.orthodb.org/download/odb10_arthropoda_fasta.tar.gz
tar xvf odb10_arthropoda_fasta.tar.gz
cat arthropoda/Rawdata/* > odb10_arthropoda_proteins.fa

# bring in a softmasked genome that is ready for annotation, via a soft link
ln -s $PM_REF/faDnaPolishing/masking/Pmac000.1_polished.cleaned.softmasked.fa
###########
# define your genome and protein sets.
genome=Pmac000.1_polished.cleaned.softmasked.fa
proteins=odb10_arthropoda_proteins.fa

###########
# now set up the other dependencies.

# install a local "key" for running the gmes Gene Mark software in your local home folder
# get the key
cp /data/programs/scripts/gm_key_64 gm_key
# put it in your home folder using this script
cp gm_key ~/.gm_key

###########
# you should be able to copy and paste that below, from 'your_working_dir=$(pwd)' down to 'braker.pl ...'
# and run braker
###########

# first this makes an augustus config file in your local folder that augustus needs to be able to write to
your_working_dir=$(pwd)
cp -r /data/programs/Augustus_v3.3.3/config/ $your_working_dir/augustus_config
export AUGUSTUS_CONFIG_PATH=$your_working_dir/augustus_config


# now set paths to the other tools
export PATH=/mnt/griffin/chrwhe/software/BRAKER2_v2.1.5/scripts/:$PATH
export AUGUSTUS_BIN_PATH=/data/programs/Augustus_v3.3.3/bin
export AUGUSTUS_SCRIPTS_PATH=/data/programs/Augustus_v3.3.3/scripts
export DIAMOND_PATH=/data/programs/diamond_v0.9.24/
export GENEMARK_PATH=/data/programs/gmes_linux_64.4.61_lic/
export BAMTOOLS_PATH=/data/programs/bamtools-2.5.1/bin/
export PROTHINT_PATH=/data/programs/ProtHint/bin/
export ALIGNMENT_TOOL_PATH=/data/programs/gth-1.7.0-Linux_x86_64-64bit/bin
export SAMTOOLS_PATH=/data/programs/samtools-1.10/
export MAKEHUB_PATH=/data/programs/MakeHub/

braker.pl --genome=$genome --prot_seq=$proteins --softmasking --cores=30
# options
# FREQUENTLY USED OPTIONS
#
# --species=sname                     Species name. Existing species will not be
#                                     overwritten. Uses Sp_1 etc., if no species
#                                     is assigned
# DEVELOPMENT OPTIONS (PROBABLY STILL DYSFUNCTIONAL)
#
# --splice_sites=patterns             list of splice site patterns for UTR
#                                     prediction; default: GTAG, extend like this:
#                                     --splice_sites=GTAG,ATAC,...
#                                     this option only affects UTR training
#                                     example generation, not gene prediction
#                                     by AUGUSTUS


### Important notes from braker_log.txt
# IMPORTANT INFORMATION: no species for identifying the AUGUSTUS  parameter set that will arise from this BRAKER run was set. BRAKER will create an AUGUSTUS parameter set with name Sp_1. This parameter set can be used for future BRAKER/AUGUSTUS prediction runs for the same species. It is usually not necessary to retrain AUGUSTUS with novel extrinsic data if a high quality parameter set already exists.
# INFORMATION: the size of flanking region used in this BRAKER run is 3231. You might need this value if you later add a UTR training on top of an already existing BRAKER run.
# Fri Sep 11 16:18:29 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.gb contains 17281 genes.
# Fri Sep 11 16:18:34 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.f.gb contains 5296 genes.
# Fri Sep 11 16:18:50 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.fff.gb contains 5240 genes.
# Fri Sep 11 16:18:51 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.gb.test contains 300 genes.
# Fri Sep 11 16:18:52 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.gb.train contains 4940 genes.
# Fri Sep 11 16:18:59 2020: Error rate of missing stop codon is 0.944736842105263
# Fri Sep 11 16:19:05 2020: Setting frequency of stop codons to tag=0.226, taa=0.524, tga=0.25.
# Fri Sep 11 16:21:47 2020: The accuracy after initial training (no optimize_augustus.pl, no CRF) is 0.8106
# Fri Sep 11 19:16:32 2020: The accuracy after training (after optimize_augustus.pl, no CRF) is 0.810266666666667

### examine breaker output
head braker.gtf
# Sc0000002_pilon AUGUSTUS        stop_codon      4293427 4293429 .       -       0       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        CDS     4293427 4293565 1       -       1       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        exon    4293427 4293565 .       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        intron  4293566 4293783 1       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        CDS     4293784 4294008 1       -       1       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        exon    4293784 4294008 .       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        intron  4294009 4295006 1       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        CDS     4295007 4295128 1       -       0       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        exon    4295007 4295128 .       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        intron  4295129 4296293 1       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";

# how many uniq genes are there?

# how many uniq genes are there?

# fasta from gff
gff_file=braker/braker.gtf
reference=Pmac000.1_polished.cleaned.softmasked.fa
cds_outfile=braker_test.CDS.fa
prot_outfile=braker_test.prot.fa
/data/programs/cufflinks-2.2.1.Linux_x86_64/gffread "$gff_file" -g "$reference" -x "$cds_outfile" -y "$prot_outfile"

# have a look and validate the gtf, do they have nice start, stop and no internal stops?
more braker_test.prot.fa

# get count of genes
grep -c '>' braker_test.prot.fa
# 18406

# for only one isoform per gene
grep '>' braker_test.prot.fa | grep '.t1' | wc -l
# 16306
mv braker_test.CDS.fa Pmac000.1_polished_braker_test.CDS.fa
mv braker_test.prot.fa Pmac000.1_polished_braker_test.prot.fa
mv braker/braker.gtf Pmac000.1_polished_braker.gtf


###########################################################################
#### Annotation using PmacD_qmRac4MedPur.cleaned.masked.haploidA.fasta ####
#### aka Pmac000.1_unpolished.cleaned.fasta ###############################
###########################################################################
# check for softmasked genome
# use RED to softmask genome, see Pmac_softmask_hardmask.sh

#### Braker2 annotation ####
mkdir $PM_ANNOT/braker2_unpolished
cd $PM_ANNOT/braker2_unpolished

wget https://v100.orthodb.org/download/odb10_arthropoda_fasta.tar.gz
tar xvf odb10_arthropoda_fasta.tar.gz
cat arthropoda/Rawdata/* > odb10_arthropoda_proteins.fa

# bring in a softmasked genome that is ready for annotation, via a soft link
ln -s $PM_REF/faDnaPolishing/masking/Pmac000.1_unpolished.cleaned.softmasked.fa
###########
# define your genome and protein sets.
genome=Pmac000.1_unpolished.cleaned.softmasked.fa
proteins=odb10_arthropoda_proteins.fa

###########
# now set up the other dependencies.

# install a local "key" for running the gmes Gene Mark software in your local home folder
# get the key
cp /data/programs/scripts/gm_key_64 gm_key
# put it in your home folder using this script
cp gm_key ~/.gm_key

###########
# you should be able to copy and paste that below, from 'your_working_dir=$(pwd)' down to 'braker.pl ...'
# and run braker
###########

# first this makes an augustus config file in your local folder that augustus needs to be able to write to
your_working_dir=$(pwd)
cp -r /data/programs/Augustus_v3.3.3/config/ $your_working_dir/augustus_config
export AUGUSTUS_CONFIG_PATH=$your_working_dir/augustus_config


# now set paths to the other tools
export PATH=/mnt/griffin/chrwhe/software/BRAKER2_v2.1.5/scripts/:$PATH
export AUGUSTUS_BIN_PATH=/data/programs/Augustus_v3.3.3/bin
export AUGUSTUS_SCRIPTS_PATH=/data/programs/Augustus_v3.3.3/scripts
export DIAMOND_PATH=/data/programs/diamond_v0.9.24/
export GENEMARK_PATH=/data/programs/gmes_linux_64.4.61_lic/
export BAMTOOLS_PATH=/data/programs/bamtools-2.5.1/bin/
export PROTHINT_PATH=/data/programs/ProtHint/bin/
export ALIGNMENT_TOOL_PATH=/data/programs/gth-1.7.0-Linux_x86_64-64bit/bin
export SAMTOOLS_PATH=/data/programs/samtools-1.10/
export MAKEHUB_PATH=/data/programs/MakeHub/

braker.pl --genome=$genome --prot_seq=$proteins --softmasking --cores=30
# options
# FREQUENTLY USED OPTIONS
#
# --species=sname                     Species name. Existing species will not be
#                                     overwritten. Uses Sp_1 etc., if no species
#                                     is assigned
# DEVELOPMENT OPTIONS (PROBABLY STILL DYSFUNCTIONAL)
#
# --splice_sites=patterns             list of splice site patterns for UTR
#                                     prediction; default: GTAG, extend like this:
#                                     --splice_sites=GTAG,ATAC,...
#                                     this option only affects UTR training
#                                     example generation, not gene prediction
#                                     by AUGUSTUS


### Important notes from braker_log.txt
# IMPORTANT INFORMATION: no species for identifying the AUGUSTUS  parameter set that will arise from this BRAKER run was set. BRAKER will create an AUGUSTUS parameter set with name Sp_1. This parameter set can be used for future BRAKER/AUGUSTUS prediction runs for the same species. It is usually not necessary to retrain AUGUSTUS with novel extrinsic data if a high quality parameter set already exists.
# INFORMATION: the size of flanking region used in this BRAKER run is 3231. You might need this value if you later add a UTR training on top of an already existing BRAKER run.
# Fri Sep 11 16:18:29 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.gb contains 17281 genes.
# Fri Sep 11 16:18:34 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.f.gb contains 5296 genes.
# Fri Sep 11 16:18:50 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.fff.gb contains 5240 genes.
# Fri Sep 11 16:18:51 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.gb.test contains 300 genes.
# Fri Sep 11 16:18:52 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.gb.train contains 4940 genes.
# Fri Sep 11 16:18:59 2020: Error rate of missing stop codon is 0.944736842105263
# Fri Sep 11 16:19:05 2020: Setting frequency of stop codons to tag=0.226, taa=0.524, tga=0.25.
# Fri Sep 11 16:21:47 2020: The accuracy after initial training (no optimize_augustus.pl, no CRF) is 0.8106
# Fri Sep 11 19:16:32 2020: The accuracy after training (after optimize_augustus.pl, no CRF) is 0.810266666666667

### examine breaker output
head braker.gtf
# Sc0000002_pilon AUGUSTUS        stop_codon      4293427 4293429 .       -       0       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        CDS     4293427 4293565 1       -       1       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        exon    4293427 4293565 .       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        intron  4293566 4293783 1       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        CDS     4293784 4294008 1       -       1       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        exon    4293784 4294008 .       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        intron  4294009 4295006 1       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        CDS     4295007 4295128 1       -       0       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        exon    4295007 4295128 .       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        intron  4295129 4296293 1       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";

# how many uniq genes are there?

# how many uniq genes are there?

# fasta from gff
gff_file=braker/braker.gtf
reference=$PM_REF/faDnaPolishing/masking/Pmac000.1_unpolished.cleaned.softmasked.fa
cds_outfile=braker_test.CDS.fa
prot_outfile=braker_test.prot.fa
/data/programs/cufflinks-2.2.1.Linux_x86_64/gffread "$gff_file" -g "$reference" -x "$cds_outfile" -y "$prot_outfile"

# have a look and validate the gtf, do they have nice start, stop and no internal stops?
more braker_test.prot.fa

# get count of genes
grep -c '>' braker_test.prot.fa
# 19686

# for only one isoform per gene
grep '>' braker_test.prot.fa | grep '.t1' | wc -l
# 17407

mv braker_test.CDS.fa Pmac000.1_unpolished_braker_test.CDS.fa
mv braker_test.prot.fa Pmac000.1_unpolished_braker_test.prot.fa
mv braker/braker.gtf Pmac000.1_unpolished_braker.gtf


##########################################################################################################
#### Annotation using Pmac_Mums_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.pilon.polish.fasta ####
#### aka PmacMums_polished.cleaned.fasta #################################################################
##########################################################################################################
# check for softmasked genome
# use RED to softmask genome, see Pmac_softmask_hardmask.sh

#### Braker2 annotation ####
mkdir $PM_ANNOT/braker2_mumsPol
cd $PM_ANNOT/braker2_mumsPol

wget https://v100.orthodb.org/download/odb10_arthropoda_fasta.tar.gz
tar xvf odb10_arthropoda_fasta.tar.gz
cat arthropoda/Rawdata/* > odb10_arthropoda_proteins.fa

# bring in a softmasked genome that is ready for annotation, via a soft link
ln -s $PM_REF/faDnaPolishing/masking/PmacMums_polished.cleaned.softmasked.fa
###########
# define your genome and protein sets.
genome=PmacMums_polished.cleaned.softmasked.fa
proteins=odb10_arthropoda_proteins.fa

###########
# now set up the other dependencies.

# install a local "key" for running the gmes Gene Mark software in your local home folder
# get the key
cp /data/programs/scripts/gm_key_64 gm_key
# put it in your home folder using this script
cp gm_key ~/.gm_key

###########
# you should be able to copy and paste that below, from 'your_working_dir=$(pwd)' down to 'braker.pl ...'
# and run braker
###########

# first this makes an augustus config file in your local folder that augustus needs to be able to write to
your_working_dir=$(pwd)
cp -r /data/programs/Augustus_v3.3.3/config/ $your_working_dir/augustus_config
export AUGUSTUS_CONFIG_PATH=$your_working_dir/augustus_config


# now set paths to the other tools
export PATH=/mnt/griffin/chrwhe/software/BRAKER2_v2.1.5/scripts/:$PATH
export AUGUSTUS_BIN_PATH=/data/programs/Augustus_v3.3.3/bin
export AUGUSTUS_SCRIPTS_PATH=/data/programs/Augustus_v3.3.3/scripts
export DIAMOND_PATH=/data/programs/diamond_v0.9.24/
export GENEMARK_PATH=/data/programs/gmes_linux_64.4.61_lic/
export BAMTOOLS_PATH=/data/programs/bamtools-2.5.1/bin/
export PROTHINT_PATH=/data/programs/ProtHint/bin/
export ALIGNMENT_TOOL_PATH=/data/programs/gth-1.7.0-Linux_x86_64-64bit/bin
export SAMTOOLS_PATH=/data/programs/samtools-1.10/
export MAKEHUB_PATH=/data/programs/MakeHub/

braker.pl --genome=$genome --prot_seq=$proteins --softmasking --cores=30
# options
# FREQUENTLY USED OPTIONS
#
# --species=sname                     Species name. Existing species will not be
#                                     overwritten. Uses Sp_1 etc., if no species
#                                     is assigned
# DEVELOPMENT OPTIONS (PROBABLY STILL DYSFUNCTIONAL)
#
# --splice_sites=patterns             list of splice site patterns for UTR
#                                     prediction; default: GTAG, extend like this:
#                                     --splice_sites=GTAG,ATAC,...
#                                     this option only affects UTR training
#                                     example generation, not gene prediction
#                                     by AUGUSTUS


### Important notes from braker_log.txt
# IMPORTANT INFORMATION: no species for identifying the AUGUSTUS  parameter set that will arise from this BRAKER run was set. BRAKER will create an AUGUSTUS parameter set with name Sp_1. This parameter set can be used for future BRAKER/AUGUSTUS prediction runs for the same species. It is usually not necessary to retrain AUGUSTUS with novel extrinsic data if a high quality parameter set already exists.
# INFORMATION: the size of flanking region used in this BRAKER run is 3231. You might need this value if you later add a UTR training on top of an already existing BRAKER run.
# Fri Sep 11 16:18:29 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.gb contains 17281 genes.
# Fri Sep 11 16:18:34 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.f.gb contains 5296 genes.
# Fri Sep 11 16:18:50 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.fff.gb contains 5240 genes.
# Fri Sep 11 16:18:51 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.gb.test contains 300 genes.
# Fri Sep 11 16:18:52 2020: Genbank format file /mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/braker2/braker/train.gb.train contains 4940 genes.
# Fri Sep 11 16:18:59 2020: Error rate of missing stop codon is 0.944736842105263
# Fri Sep 11 16:19:05 2020: Setting frequency of stop codons to tag=0.226, taa=0.524, tga=0.25.
# Fri Sep 11 16:21:47 2020: The accuracy after initial training (no optimize_augustus.pl, no CRF) is 0.8106
# Fri Sep 11 19:16:32 2020: The accuracy after training (after optimize_augustus.pl, no CRF) is 0.810266666666667

### examine breaker output
head braker.gtf
# Sc0000002_pilon AUGUSTUS        stop_codon      4293427 4293429 .       -       0       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        CDS     4293427 4293565 1       -       1       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        exon    4293427 4293565 .       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        intron  4293566 4293783 1       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        CDS     4293784 4294008 1       -       1       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        exon    4293784 4294008 .       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        intron  4294009 4295006 1       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        CDS     4295007 4295128 1       -       0       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        exon    4295007 4295128 .       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";
# Sc0000002_pilon AUGUSTUS        intron  4295129 4296293 1       -       .       transcript_id "file_1_file_1_g11437.t1"; gene_id "file_1_file_1_g11437";

# how many uniq genes are there?

# how many uniq genes are there?

# fasta from gff
gff_file=braker/braker.gtf
reference=$PM_REF/faDnaPolishing/masking/PmacMums_polished.cleaned.softmasked.fa
cds_outfile=PmacMums_polished_braker_test.CDS.fa
prot_outfile=PmacMums_polished_braker_test.prot.fa
/data/programs/cufflinks-2.2.1.Linux_x86_64/gffread "$gff_file" -g "$reference" -x "$cds_outfile" -y "$prot_outfile"

# have a look and validate the gtf, do they have nice start, stop and no internal stops?
more *braker_test.prot.fa

# get count of genes
grep -c '>' *braker_test.prot.fa
# 18655

# for only one isoform per gene
grep '>' *braker_test.prot.fa | grep '.t1' | wc -l
# 16545

mv braker/braker.gtf PmacMums_polished_braker.gtf

######################
#### OHR analysis ####
######################
mkdir -p $PM_COMP/OHR_analysis
cd $PM_COMP/OHR_analysis

# annotation=Pmac000.1_polished_braker
annotation=PmacMums_polished_braker
# genome=$PM_REF/faDnaPolishing/masking/Pmac000.1_polished.cleaned.softmasked.fa
genome=$PM_REF/faDnaPolishing/masking/PmacMums_polished.cleaned.softmasked.fa

# collect all good amino acid transcripts from gffread
/data/programs/cufflinks-2.2.1.Linux_x86_64/gffread $PM_ANNOT/braker2_mumsPol/${annotation%.gtf}.gtf -g $genome -J -w ${annotation%.gtf}_goodTranscripts.fa -y ${annotation%.gtf}_goodTranscripts_AA.faa

# collapse proteins with CD-hit
#
# ====== CD-HIT version 4.8.1 (built on Jun  6 2019) ======
#
# Usage: /data/programs/cdhit/cd-hit [Options]
#
# Options (subset)
#
# -i   input filename in fasta format, required, can be in .gz format
# -o   output filename, required
# -c   sequence identity threshold, default 0.9
# this is the default cd-hit's "global sequence identity" calculated as:
# number of identical amino acids or bases in alignment
# divided by the full length of the shorter sequence
# -M   memory limit (in MB) for the program, default 800; 0 for unlimitted;
# -T   number of threads, default 1; with 0, all CPUs will be used
# -aS  alignment coverage for the shorter sequence, default 0.0
# if set to 0.9, the alignment must covers 90% of the sequence
# "CD-HIT: a fast program for clustering and comparing large sets of protein or nucleotide sequences", Weizhong Li & Adam Godzik. Bioinformatics, (2006) 22:1658-1659
# "CD-HIT: accelerated for clustering the next generation sequencing data", Limin Fu, Beifang Niu, Zhengwei Zhu, Sitao Wu & Weizhong Li. Bioinformatics, (2012) 28:3150-3152

for i in *Mums*Transcripts_AA.faa
do /data/programs/cdhit/cd-hit -i $i -o ${i%.faa}_cd90.faa -c 0.9 -T 16 -aS 0.8 -M 0
done


### Do OHR analysis to compare gene length against B. mori

#first, make blast db
# USAGE
#   makeblastdb [-h] [-help] [-in input_file] [-input_type type]
#     -dbtype molecule_type [-title database_title] [-parse_seqids]
#     [-hash_index] [-mask_data mask_data_files] [-mask_id mask_algo_ids]
#     [-mask_desc mask_algo_descriptions] [-gi_mask]
#     [-gi_mask_name gi_based_mask_names] [-out database_name]
#     [-max_file_sz number_of_bytes] [-logfile File_Name] [-taxid TaxID]
#     [-taxid_map TaxIDMapFile] [-version]
#
# DESCRIPTION
#    Application to create BLAST databases, version 2.5.0+

for i in *Mums*Transcripts_AA_cd90.faa
do /data/programs/ncbi-blast-2.5.0+/bin/makeblastdb -dbtype prot -in $i
done

# blast using parallel script below
# wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/151/625/GCF_000151625.1_ASM15162v1/GCF_000151625.1_ASM15162v1_protein.faa.gz
# /data/programs/cdhit/cd-hit -i Bmori_ASM15162v1_protein.faa -o Bmori_ASM15162v1_protein_cd90.faa -c 0.9 -T 16 -aS 0.8 -M 0
# For each protein in bmori, how many hits are there in my genome annotation blast database
protein_file=Bmori_ASM15162v1_protein_cd90.faa
for i in *Mums*Transcripts_AA_cd90.faa
do cat $protein_file | parallel --block 10k -k --recstart '>' --pipe "/data/programs/ncbi-blast-2.5.0+/bin/blastp -evalue 0.00001 -outfmt '6 qseqid sseqid qlen length slen qstart qend sstart send evalue bitscore pident' -db $i -query - " > Bmori90_v_${i%faa}tsv
done

# then do reverse
# For each protein in my genome annotation, how many hits are there in the bmori blast database

/data/programs/ncbi-blast-2.5.0+/bin/makeblastdb -dbtype prot -in $protein_file

for i in *Mums*Transcripts_AA_cd90.faa
do cat $i | parallel --block 10k -k --recstart '>' --pipe "/data/programs/ncbi-blast-2.5.0+/bin/blastp -evalue 0.00001 \
-outfmt '6 qseqid sseqid qlen length slen qstart qend sstart send evalue bitscore pident' -db Bmori_ASM15162v1_protein_cd90.faa -query - " > ${i%.faa}_v_Bmori90.tsv
done
# convert Blast output into tab format

# crunch using python code
# Coverage table.py:
#
# Copy your input files here /home/cwheat/Softwares/OHR/
#
# Input files:
#         Blast output in xml format
#         Predicted gene set/Protein fasta file
#
# Usage:
#         python coverage_table.py -f <protein fasta file> -x <blast xml output> -c <1/2>
#
# Output
#         blast_xml_output_prefix.tab
#         blast_xml_output_prefix.pdf
#
# Note:
# Only blast hits with evalue less than 10e-5 are considered for the calculating the ortholog hit ratios.
python /mnt/griffin/racste/Software/OHR/coverage_table.py -x Bmori90_v_Pmac000.1_polished_braker_goodTranscripts_AA_cd90.tsv -c 2
python /mnt/griffin/racste/Software/OHR/coverage_table.py -x Pmac000.1_polished_braker_goodTranscripts_AA_cd90_v_Bmori90.tsv -c 2

python /mnt/griffin/racste/Software/OHR/coverage_table.py -x Bmori90_v_Pmac000.1_unpolished_braker_goodTranscripts_AA_cd90.tsv -c 2
python /mnt/griffin/racste/Software/OHR/coverage_table.py -x Pmac000.1_unpolished_braker_goodTranscripts_AA_cd90_v_Bmori90.tsv -c 2

python /mnt/griffin/racste/Software/OHR/coverage_table.py -x Bmori90_v_PmacMums_polished_braker_goodTranscripts_AA_cd90.tsv -c 2
python /mnt/griffin/racste/Software/OHR/coverage_table.py -x PmacMums_polished_braker_goodTranscripts_AA_cd90_v_Bmori90.tsv -c 2

############################################
#### update annotations with ragtag agp ####
############################################

# we ended up scaffolding the assemblies using RagTag, so now we have to update the Pmac_annotations
# python3 /data/programs/RagTag/ragtag.py updategff -h
# usage: ragtag.py updategff [-c] <genes.gff> <ragtag.agp>
#
# Update gff intervals given a RagTag AGP file
#
# positional arguments:
#  <genes.gff>     gff file
#  <ragtag.*.agp>  agp file
#
# optional arguments:
#  -h, --help      show this help message and exit
#  -c              update for misassembly correction (ragtag.correction.agp)

python3 /data/programs/RagTag/ragtag.py updategff PmacMums_polished_braker.gtf PmacMums_polished_against_Pieris_napi_fullAsm_chomoOnly.ragtag.scaffolds.agp > PmacMums_polished_braker_ragtagScaffolds.gtf
python3 /data/programs/RagTag/ragtag.py updategff Pmac000.1_polished_braker.gtf Pmac000.1_polished_against_Pieris_napi_fullAsm_chomoOnly.ragtag.scaffolds.agp > Pmac000.1_polished_braker_ragtagScaffolds.gtf
python3 /data/programs/RagTag/ragtag.py updategff Pmac000.1_unpolished_braker.gtf Pmac000.1_unpolished_against_Pieris_napi_fullAsm_chomoOnly.ragtag.scaffolds.agp > Pmac000.1_unpolished_braker_ragtagScaffolds.gtf

# test that the number of genes are the same
reference=/mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/pseudochromosomal/RagTag/PmacMums_polished_against_Pieris_napi_fullAsm_chomoOnly.out/PmacMums_polished_against_Pieris_napi_fullAsm_chomoOnly.ragtag.scaffolds.fasta
gff_file=$PM_ANNOT/RagTag_updateGFF/PmacMums_polished_braker_ragtagScaffolds.gtf
cds_outfile=PmacMums_polished_braker_ragtagScaffolds.CDS.fa
prot_outfile=PmacMums_polished_braker_ragtagScaffolds.prot.fa
/data/programs/cufflinks-2.2.1.Linux_x86_64/gffread "$gff_file" -g "$reference" -x "$cds_outfile" -y "$prot_outfile"

# have a look and validate the gtf, do they have nice start, stop and no internal stops?
more *braker_test.prot.fa

# get count of genes
grep -c '>' *.prot.fa
# 18655, same as above

# for only one isoform per gene
grep '>' *.prot.fa | grep '.t1' | wc -l
# 16545, same as above


######################################
#### EggNOG functional annotation ####
######################################
