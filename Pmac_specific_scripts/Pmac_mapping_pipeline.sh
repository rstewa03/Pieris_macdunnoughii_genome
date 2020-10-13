Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileupexport TOOLS=/data/programs
export PM_READS=/mnt/griffin/Reads/Pieris_macdounghii_data
export PM_HOME=/mnt/griffin/racste/P_macdunnoughii
export PM_DATA=$PM_HOME/Pmac_data
export PM_ALIGN=$PM_HOME/Pmac_alignments
export PM_REF=$PM_HOME/Pmac_genome_versions

# P mac read mapping
#cd $PM_HOME
#mkdir -p Pmac_alignments/star
#export PM_ALIGN=$PM_HOME/Pmac_alignments

### NextGen mapping software: make single .bam file
# perform from the
## Example usage (where input reads files have been cleaned and quality assessed)
# ngm -r genome.fasta -1 reads1_clean.fq  -2 reads2_clean.fq  -t 30 -i 0.90 -b -o output.bam

# move to the trimmed data directory to
cd $PM_DATA/clean
mkdir genome_MS
mkdir larval_MS
mv Pmac000*fq genome_MS
cp Pmac_Mums_*fq genome_MS
mv Pmac* larval_MS

cd $PM_ALIGN/NGM_genome/
/mnt/griffin/kaltun/software/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/PmacD_Rac4MedPurge.fasta -1 /mnt/griffin/racste/P_macdunnoughii/Pmac_data/clean/genome_MS/Pmac000.1_1.fq.ctq20.fq.gz -2 /mnt/griffin/racste/P_macdunnoughii/Pmac_data/clean/genome_MS/Pmac000.1_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o Pmac000.1_NGM_Rac4MedPurge.bam
/mnt/griffin/kaltun/software/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/PmacD_Rac4MedPurge.fasta -1 /mnt/griffin/racste/P_macdunnoughii/Pmac_data/clean/genome_MS/Pmac_Mums_1.fq.ctq20.fq.gz -2 /mnt/griffin/racste/P_macdunnoughii/Pmac_data/clean/genome_MS/Pmac_Mums_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o Pmac_Mums_NGM_Rac4MedPurge.bam

cd $PM_ALIGN/NGM_genome
ls *.bam | parallel -j2 "samtools view -b {.}.bam > {.}.view.bam"
ls *.view.bam | parallel -j2 "samtools sort -o {.}.sort.bam -T {.}_temp {.}.bam"
ls *.sort.bam | parallel -j2 "samtools index {.}.bam"

rm *view.bam

#################################
#### Go Left: check coverage ####
#################################

/mnt/griffin/kaltun/software/goleft_linux64 covstats *sort.bam

###################
#### Polishing ####
###################

# Pilon_polish_FBCflyeRMP.sh :
#!/bin/bash
#to run run command followed by bamfile you want to polish with, i.e ./01_polish_aln.sh bamfile.bam
# reference=/mnt/grifin/racste/P_macdunnoughii/Pmac_genome_versions/PmacD_flyeRac4MedPur.fasta
# java -ea -Xmx200g -jar /mnt/griffin/racste/Software/pilon-1.23.jar  --genome $reference --frags $1 --threads 30 --outdir ${1%.bam}.PILON --tracks --vcf --changes --diploid --output ${1%.bam}.pilon.polish

bash Pilon_polish_FBCflyeRMP.sh Pmac000.1_NGM_Rac4MedPurge.bam
bash Pilon_polish_FBCflyeRMP.sh Pmac_Mums_NGM_Rac4MedPurge.bam

# Check using BUSCO and seqkit
# file                                                     format  type  num_seqs      sum_len  min_len    avg_len    max_len      Q1      Q2       Q3  sum_gap      N50
# Pmac000.1_NGM_Rac4MedPurge.view.sort.pilon.polish.fasta  FASTA   DNA      2,348  324,027,004       55  138,001.3  6,756,163  33,398  90,675  163,831        0  237,057
# Pmac_Mums_NGM_Rac4MedPurge.view.sort.pilon.polish.fasta  FASTA   DNA      2,348  324,454,314       55  138,183.3  6,765,458  33,513  90,311  163,881        0  236,913

