setwd("/mnt/griffin/racste/P_macdunnoughii/Pmac_alignments/NGM_genome/RagTagMap/")

library(tidyverse)
library(ggpubr)

#### Assembly ####
pool_assem <- read_tsv("PmacMums_polished_ragtag_i80_ChrOrder.tsv") %>% arrange(Chr_order) 
pos <- seq(1:length(pool_assem$lenQ))
for (i in 2:length(pos)) {
  pos[i] <- pos[i-1] + pool_assem$lenQ[i-1]
}
pool_assem$start <- pos
pool_color = rep(brewer.pal(n=11, "Spectral")[c(1:4,8:11)], length.out = length(pool_assem$Chr_order))

#### Pi ####

cols <- c("Chr", "Window", "nSNPs", "Cov", "Stat")
pi_50k <- read_table2("Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.50k.pi", skip = 1, col_names = cols) %>%
  left_join(pool_assem) %>% 
  arrange(Chr_order, Window) %>% 
  mutate(position = start + Window)
pi_50k$Stat <- as.numeric(gsub("na","NA",pi_50k$Stat))
pi_0.5k <- read_table2("Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.0.5k.pi", skip = 1, col_names = cols) %>%
  left_join(pool_assem) %>% 
  arrange(Chr_order, Window) %>% 
  mutate(position = start + Window) %>% filter(Cov >= 0.5)
pi_0.5k$Stat <- as.numeric(gsub("na","NA",pi_0.5k$Stat))
length(pi_50k$Stat[pi_50k$Cov > 0.5 & pi_50k$Chr_order!= "Chr01"]) *0.025
top2.5 <- pi_50k %>% na.omit() %>% filter( Cov > 0.5 & Chr_order!= "Chr01") %>%  arrange(Stat) %>% tail(145) %>% arrange(Chr_order) 
bottom2.5 <- pi_50k %>% na.omit() %>% filter(Cov > 0.5 & Chr_order!= "Chr01") %>%  arrange(Stat) %>% head(145) %>% arrange(Chr_order)

pi_50k_outliers <- union(top2.5, bottom2.5)
ggplot() +
  geom_histogram(data = na.omit(pi_50k[pi_50k$Chr_order != "Chr01",]), aes(x = Stat), bins = 50, fill = "gray") +
  geom_histogram(data = na.omit(pi_50k[(pi_50k$Stat <  0.001848721 | 
                                          pi_50k$Stat > 0.009117894),]), aes(x = Stat), bins = 50, fill = "gray40") +
  geom_histogram(data =na.omit(pi_50k[pi_50k$Chr_order == "Chr01",]), aes(x = Stat), fill =pool_color[1], bins = 50)+
  labs(x = "Nucleotide Diversity (pi)", y = "Count (50kb windows)" ) +
  theme_bw(base_size = 15)
ggsave("Pmac_mums_PmacMums_pi_outliers.pdf", height = 5, width = 8)

# geom_rect(data = pi_50k_outliers, aes(xmin = Window - 25000, xmax = Window + 25000, ymin = 0, ymax = 0.075), color = "black")

pi_50k %>% na.omit() %>%  arrange(Stat) %>% tail(156) %>% summarize(min(Stat))
pi_50k %>% na.omit() %>%  arrange(Stat) %>% summarize(mean(Stat))
pi_50k %>% na.omit() %>%  arrange(Stat) %>% filter(Chr_order != "Chr01") %>%  summarize(mean(Stat))
pi_50k %>% na.omit() %>%  arrange(Stat) %>% filter(Chr_order == "Chr01") %>%  summarize(mean(Stat))

pool_assem_1to6 <- pool_assem$Chr[pool_assem$start < 7.8e7]
pool_assem_7to12 <- pool_assem$Chr[pool_assem$start > 7.8e7 & pool_assem$start < 15.6e7]
pool_assem_13to19 <- pool_assem$Chr[pool_assem$start > 15.6e7 & pool_assem$start < 23.4e7]
pool_assem_remain<- pool_assem$Chr[pool_assem$start > 23.4e7]

