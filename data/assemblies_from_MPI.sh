
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
