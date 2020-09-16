# Packages
library(tidyverse)
library(circlize)
library(RColorBrewer)

# Define functions
`%notin%` <- Negate(`%in%`)

# set working directory
setwd("/mnt/griffin/racste/P_macdunnoughii/Pmac_alignments/NGM_genome/PmacD_qmRac4MedPur.cleaned.masked/qmRac4MedPur.cleaned.masked_polish/align_Pnapi")
setwd("/mnt/griffin/racste/P_macdunnoughii/Pmac_genome_versions/align_Pnapi/")
# Prefix
Prefix <- "nucmer_aln_Pnap_v_Pmacqm"

Ref_pal <- read_table("Pnap_contigs.txt", col_names = F) %>% 
   rename(Chr = X1) %>% 
  filter(Chr != "Mitochondria") %>% 
  mutate(color = rep(brewer.pal(n=11, "Spectral"), length.out = length(Chr)))

Qry_pal <-read_table2("Pmac_contigs.txt", col_names = F) %>% 
  rename(Chr = X1) %>% 
  mutate(color = "#FFFFFF")

Pal1 <- union(Ref_pal, Qry_pal)

#### load data ####
## if data are in a text file generated using nucmer -> delta-filter -> show-coords > .txt file, uncomment the following:
# nucmer_coord_colnames1 <- c('RS','RE','QS','QE','L1','L2','Percent','lenR','lenQ','covR', 'covQ','Ref','Qry')
# Alignment <- read_table2("alt_Pmac00.1_Pnap_nucmer_filter_coords.txt", skip = 4, col_names = nucmer_coord_colnames1 ) 

## if data are in a csv file generated using nucmer -> show-coords > .coords file then modified using qwk, uncomment the following: 
nucmer_coord_colnames2 <- c('RS','RE','QS','QE','L1','L2','Percent','lenR','lenQ','Ref','Qry')
# Alignment <- read_csv("nucmer_aln_Pnap_v_Pmac000.1polish.filt.coords", col_names = nucmer_coord_colnames2 ) 
Alignment <- read_csv("nucmer_aln_Pnap_v_Pmacqm.filt.coords", col_names = nucmer_coord_colnames2 ) 

#### Filter data ####

#remove scaffolds with only one hit
Alignment2 <- Alignment %>% 
  group_by(Ref) %>% 
  mutate(n_segments = n()) %>% 
  filter(n_segments != 1) %>% 
  select(-n_segments) %>% ungroup()

# Visualize alignment
plot <- ggplot(data = Alignment2) 
plot + geom_point( aes(x = Percent, y = L1))
plot + geom_histogram( aes(log10(L1)))

# remove short Pnapi scaffolds, short alignments, low identity alignments
t_per <- 90
t_len <- 2000
Alignment3 <- Alignment2 %>% filter(lenR >= 1000000 & L1 >= t_len & Percent >= t_per)


#### Create vectors for circlize plot ####

# Define the order of the reference and query chromosomes
Ref_order <- unique(Alignment3$Ref) 
# or, if you want it in the correct order, 
# Ref_order <- Ref_pal$Chr[1:length(unique(Alignment3$Ref))]
Qry_order <- rev(unique(Alignment3[Alignment3$Ref %in% Ref_order,]$Qry))
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
  QS <- Alignment3$QS[i]
  QE <- Alignment3$QE[i]
  circos.link(reference, c(RS,RE),
             query, c(QS, QE),
             col = Pal1$color[Pal1$Chr == reference])}

circos.clear()
dev.off()