chr1to6 <- ggplot() +
  geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_point(data = pi_0.5k[pi_0.5k$Chr %in% pool_assem_1to6,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = pi_50k[pi_50k$Chr %in% pool_assem_1to6,], aes(x = position, y = Stat))+
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[1:6], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0),breaks = c(0, 5.0e6, 1.0e7, 1.5e7, 2.0e7, 2.5e7, 3.0e7, 3.5e7, 4.0e7, 4.5e7, 5.0e7, 5.5e7, 6.0e7, 6.5e7, 7.0e7, 7.5e7, 8.0e7))+
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())
chr7to12 <- ggplot() +
   geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_7to12,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
   geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_7to12,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
   geom_point(data = pi_0.5k[pi_0.5k$Chr %in% pool_assem_7to12,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = pi_50k[pi_50k$Chr %in% pool_assem_7to12,], aes(x = position, y = Stat))+
  geom_line() +
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[7:12], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0),breaks = c(8.0e7, 8.5e7, 9.0e7, 9.5e7, 10.0e7, 10.5e7, 11.0e7, 11.5e7, 12.0e7, 12.5e7, 13.0e7, 13.5e7, 14.0e7, 14.5e7, 15.0e7, 15.5e7)) +
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())
chr13to19<- ggplot() +
  geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_13to19,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_13to19,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_point(data = pi_0.5k[pi_0.5k$Chr %in% pool_assem_13to19,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = pi_50k[pi_50k$Chr %in% pool_assem_13to19,], aes(x = position, y = Stat))+
  geom_line() +
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[13:19], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0),breaks = c(16.0e7, 16.5e7, 17.0e7, 17.5e7, 18.0e7, 18.5e7, 19.0e7, 19.5e7, 20.0e7, 20.5e7, 21.0e7, 21.5e7, 22.0e7, 22.5e7, 23.0e7, 23.5e7)) +
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" ) +
  theme(panel.grid = element_blank())
chrRemain <- ggplot() +
  geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_remain,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_remain,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_point(data = pi_0.5k[pi_0.5k$Chr %in% pool_assem_remain,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = pi_50k[pi_50k$Chr %in% pool_assem_remain,], aes(x = position, y = Stat))+
  geom_line() +
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[20:45], guide = FALSE)  +
  scale_x_continuous( expand = c(0,0), breaks = c(24.0e7, 24.5e7, 25.0e7, 25.5e7, 26.0e7, 26.5e7, 27.0e7, 27.5e7, 28.0e7, 28.5e7, 29e7, 29.5e7, 30.0e7, 30.5e7, 31.0e7, 31.5e7, 32e7)) +
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())

pi_50k_plot <- ggarrange(chr1to6, chr7to12, chr13to19, chrRemain, ncol = 1)
Pmac_mums_PmacMums_50kpi_plot <- annotate_figure(pi_50k_plot,
                                                 bottom = text_grob("Position in genome (bp)"),
                                                 left = text_grob(expression(pi), rot = 90),
                                                 fig.lab = "Pmac_mums_PmacMums_50kpi_plot", fig.lab.face = "bold",fig.lab.pos = "bottom.left")
ggsave(plot = Pmac_mums_PmacMums_50kpi_plot, "Pmac_mums_PmacMums_50kpi_plot.pdf", height = 10, width = 15)

#### D ####

cols <- c("Chr", "Window", "nSNPs", "Cov", "Stat")
D_50k <- read_table2("Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.subsampled.50k.D", skip = 1, col_names = cols) %>%
  left_join(pool_assem) %>% 
  arrange(Chr_order, Window) %>% 
  mutate(position = start + Window)
D_50k$Stat <- as.numeric(gsub("na","NA",D_50k$Stat))
D_0.5k <- read_table2("Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.subsampled.0.5k.D", skip = 1, col_names = cols) %>%
  left_join(pool_assem) %>% 
  arrange(Chr_order, Window) %>% 
  mutate(position = start + Window) %>% filter(Cov >= 0.5)
