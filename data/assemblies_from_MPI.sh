# some notes

I am very aware of the differences in basecalling for ONT data - for which the accuracy has improved over time quite significantly. What we have been using in general for the fast basecalling is the respective version of the GUPPY basecaller software implemented in the most recent version of the MinKNOW software. If you try to use the high accuracy basecalling during a sequencing run, you will end up waiting forever (weeks) for the basecalling of the data, essentially blocking the computer for the time it takes for the basecalling to finish. The reason for this is that you have to use the CPUs for basecalling - and this option is really, really slow.

We had also started to look into the stand-alone version of GUPPY, which is command line, and for which you can also do both, fast basecalling and high-accuracy basecalling (HAC). To make HAC feasible, we had our IT guys set up a specialized workstation, with a top-end (and expensive) graphics card (Nvidia RTX-2080-TI). Several different Nvidia graphics cards work well for HAC, but you have to have the right CUDA version installed, as well as the maching Linux graphics card version of the GUPPY basecaller. With this setup, we have started to HAC re-call all of the older basecalled ONT data from fast5 files. What used to take appr. 4 weeks to call 20 Gb of data can now be done over night. And yes, HAC data makes quite a difference, even when simply looking at BUSCO data. However, you should be aware of the fact that even HAC basecalling does not take care of the homopolymer and some of the Indel problems assocaited with ONT data. What seems to be the optimal appraoch is to generate ONT data (upwards of 20fold coverage), perform HAC basecalling, assemble the genome using Flye (at least in the majority of cases), perform several rounds of polishing using Racon and Medaka, purge Haplotigs, and then perform a final round of polishing using 10-20x coverage Illumina data. Using this approach, also the ONT Indel-caused internal stop codons are corrected, resulting in complete gene prediction.

In case you do have a workstation with a high-end graphics card (or you would like to use another basecaller), I can certainly send you the fast5 files and the correct GUPPY software version - or we could do the HAC for all of the Pieridae here and send you the new fastq files.


# Cryptshare link. However, the upload of the larger (fastq) files will still take a few hours - but after this you should received a new Cryptshare download email.
# Here is the Password for the file download: R---Xy/F
# The uploaded files include both the P. macdunnoughii genome assembly files as well as the Agrotis fastq files.
scp MPI_cs-transfer.zip chrwhe@miles.zoologi.su.se:/mnt/griffin/chrwhe
#

cd /mnt/griffin/chrwhe/Pieris_macdunnoughii
unzip MPI_cs-transfer.zip
# Archive:  MPI_cs-transfer.zip
#   inflating: PmacD_Rac4MedPurge.fasta
#   inflating: AgroFat-Gen3.fastq.gz
#   inflating: PmacD_assem_stats.xlsx
#   inflating: AgrotisF-Gen2.fastq.gz
#   inflating: PmacD_assembly_info.txt
#   inflating: PmacD_assembly.fasta



/data/programs/scripts/AsmQC PmacD_assembly.fasta

-------------------------------
    AssemblyQC Result
-------------------------------
Contigs Generated :        5,282
Maximum Contig Length : 6,791,119
Minimum Contig Length :      339
Average Contig Length : 75,296.3 ± 169,153.8
Median Contig Length :   4,618.0
Total Contigs Length :  397,714,914
Total Number of Non-ATGC Characters :      2,800
Percentage of Non-ATGC Characters :        0.001
Contigs >= 100 bp :        5,282
Contigs >= 200 bp :        5,282
Contigs >= 500 bp :        5,280
Contigs >= 1 Kbp :         5,157
Contigs >= 10 Kbp :        3,391
Contigs >= 1 Mbp :            10
N50 value :      181,826
Generated using /mnt/griffin/racste/PmacD_assembly.fasta

312M  PmacD_Rac4MedPurge.fasta

pigz PmacD_Rac4MedPurge.fasta

89M PmacD_Rac4MedPurge.fasta.gz

scp chrwhe@miles.zoologi.su.se:/mnt/griffin/chrwhe/Pieris_macdunnoughiiPmacD_Rac4MedPurge.fasta.gz .



##########
# 1 Sept
# latest package from Heiko
# several assemblies, namely Flye, NECAT and QuickMerge and also a table with the stats.
# For the first two assemblies we have also included the unpurged contigs.
# In case you have any questions, simply send em an email.

cd /mnt/griffin/chrwhe/MPI_deliveries
unzip cs-transfer_31Au2020.zip
# Archive:  cs-transfer_31Au2020.zip
#   inflating: PmacD_qmRac4MedPur.fasta
#   inflating: PmacD_flyeRac4Med.fasta
#   inflating: PmacD_necatRac4Med.fasta
#   inflating: PmacD_necatRac4MedPur.fasta
#   inflating: PmacD_flyeRac4MedPur.fasta
#   inflating: PmacD_HACassembly_Stats.xlsx
#   inflating: Assembly protocol in MPICE.docx

scp chrwhe@miles.zoologi.su.se:/mnt/griffin/chrwhe/MPI_deliveries/Assembly* .
