# using RED

mkdir masking
cd masking/

# get your genome
ln -s ../../Pieris_rapae_fullAsm.fasta .

# define a path for the Red software
export PATH=/data/programs/RED/redUnix64/:$PATH
# run the script with your genome and output header named (this output header will be used for names of the new files generated).
python /data/programs/scripts/redmask.py -i Pieris_rapae_fullAsm.fasta -o Pieris_rapae_fullAsm > results.log

# see what you got
more results.log
[Sep 02 04:48 PM] Running Python v2.7.16
[Sep 02 04:48 PM] Loading assembly:
    Contigs: 2,772
    Length:  323,179,347 bp
    nN50:    11,535,178 bp
[Sep 02 04:48 PM] Splitting genome assembly into training set (contigs > 1000 bp)
[Sep 02 04:48 PM] Finding repeats with Red (REpeat Detector)
[Sep 02 04:58 PM] Collecting results from Red
[Sep 02 04:58 PM] Summarizing results and converting to BED format

Masked genome: /mnt/griffin/chrwhe/Pieris_rapae_v1/genome_fullASM/masking/Pieris_rapae_fullAsm.softmasked.fa
Repeat BED file: /mnt/griffin/chrwhe/Pieris_rapae_v1/genome_fullASM/masking/Pieris_rapae_fullAsm.repeats.bed
Repeat FASTA file: /mnt/griffin/chrwhe/Pieris_rapae_v1/genome_fullASM/masking/Pieris_rapae_fullAsm.repeats.fasta
num scaffolds: 2,772
assembly size: 323,179,347 bp
masked repeats: 118,710,751 bp (36.73%)



#############
# install issues

# install needed package
pip install natsort
# export path to RED
export PATH=/data/programs/RED/redUnix64/:$PATH
# run the script.
python /data/programs/scripts/redmask.py -i Pieris_rapae_fullAsm.fasta -o output > results.log