D_0.5k$Stat <- as.numeric(gsub("na","NA",D_0.5k$Stat))

chr1to6 <- ggplot() +
  geom_point(data = D_0.5k[D_0.5k$Chr %in% pool_assem_1to6,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = D_50k[D_50k$Chr %in% pool_assem_1to6,], aes(x = position, y = Stat))+
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[1:6], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0),breaks = c(0, 5.0e6, 1.0e7, 1.5e7, 2.0e7, 2.5e7, 3.0e7, 3.5e7, 4.0e7, 4.5e7, 5.0e7, 5.5e7, 6.0e7, 6.5e7, 7.0e7, 7.5e7, 8.0e7))+
  scale_y_continuous(expand = c(0,0), limits = c(-2.5,2)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())
chr7to12 <- ggplot() +
  geom_point(data = D_0.5k[D_0.5k$Chr %in% pool_assem_7to12,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = D_50k[D_50k$Chr %in% pool_assem_7to12,], aes(x = position, y = Stat))+
  geom_line() +
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[7:12], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0),breaks = c(8.0e7, 8.5e7, 9.0e7, 9.5e7, 10.0e7, 10.5e7, 11.0e7, 11.5e7, 12.0e7, 12.5e7, 13.0e7, 13.5e7, 14.0e7, 14.5e7, 15.0e7, 15.5e7)) +
  scale_y_continuous(expand = c(0,0), limits = c(-2.5,2)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())
chr13to19<- ggplot() +
  geom_point(data = D_0.5k[D_0.5k$Chr %in% pool_assem_13to19,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = D_50k[D_50k$Chr %in% pool_assem_13to19,], aes(x = position, y = Stat))+
  geom_line() +
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[13:19], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0),breaks = c(16.0e7, 16.5e7, 17.0e7, 17.5e7, 18.0e7, 18.5e7, 19.0e7, 19.5e7, 20.0e7, 20.5e7, 21.0e7, 21.5e7, 22.0e7, 22.5e7, 23.0e7, 23.5e7)) +
  scale_y_continuous(expand = c(0,0), limits = c(-2.5,2)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())
chrRemain <- ggplot() +
  geom_point(data = D_0.5k[D_0.5k$Chr %in% pool_assem_remain,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = D_50k[D_50k$Chr %in% pool_assem_remain,], aes(x = position, y = Stat))+
  geom_line() +
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[19:45], guide = FALSE)  +
  scale_x_continuous( expand = c(0,0), breaks = c(24.0e7, 24.5e7, 25.0e7, 25.5e7, 26.0e7, 26.5e7, 27.0e7, 27.5e7, 28.0e7, 28.5e7, 29e7, 29.5e7, 30.0e7, 30.5e7, 31.0e7, 31.5e7, 32e7)) +
  scale_y_continuous(expand = c(0,0), limits = c(-2.5,2)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())

D_50k_plot <- ggarrange(chr1to6, chr7to12, chr13to19, chrRemain, ncol = 1)
Pmac_mums_PmacMums_50kD_plot <- annotate_figure(D_50k_plot,
                                                bottom = text_grob("Position (bp)"),
                                                left = text_grob("Tajima's D", rot = 90),
                                                fig.lab = "Pmac_mums_PmacMums_50kD_plot", fig.lab.face = "bold",fig.lab.pos = "bottom.left")
ggsave(plot = Pmac_mums_PmacMums_50kD_plot, "Pmac_mums_PmacMums_50kD_plot.pdf", height = 16, width = 20)

#### theta ####

cols <- c("Chr", "Window", "nSNPs", "Cov", "Stat")
theta_50k <- read_table2("Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.50k.theta", skip = 1, col_names = cols) %>%
  left_join(pool_assem) %>% 
  arrange(Chr_order, Window) %>% 
  mutate(position = start + Window)
