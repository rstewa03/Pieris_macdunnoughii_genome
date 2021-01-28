

# Pieris_macdunnoughii_genome
Pieris macdunnoughii genome assembly

Release date: #Private, 28 January 2021

Genomics resources for Pieris macdunnoughii (Pieridae; Lepidoptera)


***************************************

### Contents ###

+ A. How we generated the genome
+ B. Genome annotation and assessment
+ C. Application of Pool-seq data
+ D. File listing

***************************************

### A. How we generated the genome ###
Isolated DNA was sequenced using Nanopore MinION. Basecalling was performed with Guppy (v. 4.0.11). From the raw reads, we generated a series of assemblies using the assemblers Flye and NECAT, combiend with four rounds of RACON (v. 1.4.13) followed by MEDAKA (v. 1.0.3). We consolidated haplotype redundancies using PURGEhaplotigs (v. 1.0.3, default settings) and merged the purged assemblies with Quickmerge (v. 0.3). All of these preliminary genome assemblies were compared and assessed using seqkit (v. 0.12.1) and BUSCO (v. 4.1.2, ref), respectively. BUSCO was run using the lepidoptera database (lepidoptera_odb10). 

The Quickmerge genome was further improved with hybrid polishing. We compared two short-read polishing approaches: using Illumina reads from a single indivdual and reads from pooled DNA of 18 individuals. We polished the final unpolished genome with each set of the mapped Illumina short reads using Pilon (v. 1.23, Ref). We compared the polished and unpolished genomes using Seqkit and BUSCO analyses. 

We used mummer (nucmer) to align the polished P. macdunnoughii genome to that of Pieris  napi. The alignment file was filtered to retain only those aligned sequences that were longer than 5000 bp and had greater than 90% identity between the two genomes. We further used the P. napi genome as a reference to arrange the polished P. macdunnoughii scaffolds into putative chromosomes for a pseudo-chromosomal assembly using RagTag (Alonge et al. 2019). 


***************************************

### Genome Annotation and Assessment ###

We used the Braker2 automated pipeline to generate annotations of the genomes. Prior to running Braker2 we softmasked the assembly with RED (v. 05/22/2015) using the redmask.py wrapper (v0.0.2), which masked 35.21% of the genome as repetitive content. We ran Braker2 in the genome and protein mode, using reference proteins from the Arthropoda section of OrthoDB (v. 10, REF). We compared the quality of the resulting annotations using an ortholog hit ratio (OHR) analysis. We calculated OHR as the proportion of a B. mori protein that was overlapped by an orthologous alignment hit in the draft P. macdunnoughii annotations. 

***************************************

### C. Application of Pool-seq data ###
In order to demonstrate the potential of  the pool-seq reads for population genetic inferences, we used Popoolation (v. , REF) to calculatenucleotide diversity (pi), Tajima’s D, and Watterson’s theta for 500 and 50,000 bp windows. 

***************************************

### D. File Listing ###

+ `Pmac01_PrelimGenomeAssessment.sh` 
+ `Pmac02_Haplomerger2.sh` 
+ `Pmac03_CleanMapIlluminaReads.sh`
+ `Pmac05_Annotation.sh`  
+ `Pmac06_OHRanalysis.sh`   
+ `Pmac06_OHRanalysis.R`   
+ `Pmac07_Synteny.sh`   
+ `Pmac07_Synteny.R`   
+ `Pmac08_pseudochromosomalAlignment.sh`   
+ `Pmac09_popGen.sh`   
+ `Pmac09_popGen.R`   