# Pmac000.1_NGM_Rac4MedPurge.view.sort.pilon.polish_v_lepidoptera_odb10
# |Results from dataset lepidoptera_odb10           |
# --------------------------------------------------
# |C:97.3%[S:95.9%,D:1.4%],F:0.8%,M:1.9%,n:5286     |
# |5146   Complete BUSCOs (C)                       |
# |5071   Complete and single-copy BUSCOs (S)       |
# |75     Complete and duplicated BUSCOs (D)        |
# |43     Fragmented BUSCOs (F)                     |
# |97     Missing BUSCOs (M)                        |
# |5286   Total BUSCO groups searched               |
# --------------------------------------------------
#
# Pmac_Mums_NGM_Rac4MedPurge.view.sort.pilon.polish_v_lepidoptera_odb10
# --------------------------------------------------
# |Results from dataset lepidoptera_odb10           |
# --------------------------------------------------
# |C:97.5%[S:96.0%,D:1.5%],F:0.8%,M:1.7%,n:5286     |
# |5151   Complete BUSCOs (C)                       |
# |5074   Complete and single-copy BUSCOs (S)       |
# |77     Complete and duplicated BUSCOs (D)        |
# |44     Fragmented BUSCOs (F)                     |
# |91     Missing BUSCOs (M)                        |
# |5286   Total BUSCO groups searched               |
# --------------------------------------------------

mkdir PmacD_Rac4MedPurge
mv * PmacD_Rac4MedPurge

################################
#### Map to haploidA genome ####
################################
cd $PM_ALIGN/NGM_genome/
$TOOLS/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r $PM_REF/PmacD_qmRac4MedPur.cleaned.masked.haploidA.fasta -1 $PM_DATA/clean/genome_MS/Pmac000.1_1.fq.ctq20.fq.gz -2 $PM_DATA/clean/genome_MS/Pmac000.1_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o Pmac000.1_NGM_qmRac4MedPur.cleaned.masked.haploidA.bam
$TOOLS/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r $PM_REF/PmacD_qmRac4MedPur.cleaned.masked.haploidA.fasta -1 $PM_DATA/clean/genome_MS/Pmac_Mums_1.fq.ctq20.fq.gz -2 $PM_DATA/clean/genome_MS/Pmac_Mums_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o Pmac_Mums_NGM_qmRac4MedPur.cleaned.masked.haploidA.bam
$TOOLS/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r $PM_REF/PmacD_qmRac4MedPur.cleaned.masked.haploidA.fasta -1 $PM_DATA/clean/genome_MS/sample_Pmac000.1_1.fq.ctq20.fq.gz -2 $PM_DATA/clean/genome_MS/sample_Pmac000.1_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o sample_Pmac000.1_NGM_qmRac4MedPur.cleaned.masked.haploidA.bam
$TOOLS/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r $PM_REF/PmacD_qmRac4MedPur.cleaned.masked.haploidA.fasta -1 $PM_DATA/clean/genome_MS/sample_Pmac_Mums_1.fq.ctq20.fq.gz -2 $PM_DATA/clean/genome_MS/sample_Pmac_Mums_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o sample_Pmac_Mums_NGM_qmRac4MedPur.cleaned.masked.haploidA.bam

cd $PM_ALIGN/NGM_genome
ls *.bam | parallel -j4 "samtools view -b {.}.bam > {.}.view.bam"
ls *.view.bam | parallel -j4 "samtools sort -o {.}.sort.bam -T {.}_temp {.}.bam"
ls *.sort.bam | parallel -j4 "samtools index {.}.bam"

rm *view.bam

#################################
#### Check stats with GoLeft ####
#################################
/mnt/griffin/kaltun/software/goleft_linux64 covstats *sorted.bam > GoLeft.txt

