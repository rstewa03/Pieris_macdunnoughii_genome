#####################
#### Environment ####
#####################

# Set environment

######################
#### Softmasking ####
######################

###########################
#### Softmask with RED ####
###########################

#  python /mnt/griffin/chrwhe/software/redmask/redmask.py
# usage: redmask.py [-h] -i GENOME -o OUTPUT [-m MIN] [--training TRAINING]
#                   [-l WORD_LEN] [-t THRESHOLD] [-g GAUSSIAN] [-c MARKOV_ORDER]
#                   [--debug] [--version]
#
# Wraper for Red - repeat identification and masking for genome annotation
#
# optional arguments:
#   -h, --help                                    show this help message and
#                                                 exit
#   -i GENOME, --genome GENOME                    genome assembly FASTA format
#                                                 (default: None)
#   -o OUTPUT, --output OUTPUT                    Output basename (default:
#                                                 None)
#   -m MIN, --min MIN                             Minimum number of observed
#                                                 k-mers (default: 3)
#   --training TRAINING                           Min length for training
#                                                 (default: 1000)
#   -l WORD_LEN, --word_len WORD_LEN              word length (kmer length)
#                                                 (default: None)
#   -t THRESHOLD, --threshold THRESHOLD           threshold of low adjusted
#                                                 scores of non-repeats
#                                                 (default: None)
#   -g GAUSSIAN, --gaussian GAUSSIAN              Gaussian smoothing width
#                                                 (default: None)
#   -c MARKOV_ORDER, --markov_order MARKOV_ORDER  Order of background markov
#                                                 chain (default: None)
#   --debug                                       Keep intermediate files
#                                                 (default: False)
#   --version                                     show program's version number
#                                                 and exit

cd $PM_ANNOT/masking

# install needed package
# pip install natsort
# define a path for the Red software
export PATH=/data/programs/RED/redUnix64/:$PATH

ln -s /mnt/griffin/racste/P_macdunnoughii/Pmac_alignments/NGM_genome/PmacD_qmRac4MedPur.cleaned.masked/Pmac000.1_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.PILON/Pmac000.1_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.pilon.polish.fasta Pmac000.1_polished.fasta
python /mnt/griffin/chrwhe/software/redmask/redmask.py -i Pmac000.1_polished.fasta -o Pmac000.1_polished > Pmac000.1_polished.results.log

ln -s /mnt/griffin/racste/P_macdunnoughii/Pmac_alignments/NGM_genome/PmacD_qmRac4MedPur.cleaned.masked/PmacMums_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.PILON/Pmac000.1_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.pilon.polish.fasta Pmac000.1_polished.fasta
python /mnt/griffin/chrwhe/software/redmask/redmask.py -i Pmac000.1_polished.fasta -o Pmac000.1_polished > Pmac000.1_polished.results.log

ln -s /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/PmacD_qmRac4MedPur.cleaned.masked.haploidA.fasta Pmac000.1_unpolished.fasta
python /mnt/griffin/chrwhe/software/redmask/redmask.py -i Pmac000.1_unpolished.fasta -o Pmac000.1_unpolished > Pmac000.1_unpolished.results.log

ln -s /mnt/griffin/Pierinae_genomes/Pieris_napi_genome_v1.1/Pieris_napi_fullAsm.fasta
python /mnt/griffin/chrwhe/software/redmask/redmask.py -i Pieris_napi_fullAsm.fasta -o Pieris_napi_fullAsm > Pieris_napi_fullAsm.log
# num scaffolds: 2,969
# assembly size: 349,759,982 bp
# masked repeats: 93,152,465 bp (26.63%)

################################################
#### Braker2 annotation: Pmac000.1 Polished ####
################################################

cd $PM_ANNOT
mkdir braker2_polished
# Use a relevant portion of OrthoDB protein database as the source of reference protein sequences.
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

### examine breaker output
head braker.gtf

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

### examine breaker output
head braker.gtf


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