theta_50k$Stat <- as.numeric(gsub("na","NA",theta_50k$Stat))
theta_0.5k <- read_table2("Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.0.5k.theta", skip = 1, col_names = cols) %>%
  left_join(pool_assem) %>% 
  arrange(Chr_order, Window) %>% 
  mutate(position = start + Window) %>% filter(Cov >= 0.5)
theta_0.5k$Stat <- as.numeric(gsub("na","NA",theta_0.5k$Stat))
length(theta_50k$Stat[theta_50k$Cov > 0.5 & theta_50k$Chr_order!= "Chr01"]) *0.025
top2.5 <- theta_50k %>% na.omit() %>% filter( Cov > 0.5 & Chr_order!= "Chr01") %>%  arrange(Stat) %>% tail(145) %>% arrange(Chr_order) 
bottom2.5 <- theta_50k %>% na.omit() %>% filter(Cov > 0.5 & Chr_order!= "Chr01") %>%  arrange(Stat) %>% head(145) %>% arrange(Chr_order)

theta_50k_outliers <- union(top2.5, bottom2.5)
ggplot() +
  geom_histogram(data = na.omit(theta_50k[theta_50k$Chr_order != "Chr01",]), aes(x = Stat), bins = 50, fill = "gray") +
  geom_histogram(data = na.omit(theta_50k[(theta_50k$Stat <  0.001848721 | 
                                          theta_50k$Stat > 0.009117894),]), aes(x = Stat), bins = 50, fill = "gray40") +
  geom_histogram(data =na.omit(theta_50k[theta_50k$Chr_order == "Chr01",]), aes(x = Stat), fill =pool_color[1], bins = 50)+
  labs(x = "Nucleotide Diversity (pi)", y = "Count (50kb windows)" ) +
  theme_bw(base_size = 15)
ggsave("Pmac_mums_PmacMums_theta_outliers.pdf", height = 5, width = 8)

geom_rect(data = theta_50k_outliers, aes(xmin = Window - 25000, xmax = Window + 25000, ymin = 0, ymax = 0.075), color = "black")

theta_50k %>% na.omit() %>%  arrange(Stat) %>% tail(156) %>% summarize(min(Stat))
pool_assem_1to6 <- pool_assem$Chr[pool_assem$start < 7.8e7]
pool_assem_7to12 <- pool_assem$Chr[pool_assem$start > 7.8e7 & pool_assem$start < 15.6e7]
pool_assem_13to19 <- pool_assem$Chr[pool_assem$start > 15.6e7 & pool_assem$start < 23.4e7]
pool_assem_remain<- pool_assem$Chr[pool_assem$start > 23.4e7]

