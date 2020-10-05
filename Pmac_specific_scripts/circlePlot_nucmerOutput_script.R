#### Description #### 
##
## The script takes 4 arguments: an alignment file, a list of reference contigs, a list of query contigs, an identity threshold, a minimum alignment length, and a prefix for output files
## e.g. myalignment.filt.coords 90 5000 myprefix
## columns in the alignment file should be organized as: 
## 'RS','RE','QS','QE','L1','L2','Percent','lenR','lenQ','Ref','Qry'
## and should be comma separated values (csv)
##
## Lists of contigs should have one contig per line
##
## identity should be between 0 and 100
## alignment lengths of 2000 or less will not be very meaningful
##
## The script will produce four pages of plots: 
# [1] reference vs. query with minimum reference scaffold length of 1M
# [2] reference vs. query for up to 30 of the largest reference scaffolds, 
# [3] reference vs. query for up to 30 of the largest query scaffolds, 
# [4] reference vs. query with minimum scaffold length of 2M for both the reference and query


## install required packages ##
list.of.packages <- c("tidyverse", 
                      "circlize",
                      "RColorBrewer")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# Load required packages ##
library(tidyverse)
library(circlize)
library(RColorBrewer)

## test if there is at least one argument: if not, return an error
args = commandArgs(trailingOnly=TRUE)

if (length(args)< 5) {
  stop("At least five arguments must be supplied: alignment file, contigs lists, identity threshold and minimum alignment length. Prefix optional", call.=FALSE)
} else if (length(args)<6) {
  # default output file
  args[6] = str_sub(args[1], start = 1, end = -13)
}

# Define functions
`%notin%` <- Negate(`%in%`)

#### Load alignment and palettes ####
nucmer_coord_colnames2 <- c('RS','RE','QS','QE','L1','L2','Percent','lenR','lenQ','Ref','Qry')
Alignment <- read_csv(args[1], col_names = nucmer_coord_colnames2 )
Prefix <- args[6]

Ref_pal <- read_table(args[2], col_names = "Chr") %>% 
  filter(Chr != "Mitochondria") %>%
  mutate(color = rep(brewer.pal(n=11, "Spectral"), length.out = length(Chr)))

Qry_pal <- read_table(args[3], col_names = "Chr") %>% 
  mutate(color = "#FFFFFF")

Pal1 <- union(Ref_pal, Qry_pal)

#### Set Filters ####

args[4] <- as.numeric(args[4])
t_per <- if_else(is.na(args[4]), 90, as.numeric(args[4]))
t_per <- if_else(t_per<100 & t_per>0, t_per, 90)


args[5] <- as.numeric(args[5])
t_len <- if_else(is.na(args[5]), 5000, as.numeric(args[5]))


print("Using the following arguments:")
print("Alignment:")
print(args[1])
head(Alignment)

print("Contigs:") 
print(args[2])
head(Ref_pal)

print(args[3])
head(Qry_pal)

print("Alignment idenity:")
print(t_per)

print("Minimum alignment length:")
print(t_len)

print("Output prefix")
print(Prefix)

#### filter alignment ####
###remove scaffolds with only one hit
Alignment2 <- Alignment %>% 
  group_by(Ref) %>% 
  mutate(n_segments = n()) %>% 
  filter(n_segments != 1) %>% 
  select(-n_segments) %>% ungroup()


# remove short Pnapi scaffolds, short alignments, low identity alignments

Alignment3 <- Alignment2 %>% filter(lenR >= 1000000 & L1 >= t_len & Percent >= t_per)


#### Create vectors for circlize plot ####

# Define the order of the reference and query chromosomes
Ref_order <- unique(Alignment3$Ref)
Qry_order <- rev(unique(Alignment3[Alignment3$Ref %in% Ref_order,]$Qry))
# unique(Qry_pal$Chr)


Alignment_order <- c(Ref_order, Qry_order) 
Alignment_order <- factor(Alignment_order, levels = Alignment_order)

# Define the lengths of each chromosome
Ref3 <- Alignment3 %>% select(Ref, lenR) %>% unique() %>% mutate(Ref = factor(Ref, levels = Ref_order)) %>% arrange(Ref)
Qry3 <- Alignment3 %>% select(Qry, lenQ) %>% unique() %>% mutate(Qry = factor(Qry, levels = Qry_order)) %>% arrange(Qry)
Alignment_tracks <- cbind(rep(0, length(Alignment_order)),c(Ref3$lenR,Qry3$lenQ))


