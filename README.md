

# Pieris_macdunnoughii_genome
Pieris macdunnoughii genome assembly

Release date: #Private, 28 January 2021

Genomics resources for Pieris macdunnoughii (Pieridae; Lepidoptera)


***************************************

### Contents ###

+ A. How we generated the genome
+ B. Genome annotation and assessment
+ C. File Listing

***************************************

### A. Annotation ###
<!-- Here we are using MESPA, which is a effectively a wrapper for spaln2, which uses the results to scaffold assemblies by proteins and then generates a GFF file based upon the input protein sequences, as well as summary stats. We use it cause it works and is very fast, but there are perhaps other methods that are better, both for scaffolding and annotation (e.g. BRAKER)

Neethiraj, R., Hornett, E.A., Hill, J.A., and Wheat, C.W. (2017). Investigating the genomic basis of discrete phenotypes using a Pool-Seq-only approach: New insights into the genetics underlying colour variation in diverse taxa. Molecular Ecology 26, 4990–5002.

- [link to article](https://onlinelibrary.wiley.com/doi/full/10.1111/mec.14205) -->


***************************************

### Assessments ###

+ `annotation.sh` — shows the steps for generating the annotation, as well as results.
+ `genome_stats.sh` - show results from running assemblathon_stats.pl, from the Assemblathon 2 competition (https://github.com/ucdavis-bioinformatics/assemblathon2-analysis), on the pre and post scaffolded geomes.
+ `transcriptome_assembly_proteins.sh` - shows summary stats on the protein file used for scaffolding and annotation.

***************************************

### C. File Listing ###

+ `Pararge_aegeria_v2.Braker_functional_annotations.tsv`  these are the EGGNOG protein level annotations from the highquality Brake annotation (braker_prot.start_nointstop_stoprm.fa)
+ `Pararge_aegeria_v2.Braker_proteins.fa`  n=29069 these are the proteins from the Braker annotation
+ `Pararge_aegeria_v2.Braker_proteins_hiqualityfiltered.fa`  n=23567 these are the proteins from the brake annotaiton with start and stop codons, and no internal stop codons
+ `Pararge_aegeria_v2.repeats.bed`    repeat masking coordinates, of which 157,778,708 bp (32.92%) was identified as repeat content
+ `Pararge_aegeria_v2.softmasked.fa`  a soft masked genome based upon the repeat bed file
+ `README.md` — This file.
