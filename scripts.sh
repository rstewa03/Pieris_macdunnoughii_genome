#mapping
read1=BP_1final.wheat.fq
read2=BP_2final.wheat.fq
reference=scaffolds.mfa
outfile=BP_1final.bam
/data/programs/NextGenMap-0.4.10/bin/ngm-0.4.10/ngm -r "$reference" -1 "$read1" -2 "$read2" -t 50 -p -b -i 0.90 -o "$outfile"


#########################
### CLEANING & ASSESSMENT
### Based on SH_data_prep tutorial: https://sites.google.com/site/pierisgenomes/slu_rnaseq/sh_data_prep
### modified with Ram's script (2 May 2016)
### Duke path to programs: </data/programs/stacks-1.21/program.name>
###                        </data/programs/bbmap_34.86/program.name>


### clone filter: remove PCR duplicates from among files
## example usage (use -i gzfastq for use with fq.gz files)
/data/programs/stacks-1.21/clone_filter -i gzfastq -1 file1.fq.gz -2 file2.fq.gz -o .

# So for the mums:

## my data CO Mums (103) 11-May-2016
/data/programs/stacks-1.21/clone_filter -i gzfastq -1 Pmac_Mums_1.fq.gz -2 Pmac_Mums_2.fq.gz -o . 
# 92571068 pairs of reads input. 89925978 pairs of reads output, discarded 2645090 pairs of reads, 2.86% clone reads.



### adapter filter: compares read pairs against list of known Illumina adapters & filters out matching sequences
# input file from pcr duplicate clone filter  [filename1.fq].fil.fq_1 and [filename2.fq].fil.fq_2
# reads in output file will have had adapters trimmed (here, output file includes 'noadapt' to indicate adapter trim)

## example
/data/programs/bbmap_34.86/bbduk.sh in=file1.fil.fq_1 in2=file2.fil.fq_2 out=temp_1.fq out2=temp_2.fq ref=/data/programs/bbmap_34.86/resources/truseq.fa.gz,/data/programs/bbmap_34.86/resources/nextera.fa.gz ktrim=r k=23 mink=11 hdist=1 overwrite=t

# my data CO Mums (103) 12-May-2016
/data/programs/bbmap_34.86/bbduk.sh in=Pmac_Mums_1.fq.fil.fq_1 in2=Pmac_Mums_2.fq.fil.fq_2 out=Pmac_Mums_noadapt_1.fq out2=Pmac_Mums_noadapt_2.fq ref=/data/programs/bbmap_34.86/resources/truseq.fa.gz,/data/programs/bbmap_34.86/resources/nextera.fa.gz ktrim=r k=23 mink=11 hdist=1 overwrite=t


###quality and contaminant filter: trims based on PHRED scores trimq = 10
## example usage
/data/programs/bbmap_34.86/bbduk2.sh in=temp_1.fq in2=temp_2.fq out=file1.ftq.fq out2=file2.ftq.fq ref=/data/programs/bbmap_34.86/resources/phix174_ill.ref.fa.gz k=27 hdist=1 qtrim=rl trimq=10 minlen=40 qout=auto
#phix is dna added to the reaction to get a sense of the error distribution of the bases

/data/programs/bbmap_34.86/bbduk2.sh in=Pmac_Mums_noadapt_1.fq in2=Pmac_Mums_noadapt_2.fq out=Pmac_Mums_1.ftq10.fq out2=Pmac_Mums_2.ftq10.fq ref=/data/programs/bbmap_34.86/resources/phix174_ill.ref.fa.gz k=27 hdist=1 qtrim=rl trimq=10 minlen=40 qout=auto
