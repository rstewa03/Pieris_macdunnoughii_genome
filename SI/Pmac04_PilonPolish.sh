#############################################################
#### Polish haplomerged genome with illumina short reads ####
#############################################################

### Prepare Pilon polishing script
nano Pilon_polish_HAC_qm_RMP_hapmerg_hapA.sh
# paste:
#!/bin/bash
#to run run command followed by bamfile you want to polish with, i.e ./01_polish_aln.sh bamfile.bam
reference=/mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/PmacD_qmRac4MedPur.cleaned.masked.haploidA.fasta
java -ea -Xmx200g -jar /mnt/griffin/racste/Software/pilon-1.23.jar  --genome $reference --frags $1 --threads 30 --outdir ${1%.bam}.PILON --tracks --vcf --changes --diploid --output ${1%.bam}.pilon.polish

#### Polish
# move into alignment directory with indexed bamfiles
ls *sort.bam | parallel -j4 --dry-run "bash /mnt/griffin/racste/Scripts/Pilon_polish_HAC_qm_RMP_hapmerg_hapA.sh {.}.bam"

#### check stats
/mnt/griffin/racste/Software/seqkit stats *fasta -a
# file                                                                                    format  type  num_seqs      sum_len  min_len      avg_len     max_len       Q1         Q2         Q3  sum_gap        N50  Q20(%)  Q30(%)
# Pmac000.1_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.pilon.polish.fasta         FASTA   DNA        106  316,067,271      644  2,981,766.7  14,783,675  551,127  2,080,525  4,575,637        0  5,174,956       0       0
# Pmac_Mums_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.pilon.polish.fasta         FASTA   DNA        106  316,549,294      644  2,986,314.1  14,824,368  554,582  2,074,755  4,567,088        0  5,202,377       0       0
# sample_Pmac000.1_NGM_qmRac4MedPur.cleaned.masked.haploidA.view.sort.pilon.polish.fasta  FASTA   DNA        106  315,993,601      644  2,981,071.7  14,778,052  550,545  2,079,798  4,579,095        0  5,170,597       0       0

# run BUSCO analysis
export BUSCO_CONFIG_FILE=/data/programs/busco-4.1.2/config/config.ini
# Run multiple
library=lepidoptera_odb10
for i in `ls -1 *fasta | sed 's/.fasta//'`
do
genome=$i.fasta;
outfile=${i}_v_lepidoptera_odb10;
python3 /data/programs/busco-4.1.2/bin/busco -i $genome -l $library -m genome -o $outfile -c 30;
done

mkdir BUSCO_summaries
cd BUSCO_summaries
# move short summaries into BUSCO_summaries
python3 /data/programs/busco-4.1.2/scripts/generate_plot.py -wd .