#### Create the circlize plot ####
pdf(paste0(Prefix,"_circosPlot_",t_per,"id_", t_len, "L1_1MlenR.pdf"), width = 10, height=7)
par(mar = c(1, 1, 1, 1))
circos.par(cell.padding = c(0, 0, 0, 0))
circos.initialize(factors = Alignment_order, xlim = Alignment_tracks)
circos.trackPlotRegion(ylim = c(0, 1), panel.fun = function(x, y) {
  chr = get.cell.meta.data("sector.index")
  xlim = get.cell.meta.data("xlim")
  ylim = get.cell.meta.data("ylim")
  circos.rect(xlim[1], 0, xlim[2], 0.5, col = Pal1$color[Pal1$Chr == chr])
  circos.text(mean(xlim), 1, chr, cex = 0.5, facing = "clockwise",
              niceFacing = TRUE)
}, bg.border = NA)

for ( i in c(1:dim(Alignment3)[1])){
  reference <- Alignment3$Ref[i]
  query <- Alignment3$Qry[i]
  RS <- Alignment3$RS[i]
  RE <- Alignment3$RE[i]
  QS <-  Alignment3$QS[i]
  QE <- Alignment3$QE[i]  
  # QS <- Alignment3$lenQ[i] - Alignment3$QS[i]
  # QE <- Alignment3$lenQ[i] - Alignment3$QE[i]
  # 
  circos.link(reference, c(RS,RE),
             query, c(QS, QE),
             col = Pal1$color[Pal1$Chr == reference])}

circos.clear()
dev.off()



#### Csome Subsets ####

Alignment4 <-list()
Alignment4$onetofive <- Alignment3[Alignment3$Ref %in% Ref_pal$Chr[1:5],]
Alignment4$sixtoten <- Alignment3[Alignment3$Ref %in% Ref_pal$Chr[6:10],]
Alignment4$eleventofifteen <- Alignment3[Alignment3$Ref %in% Ref_pal$Chr[11:15],]
Alignment4$sixteentotwenty <- Alignment3[Alignment3$Ref %in% Ref_pal$Chr[16:20],]
Alignment4$twentyonetotwentyfive <- Alignment3[Alignment3$Ref %in% Ref_pal$Chr[21:25],] #modify as necessary
Alignment4$twentyfivetothirty <- Alignment3[Alignment3$Ref %in% Ref_pal$Chr[25:length(Ref_pal$Chr)],] %>% filter(lenR >= 1000000) #modify as necessary

### Create vectors for circlize plot ###
CircPlotVec <- list()
for (i in 1:length(Alignment4)){
  CircPlotVec[[i]] <- list()
  names(CircPlotVec)[i] <- names(Alignment4)[i]  
  
  Ref_order <- unique(Alignment4[[i]]$Ref) 
    Qry_order <- rev(unique(Alignment4[[i]][Alignment4[[i]]$Ref %in% Ref_order,]$Qry))
    Alignment_order <- c(Ref_order, Qry_order) 
    CircPlotVec[[i]]$Alignment_order <- factor(Alignment_order, levels = Alignment_order)
    
    Ref3 <- Alignment4[[i]] %>% select(Ref, lenR) %>% unique() %>% mutate(Ref = factor(Ref, levels = Ref_order)) %>% arrange(Ref)
    Qry3 <- Alignment4[[i]]%>% select(Qry, lenQ) %>% unique() %>% mutate(Qry = factor(Qry, levels = Qry_order)) %>% arrange(Qry)
    # CircPlotVec[[i]]$Alignment_tracks <- rbind(cbind(rep(0, length(Ref3$lenR)),Ref3$lenR),cbind(Qry3$lenQ,rep(0, length(Qry3$lenQ))))
    CircPlotVec[[i]]$Alignment_tracks <- cbind(rep(0, length(Alignment_order)),c(Ref3$lenR,Qry3$lenQ))
}

pdf(paste0(Prefix,"_circosPlotZoom_",t_per,"id_", t_len, "L1_1MlenR.pdf"), width = 10, height=17)
layout(matrix(1:6, 3, 2))
for(i in 1:length(CircPlotVec)) {
  factors = CircPlotVec[[i]]$Alignment_order
  xlim = CircPlotVec[[i]]$Alignment_tracks
  par(mar = c(0.5, 0.5, 0.5, 0.5))
  circos.par(cell.padding = c(0, 0, 0, 0))
  circos.initialize(factors = factors, xlim = xlim)
  circos.trackPlotRegion(ylim = c(0, 1), panel.fun = function(x, y) {
    chr = get.cell.meta.data("sector.index")
    xlim = get.cell.meta.data("xlim")
    ylim = get.cell.meta.data("ylim")
    circos.rect(xlim[1], 0, xlim[2], 0.5, col = Pal1$color[Pal1$Chr == chr])
    circos.text(mean(xlim), 1, chr, cex = 0.5, facing = "clockwise",
                niceFacing = TRUE)
  }, bg.border = NA)
  
  for ( k in c(1:dim(Alignment4[[i]])[1])){
    reference <- Alignment4[[i]]$Ref[k]
    query <- Alignment4[[i]]$Qry[k]
    RS <- Alignment4[[i]]$RS[k]
    RE <- Alignment4[[i]]$RE[k]
    # QS <- Alignment3$lenQ[i] - Alignment3$QS[i]
    # QE <- Alignment3$lenQ[i] - Alignment3$QE[i]
     QS <- Alignment4[[i]]$QS[k]
    QE <- Alignment4[[i]]$QE[k]
    circos.link(reference, c(RS,RE),
                query, c(QS, QE),
                col = Pal1$color[Pal1$Chr == reference])}
  circos.clear()

}
dev.off()