################################
#### map to polished genome ####
################################
mkdir -p $PM_ALIGN/NGM_genome/polishMap
cd $PM_ALIGN/NGM_genome/polishMap
$TOOLS/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r $PM_REF/Pmac000.1_polished.fasta -1 $PM_DATA/clean/genome_MS/Pmac000.1_1.fq.ctq20.fq.gz -2 $PM_DATA/clean/genome_MS/Pmac000.1_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o Pmac000.1_NGM_Pmac000.1_polished.bam
$TOOLS/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r $PM_REF/Pmac000.1_polished.fasta -1 $PM_DATA/clean/genome_MS/Pmac_Mums_1.fq.ctq20.fq.gz -2 $PM_DATA/clean/genome_MS/Pmac_Mums_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o Pmac_Mums_NGM_Pmac000.1_polished.bam
$TOOLS/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r $PM_REF/Pmac000.1_polished.fasta -1 $PM_DATA/clean/genome_MS/sample_Pmac000.1_1.fq.ctq20.fq.gz -2 $PM_DATA/clean/genome_MS/sample_Pmac000.1_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o sample_Pmac000.1_NGM_Pmac000.1_polished.bam
ls *polished.bam | parallel -j4 "samtools view -b {.}.bam > {.}.view.bam"
ls *polished.view.bam | parallel -j4 "samtools sort -o {.}.sort.bam -T {.}_temp {.}.bam"
ls *polished.sort.bam | parallel -j4 "samtools index {.}.bam"


################################
#### Assess mapping quality ####
################################
# http://qualimap.bioinfo.cipf.es/doc_html/command_line.html
# # /data/programs/qualimap_v2.2.1/qualimap bamqc
# usage: qualimap bamqc -bam <arg> [-c] [-gd <arg>] [-gff <arg>] [-hm <arg>] [-ip]
#        [-nr <arg>] [-nt <arg>] [-nw <arg>] [-oc <arg>] [-os] [-outdir <arg>]
#        [-outfile <arg>] [-outformat <arg>] [-p <arg>] [-sd] [-sdmode <arg>]
#  -bam <arg>                           Input mapping file in BAM format
#  -c,--paint-chromosome-limits         Paint chromosome limits inside charts
#  -gd,--genome-gc-distr <arg>          Species to compare with genome GC
#                                       distribution. Possible values: HUMAN -
#                                       hg19; MOUSE - mm9(default), mm10
#  -gff,--feature-file <arg>            Feature file with regions of interest in
#                                       GFF/GTF or BED format
#  -hm <arg>                            Minimum size for a homopolymer to be
#                                       considered in indel analysis (default is
#                                       3)
#  -ip,--collect-overlap-pairs          Activate this option to collect statistics
#                                       of overlapping paired-end reads
#  -nr <arg>                            Number of reads analyzed in a chunk
#                                       (default is 1000)
#  -nt <arg>                            Number of threads (default is 64)
#  -nw <arg>                            Number of windows (default is 400)
#  -oc,--output-genome-coverage <arg>   File to save per base non-zero coverage.
#                                       Warning: large files are expected for
#                                       large genomes
#  -os,--outside-stats                  Report information for the regions outside
#                                       those defined by feature-file  (ignored
#                                       when -gff option is not set)
#  -outdir <arg>                        Output folder for HTML report and raw
#                                       data.
#  -outfile <arg>                       Output file for PDF report (default value
#                                       is report.pdf).
#  -outformat <arg>                     Format of the output report (PDF, HTML or
#                                       both PDF:HTML, default is HTML).
#  -p,--sequencing-protocol <arg>       Sequencing library protocol:
#                                       strand-specific-forward,
#                                       strand-specific-reverse or
#                                       non-strand-specific (default)
#  -sd,--skip-duplicated                Activate this option to skip duplicated
#                                       alignments from the analysis. If the
#                                       duplicates are not flagged in the BAM
#                                       file, then they will be detected by
#                                       Qualimap and can be selected for skipping.
#  -sdmode,--skip-dup-mode <arg>        Specific type of duplicated alignments to
#                                       skip (if this option is activated).
#                                       0 : only flagged duplicates (default)
#                                       1 : only estimated by Qualimap
#                                       2 : both flagged and estimated

################################


ls *sort.bam | parallel -j4 "/data/programs/qualimap_v2.2.1/qualimap bamqc -bam {.}.bam -outdir {.}"


/data/programs/qualimap_v2.2.1/qualimap bamqc -bam Pmac000.1_NGM_Pmac000.1_polished.view.sort.bam -outdir Pmac000.1_qualimap_results -outformat html unset DISPLAY
/data/programs/qualimap_v2.2.1/qualimap bamqc -bam Pmac_Mums_NGM_Pmac000.1_polished.view.sort.bam -outdir PmacMums_qualimap_results -outformat html unset DISPLAY
/data/programs/qualimap_v2.2.1/qualimap bamqc -bam sample_Pmac000.1_NGM_Pmac000.1_polished.view.sort.bam -outdir sample_Pmac000.1_qualimap_results -outformat html unset DISPLAY


