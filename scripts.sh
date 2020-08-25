#mapping
read1=BP_1final.wheat.fq
read2=BP_2final.wheat.fq
reference=scaffolds.mfa
outfile=BP_1final.bam
/data/programs/NextGenMap-0.4.10/bin/ngm-0.4.10/ngm -r "$reference" -1 "$read1" -2 "$read2" -t 50 -p -b -i 0.90 -o "$outfile"
