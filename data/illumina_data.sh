
# location of reads on MILES
/mnt/griffin/Reads/Pieris_macdounghii_data

# single individual Illumina sequence data
Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_1.fq.gz
Pieris_macdounghii.USA.14.Colorado.Pmac000.Thorax.1_2.fq.gz


# poolseq data
# from local

scp -r P4308 chrwhe@miles.zoologi.su.se:/mnt/griffin/Reads/Pieris_macdounghii_data

/mnt/griffin/Reads/Pieris_macdounghii_data

# also need
# The F2 rescue (can’t eat Thlaspi) have a different project number, P5504, 16_11
scp -r P5504 chrwhe@miles.zoologi.su.se:/mnt/griffin/Reads/Pieris_macdounghii_data
# Pools WTS1S2_piol_thal

NGI ID	User ID	Mreads	>=Q30	Status
P5504_101	Wt_20L_18C_pupae	231.58	91.11	PASSED
P5504_102	Wt_24L_23C_pupae	200.36	90.3	PASSED
P5504_103	S1_24L_18C_pupae	220.45	90.75	PASSED
P5504_104	S1_20L_23C_pupae	228.48	90.72	PASSED
P5504_105	S2_24L_18C_pupae	152.35	90.11	PASSED
P5504_106	S1_24L_18C_adults	174.57	90.49	PASSED
P5504_107	S2_24L_18C_adults	116.02	90.09	PASSED
P5504_108	S2_24L_23C_adults	157.85	91.58	PASSED
P5504_109	Thal	107.80	91.25	PASSED
P5504_110	Piol	191.47	92.11	PASSED