for i in `ls -1 *view.sort.bam | sed 's/.view.sort.bam//'`
do
  /data/programs/qualimap_v2.2.1/qualimap bamqc -bam $i.view.sort.bam -outdir $i -outformat html unset DISPLAY;
done


#####################################################
#### map Colorado Mums to polished RagTag genome ####
#####################################################

cd $PM_ALIGN/NGM_genome/RagTagMap

$TOOLS/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r PmacMums_polished.ragtag_i80.nh.fasta -1 $PM_DATA/clean/genome_MS/Pmac_Mums_1.fq.ctq20.fq.gz -2 $PM_DATA/clean/genome_MS/Pmac_Mums_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o Pmac_Mums_NGM_PmacMums_polished_ragtag.bam

# Prepare mpileup
path_to_samtools=/data/programs/samtools-1.10
# here we are filtering on -f 3 = retain reads as pairs, and mapped as proper pairs, with input -b being BAM
# note that for highly fragmented genomes, you might not want to filter on proper pairs, as many will be broken
# for high quality genomes, you should be keeping these.
$path_to_samtools/samtools view -f 3 -@ 30 -b Pmac_Mums_NGM_PmacMums_polished_ragtag.bam >  Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.bam
# sorting
$path_to_samtools/samtools sort -@ 30 Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.bam -o Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.bam -T temp
# indexing
$path_to_samtools/samtools index Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.bam
# sanity check on the bam files

$TOOLS/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r Pmac000.1_polished.ragtag_i80.nh.fasta -1 $PM_DATA/clean/genome_MS/Pmac_Mums_1.fq.ctq20.fq.gz -2 $PM_DATA/clean/genome_MS/Pmac_Mums_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o Pmac_Mums_NGM_Pmac000.1_polished_ragtag.bam
path_to_samtools=/data/programs/samtools-1.10
$path_to_samtools/samtools view -f 3 -@ 30 -b Pmac_Mums_NGM_Pmac000.1_polished_ragtag.bam >  Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.bam
$path_to_samtools/samtools sort -@ 30 Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.bam -o Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.bam -T temp
$path_to_samtools/samtools index Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.bam
samtools quickcheck -v *sorted.bam > bad_bams.fofn   && echo 'all ok' || echo 'some files failed check, see bad_bams.fofn'

########################
#### create mpileup ####


#######
bamfile=Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted
reference=PmacMums_polished.ragtag_i80.nh.fasta
phred=20
mapq=20
#
# making mpileup, filtering to skip bases with base quality (PHRED) lower than threshold set
# and with mapq lower than threshold set.
# here including the reference allows for this reference base call to be included in downstream files, so that it will not be "N"
# -B is to speed things up by not calling alignment quality computation.
# $path_to_samtools/samtools mpileup -B -q $mapq -Q $phred -f $reference $bamfile.bam > $bamfile.mpileup
# identify indels
perl /data/programs/popoolation/basic-pipeline/identify-genomic-indel-regions.pl --input $bamfile.mpileup --output $bamfile.indel.gtf --indel-window 5 --min-count 1
# remove indels
perl /data/programs/popoolation/basic-pipeline/filter-pileup-by-gtf.pl  --gtf $bamfile.indel.gtf --input $bamfile.mpileup --output $bamfile.rmindel.pileup

#######
bamfile=Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted
reference=Pmac000.1_polished.ragtag_i80.nh.fasta
phred=20
mapq=20
# $path_to_samtools/samtools mpileup -B -q $mapq -Q $phred -f $reference $bamfile.bam > $bamfile.mpileup
perl /data/programs/popoolation/basic-pipeline/identify-genomic-indel-regions.pl --input $bamfile.mpileup --output $bamfile.indel.gtf --indel-window 5 --min-count 1
perl /data/programs/popoolation/basic-pipeline/filter-pileup-by-gtf.pl  --gtf $bamfile.indel.gtf --input $bamfile.mpileup --output $bamfile.rmindel.pileup

