

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

### A. How we generated the genome ###
-- Isolated DNA was sequenced using Nanopore MinION. Basecalling was performed with Guppy (v. 4.0.11). From the raw reads, we generated a series of assemblies using the assemblers Flye and NECAT, combiend with four rounds of RACON (v. 1.4.13) followed by MEDAKA (v. 1.0.3). We consolidated haplotype redundancies using PURGEhaplotigs (v. 1.0.3, default settings) and merged the purged assemblies with Quickmerge (v. 0.3). All of these preliminary genome assemblies were compared and assessed using seqkit (v. 0.12.1) and BUSCO (v. 4.1.2, ref), respectively. BUSCO was run using the lepidoptera database (lepidoptera_odb10). 
-- 

Illumina sequencing and mapping
We produced two sets of Illumina short-read sequence data that were then used to polish the genome assembly. The first set of short-read sequences  came from an individual P. macunnoughii female collected in Gothic, CO, USA in 2014. The second was a set of pooled illumina short read sequences from 18 adult P. macdunnoughii females reared in the lab in 2006. These butterflies also originated from the Gothic, CO, population. DNA extraction was per individual, using a commerical kit (cell and tissue DNA kit) for robotic extraction on a KingFisher Duo Prime purifier (ThermoFisher Scientific), follwoing standard protocols with added RNAse A to remove RNA contamination. DNA concentration and purity was quantified using a Qubit 2.0 flourometer (ThermoFisher Scientific) and nanodrop (ThermoFisher Scientific), and run on a 2% agarose gel stained with GelRed to visually ascertain that DNA fragmentation was minimal. Samples were then pooled by population using an equal amount of DNA from each individual, and used for library preparation and sequencing (Illumina HiSeq), which was performed by SciLifeLab (Stockholm, Sweden), using 150-bp paired-end reads with 350 bp insert size.

The resulting Illumina sequencing data was filtered for PCR clones (Stacks 1.21 clone filter), adapters trimmed using truseq and nextera reference databases, and filtered for read quality (bbmap 34.86, bbduk2.sh) with a base quality threshold of 20 and a minimum read length of 40, resulting in 1.98x108 and 1.63x108 cleaned paired reads for the individual and pooled samples, respectively. Higher read coverage can improve the quality of polishing by Pilon (reference). To better directly compare the effect of polishing with individual or pool-seq data, we used seqkit to produce a random subsample of 1.60x108 reads of the individual sample. We mapped the full and subsampled set of reads to the v0.08 draft assembly with NextGenMapper (v. 0.5.5) and assessed differences in coverage and insert size using GoLeft (v. 0.2.1) and Qualimap (v. 2.2.1). 

Short-read polishing and annotation assessment
We polished the final unpolished genome with each set of the mapped Illumina short reads using Pilon (v. 1.23, Ref). We compared the polished and unpolished genomes using Seqkit and BUSCO analyses. To better assess the effects of polishing, we used the Braker2 automated pipeline to generate comprehensive annotations of the unpolished genome and both polished genomes (v. , Ref). Prior to running Braker2 we softmasked the assembly with RED (v. 05/22/2015, Girgis et al… ) using the redmask.py wrapper (v0.0.2), which masked 35.21% of the genome as repetitive content. We ran Braker2 in the genome and protein mode, using reference proteins from the Arthropoda section of OrthoDB (v. 10, REF). 

We compared the quality of the resulting annotations using an ortholog hit ratio (OHR) analysis, similar to that used by O’Niel et al (2010), modified for proteins. To do this we compared proteins from a Bombyx mori annotation to those in the unpolished assembly annotation, the individual-polished assembly annotation, and the pool-seq-polished assembly annotation. For each of the draft annotations, we used CD-HIT (v. 4.8.1, REF) to collapse protein clusters with greater than 90% identity over 80% of the protein length, from which we created blast databases (NCBI BLAST v. 2.5.0). The B. mori protein set was accessed from NCBI (GCF_000151625.1_ASM15162v1), and each protein in the set was blasted against the P. macdunnoughii protein databases. We calculated OHR as the proportion of a B. mori protein that was overlapped by an orthologous alignment hit in the draft P. macdunnoughii annotations. In our analysis, we focus on the OHR of the longest overlapping sequence.

Synteny and pseudo-chromosomal assembly
We used mummer (nucmer, ver ref) to align the pool-seq-polished P. macdunnoughii genome to that of the closely related eurasian species Pieris napi napi , which has a high quality, chromosome level assembly (Hill et al. 2019). The alignment file was filtered to retain only those aligned sequences that were longer than 5000 bp and had greater than 90% identity between the two genomes. Due to considerable synteny between the two Pieris genomes, we used the P. napi genome as a reference to arrange the pool-seq-polished P. macdunnoughii scaffolds into putative chromosomes for a pseudo-chromosomal assembly. To do this, we used RagTag (Alonge et al. 2019) to group and orient scaffolds against chromosomes 1 through 25 of the P. napi genome. We excluded unplaced P. napi scaffolds in this process, in order to target chromosomal placements of the P. macdunnoughii scaffolds. We set a lower grouping confidence threshold of 80% to minimize chimeric chromosomes. RagTag added 100 bp of N between each joined scaffold, increasing the length of the genome by 5600bp. 

Genome-wide population genetic variation 
In order to demonstrate the potential of  the pool-seq reads for population genetic inferences, these reads were mapped to the final pseudo-chromosomal assembly with NextGenMapper, filtered to keep proper pairs, and then we generated a pileup file with Samtools mpileup. We used Popoolation (v. , REF) to filter insertions and deletions before calculating nucleotide diversity (pi), Tajima’s D, and Watterson’s theta for 500 and 50,000 bp windows. Tajima’s D was calculated on a subsampled pileup file, with a maximum coverage of 80 reads and a target coverage of 20 reads. 

Bioinformatic details
The bash scripts for all of the steps described above are provided (github address), as well as the final genome assemblies and annotations.


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