chr1to6 <- ggplot() +
  geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_point(data = theta_0.5k[theta_0.5k$Chr %in% pool_assem_1to6,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = theta_50k[theta_50k$Chr %in% pool_assem_1to6,], aes(x = position, y = Stat))+
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[1:6], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0),breaks = c(0, 5.0e6, 1.0e7, 1.5e7, 2.0e7, 2.5e7, 3.0e7, 3.5e7, 4.0e7, 4.5e7, 5.0e7, 5.5e7, 6.0e7, 6.5e7, 7.0e7, 7.5e7, 8.0e7))+
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())
chr7to12 <- ggplot() +
  geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_7to12,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_7to12,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_point(data = theta_0.5k[theta_0.5k$Chr %in% pool_assem_7to12,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = theta_50k[theta_50k$Chr %in% pool_assem_7to12,], aes(x = position, y = Stat))+
  geom_line() +
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[7:12], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0),breaks = c(8.0e7, 8.5e7, 9.0e7, 9.5e7, 10.0e7, 10.5e7, 11.0e7, 11.5e7, 12.0e7, 12.5e7, 13.0e7, 13.5e7, 14.0e7, 14.5e7, 15.0e7, 15.5e7)) +
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())
chr13to19<- ggplot() +
  geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_13to19,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_13to19,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_point(data = theta_0.5k[theta_0.5k$Chr %in% pool_assem_13to19,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = theta_50k[theta_50k$Chr %in% pool_assem_13to19,], aes(x = position, y = Stat))+
  geom_line() +
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[13:19], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0),breaks = c(16.0e7, 16.5e7, 17.0e7, 17.5e7, 18.0e7, 18.5e7, 19.0e7, 19.5e7, 20.0e7, 20.5e7, 21.0e7, 21.5e7, 22.0e7, 22.5e7, 23.0e7, 23.5e7)) +
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())
chrRemain <- ggplot() +
  geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_remain,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_remain,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_point(data = theta_0.5k[theta_0.5k$Chr %in% pool_assem_remain,], aes(x = position, y = Stat, color = Chr_order), size = 0.5)+
  geom_line(data = theta_50k[theta_50k$Chr %in% pool_assem_remain,], aes(x = position, y = Stat))+
  geom_line() +
  labs( x= NULL, y = NULL) +
  scale_color_manual(values = pool_color[20:45], guide = FALSE)  +
  scale_x_continuous( expand = c(0,0), breaks = c(24.0e7, 24.5e7, 25.0e7, 25.5e7, 26.0e7, 26.5e7, 27.0e7, 27.5e7, 28.0e7, 28.5e7, 29e7, 29.5e7, 30.0e7, 30.5e7, 31.0e7, 31.5e7, 32e7)) +
  scale_y_continuous(expand = c(0,0)) +
  theme_bw() +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" )+
  theme(panel.grid = element_blank())


theta_50k_plot <- ggarrange(chr1to6, chr7to12, chr13to19, chrRemain, ncol = 1)
Pmac_mums_PmacMums_50ktheta_plot <- annotate_figure(theta_50k_plot,
                                                 bottom = text_grob("Position in genome (bp)"),
                                                 left = text_grob(expression(theta), rot = 90),
                                                 fig.lab = "Pmac_mums_PmacMums_50ktheta_plot", fig.lab.face = "bold",fig.lab.pos = "bottom.left")
ggsave(plot = Pmac_mums_PmacMums_50ktheta_plot, "Pmac_mums_PmacMums_50ktheta_plot.pdf", height = 10, width = 15)

#### Chr 23 ####

chr23_0.5 <-  read_table2("Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.0.5k.pi", skip = 1, col_names = cols) %>%
  left_join(pool_assem) %>% arrange(Chr_order, Window) %>% mutate(position = start + Window) %>% filter(Cov >= 0.5 & Chr_order == "Chr23")
chr23_50 <-  read_table2("Pmac_Mums_NGM_PmacMums_polished_ragtag.pairs.sorted.rmindel.pileup.50k.pi", skip = 1, col_names = cols) %>%
  left_join(pool_assem) %>% arrange(Chr_order, Window) %>% mutate(position = start + Window) %>% filter(Chr_order == "Chr23")
chr23_0.5$Stat <- as.numeric(gsub("na","NA",chr23_0.5$Stat))
chr23_50$Stat <- as.numeric(gsub("na","NA",chr23_50$Stat))

summary(chr23)

(chr23_pi <- ggplot()+
    # geom_rect(data = top2.5[top2.5$Chr_order == "Chr23",], aes(xmin = Window - 25000, xmax = Window + 25000, ymin = 0, ymax = 0.075), fill = "gray70")+
    # geom_rect(data = bottom2.5[bottom2.5$Chr_order == "Chr23",], aes(xmin = Window - 25000, xmax = Window + 25000, ymin = 0, ymax = 0.075), fill = "gray40")+
    geom_rect(aes(xmin =3400000, xmax = 4500000, ymin = 0, ymax = 0.06), fill = "gray70", alpha = 0.25, color = "black")+
    geom_rect(aes(xmin =4500000, xmax = 5600000, ymin = 0, ymax = 0.06), fill = "gray70", alpha = 0.25, color = "black")+ 
    geom_point(data= chr23_0.5, aes(x = Window, y = Stat, color = Chr_order)) +
    geom_line(data=chr23_50, aes(x = Window, y = Stat), size = 1) +
    scale_color_manual(values = pool_color[23], guide = FALSE)  +
    scale_x_continuous( expand = c(0,0)) +
    scale_y_continuous(expand = c(0,0), limits = c(0,0.06)) +
    theme_bw()
)