# metadata			PoolSize
/cerberus/Reads/leps/P5504/P5504_101/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX	P5504_101_S1_L001_R1_001.fastq.gz	P5504_101		Pieris_napi....Wt_20L_18C.pupae.40_1.fq.gz	Pieris	napi				Wt_20L_18C	pupae	40	1	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						473
/cerberus/Reads/leps/P5504/P5504_101/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX	P5504_101_S1_L001_R2_001.fastq.gz	P5504_101		Pieris_napi....Wt_20L_18C.pupae.40_2.fq.gz	Pieris	napi				Wt_20L_18C	pupae	40	2	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						474
/cerberus/Reads/leps/P5504/P5504_102/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_102_S2_L001_R1_001.fastq.gz	P5504_102		Pieris_napi....Wt_24L_23C.pupae.28_1.fq.gz	Pieris	napi				Wt_24L_23C	pupae	28	1	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						475
/cerberus/Reads/leps/P5504/P5504_102/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_102_S2_L001_R2_001.fastq.gz	P5504_102		Pieris_napi....Wt_24L_23C.pupae.28_2.fq.gz	Pieris	napi				Wt_24L_23C	pupae	28	2	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						476
/cerberus/Reads/leps/P5504/P5504_103/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_103_S3_L002_R1_001.fastq.gz	P5504_103		Pieris_napi....S1_24L_18C.pupae.24_1.fq.gz	Pieris	napi				S1_24L_18C	pupae	24	1	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						477
/cerberus/Reads/leps/P5504/P5504_103/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_103_S3_L002_R2_001.fastq.gz	P5504_103		Pieris_napi....S1_24L_18C.pupae.24_2.fq.gz	Pieris	napi				S1_24L_18C	pupae	24	2	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						478
/cerberus/Reads/leps/P5504/P5504_104/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_104_S4_L002_R1_001.fastq.gz	P5504_104		Pieris_napi....S1_20L_23C.pupae.19_1.fq.gz	Pieris	napi				S1_20L_23C	pupae	19	1	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						479
/cerberus/Reads/leps/P5504/P5504_104/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_104_S4_L002_R2_001.fastq.gz	P5504_104		Pieris_napi....S1_20L_23C.pupae.19_2.fq.gz	Pieris	napi				S1_20L_23C	pupae	19	2	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						480
/cerberus/Reads/leps/P5504/P5504_105/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_105_S5_L003_R1_001.fastq.gz	P5504_105		Pieris_napi....S2_24L_18C.pupae.24_1.fq.gz	Pieris	napi				S2_24L_18C	pupae	24	1	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						481
/cerberus/Reads/leps/P5504/P5504_105/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_105_S5_L003_R2_001.fastq.gz	P5504_105		Pieris_napi....S2_24L_18C.pupae.24_2.fq.gz	Pieris	napi				S2_24L_18C	pupae	24	2	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						482
/cerberus/Reads/leps/P5504/P5504_106/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_106_S6_L003_R1_001.fastq.gz	P5504_106		Pieris_napi....S1_24L_18C.thorax.19_1.fq.gz	Pieris	napi				S1_24L_18C	thorax	19	1	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						483
/cerberus/Reads/leps/P5504/P5504_106/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_106_S6_L003_R2_001.fastq.gz	P5504_106		Pieris_napi....S1_24L_18C.thorax.19_2.fq.gz	Pieris	napi				S1_24L_18C	thorax	19	2	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						484
/cerberus/Reads/leps/P5504/P5504_107/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_107_S7_L003_R1_001.fastq.gz	P5504_107		Pieris_napi....S2_24L_18C.thorax.18_1.fq.gz	Pieris	napi				S2_24L_18C	thorax	18	1	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						485
/cerberus/Reads/leps/P5504/P5504_107/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_107_S7_L003_R2_001.fastq.gz	P5504_107		Pieris_napi....S2_24L_18C.thorax.18_2.fq.gz	Pieris	napi				S2_24L_18C	thorax	18	2	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						486
/cerberus/Reads/leps/P5504/P5504_108/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_108_S8_L004_R1_001.fastq.gz	P5504_108		Pieris_napi....S2_24L_23C.thorax.26_1.fq.gz	Pieris	napi				S2_24L_23C	thorax	26	1	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						487
/cerberus/Reads/leps/P5504/P5504_108/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_108_S8_L004_R2_001.fastq.gz	P5504_108		Pieris_napi....S2_24L_23C.thorax.26_2.fq.gz	Pieris	napi				S2_24L_23C	thorax	26	2	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						488
/cerberus/Reads/leps/P5504/P5504_109/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_109_S9_L004_R1_001.fastq.gz	P5504_109	YES	Pieris_napi.SWE.15.F2noEat.Thal_pool.thorax.25_1.fq.gz	Pieris	napi	SWE	15	F2noEat	Thal_pool	thorax	25	1	fq.gz	/mnt/reads4/clean/Pieris_napi.SWE.15.F2noEat.Thal_pool.thorax.25_1.ctq.fq				SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						489
/cerberus/Reads/leps/P5504/P5504_109/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_109_S9_L004_R2_001.fastq.gz	P5504_109	YES	Pieris_napi.SWE.15.F2noEat.Thal_pool.thorax.25_2.fq.gz	Pieris	napi	SWE	15	F2noEat	Thal_pool	thorax	25	2	fq.gz	/mnt/reads4/clean/Pieris_napi.SWE.15.F2noEat.Thal_pool.thorax.25_2.ctq.fq				SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						490
/cerberus/Reads/leps/P5504/P5504_110/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_110_S10_L004_R1_001.fastq.gz	P5504_110		Pieris_napi.USA.21.Pierisnapioleracea.Piolpool.thorax.23_1.fq.gz	Pieris	napi	USA	21	Pierisnapioleracea	Piolpool	thorax	23	1	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						491
/cerberus/Reads/leps/P5504/P5504_110/02-FASTQ/160812_ST-E00198_0150_BHVTVLCCXX/	P5504_110_S10_L004_R2_001.fastq.gz	P5504_110		Pieris_napi.USA.21.Pierisnapioleracea.Piolpool.thorax.23_2.fq.gz	Pieris	napi	USA	21	Pierisnapioleracea	Piolpool	thorax	23	2	fq.gz					SciLife	robot	D448, freezer no. 2, drawers 2.3 & 2.4	HISEQX	670	150	P5504	2016-06-27						492
