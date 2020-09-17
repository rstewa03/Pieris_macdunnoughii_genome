


# generate an alignment
# make sure these are soft masked before running

# usage sibeliaz genome1.fa genome2.fa
ref_genome=
draft_genome=
# this is set to 20 cores, and 500 gb of RAM
/data/programs/SibeliaZ/SibeliaZ-LCB/bin/sibeliaz $ref_genome $draft_genome -t 20 -f 500 -o $ref_genome.$draft_genome.out


# now run ragout

# first make a configuration file, along these lines
.references = miranda,simulans,melanogaster
.target = yakuba

.maf = alignment.maf
miranda.fasta = references/miranda.fasta
simulans.fasta = references/simulans.fasta
melanogaster.fasta = references/melanogaster.fasta
yakuba.fasta = yakuba.fasta

# then run, with the config file being the *.rcp file. 
/data/programs/Ragout_v2.3/bin/ragout examples/E.Coli/ecoli.rcp --outdir examples/E.Coli/out/ --refine