Alignment4_2 <-list()
Alignment4_2$onetofive <- Alignment3[Alignment3$Qry %in% Qry_pal$Chr[1:5],]
# Alignment4_2$onetofive <- Alignment3[Alignment3$Qry %in% c("Chromosome_5_RagTag", "Chromosome_4_RagTag", "Chromosome_3_RagTag", "Chromosome_2_RagTag", "Chromosome_1_RagTag"),]

Alignment4_2$sixtoten <- Alignment3[Alignment3$Qry %in% Qry_pal$Chr[6:10],]
# Alignment4_2$sixtoten <- Alignment3[Alignment3$Qry %in% c("Chromosome_10_RagTag","Chromosome_9_RagTag", "Chromosome_8_RagTag", "Chromosome_7_RagTag", "Chromosome_6_RagTag"),]

Alignment4_2$eleventofifteen <- Alignment3[Alignment3$Qry %in% Qry_pal$Chr[11:15],]
# Alignment4_2$eleventofifteen <- Alignment3[Alignment3$Qry %in% c("Chromosome_15_RagTag", "Chromosome_14_RagTag", "Chromosome_13_RagTag", "Chromosome_12_RagTag", "Chromosome_11_RagTag"),]

Alignment4_2$sixteentotwenty <- Alignment3[Alignment3$Qry %in% Qry_pal$Chr[16:20],]
# Alignment4_2$sixteentotwenty <- Alignment3[Alignment3$Qry %in% c("Chromosome_20_RagTag","Chromosome_19_RagTag", "Chromosome_18_RagTag", "Chromosome_17_RagTag", "Chromosome_16_RagTag"),]

Alignment4_2$twentyonetotwentyfive <- Alignment3[Alignment3$Qry %in% Qry_pal$Chr[21:25],] %>% filter(lenQ > 1000000)
# Alignment4_2$twentyonetotwentyfive <- Alignment3[Alignment3$Qry %in% c("Chromosome_25_RagTag", "Chromosome_24_RagTag", "Chromosome_23_RagTag", "Chromosome_22_RagTag", "Chromosome_21_RagTag"),]

Alignment4_2$plus <- Alignment3[Alignment3$Qry %in% Qry_pal$Chr[25:length(Qry_pal$Chr)],]  %>% filter(lenQ > 1000000) #modify as necessary
# Alignment4_2$plus <- Alignment3[Alignment3$Qry %in% c("Sc0000043_pilon", "Sc0000046_pilon", "Sc0000051_pilon", "Sc0000056_pilon", "xfSc0000003_pilon", "xfSc0000006_pilon", "xfSc0000009_pilon", 
#                                                       "xfSc0000021_pilon", "xfSc0000023_pilon", "xfSc0000030_pilon", "xfSc0000032_pilon", "xfSc0000045_pilon", "xfSc0000054_pilon", 
#                                                       "xfSc0000059_pilon", "xfSc0000060_pilon", "xpSc0000074_pilon", "xpSc0000080_pilon", "xpSc0000082_pilon", "xpSc0000085_pilon", "xpSc0000102_pilon"),]

### Create vectors for circlize plot ###
CircPlotVec <- list()
for (i in 1:length(Alignment4_2)){
  CircPlotVec[[i]] <- list()
  names(CircPlotVec)[i] <- names(Alignment4_2)[i]  
  
  Ref_order <- unique(Alignment4_2[[i]]$Ref) 
  Qry_order <- rev(unique(Alignment4_2[[i]][Alignment4_2[[i]]$Ref %in% Ref_order,]$Qry))
  Alignment_order <- c(Ref_order, Qry_order) 
  CircPlotVec[[i]]$Alignment_order <- factor(Alignment_order, levels = Alignment_order)
  
  Ref3 <- Alignment4_2[[i]] %>% select(Ref, lenR) %>% unique() %>% mutate(Ref = factor(Ref, levels = Ref_order)) %>% arrange(Ref)
  Qry3 <- Alignment4_2[[i]]%>% select(Qry, lenQ) %>% unique() %>% mutate(Qry = factor(Qry, levels = Qry_order)) %>% arrange(Qry)
  CircPlotVec[[i]]$Alignment_tracks <- cbind(rep(0, length(Alignment_order)),c(Ref3$lenR,Qry3$lenQ))
}

