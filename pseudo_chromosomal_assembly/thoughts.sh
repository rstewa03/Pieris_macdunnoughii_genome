# need to use the alignment between napi and mac to put mac in a psuedo_chromosomal assemlby structure

# valid bececause of the alignemnt support of the chromosomal structure between the two species


# using ragout

https://github.com/fenderglass/Ragout/blob/master/docs/USAGE.md


# align with cactus
# https://github.com/ComparativeGenomicsToolkit/cactus/tree/v1.2.1

export PATH=/mnt/griffin/chrwhe/software/cactus-bin-v1.0.0/bin:$PATH
cactus ./jobstore ./examples/evolverMammals.txt ./evolverMammals.hal --realTimeLogging

# cactus <jobStorePath> <seqFile> <outputHal>


# running cactus


# seqFile example has this format
NEWICK tree
name1 path1
name2 path2
...
nameN pathN

* can be placed at the beginning of a name to specify that its assembly is of reference quality
# Please ensure your genomes are soft-masked with RepeatMasker

# Sequence data for progressive alignment of 4 genomes
# human, chimp and gorilla are flagged as good assemblies.
# since orang isn't, it will not be used as an outgroup species.
(((human:0.006,chimp:0.006667):0.0022,gorilla:0.008825):0.0096,orang:0.01831);
*human /data/genomes/human/human.fa
*chimp /data/genomes/chimp/
*gorilla /data/genomes/gorilla/gorilla.fa
orang /cluster/home/data/orang/


# can also generate alignment using SibeliaZ, which is a new version that looks nice.
# the output, MAF, and be used by Ragout

# The alignment will be reported relative to the sequence ids, so all the input sequences should have a
# unique id in the fasta header. By default, the output will be written in the directory "sibeliaz_out"
# in the current working directory. It will contain a GFF file "blocks_coords.gff" containing coordinates
# of the found blocks, and file "alignment.maf" with the actual alignment

/mnt/griffin/chrwhe/software/SibeliaZ/SibeliaZ-LCB/bin/sibeliaz