##########
# # then subset the data if you want to use it for calculating Tajima's D. You don't need to do this if you are going to be estimating pi
# pileup_file=combined_highlow.sorted.mpileup.rmindel.p_filt.pileup
pileup_file=Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel
targetcoverage_subsample=20
maxcoverage_subsample=80
# then subset the data (this step takes a long time)
perl /data/programs/popoolation/basic-pipeline/subsample-pileup.pl --input $pileup_file.pileup --output $pileup_file.subsampled.pileup --target-coverage $targetcoverage_subsample --max-coverage $maxcoverage_subsample --method withoutreplace --fastq-type sanger


pileup_file=Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel
targetcoverage_subsample=20
maxcoverage_subsample=80
# then subset the data
perl /data/programs/popoolation/basic-pipeline/subsample-pileup.pl --input $pileup_file.pileup --output $pileup_file.subsampled.pileup --target-coverage $targetcoverage_subsample --max-coverage $maxcoverage_subsample --method withoutreplace --fastq-type sanger







##################################################################
#### calculate population genetic statistics with Popoolation ####
##################################################################
# perl Variance-sliding.pl - A script which calculates the requested population genetics measure (pi, theta, d) along chromosomes using a sliding window approach.
# perl Variance-sliding.pl --measure pi --input input.pileup --output output.file --pool-size 500 --min-count 2 --min-coverage 4 --window-size 50000 --step-size 5000
## --input         The input file in the pileup format. A pooled population sequenced and mapped to the reference genome. Finally the mapping results have been converted to sam output format. Using the samtools the sam format can be easily converted into the pileup format.  Mandatory.
## --output       The output file.  Mandatory.
## --snp-output   If provided, this file will contain the polymorphic sites which have been used for this analysis; default=empty
## --measure      Currently, "pi", "theta" and "D" is supported. This stands for Tajima's Pi, Watterson's Theta, Tajima's D respectively; Mandatory
## --region       Provide a subregion in which the measure should be calculated using a sliding window approach; has to be of the form chr:start-end; eg 2L:5000-5000; Example: C<--region "chr2:100-1000"> Optional
## --pool-size    The size of the pool which has been sequenced. e.g.: 500; Mandatory
## -fastq-type    The encoding of the quality characters; Must either be 'sanger' or 'illumina'; default=illumina; Using the notation suggested by Cock et al (2009) the following applies:
##                  'sanger'   = fastq-sanger: phred encoding; offset of 33
##                  'solexa'   = fastq-solexa: -> NOT SUPPORTED
##                  'illumina' = fastq-illumina: phred encoding: offset of 64
##                   See also: Cock et al (2009) The Sanger FASTQ file format for sequecnes with quality socres, and the Solexa/Illumina FASTQ variants;
## --min-count    The minimum count of the minor allele. This is important for the identification of SNPs; default=2
## --min-coverage The minimum coverage of a site. Sites with a lower coverage will not be considered (for SNP identification and coverage estimation); default=4
## --max-coverage the maximum coverage; used for SNP identification, the coverage in ALL populations has to be lower or equal to this threshold, otherwise no SNP will be called. default=500000
## --min-covered-fraction the minimum fraction of a window being between min-coverage and max-coverage in ALL populations; float; default=0.6
## --min-qual      The minimum quality; Alleles with a quality lower than this threshold will not be considered (for SNP identification and coverage estimation); default=20
## --window-size  The size of the sliding window. default=50000
## --step-size    the size of one sliding window step. If this number is equal to the --window-size the sliding window will be non overlapping (jumping window). default=5000
## --no-discard-deletions per default sites with already a single deletion are discarded. By setting this flag, sites with deletions will be used.
## --test        Run the unit tests for this script.

## For every sliding window the population genetics measure will be displayed in the following format

 # 2L     1730000 557     0.726   0.005647899
 # 2L     1740000 599     0.777   0.005657701
 # 2L     1750000 650     0.767   0.006129462
 # 2L     1760000 617     0.703   0.006265200
 # 2L     1770000 599     0.672   0.006427032

 # col 1: reference chromosome
 # col 2: position in the reference chromosome
 # col 3: number of SNPs in the sliding window; These SNPs have been used to calculate the value in col 5
 # col 4: fraction of the window covered by a sufficient number of reads. Suficient means higher than min-coverage and lower than max-coverage
 # col 5: population genetics estimator (pi, theta, D)

