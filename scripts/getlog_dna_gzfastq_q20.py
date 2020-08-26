import sys,subprocess,re,os
from Bio import SeqIO

def execute(commands):
    pids = []
    for command in commands:
        r = subprocess.Popen(command, shell = True, stdout = log, stderr = log)
        r.communicate()
    log.write("\n\n")
    return None

def execute_parallel(commands):
    pids = []
    for k in commands:
        r = subprocess.Popen(k,shell =True)
	pids.append(r.pid)
    for i in pids:
        os.waitpid(i,0)
    del pids[:]


def make_commands(file1,file2):
    commands = []
    in1 = file1.rsplit(".",1)[0] + ".fil.fq_1"
    in2 = file2.rsplit(".",1)[0] + ".fil.fq_2"
    outp1 = file1.rsplit(".",1)[0] + ".ctq20.fq"
    outp2 = file2.rsplit(".",1)[0] + ".ctq20.fq"
    commands = ['printf "\nPhred-encoding\n==============\n"',"/data/programs/bbmap_34.86/testformat.sh " + file1,'printf "\nClone filter\n============\n"',"/data/programs/stacks-1.21/clone_filter -1 " + file1 + " -2 " + file2 + " -i gzfastq -o .",'printf "\nAdapter filter \n==============\n"',"/data/programs/bbmap_34.86/bbduk.sh in=" + in1 + " in2=" + in2 + " out=temp_1.fq out2=temp_2.fq ref=/data/programs/bbmap_34.86/resources/truseq.fa.gz,/data/programs/bbmap_34.86/resources/nextera.fa.gz ktrim=r k=23 mink=11 hdist=1 overwrite=t",'printf "\nLow quality filter \n==================\n"',"/data/programs/bbmap_34.86/bbduk2.sh in=temp_1.fq in2=temp_2.fq out=" + outp1 + " out2=" + outp2 + " ref=/data/programs/bbmap_34.86/resources/phix174_ill.ref.fa.gz k=27 hdist=1 qtrim=rl trimq=20 minlen=40 qout=33 overwrite=t"]
    execute(commands)
    return None

def viewaspairs(file1,file2):
    com = []
    with open(file1) as l:
	first_line = l.readline()
        if first_line.strip().endswith("/1"):
	    st1 = 'awk \'{if(NR%4==1){gsub(/\\/1$/,"",$0);print $0}else{print}}\' ' + file1 + '>' + file1+"ed"
	    st2 = 'awk \'{if(NR%4==1){gsub(/\\/2$/,"",$0);print $0}else{print}}\' ' + file2 + '>' + file2+"ed"
	    com.append(st1) 
	    com.append(st2)
            execute_parallel(com)
	    make_commands(file1+"ed",file2+"ed")
	else: 
	    make_commands(file1,file2)
    
log = open("templog.txt",'w',0)

#base_dir = os.getcwd()
with open(sys.argv[1]) as files:
    while True:
#        dir = "/cerberus/Reads/leps_concatenaed/"#files.readline().strip()
        f1 = files.readline().strip()
        f2 = files.readline().strip()
	if not f1:
	    break
#        os.chdir(dir)
	viewaspairs(f1,f2)
#        os.chdir(base_dir)
log.close()

c = 1
fin = open("log.txt",'a',0)
with open("templog.txt") as temp:
    for line in temp:
        if line.startswith("Processing short"):
	    c = 0
	elif c == 0 and line.strip().endswith("reads."):
	    fin.write(line)
	    c = 1
	elif c==1:
	    fin.write(line)
fin.close()

