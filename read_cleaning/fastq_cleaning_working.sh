
# test command calls with --dryrun
# limit the number of jobs run at a time to 15
parallel --dryrun -j 15 "pigz {}" ::: *.fastq

# now we are compressing all the raw fastq files
parallel -j 15 "pigz {}" ::: *.fastq


#########
# cleaning the well organized files
#########
# the script we will be using
scripts/getlog_dna_gzfastq_q20.py

# in your data file folder with the gz compressed fastq files
ls *gz > fastq.gz_raw

# run the cleaning script on this subset of files where their paths are indicated
python /data/programs/scripts/getlog_dna_gzfastq_q20.py fastq.gz_raw

# now look at the log.txt file ...
# I have parsed the file a bit, but the order of things shows you what was done upon the
# files that were read, and this is repeated for each set of files in the list you give the script.

Clone filter
============
Reading data from:
  SRR6837585_1.fastq.gz and
  SRR6837585_2.fastq.gz
Writing data to:
  ./SRR6837585_1.fastq.fil.fq_1 and
  ./SRR6837585_2.fastq.fil.fq_2
9330623 pairs of reads input. 9246049 pairs of reads output, discarded 84574 pairs of reads, 0.91% clone reads.

Adapter filter
==============
…
Input:                          18492098 reads          1849209800 bases.
KTrimmed:                       635303 reads (3.44%)    18032195 bases (0.98%)
Result:                         18491014 reads (99.99%)         1831177605 bases (99.02%)
…
Low quality filter
==================
…
Input:                          25422394 reads          2518565839 bases.
Contaminants:                   12996 reads (0.05%)     1298699 bases (0.05%)
QTrimmed:                       3517347 reads (13.84%)  131323609 bases (5.21%)
Result:                         24388376 reads (95.93%)         2385943531 bases (94.73%)

# how to get these things easily from the log file
grep -E '.gz and|clone reads|Input:|Results' log_old2.txt

SRR6837585_1.fastq.gz and
9330623 pairs of reads input. 9246049 pairs of reads output, discarded 84574 pairs of reads, 0.91% clone reads.
Input:                          18492098 reads          1849209800 bases.
Input:                          18491014 reads          1831177605 bases.
SRR6837586_1.fastq.gz and
12833062 pairs of reads input. 12712012 pairs of reads output, discarded 121050 pairs of reads, 0.94% clone reads.
Input:                          25424024 reads          2542402400 bases.
Input:                          25422394 reads          2518565839 bases.

#
grep -E '.gz and|clone reads|Input:|Results' log_old2.txt | cut -f1,3 -d ','

SRR6837585_1.fastq.gz and
9330623 pairs of reads input. 9246049 pairs of reads output, 0.91% clone reads.
Input:                          18492098 reads          1849209800 bases.
Input:                          18491014 reads          1831177605 bases.
SRR6837586_1.fastq.gz and
12833062 pairs of reads input. 12712012 pairs of reads output, 0.94% clone reads.
Input:                          25424024 reads          2542402400 bases.
Input:                          25422394 reads          2518565839 bases.

grep -E '.gz and|clone reads|Input:|Results' log_old2.txt | cut -f1,3 -d ',' | tr -d '\r\n' | sed 's/SRR/\nSRR/g'
SRR6837585_1.fastq.gz and9330623 pairs of reads input. 9246049 pairs of reads output, 0.91% clone reads.Input:                          18492098 reads          1849209800 bases.Input:                         18491014 reads          1831177605 bases.
SRR6837586_1.fastq.gz and12833062 pairs of reads input. 12712012 pairs of reads output, 0.94% clone reads.Input:                        25424024 reads          2542402400 bases.Input:                         25422394 reads          2518565839 bases.root@duke:/cerberus/projects/handor/Prap_WGS_2020/sra_data/fastq_raw#

grep -E '.gz and|clone reads|Input:|Results' log_old2.txt | cut -f1,3 -d ',' | tr -d '\r\n'| tr -s " " |\
awk '{gsub("\t","",$0); print;}' | sed 's/SRR/\nSRR/g' |\
sed -e 's/ and/,/g' -e 's/ pairs of reads input. /,/g' -e 's/ pairs of reads output, /,/g' -e 's/% clone reads.Input: /,/g'

SRR6837585_1.fastq.gz,9330623,9246049,0.91% clone reads.Input: 18492098 reads 1849209800 bases.Input: 18491014 reads 1831177605 bases.
SRR6837586_1.fastq.gz,12833062,12712012,0.94% clone reads.Input: 25424024 reads 2542402400 bases.Input: 25422394 reads 2518565839 bases.

grep -E '.gz and|clone reads|Input:|Results' log_old2.txt | cut -f1,3 -d ',' | tr -d '\r\n'| tr -s " " |\
awk '{gsub("\t","",$0); print;}' | sed 's/SRR/\nSRR/g' |\
sed -e 's/ and/,/g' -e 's/ pairs of reads input. /,/g' -e 's/ pairs of reads output, /,/g' -e 's/% clone reads.Input: /,/g' |\
sed '1 i file,reads_input,clone_filter_output'


#

grep -E '.gz and|clone reads|Input:|Result:' log.txt | cut -f1,3 -d ',' | tr -d '\r\n'| tr -s " " |\
awk '{gsub("\t","",$0); print;}' | sed 's/SRR/\nSRR/g' |\
sed -e 's/ and/,/g' -e 's/ pairs of reads input. /,/g' -e 's/ pairs of reads output, /,/g' -e 's/% clone reads.Input: /,/g' |\
sed '1 i file,reads_input,clone_filter_output' | head -4












#####