# SNP Output: This output file is optional, it will only be created if the option  --snp-output is provided.
# For example:

 # >2R:50; 2R:0-100; snps:3
 # 2R      13      A       17      10      0       0       7       0
 # 2R      30      A       34      33      1       0       0       0
 # 2R      37      A       40      39      1       0       0       0
 #
 # >2R:150; 2R:100-200; snps:2
 # 2R      105     A       76      64      0       12      0       0
 # 2R      118     T       75      0       72      1       2       0

 # The header contains the following information
 #  >chr:middle chr:start-end snps:scnpcount
 #  chr..chromosome (contig)
 #  middle.. middle position of the window
 #  start.. start position of the window
 #  end.. end position of the window
 #  snpcount.. number of snps found in the given window
 #
 #  The individual tab-delimited entries are in the following format:
 #  col 1: chromosome ID (contig)
 #  col 2: position in chromosome
 #  col 3: reference character
 #  col 4: coverage
 #  col 5: counts of A's
 #  col 6: counts of T's
 #  col 7: counts of C's
 #  col 8: counts of G's
 #  col 9: counts of N's
 # pileup_file=Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel
 # maxdepth=500
 # poolsize=40
 # window=500
 # metric=pi
 # outfile=$pileup_file."$metric"."$window"
 #  /data/programs/scripts/popoolation_parallel_scripts/parallel_variance_sliding_pi_D.sh 50 $pileup_file.pileup $outfile $maxdepth $poolsize $window $window $metric sanger
 # pileup_file=Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.subsampled
 # maxdepth=500
 # poolsize=40
 # window=500metric=D
 # outfile=$pileup_file."$metric"."$window"
 # /data/programs/scripts/popoolation_parallel_scripts/parallel_variance_sliding_pi_D.sh 50 $pileup_file.pileup $outfile $maxdepth $poolsize $window $window $metric sanger
 # 
 # pileup_file=Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel
 # maxdepth=500
 # poolsize=40
 # window=50000
 # metric=pi
 # outfile=$pileup_file."$metric"."$window"
 #  /data/programs/scripts/popoolation_parallel_scripts/parallel_variance_sliding_pi_D.sh 50 $pileup_file.pileup $outfile $maxdepth $poolsize $window $window $metric sanger
 # pileup_file=Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.subsampled
 # metric=D
 # outfile=$pileup_file."$metric"."$window"
 # /data/programs/scripts/popoolation_parallel_scripts/parallel_variance_sliding_pi_D.sh 50 $pileup_file.pileup $outfile $maxdepth $poolsize $window $window $metric sanger

nano
perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure pi --input Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 50000 --step-size 50000 --output Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.50k.pi --snp-output Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.50k.snps
perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure pi --input Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 50000 --step-size 50000 --output Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup.50k.pi --snp-output Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup.50k.snps

perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure D --input Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.subsampled.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 50000 --step-size 50000 --output Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.subsampled.50k.D
perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure D --input Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.subsampled.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 50000 --step-size 50000 --output Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup.subsampled.50k.D

perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure theta --input Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 50000 --step-size 50000 --output Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.subsampled.50k.theta
perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure theta --input Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 50000 --step-size 50000 --output Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup.subsampled.50k.theta

perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure pi --input Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 500 --step-size 500 --output Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.0.5k.pi --snp-output Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.0.5k.snps
perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure pi --input Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 500 --step-size 500 --output Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup.0.5k.pi --snp-output Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup.0.5k.snps

perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure D --input Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.subsampled.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 500 --step-size 500 --output Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.subsampled.0.5k.D
perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure D --input Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.subsampled.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 500 --step-size 500 --output Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup.subsampled.0.5k.D

perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure theta --input Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 500 --step-size 500 --output Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.subsampled.0.5k.theta
perl /data/programs/popoolation/Variance-sliding.pl --fastq-type sanger --measure theta --input Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup --min-count 2 --min-coverage 4 --max-coverage 500 --min-covered-fraction 0.25 --pool-size 40 --window-size 500 --step-size 500 --output Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted.rmindel.pileup.subsampled.0.5k.theta
parallel -j12 < SlidingWindowJobs.txt 

