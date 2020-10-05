#############################################
#### Align Pmac genome versions to Pnapi ####
#############################################

# set the reference genome pathway and file
# Reference=/mnt/griffin/Pierinae_genomes/Pieris_napi_genome_v1.1/Pieris_napi_fullAsm.fasta
Reference_path=$PM_REF/faDnaPolishing/
Reference=Pieris_napi_fullAsm.cleaned.fasta
# generate a list of reference contigs
grep '>' $Reference_path/$Reference | sed 's/>//' > Pnap_contigs.txt
Ref_contigs=Pnap_contigs.txt

# set the query genome pathway and file
Query_path=$PM_REF/pseudochromosomal/RagTag/PmacMums_polished_against_Pieris_napi_fullAsm_chromoOnly_i.80.out/
Query=PmacMums_polished_against_Pieris_napi_fullAsm_chromoOnly_i.80.ragtag.scaffolds.fasta
# generate a list of reference contigs
grep '>' $Query_path/$Query | sed 's/>//' > Pmac_contigs.txt
Qry_contigs=Pmac_contigs.txt

# set a prefix for output files
Prefix=nucmer_aln_Pnap_v_PmacMums_polished_ragtag_i80

# Run nucmer to align the two genomes

# Options (default value in (), *required):
#      --mum                                Use anchor matches that are unique in both the reference and query (false)
#      --maxmatch                           Use all anchor matches regardless of their uniqueness (false)
#  -b, --breaklen=uint32                    Set the distance an alignment extension will attempt to extend poor scoring regions before giving up (200)
#  -c, --mincluster=uint32                  Sets the minimum length of a cluster of matches (65)
#  -D, --diagdiff=uint32                    Set the maximum diagonal difference between two adjacent anchors in a cluster (5)
#  -d, --diagfactor=double                  Set the maximum diagonal difference between two adjacent anchors in a cluster as a differential fraction of the gap length (0.12)
#      --noextend                           Do not perform cluster extension step (false)
#  -f, --forward                            Use only the forward strand of the Query sequences (false)
#  -g, --maxgap=uint32                      Set the maximum gap between two adjacent matches in a cluster (90)
#  -l, --minmatch=uint32                    Set the minimum length of a single exact match (20)
#  -L, --minalign=uint32                    Minimum length of an alignment, after clustering and extension (0)
#      --nooptimize                         No alignment score optimization, i.e. if an alignment extension reaches the end of a sequence, it will not backtrack to optimize the alignment score and instead terminate the alignment at the end of the sequence (false)
#  -r, --reverse                            Use only the reverse complement of the Query sequences (false)
#      --nosimplify                         Don't simplify alignments by removing shadowed clusters. Use this option when aligning a sequence to itself to look for repeats (false)
#  -p, --prefix=PREFIX                      Write output to PREFIX.delta (out)
#      --delta=PATH                         Output delta file to PATH (instead of PREFIX.delta)
#      --sam-short=PATH                     Output SAM file to PATH, short format
#      --sam-long=PATH                      Output SAM file to PATH, long format
#      --save=PREFIX                        Save suffix array to files starting with PREFIX
#      --load=PREFIX                        Load suffix array from file starting with PREFIX
#      --batch=BASES                        Proceed by batch of chunks of BASES from the reference
#  -t, --threads=NUM                        Use NUM threads (# of cores)
#  -U, --usage                              Usage
#  -h, --help                               This message
#      --full-help                          Detailed help
#  -V, --version                            Version

$TOOLS/mummer-4.0.0beta2/nucmer --mum -c 100 -t 20 -p $Prefix $Reference $Query
$TOOLS/mummer-4.0.0beta2/show-coords -r -c -l $Prefix.delta > $Prefix.coords
cat $Prefix.coords | sed 1,5d | tr -s ' ' | awk 'BEGIN {FS=" "; OFS=","} {;print $1,$2,$4,$5,$7,$8,$10,$12,$13,$18,$19}' > $Prefix.filt.coords



#Run the circlize plot script to generate figures
Rscript /mnt/griffin/racste/circlePlot_nucmerOutput_script.R $Prefix.filt.coords $Ref_contigs $Qry_contigs 90 5000 


#### alternative alignment method
# creates two additional columns so not compatible with circlePlot_nucmerOutput_script.R

# $TOOLS/mummer-4.0.0beta2/nucmer --mum -c 100 $PM_ANNOT/masking/Pieris_napi_fullAsm.hardmasked.fa $PM_ANNOT/masking/Pmac000.1_polished.hardmasked.fa -p alt_Pmac00.1_hardmasked_Pnap_nucmer -t 30
# $TOOLS/mummer-4.0.0beta2/show-coords -c -l -L 1000 -r -T alt_Pmac00.1_hardmasked_Pnap_nucmer.delta > alt_Pmac00.1_hardmasked_Pnap_nucmer.txt

