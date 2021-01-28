#### Figure 2A ####

# Packages
library(tidyverse)
library(circlize)
library(RColorBrewer)

setwd("/mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/align_Pnapi/")

Prefix <- "nucmer_aln_Pnap_v_PmacMums_polished.filt.coords"

Ref_pal <- read_table("Pnap_contigs.txt", col_names = F) %>%
  dplyr::rename(Chr = X1) %>%
  filter(Chr != "Mitochondria") %>%
  # arrange(Chr) %>% #optional, keeps the colors separate, but still have the issue of chromosome name order
  mutate(color = rep(brewer.pal(n=11, "Spectral")[c(1:4,8:11)], length.out = length(Chr)))
# mutate(color = rep(mypal, length.out = length(Chr)))


Qry_pal <-read_table2("Pmac_contigs.txt", col_names = F) %>%
  # Qry_pal <-read_table2("Pmac_contigs.txt", col_names = F) %>%
  dplyr::rename(Chr = X1) %>%
  mutate(color = "#FFFFFF")
unique(Qry_pal$Chr)

Pal1 <- union(Ref_pal, Qry_pal)

#### load data ####
## if data are in a text file generated using nucmer -> delta-filter -> show-coords > .txt file, uncomment the following:
# nucmer_coord_colnames1 <- c('RS','RE','QS','QE','L1','L2','Percent','lenR','lenQ','covR', 'covQ','Ref','Qry')

## if data are in a csv file generated using nucmer -> show-coords > .coords file then modified using qwk, uncomment the following:
nucmer_coord_colnames2 <- c('RS','RE','QS','QE','L1','L2','Percent','lenR','lenQ','Ref','Qry')

## alignment file:
Alignment <- read_csv("nucmer_aln_Pnap_v_PmacMums_polished.cleaned.filt.coords", col_names = nucmer_coord_colnames2 )
head(Alignment)

#### Filter data ####
head(Alignment)

zchromosome <- Alignment %>% filter(Ref == "modScaffold_95_1" & L1 > 1000)


#remove scaffolds with only one hit
Alignment2 <- Alignment %>%
  group_by(Ref) %>%
  mutate(n_segments = n()) %>%
  filter(n_segments != 1) %>%
  dplyr::select(-n_segments) %>% ungroup()

# Visualize alignment
# plot <- ggplot(data = Alignment2)
# plot + geom_point( aes(x = Percent, y = L1))
# plot + geom_histogram( aes(log10(L1)))

# remove short Pnapi scaffolds, short alignments, low identity alignments
t_per <- 90
t_len <- 5000
Alignment3 <- Alignment2 %>% filter(lenR >= 1000000 & L1 >= t_len & Percent >= t_per& Percent <= 98)


#### Create vectors for circlize plot ####

# Define the order of the reference and query chromosomes
Ref_order <- unique(Alignment3$Ref)
Qry_order <- rev(unique(Alignment3[Alignment3$Ref %in% Ref_order,]$Qry))
# unique(Qry_pal$Chr)


Alignment_order <- c(Ref_order, Qry_order)
Alignment_order <- factor(Alignment_order, levels = Alignment_order)

# Define the lengths of each chromosome
Ref3 <- Alignment3 %>% dplyr::select(Ref, lenR) %>% unique() %>% mutate(Ref = factor(Ref, levels = Ref_order)) %>% arrange(Ref)
Qry3 <- Alignment3 %>% dplyr::select(Qry, lenQ) %>% unique() %>% mutate(Qry = factor(Qry, levels = Qry_order)) %>% arrange(Qry)
Alignment_tracks <- cbind(rep(0, length(Alignment_order)),c(Ref3$lenR,Qry3$lenQ))
# Alignment_tracks <- rbind(cbind(rep(0, length(Ref3$lenR)),Ref3$lenR),cbind(Qry3$lenQ,rep(0, length(Qry3$lenQ))))


