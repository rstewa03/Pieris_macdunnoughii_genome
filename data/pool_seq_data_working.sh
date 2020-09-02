#
# pmac mums
/cerberus/Reads/leps/P4308/P4308_103/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/P4308_103_S2_L001_R1_001.fastq.gz Pmac_Mums_1.fq.gz
/cerberus/Reads/leps/P4308/P4308_103/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/P4308_103_S2_L001_R2_001.fastq.gz Pmac_Mums_2.fq.gz

#
/cerberus/Reads/leps/P4308/P4308_101/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/	P4308_101_S3_L002_R1_001.fastq.gz			Pieris_napi..15..SWCO2.Thorax.69_1.fq.gz	Pieris	napi		15		SWCO2	Thorax	69	1	fq.gz					Scilife	Robot	D448, freezer no.2, drawer 2.8	HISEQX	350	150	P4308	2016-March-04		NO	247583687			445
/cerberus/Reads/leps/P4308/P4308_101/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/	P4308_101_S3_L002_R2_001.fastq.gz			Pieris_napi..15..SWCO2.Thorax.69_2.fq.gz	Pieris	napi		15		SWCO2	Thorax	69	2	fq.gz					Scilife	Robot	D448, freezer no.2, drawer 2.8	HISEQX	350	150	P4308	2016-March-04		NO	247583687			446
/cerberus/Reads/leps/P4308/P4308_102/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/	P4308_102_S1_L001_R1_001.fastq.gz			Pieris_napi..15..COSW1.Thorax.73_1.fq.gz	Pieris	napi		15		COSW1	Thorax	73	1	fq.gz					Scilife	Robot	D448, freezer no.2, drawer 2.8	HISEQX	350	150	P4308	2016-March-04		NO	265869733			447
/cerberus/Reads/leps/P4308/P4308_102/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/	P4308_102_S1_L001_R2_001.fastq.gz			Pieris_napi..15..COSW1.Thorax.73_2.fq.gz	Pieris	napi		15		COSW1	Thorax	73	2	fq.gz					Scilife	Robot	D448, freezer no.2, drawer 2.8	HISEQX	350	150	P4308	2016-March-04		NO	265869733			448
/cerberus/Reads/leps/P4308/P4308_103/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/	P4308_103_S2_L001_R1_001.fastq.gz			Pieris_napi..15..Mother.Thorax.19_1.fq.gz	Pieris	napi		15		Mother	Thorax	19	1	fq.gz			0	19	Scilife	Robot	D448, freezer no.2, drawer 2.8	HISEQX	350	150	P4308	2016-March-04		NO	92571068			449
/cerberus/Reads/leps/P4308/P4308_103/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/	P4308_103_S2_L001_R2_001.fastq.gz			Pieris_napi..15..Mother.Thorax.19_2.fq.gz	Pieris	napi		15		Mother	Thorax	19	2	fq.gz			0	19	Scilife	Robot	D448, freezer no.2, drawer 2.8	HISEQX	350	150	P4308	2016-March-04		NO	92571068			450
/cerberus/Reads/leps/P4308/P4308_104/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/	P4308_104_S4_L002_R1_001.fastq.gz			Pieris_napi..15..Hybrid_father.Thorax.20_1.fq.gz	Pieris	napi		15		Hybrid_father	Thorax	20	1	fq.gz			20	0	Scilife	Robot	D448, freezer no.2, drawer 2.8	HISEQX	350	150	P4308	2016-March-04		NO	73310265			451
/cerberus/Reads/leps/P4308/P4308_104/02-FASTQ/160426_ST-E00201_0085_BHLTVFCCXX/	P4308_104_S4_L002_R2_001.fastq.gz			Pieris_napi..15..Hybrid_father.Thorax.20_2.fq.gz	Pieris	napi		15		Hybrid_father	Thorax	20	2	fq.gz			20	0	Scilife	Robot	D448, freezer no.2, drawer 2.8	HISEQX	350	150	P4308	2016-March-04		NO	73310265			452

ssh chrisbak@ren.lan.zoologi.su.se


# data
cd /share/chrisbak/
# get data
scp chrisbak@ren.lan.zoologi.su.se:/share/chrisbak/reads5/clean/Colias_crocea.ESP.15.Aiguamolls.Field_Alba_AW15142.Abdomen.1_*.ctq.fq.gz .
scp chrisbak@ren.lan.zoologi.su.se:/share/chrisbak/reads5/clean/Colias_crocea.ESP.15.Aiguamolls.Field_Orange_AW1574.Abdomen.1_*.ctq.fq.gz .


#
cd /share/chrisbak
# ls Colias_crocea*Alba* | wc -l # 24 reads, 12 samples.
# /share/chrisbak/reads5/clean $ ls Colias_crocea*Field*Alba* | wc -l
# 18
find . -name "*P4308*" # nothing
find . -name "*16_02*" # nothing
find . -name "*macdounghii*" # yes, but not what we are looking for
find . -name "*Mother*" # no Pieris
find . -name "*SWCO*" # nothing
find . -name "*Pieris*" # nothing similar
find . -name "*mother*" # nothing
find . -name "*mac*gz"

#
./reads4/clean/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_1.ctq.fq.gz
./reads4/clean/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_2.ctq.fq.gz
./mnt_old/reads4/clean/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_1.ctq.fq.gz
./mnt_old/reads4/clean/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_2.ctq.fq.gz
./mnt_old/reads3/compressed/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_2.fq.gz
./mnt_old/reads3/compressed/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_1.fq.gz
./reads3/compressed/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_2.fq.gz
./reads3/compressed/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_1.fq.gz


# get these for the individual data
./reads3/compressed/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_2.fq.gz
./reads3/compressed/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_1.fq.gz



cd /mnt/griffin/Reads
sudo mkdir Pieris_macdounghii_data
cd Pieris_macdounghii_data
scp -r chrisbak@ren.lan.zoologi.su.se:/share/chrisbak/reads3/compressed/Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1* .
mv
/mnt/griffin/Reads/Ccrocea_data
