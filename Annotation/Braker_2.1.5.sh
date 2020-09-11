###################################
# BRAKER2 install Aug31 2020
# https://github.com/Gaius-Augustus/BRAKER#what-is-braker
# version = "2.1.5"; I had to find this in the braker.pl script, down a ways
# MILES

###############
# test run documentation
# BRAKER with proteins of any evolutionary distance
# We recommend using OrthoDB as basis for proteins.fa.
# The instructions on how to prepare the input OrthoDB proteins are
# documented here: https://github.com/gatech-genemark/ProtHint#protein-database-preparation.

# make a new folder, here I am using braker2_test
mkdir braker2_test
cd braker2_test

# We recommend to use a relevant portion of OrthoDB protein database as the source of reference protein sequences.
# For example, if your genome of interest is an insect, download arthropoda proteins:
wget https://v100.orthodb.org/download/odb10_arthropoda_fasta.tar.gz
tar xvf odb10_arthropoda_fasta.tar.gz
cat arthropoda/Rawdata/* > odb10_arthropoda_proteins.fa

# bring in a softmasked genome that is ready for annotation, via a soft link
ln -s /mnt/griffin/chrwhe/Colias_eurytheme_genome/masked/Ce_ref_polished.cleaned.masked.fa.softmasked.fa .
###########
# define your genome and protein sets.
genome=Ce_ref_polished.cleaned.masked.fa.softmasked.fa
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

#  finished, took about 10 hours


head braker.log
#**********************************************************************************
#                               BRAKER CONFIGURATION
#**********************************************************************************
# BRAKER CALL: /mnt/griffin/chrwhe/software/BRAKER2_v2.1.5/scripts/braker.pl --genome=Ce_ref_polished.cleaned.masked.fa.softmasked.fa --prot_seq=odb10_arthropoda_proteins.fa --softmasking --cores=30
# Wed Sep  9 13:37:06 2020: braker.pl version 2.1.5
...
# Wed Sep  9 22:53:34 2020: deleting job lst files (if existing)
# so took about 10 hours.

##############
# output files
##############
# braker.gtf: Union of augustus.hints.gtf and reliable GeneMark-EX predictions (genes fully supported by external evidence).
# In --esmode, this is the union of augustus.ab_initio.gtf and all GeneMark-ES genes. Thus, this set
# is generally more sensitive (more genes correctly predicted) and can be less specific
# (more false-positive predictions can be present).

# GeneMark-E*/genemark.gtf: Genes predicted by GeneMark-ES/ET/EP/EP+ in GTF-format.
# This file will be missing if BRAKER was executed with proteins of close homology and the option --trainFromGth

# hintsfile.gff: The extrinsic evidence data extracted from RNAseq.bam and/or protein data.

# augustus.hints.gtf: Genes predicted by AUGUSTUS with hints from given extrinsic evidence


head braker.gtf
Sc0000020_pilon AUGUSTUS        start_codon     2938536 2938538 .       +       0       transcript_id "file_1_file_1_g7517.t1"; gene_id "file_1_file_1_g7517";
Sc0000020_pilon AUGUSTUS        CDS     2938536 2938593 1       +       0       transcript_id "file_1_file_1_g7517.t1"; gene_id "file_1_file_1_g7517";
Sc0000020_pilon AUGUSTUS        exon    2938536 2938593 .       +       .       transcript_id "file_1_file_1_g7517.t1"; gene_id "file_1_file_1_g7517";
Sc0000020_pilon AUGUSTUS        intron  2938594 2938964 1       +       .       transcript_id "file_1_file_1_g7517.t1"; gene_id "file_1_file_1_g7517";

# how many uniq genes are there?

# fasta from gff
gff_file=braker/braker.gtf
reference=Ce_ref_polished.cleaned.masked.fa.softmasked.fa
cds_outfile=braker_test.CDS.fa
prot_outfile=braker_test.prot.fa
/data/programs/cufflinks-2.2.1.Linux_x86_64/gffread "$gff_file" -g "$reference" -x "$cds_outfile" -y "$prot_outfile"

# have a look and validate the gtf, do they have nice start, stop and no internal stops?
more braker_test.prot.fa

# get count of genes
grep -c '>' braker_test.prot.fa
22089
# for only one isoform per gene
grep '>' braker_test.prot.fa | grep '.t1' | wc -l
19762



###############
# other option notes from https://github.com/Gaius-Augustus/BRAKER#what-is-braker


#######
# BRAKER with RNA-Seq and distant protein data
braker.pl --genome=genome.fa --prot_seq=orthodb.fa --bam=file1.bam,file2.bam --etpmode --softmasking
# or
bamfiles=Pae1C03Aligned.out.bam,Pae1C06Aligned.out.bam,Pae1C12Aligned.out.bam
braker.pl --genome=genome.fa --prot_seq=orthodb.fa --bam=$bamfiles --etpmode --softmasking
# you can also include proteins of short evolutionary distance, but I'm not covering that now.


###############
# --UTR=on needs RNAseq data, and you can use previous braker run predictions

# --makehub --email=your@mail.de
# If --makehub and --email=your@mail.de (with your valid e-mail adress) are provided,
# a track data hub for visualizing results with the UCSC Genome Browser will be generated
# using MakeHub (https://github.com/Gaius-Augustus/MakeHub).

# --stranded=+,-,.,...
# If --UTR=on is enabled, strand-separated bam-files can be provided with --bam=plus.bam,minus.bam.
# In that case, --stranded=... should hold the strands of the bam files
# (+ for plus strand, - for minus strand, . for unstranded).
# Note that unstranded data will be used in the gene prediction step, only,
# if the parameter --stranded=... is set. This is an experimental feature!