Prefix
#### Create the circlize plot ####
pdf(paste0(Prefix,"_circosPlot_",t_per,"id_", t_len, "L1_1MlenR.pdf"), width = 10, height=7)
par(mar = c(1, 1, 1, 1))
circos.par(cell.padding = c(0, 0, 0, 0), canvas.xlim = c(-1.55, 1.55))
circos.initialize(factors = Alignment_order, xlim = Alignment_tracks)
circos.trackPlotRegion(ylim = c(0, 1), panel.fun = function(x, y) {
  chr = get.cell.meta.data("sector.index")
  xlim = get.cell.meta.data("xlim")
  ylim = get.cell.meta.data("ylim")
  circos.rect(xlim[1], 0, xlim[2], 0.5, col = Pal1$color[Pal1$Chr == chr])
  circos.text(mean(xlim), 1, chr, cex = 0.5, facing = "clockwise",
              niceFacing = TRUE,  adj = c(0.4, 0.5))
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
circos.info()

#### Figure 2b ####
# continue with loaded dataframes. 
#### Focusing on a target scaffold in either reference ####
scaffold <- "Sc0000000_pilon"
t_per <- 90
t_len <- 5000

Alignment6 <- Alignment2 %>% filter((Ref == scaffold | Qry == scaffold) & Percent >= t_per & L1 >= t_len)


#### Create vectors for circlize plot ####

# Define the order of the reference and query chromosomes
Ref_order <- unique(Alignment6$Ref)
# or, if you want it in the correct order,
# Ref_order <- Ref_pal$Chr[1:length(unique(Alignment6$Ref))]
Qry_order <- rev(unique(Alignment6[Alignment6$Ref %in% Ref_order,]$Qry))
Alignment_order <- c(Ref_order, Qry_order)
Alignment_order <- factor(Alignment_order, levels = Alignment_order)

# Define the lengths of each chromosome
Ref6 <- Alignment6 %>% select(Ref, lenR) %>% unique() %>% mutate(Ref = factor(Ref, levels = Ref_order)) %>% arrange(Ref)
Qry6 <- Alignment6 %>% select(Qry, lenQ) %>% unique() %>% mutate(Qry = factor(Qry, levels = Qry_order)) %>% arrange(Qry)
Alignment_tracks <- cbind(rep(0, length(Alignment_order)),c(Ref6$lenR,Qry6$lenQ))

#### Create the circlize plot ####
pdf(paste0(Prefix,"_", scaffold,"_circosPlot_",t_per,"id_", t_len, "L1.pdf"), width = 10, height=8)
par(mar = c(1, 1, 1, 1))
circos.par(cell.padding = c(0, 0, 0, 0), canvas.xlim = c(-1.5, 1.5))
circos.initialize(factors = Alignment_order, xlim = Alignment_tracks)
circos.trackPlotRegion(ylim = c(0, 1), panel.fun = function(x, y) {
  chr = get.cell.meta.data("sector.index")
  xlim = get.cell.meta.data("xlim")
  ylim = get.cell.meta.data("ylim")
  circos.rect(xlim[1], 0, xlim[2], 0.5, col = Pal1$color[Pal1$Chr == chr])
  circos.text(mean(xlim), 1, chr, cex = 0.75, facing = "clockwise",
              niceFacing = TRUE, adj = c(0.25,0.5))
}, bg.border = NA)

for ( i in c(1:dim(Alignment6)[1])){
  reference <- Alignment6$Ref[i]
  query <- Alignment6$Qry[i]
  RS <- Alignment6$RS[i]
  RE <- Alignment6$RE[i]
  # QS <- Alignment3$lenQ[i] - Alignment3$QS[i]
  # QE <- Alignment3$lenQ[i] - Alignment3$QE[i]
  QS <- Alignment6$QS[i]
  QE <- Alignment6$QE[i]
  circos.link(reference, c(RS,RE),
              query, c(QS, QE),
              col = Pal1$color[Pal1$Chr == reference])}

circos.clear()
dev.off()

#### Figure 2C ####
Prefix <- "nucmer_aln_Pnap_v_PmacMums_polished.filt.coords"

Ref_pal <- read_table("Pnap_contigs.txt", col_names = F) %>%
  dplyr::rename(Chr = X1) %>%
  filter(Chr != "Mitochondria") %>%
  # arrange(Chr) %>% #optional, keeps the colors separate, but still have the issue of chromosome name order
  mutate(color = rep(brewer.pal(n=11, "Spectral")[c(1:4,8:11)], length.out = length(Chr)))
# mutate(color = rep(mypal, length.out = length(Chr)))


Qry_pal <-read_table2("Pmac_contigs.txt", col_names = F) %>%
  # Qry_pal <-read_table2("Pmac_contigs.txt", col_names = F) %>%
  dplyr::rename(Chr = X1) %>%
  mutate(color = "#FFFFFF")
unique(Qry_pal$Chr)

Pal1 <- union(Ref_pal, Qry_pal)

#### load data ####
Alignment <- read_csv("/mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/align_Pnapi/nucmer_aln_Pnap_v_PmacMums_polished_ragtag_i80.filt.coords", col_names = nucmer_coord_colnames2 )
head(Alignment)

#### Filter data ####
#remove scaffolds with only one hit
Alignment2 <- Alignment %>%
  group_by(Ref) %>%
  mutate(n_segments = n()) %>%
  filter(n_segments != 1) %>%
  dplyr::select(-n_segments) %>% ungroup()

# remove short Pnapi scaffolds, short alignments, low identity alignments
t_per <- 90
t_len <- 5000

lenR_cutoff <- 2000000
lenQ_cutoff <- 2000000
Alignment5 <- Alignment2 %>% filter(lenR >= lenR_cutoff & lenQ >= lenQ_cutoff & L1 >= t_len & Percent >= t_per)

#### Create vectors for circlize plot ####

# Define the order of the reference and query chromosomes
Ref_order <-  c("modScaffold_17_1", "Chromosome_1",  "Chromosome_2", "Chromosome_3", "Chromosome_4", "Chromosome_5",
                "Chromosome_6", "Chromosome_7", "Chromosome_8", "Chromosome_9", "Chromosome_10",
                "Chromosome_11", "Chromosome_12", "Chromosome_13", "Chromosome_14", "Chromosome_15",
                "Chromosome_16", "Chromosome_17", "Chromosome_18", "Chromosome_19",  "Chromosome_20", "Chromosome_21",
                "Chromosome_22", "Chromosome_23", "Chromosome_24",  "Chromosome_25",
                "modScaffold_35_1", "modScaffold_40_1")

Qry_order <- c("xfSc0000003_pilon", "Chromosome_25_RagTag","Chromosome_24_RagTag",
               "Chromosome_23_RagTag", "xfSc0000009_pilon" ,  "Chromosome_22_RagTag","xfSc0000006_pilon" ,
               "Chromosome_21_RagTag", "Chromosome_20_RagTag",   "Chromosome_19_RagTag",  "Chromosome_18_RagTag",
               "Chromosome_17_RagTag", "Chromosome_16_RagTag", "Chromosome_15_RagTag",
               "Chromosome_14_RagTag", "Chromosome_13_RagTag", "Chromosome_12_RagTag",
               "Chromosome_11_RagTag", "Chromosome_10_RagTag","Chromosome_9_RagTag",
               "Chromosome_8_RagTag", "Chromosome_7_RagTag", "Chromosome_6_RagTag", "Chromosome_5_RagTag",
               "Chromosome_4_RagTag", "Chromosome_3_RagTag", "Chromosome_2_RagTag", "Chromosome_1_RagTag")

Alignment_order <- c(Ref_order, Qry_order)
Alignment_order <- factor(Alignment_order, levels = Alignment_order)

# Define the lengths of each chromosome
Ref5 <- Alignment5 %>% select(Ref, lenR) %>% unique() %>% mutate(Ref = factor(Ref, levels = Ref_order)) %>% arrange(Ref)
Qry5 <- Alignment5 %>% select(Qry, lenQ) %>% unique() %>% mutate(Qry = factor(Qry, levels = Qry_order)) %>% arrange(Qry)
Alignment_tracks <- cbind(rep(0, length(Alignment_order)),c(Ref5$lenR,Qry5$lenQ))
Alignment_lim = cbind(rep(c(0, 0), times = c(length(Ref_order), length(Qry_order))),
                      rep(c(1,1), times = c(length(Ref_order), length(Qry_order))))


### Create the circlize plot ###


pdf(paste0(Prefix,"_circosPlot_",t_per,"id_", t_len, "L1_2MlenR_2MlenQ.pdf"), width = 10, height=8)
par(mar = c(1, 1, 1, 1))
circos.par(cell.padding = c(0, 0, 0, 0), canvas.xlim = c(-1.55, 1.55))
circos.initialize(factors = Alignment_order, xlim = Alignment_tracks)
circos.trackPlotRegion(ylim = c(0, 1), panel.fun = function(x, y) {
  chr = get.cell.meta.data("sector.index")
  xlim = get.cell.meta.data("xlim")
  ylim = get.cell.meta.data("ylim")
  circos.rect(xlim[1], 0, xlim[2], 0.5, col = Pal1$color[Pal1$Chr == chr])
  circos.text(mean(xlim), 1, chr, cex = 0.5, facing = "clockwise",
              niceFacing = TRUE,  adj = c(0.4, 0.5))
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
  circos.link(reference, c(RS, RE), query, c(QS, QE),
              col = Pal1$color[Pal1$Chr == reference])}

circos.clear()
dev.off()
