#########
# here are details on working with genomic data for
# PCR duplicate removal, followed by read trimming and cleaning



# the script we will be using
/cerberus/projects/chrwhe/software/getlog_dna_gzfastq_q20.py

# first, we are checking the paths in this python script (using nano)
# these look OK. It uses these, which are installed in these locations on DUKE (script is from MILES)
# /data/programs/bbmap_34.86/
# /data/programs/stacks-1.21/clone_filter

# collect fastq files to single folder

find ../S* -name "*gz" | head -4 > test_set
while read p; do mv $p . ; done < test_set


ls *gz > files_no_path #
reads_1
reads_2

python getlog_rna.q20.py files_no_path



cleaning script “getlog.py” at /cerberus/Reads/leps/P4856.
In the same directory I also have a file called “list” which is the input for getlog.py.
This file has three lines for every read pair where the
first line is the path to the folder
next two lines are the names of the read files.

/cerberus/Reads/leps/P4856/getlog.py
/cerberus/Reads/leps/P4856/list


head list
P4856_101/02-FASTQ/160610_ST-E00266_0101_AHNG73CCXX
P4856_101_S5_L002_R1_001.fastq
P4856_101_S5_L002_R2_001.fastq
P4856_102/02-FASTQ/160610_ST-E00266_0101_AHNG73CCXX
P4856_102_S6_L002_R1_001.fastq
P4856_102_S6_L002_R2_001.fastq
P4856_104/02-FASTQ/160610_ST-E00266_0101_AHNG73CCXX
P4856_104_S7_L002_R1_001.fastq
P4856_104_S7_L002_R2_001.fastq
P4856_105/02-FASTQ/160610_ST-E00266_0101_AHNG73CCXX
P4856_105_S8_L002_R1_001.fastq
P4856_105_S8_L002_R2_001.fastq


 scp getlog.py chrwhe@miles.zoologi.su.se:/mnt/griffin/chrwhe


/mnt/griffin/chrwhe/katie_duryea_reads/Raw_Data/Color_Dev_Project/188A
test1.fq
test2.fq


/mnt/griffin/chrwhe/katie_duryea_reads/Raw_Data/Color_Dev_Project/188A
both_188A_1.fq


find $Color_Dev_Project -type f -name "*.fq"


To run it you simply need to do,
Python getlog.py list

Once finished you will find a file called log.txt in the working directory and in that file you can find the run statistics from bbduk and stacks. This script is also optimized for running in DUKE so let me know if you’re planning on integrating this script into another pipeline and I can make the necessary changes.


This script only takes one pair at a time so I recommend running two or three instances of this script in parallel. If you would like to talk about this, I can come by your office tomorrow at 12.



# make list for batch cleaning.
/mnt/griffin/chrwhe/Iele_TA_data/sra
SRR1265958_1.fastq
SRR1265958_2.fastq
/mnt/griffin/chrwhe/Iele_TA_data/sra
SRR2962606_1.fastq
SRR2962606_2.fastq
/mnt/griffin/chrwhe/Iele_TA_data/sra
SRR2962607_1.fastq
SRR2962607_2.fastq
/mnt/griffin/chrwhe/Iele_TA_data/sra
SRR2962608_1.fastq
SRR2962608_2.fastq
/mnt/griffin/chrwhe/Iele_TA_data/sra
SRR2962609_1.fastq
SRR2962609_2.fastq
/mnt/griffin/chrwhe/Iele_TA_data/sra
SRR2990848_1.fastq
SRR2990848_2.fastq
/mnt/griffin/chrwhe/Iele_TA_data/sra
SRR2990849_1.fastq
SRR2990849_2.fastq
/mnt/griffin/chrwhe/Iele_TA_data/sra
SRR2990850_1.fastq
SRR2990850_2.fastq
/mnt/griffin/chrwhe/Iele_TA_data/sra
SRR2990851_1.fastq
SRR2990851_2.fastq

python /data/projects/chrwhe/getlog.py list

/mnt/griffin/chrwhe/Iele_TA_data/sra/set2
SRR2990850_1.fastq
SRR2990850_2.fastq
/mnt/griffin/chrwhe/Iele_TA_data/sra/set2
SRR2990851_1.fastq
SRR2990851_2.fastq
