
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
$path_to_samtools/samtools mpileup -B -q $mapq -Q $phred -f $reference $bamfile.bam > $bamfile.mpileup
# identify indels
perl /data/programs/popoolation/basic-pipeline/identify-genomic-indel-regions.pl --input $bamfile.mpileup --output $bamfile.indel.gtf --indel-window 5 --min-count 1
# remove indels
perl /data/programs/popoolation/basic-pipeline/filter-pileup-by-gtf.pl  --gtf $bamfile.indel.gtf --input $bamfile.mpileup --output $bamfile.rmindel.pileup

#######
bamfile=Pmac_Mums_NGM_Pmac000.1_polished_ragtag.pairs.sorted
reference=Pmac000.1_polished.ragtag_i80.nh.fasta
phred=20
mapq=20
 $path_to_samtools/samtools mpileup -B -q $mapq -Q $phred -f $reference $bamfile.bam > $bamfile.mpileup
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