chr23_pi + 
  # facet_zoom(xlim = c(3400000, 4500000),shrink = TRUE ) +
  facet_zoom(xlim = c(4500000, 5600000),)

csome23_genes <- read_tsv("/mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/RagTag_updateGFF/csome_23_genes.tsv", col_names = c("v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9")) %>% 
  filter(v4 > 3400000 & v4 < 4500000 & v3 == "exon") %>% 
  separate (v9, into = c("transcript", "gene"), sep = ";") %>% 
  mutate(gene = as.factor(gene)) %>% group_by(gene, v7) %>% 
  summarize(start = if_else(v7 == "+", min(v4), max(v4)),
            end = if_else(v7 == "+", max(v5), min(v5))) %>% 
  unique() 
csome23_genes$y <- rep(seq(from = 0.03, to = 0.039, by = 0.001), length.out = length(csome23_genes$gene))

chr23_pi_zoom <- ggplot()+
  # geom_rect(data = top2.5[top2.5$Chr_order == "Chr23",], aes(xmin = Window - 25000, xmax = Window + 25000, ymin = 0, ymax = 0.03), fill = "gray70")+
  # geom_rect(data = bottom2.5[bottom2.5$Chr_order == "Chr23",], aes(xmin = Window - 25000, xmax = Window + 25000, ymin = 0, ymax = 0.03), fill = "gray70")+
  geom_point(data= chr23_0.5, aes(x = Window, y = Stat, color = Chr_order)) +
  geom_line(data=chr23_50, aes(x = Window, y = Stat), size = 1) +
  geom_segment(data = csome23_genes, aes( x = start, xend = end, y = y, yend = y), size = 2) +
  scale_color_manual(values = pool_color[23], guide = FALSE)  +
  scale_x_continuous(expand=c(0,0), limits = c(3400000, 4500000))+
  scale_y_continuous(expand=c(0,0), limits = c(0, 0.04))+
  theme_bw()

