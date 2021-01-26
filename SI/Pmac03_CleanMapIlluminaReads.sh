# Pieris macdunnoughii reads for polishing
cd $PM_DATA/raw

## For genome MS
# Individual illumina WGS (thorax)
ln -s $PM_READS/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_1.fq.gz Pmac000.1_1.fq.gz
ln -s $PM_READS/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_2.fq.gz Pmac000.1_2.fq.gz

# Pool-Seq CO females (103)
ln -s $PM_READS/P4308/P4308_103/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/P4308_103_S2_L001_R1_001.fastq.gz Pmac_Mums_1.fq.gz
ln -s $PM_READS/P4308/P4308_103/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/P4308_103_S2_L001_R2_001.fastq.gz Pmac_Mums_2.fq.gz


##################
#### Cleaning ####
##################
# Use in-house cleaning script
# supposed location: /data/programs/scripts/getlog_dna_gzfastq_q20.py

# in your data file folder with the gz compressed fastq files
ls *gz > fq.gz_raw

# NOTE that this should be a list of paired read 1 and read 2 fastq files
# these shoudl always be the same data, read1 then read2, in the list.
# so the list shoudl always be divisible by 2, etc.

# run the cleaning script on this subset of files where their paths are indicated
python /mnt/griffin/racste/getlog_dna_gzfastq_q20_v25_8_20.py fq.gz_raw

# The cleaning script produces a log file (log.txt) which needs to be parsed into a .csv
# line 1:  pulls all lines containing the target strings | cuts at ',' and retains parts 1 and 3 |
grep -E '.gz and|clone reads|Input:|Result:' log.txt | cut -f1,3 -d ',' | tr -d '\r\n'| tr -s " " |\
awk '{gsub("\t","",$0); print;}' | sed 's/Pmac/\nPmac/g' |\
sed -e 's/ and/,/g' -e 's/ pairs of reads input. /,/g' -e 's/ pairs of reads output. /,/g' -e 's/ pairs of reads /,/g' -e 's/ clone reads.Input: /,/g' -e 's/Input: /,/g' -e 's/ reads /,/g' -e 's/ bases.Result: /,/g' -e 's/ bases /,/g' -e 's/) /,/g' -e 's/ reads /,/g' -e 's/) bases //g' -e 's/(//g' -e 's/)//g' |\
sed '1 i file,clonefilter_in_pairs,clonefilter_out_pairs,clonefilter_percent_remaining,adapter_in_reads,adapter_in_bases,adapter_out_reads,adapter_out_reads_pct,adapter_out_bases,adapter_out_bases_pct,qualtrim_in_reads,qualtrim_in_bases,qualtrim_out_reads,qualtrim_out_reads_pct,qualtrim_out_bases,qualtrim_out_bases_pct' > filt_qtrim_log_rescue.csv


# check read quality
for i in `ls -1 *.fq.ctq20.fq | sed 's/.fq.ctq20.fq//'`;
do echo "perl $TOOLS/FastQC/fastqc -o $PM_DATA/clean -t 10 $i.fq.ctq20.fq" >> $PM_DATA/clean/fastqc_jobs.txt; done
head -1 $PM_DATA/clean/fastqc_jobs.txt
parallel -j10 < fastqc_jobs.txt

pigz *fq


############################################
#### create cleaned reads of equal size ####
############################################

zcat Pmac000.1_1.fq.ctq20.fq.gz | /mnt/griffin/racste/Software/seqkit sample -n 80000000 -o sample_Pmac000.1_1.fq.ctq20.fq.gz
zcat Pmac000.1_2.fq.ctq20.fq.gz | /mnt/griffin/racste/Software/seqkit sample -n 80000000 -o sample_Pmac000.1_2.fq.ctq20.fq.gz
zcat Pmac_Mums_1.fq.ctq20.fq.gz | /mnt/griffin/racste/Software/seqkit sample -n 80000000 -o sample_Pmac_Mums_1.fq.ctq20.fq.gz
zcat Pmac_Mums_2.fq.ctq20.fq.gz | /mnt/griffin/racste/Software/seqkit sample -n 80000000 -o sample_Pmac_Mums_2.fq.ctq20.fq.gz


###############################################
#### Map short reads to Haplomerged genome ####
###############################################
### NextGen mapping software: make single .bam file
## Example usage (where input reads files have been cleaned and quality assessed)
# ngm -r genome.fasta -1 reads1_clean.fq  -2 reads2_clean.fq  -t 30 -i 0.90 -b -o output.bam

# move to the trimmed data directory to
cd $PM_DATA/clean
mkdir genome_MS
mv Pmac000*fq genome_MS
cp Pmac_Mums_*fq genome_MS


cd $PM_ALIGN/NGM_genome/
/mnt/griffin/kaltun/software/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/PmacD_Rac4MedPurge.fasta -1 /mnt/griffin/racste/P_macdunnoughii/Pmac_data/clean/genome_MS/Pmac000.1_1.fq.ctq20.fq.gz -2 /mnt/griffin/racste/P_macdunnoughii/Pmac_data/clean/genome_MS/Pmac000.1_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o Pmac000.1_NGM_Rac4MedPurge.bam
/mnt/griffin/kaltun/software/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/PmacD_Rac4MedPurge.fasta -1 /mnt/griffin/racste/P_macdunnoughii/Pmac_data/clean/genome_MS/sample_Pmac000.1_1.fq.ctq20.fq.gz -2 /mnt/griffin/racste/P_macdunnoughii/Pmac_data/clean/genome_MS/sample_Pmac000.1_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o sample_Pmac000.1_NGM_Rac4MedPurge.bam
/mnt/griffin/kaltun/software/NextGenMap-0.5.5/bin/ngm-0.5.5/ngm -r /mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/PmacD_Rac4MedPurge.fasta -1 /mnt/griffin/racste/P_macdunnoughii/Pmac_data/clean/genome_MS/Pmac_Mums_1.fq.ctq20.fq.gz -2 /mnt/griffin/racste/P_macdunnoughii/Pmac_data/clean/genome_MS/Pmac_Mums_2.fq.ctq20.fq.gz -t 30 -i 0.9 -b -o Pmac_Mums_NGM_Rac4MedPurge.bam

cd $PM_ALIGN/NGM_genome
ls *.bam | parallel -j2 "samtools view -b {.}.bam > {.}.view.bam"
ls *.view.bam | parallel -j2 "samtools sort -o {.}.sort.bam -T {.}_temp {.}.bam"
ls *.sort.bam | parallel -j2 "samtools index {.}.bam"

rm *view.bam


#################################
#### Check mapping and coverage ####
#################################
samtools flagstat Pmac000.1_NGM_Rac4MedPurge.bam
samtools flagstat sample_Pmac000.1_NGM_Rac4MedPurge.bam
samtools flagstat Pmac_Mums_NGM_Rac4MedPurge.bam

/mnt/griffin/kaltun/software/goleft_linux64 covstats *.bam
