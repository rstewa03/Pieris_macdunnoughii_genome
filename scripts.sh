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