csome23_genes_compare <- read_tsv("/mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/RagTag_updateGFF/csome_23_genes.tsv", col_names = c("v1", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9")) %>% 
  # filter(v4 > 4500000 & v4 < 5600000 & v3 == "exon") %>% 
  separate (v9, into = c("transcript", "gene"), sep = ";") %>% 
  mutate(gene = as.factor(gene)) %>% group_by(gene, v7) %>% 
  summarize(start = if_else(v7 == "+", min(v4), max(v4)),
            end = if_else(v7 == "+", max(v5), min(v5))) %>% 
  unique() 
csome23_genes_compare$y <- rep(seq(from = 0.03, to = 0.039, by = 0.001), length.out = length(csome23_genes_compare$gene))
tail(csome23_genes_compare)

chr23_pi_zoom_compare <- ggplot()+
  # geom_rect(data = top2.5[top2.5$Chr_order == "Chr23",], aes(xmin = Window - 25000, xmax = Window + 25000, ymin = 0, ymax = 0.04), fill = "gray70")+
  geom_point(data= chr23_0.5, aes(x = Window, y = Stat, color = Chr_order)) +
  geom_line(data=chr23_50, aes(x = Window, y = Stat), size = 1) +
  geom_segment(data = csome23_genes_compare, aes( x = start, xend = end, y = y, yend = y), size = 2) +
  scale_color_manual(values = pool_color[23], guide = FALSE)  +
  scale_x_continuous(expand=c(0,0), limits = c(4500000, 5600000))+
  scale_y_continuous(expand=c(0,0), limits = c(0, 0.04))+
  theme_bw()
chr23_fig <- ggarrange( chr23_pi+theme(axis.title = element_blank()), chr23_pi_zoom+theme(axis.title = element_blank()),chr23_pi_zoom_compare +theme(axis.title = element_blank()), ncol = 1, labels = "AUTO")
chr23_fig_annotate <- annotate_figure(chr23_fig,
                                      bottom = text_grob("Position in Chromosome (bp)"),
                                      left = text_grob("Nucleotide diversity (pi)", rot = 90),
                                      fig.lab = "Pmac_mums_PmacMums_Chr23_zoom", fig.lab.face = "bold",fig.lab.pos = "bottom.left",
) 
ggsave(plot = chr23_pi, "Pmac_mums_PmacMums_chr23_pi_plot.pdf", height = 5, width = 8)
ggsave(plot = chr23_fig_annotate, "Pmac_mums_PmacMums_chr23_pi_zoom.pdf", height = 8, width = 8)

#### gtf ###
Eggnog <- read_tsv("/mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/EggNOG/PmacMums_polished_braker_ragtagScaffolds.gene_name.gene_function.eggNOG.tsv", col_names = c("transcript", "gene_name", "gene_function"))

gtf <- read_tsv("/mnt/griffin/racste/P_macdunnoughii/Pmac_annotations/RagTag_updateGFF/PmacMums_polished_braker_ragtagScaffolds_filtered.gtf", col_names = c("Chr", "v2", "v3", "v4", "v5", "v6", "v7", "v8", "v9")) %>% 
  separate (v9, into = c("transcript", "gene"), sep = ";") %>% mutate(transcript = gsub( "transcript_id \"", "", transcript),
                                                                      transcript = gsub("\"", "", transcript),
                                                                      gene = gsub(" gene_id \"", "", gene),
                                                                      gene = gsub("\"", "", gene),) %>% 
  left_join(Eggnog) %>% 
  mutate(gene = as.factor(gene)) %>% group_by(Chr, gene, v7, transcript, gene_name, gene_function) %>% 
  summarize(start = if_else(v7 == "+", min(v4), max(v4)),
            end = if_else(v7 == "+", max(v5), min(v5)),
            length = end - start) %>% 
  unique() 
head(gtf)

iround <- function(x, interval){
  ## Round numbers to desired interval
  ##
  ## Args:
  ##   x:        Numeric vector to be rounded
  ##   interval: The interval the values should be rounded towards.
  ## Retunrs:
  ##   a numeric vector with x rounded to the desired interval.
  ##
  interval[ifelse(x < min(interval), 1, findInterval(x, interval))]
}
iround(25, 100)
gtf$Window <- iround(gtf$start, seq(0, 15650382, by = 50000))+25000
pi_50k_GO <- gtf %>% left_join(mutate(pi_50k, Chr = gsub("Pmac_v1_", "", Chr)), by = c("Chr","Window")) %>% 
  mutate(outliers = if_else(Stat > min(top2.5$Stat)  & Chr != "Chromosome_1_RagTag", "Upper2.5",if_else( Stat < max(bottom2.5$Stat) & Chr != "Chromosome_1_RagTag", "Lower2.5", "Middle95")),
         outliers2 = if_else(is.na(outliers), "Chr01", outliers))
pi_50k_GO_summ <- pi_50k_GO %>% group_by (Chr_order, Window, outliers2) %>% summarize (n_genes = n(), 
                                                                                       mean_gene_length = mean(abs(length)))

ggplot(pi_50k_GO_summ, aes(x = outliers2, y = n_genes)) +
  geom_violin(trim = TRUE) + 
  geom_boxplot(width = 0.15) +
  theme_bw()

ggplot(pi_50k_GO_summ, aes(x = outliers2, y = mean_gene_length)) +
  geom_violin(trim = TRUE) + 
  geom_boxplot(width = 0.15) +
  theme_bw()


pi_cont <- ggplot() +
  # geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  # geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_line(data = pi_50k, aes(x = position, y = Stat)) + #, color = Chr_order))+
  labs( x= NULL, y = "pi") +
  scale_color_manual(values = pool_color[1:46], guide = FALSE)  +
   scale_x_continuous(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0), breaks = c(0, 0.005, 0.01, 0.015)) +
  theme_bw() +
  theme(strip.background = element_blank(),
        strip.text = element_blank())

theta_cont <- ggplot() +
  # geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  # geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_line(data =  theta_50k, aes(x = position, y = Stat)) + #, color = Chr_order))+
  labs( x= NULL, y = "theta") +
  scale_color_manual(values = pool_color[1:46], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0), breaks = c(0, 0.005, 0.01, 0.015)) +
  theme_bw() +
  theme(strip.background = element_blank(),
        strip.text = element_blank())

