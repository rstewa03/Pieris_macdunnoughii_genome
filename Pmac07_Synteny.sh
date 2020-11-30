#############################################
#### Align Pmac genome versions to Pnapi ####
#############################################

# set the reference genome pathway and file
# Reference=/mnt/griffin/Pierinae_genomes/Pieris_napi_genome_v1.1/Pieris_napi_fullAsm.fasta
Reference=$PM_REF/faDnaPolishing/Pieris_napi_fullAsm.cleaned.fasta
# generate a list of reference contigs
grep '>' $Reference | sed 's/>//' > Pnap_contigs.txt
Ref_contigs=Pnap_contigs.txt

#### PoolSeq ####
# set the query genome pathway and file
Query=$PM_REF/faDnaPolishing/PmacMums_polished.cleaned.fasta
# generate a list of reference contigs
grep '>' $Query | sed 's/>//' > Pmac_contigs.txt
Qry_contigs=Pmac_contigs.txt

# set a prefix for output files
Prefix=nucmer_aln_Pnap_v_PmacMums_polished.cleaned

# Run nucmer to align the two genomes
$TOOLS/mummer-4.0.0beta2/nucmer --mum -c 100 -t 20 -p $Prefix $Reference $Query
$TOOLS/mummer-4.0.0beta2/show-coords -r -c -l $Prefix.delta > $Prefix.coords
cat $Prefix.coords | sed 1,5d | tr -s ' ' | awk 'BEGIN {FS=" "; OFS=","} {;print $1,$2,$4,$5,$7,$8,$10,$12,$13,$18,$19}' > $Prefix.filt.coords

#
Rscript /mnt/griffin/racste/circlePlot_nucmerOutput_script.R $Prefix.filt.coords $Ref_contigs $Qry_contigs 90 5000
### additional R scripts