pdf(paste0(Prefix,"_circosPlotZoom_2_",t_per,"id_", t_len, "L1.pdf"), width = 10, height=17)
layout(matrix(1:6, 3, 2))
for(i in 1:length(CircPlotVec)) {
  factors = CircPlotVec[[i]]$Alignment_order
  xlim = CircPlotVec[[i]]$Alignment_tracks
  par(mar = c(0.5, 0.5, 0.5, 0.5))
  circos.par(cell.padding = c(0, 0, 0, 0))
  circos.initialize(factors = factors, xlim = xlim)
  circos.trackPlotRegion(ylim = c(0, 1), panel.fun = function(x, y) {
    chr = get.cell.meta.data("sector.index")
    xlim = get.cell.meta.data("xlim")
    ylim = get.cell.meta.data("ylim")
    circos.rect(xlim[1], 0, xlim[2], 0.5, col = Pal1$color[Pal1$Chr == chr])
    circos.text(mean(xlim), 1, chr, cex = 0.5, facing = "clockwise",
                niceFacing = TRUE)
  }, bg.border = NA)
  
  for ( k in c(1:dim(Alignment4_2[[i]])[1])){
    reference <- Alignment4_2[[i]]$Ref[k]
    query <- Alignment4_2[[i]]$Qry[k]
    RS <- Alignment4_2[[i]]$RS[k]
    RE <- Alignment4_2[[i]]$RE[k]
    # QS <- Alignment3$lenQ[i] - Alignment3$QS[i]
    # QE <- Alignment3$lenQ[i] - Alignment3$QE[i]
    QS <- Alignment4_2[[i]]$QS[k]
    QE <- Alignment4_2[[i]]$QE[k]
    circos.link(reference, c(RS,RE),
                query, c(QS, QE),
                col = Pal1$color[Pal1$Chr == reference])}
  circos.clear()
  
}
dev.off()


### filter query size ###

# remove short Pnapi scaffolds, short alignments, low identity alignments
lenR_cutoff <- 2000000
lenQ_cutoff <- 2000000
Alignment5 <- Alignment2 %>% filter(lenR >= lenR_cutoff & lenQ >= lenQ_cutoff & L1 >= t_len & Percent >= t_per)


#### Create vectors for circlize plot ####

# Define the order of the reference and query chromosomes
Ref_order <- unique(Alignment5$Ref) 
# or, if you want it in the correct order, 
# Ref_order <- Ref_pal$Chr[1:length(unique(Alignment5$Ref))]
Qry_order <- rev(unique(Alignment5[Alignment5$Ref %in% Ref_order,]$Qry))
Alignment_order <- c(Ref_order, Qry_order) 
Alignment_order <- factor(Alignment_order, levels = Alignment_order)

# Define the lengths of each chromosome
Ref5 <- Alignment5 %>% select(Ref, lenR) %>% unique() %>% mutate(Ref = factor(Ref, levels = Ref_order)) %>% arrange(Ref)
Qry5 <- Alignment5 %>% select(Qry, lenQ) %>% unique() %>% mutate(Qry = factor(Qry, levels = Qry_order)) %>% arrange(Qry)
Alignment_tracks <- cbind(rep(0, length(Alignment_order)),c(Ref5$lenR,Qry5$lenQ))


### Create the circlize plot ###
pdf(paste0(Prefix,"_circosPlot_",t_per,"id_", t_len, "L1_2MlenR_2MlenQ.pdf"), width = 10, height=7)
par(mar = c(1, 1, 1, 1))
circos.par(cell.padding = c(0, 0, 0, 0))
circos.initialize(factors = Alignment_order, xlim = Alignment_tracks)
circos.trackPlotRegion(ylim = c(0, 1), panel.fun = function(x, y) {
  chr = get.cell.meta.data("sector.index")
  xlim = get.cell.meta.data("xlim")
  ylim = get.cell.meta.data("ylim")
  circos.rect(xlim[1], 0, xlim[2], 0.5, col = Pal1$color[Pal1$Chr == chr])
  circos.text(mean(xlim), 1, chr, cex = 0.5, facing = "clockwise",
              niceFacing = TRUE)
}, bg.border = NA)

for ( i in c(1:dim(Alignment5)[1])){
  reference <- Alignment5$Ref[i]
  query <- Alignment5$Qry[i]
  RS <- Alignment5$RS[i]
  RE <- Alignment5$RE[i]
  # QS <- Alignment3$lenQ[i] - Alignment3$QS[i]
  # QE <- Alignment3$lenQ[i] - Alignment3$QE[i]
  QS <- Alignment5$QS[i]
  QE <- Alignment5$QE[i]
  circos.link(reference, c(RS,RE),
              query, c(QS, QE),
              col = Pal1$color[Pal1$Chr == reference])}

circos.clear()
dev.off()