D_cont <- ggplot() +
  # geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  # geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_line(data =  D_50k, aes(x = position, y = Stat)) + #, color = Chr_order))+
  labs( x= NULL, y = "Taj. D") +
  scale_color_manual(values = pool_color[1:46], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0), breaks = c(-1, -0.5, 0, 0.5)) +
  theme_bw() +
  theme(strip.background = element_blank(),
        strip.text = element_blank())

pi_theta_D_stacked <- ggarrange(pi_cont, theta_cont, D_cont, ncol = 1, labels = "AUTO", align = "hv")
pi_theta_D_stacked <- annotate_figure(pi_theta_D_stacked,
                                                    bottom = text_grob("Position in genome (bp)"),
                                                    fig.lab = "Pmac_mums_PmacMums_50k_stacked_plot", fig.lab.face = "bold",fig.lab.pos = "bottom.left")
ggsave(plot = pi_theta_D_stacked, "Pmac_mums_PmacMums_pi_theta_D_stacked.pdf", height = 6, width = 30)


pi_sub<- ggplot() +
  # geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  # geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  geom_line(data = pi_50k[pi_50k$Chr_order == "Chr01"|
                            pi_50k$Chr_order == "Chr02"|
                            pi_50k$Chr_order == "Chr03"|
                            pi_50k$Chr_order == "Chr23",], aes(x = Window, y = Stat, color = Chr_order))+
  
  labs( x= NULL, y = expression(pi)) +
  scale_color_manual(values = pool_color[c(1:3,23)], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0), breaks = c(0.0, 4e06, 8e06, 1.2e07))+
  scale_y_continuous( breaks = c(0, 0.005, 0.01, 0.015)) +
  theme_bw(base_size = 15) +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" ) +
  theme(strip.background = element_blank())
theta_sub<- ggplot() +
  # geom_rect(data = top2.5[top2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray70")+
  # geom_rect(data = bottom2.5[bottom2.5$Chr %in% pool_assem_1to6,], aes(xmin = position - 25000, xmax = position + 25000, ymin = 0, ymax = 0.075), color = "gray40")+
  
  geom_line(data = theta_50k[theta_50k$Chr_order == "Chr01"|
                               theta_50k$Chr_order == "Chr02"|
                               theta_50k$Chr_order == "Chr03"|
                               theta_50k$Chr_order == "Chr23",], aes(x = Window, y = Stat, color = Chr_order),linetype = "solid")+
  labs( x= NULL, y = expression(theta)) +
  scale_color_manual(values = pool_color[c(1:3,23)], guide = FALSE)  +
  scale_x_continuous(expand = c(0,0), breaks = c(0.0, 4e06, 8e06, 1.2e07))+
  scale_y_continuous(breaks = c(0, 0.005, 0.01, 0.015)) +
  theme_bw(base_size = 15) +
  facet_grid(~Chr_order, scales = "free_x", space = "free_x" ) +
  theme(strip.background = element_blank(), strip.text = element_blank())


pi_theta_sub_stacked <- annotate_figure(ggarrange(pi_sub, theta_sub, ncol = 1, labels = "AUTO", align="hv"), bottom = text_grob("Position in chromosome (bp)"))
ggsave(plot = pi_theta_sub_stacked, "Pmac_mums_PmacMums_pi_theta_sub_stacked.pdf", height = 6, width = 12)
