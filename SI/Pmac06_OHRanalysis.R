setwd(dir = "OneDrive/Pmacdunnoughii_genome/")

library(tidyverse)
library(ggsci)
library(ggpubr)
library(ggforce)
library(ggbeeswarm)
library(RColorBrewer)

mypal <- pal_nejm()(8) %>% str_sub(start = 1, end = 7)

#### OHR analysis ####
OHR_colnames <- c("protID", "dbID", "protLen", "dbHits", "OHRsum", "OHRlongest", "Identity")
bmori2pmacpol <- read_table2(file = "OHR_analysis/Bmori90_v_Pmac000.1_polished_braker_goodTranscripts_AA_cd90.blasttab", col_names = OHR_colnames, skip = 1) %>% mutate(genome = "Ind_pol")
bmori2pmacunpol <- read_table2(file = "OHR_analysis/Bmori90_v_Pmac000.1_unpolished_braker_goodTranscripts_AA_cd90.blasttab", col_names = OHR_colnames, skip = 1) %>% mutate(genome = "unpol")
bmori2pmacmums <- read_table2(file = "OHR_analysis/Bmori90_v_PmacMums_polished_braker_goodTranscripts_AA_cd90.blasttab", col_names = OHR_colnames, skip = 1) %>% mutate(genome = "Mums_pol")

full <- union(bmori2pmacpol, bmori2pmacmums) %>% union(bmori2pmacunpol) %>% mutate(genome = factor(genome, levels = c("unpol", "Ind_pol", "Mums_pol")))
summary(full)

full %>% group_by(genome) %>% summarize(medianOHR =  median(OHRlongest),
                                        medianID =  median(Identity),
                                        OHR95 = sum(OHRlongest>0.95),
                                        ID95 = sum(Identity>95))

my_comparisons <- list(c("unpol", "Mums_pol"), c("unpol", "Ind_pol"),  c("Ind_pol", "Mums_pol"))

OHRlongest_box <- ggplot(full, aes(x = genome, y = OHRlongest)) +
  geom_boxplot(aes(color = genome, fill = genome), alpha = 0.25, size = 0.5) +
  scale_color_manual(values = mypal[c(2,1,3)], guide = FALSE) +
  scale_fill_manual(values = mypal[c(2,1,3)], guide = FALSE) +
  scale_x_discrete(labels= c("Unpolished", "Individual\npolished", "Pool\npolished")) +
  labs(y = "OHR of longest ortholog", x = "Assembly") +
  theme_bw() +theme(panel.grid = element_blank()) +
  stat_compare_means(comparisons = my_comparisons[3:1], ) +
  stat_compare_means(label.y = 1.5)
OHRlongest_box
ggsave(plot = OHRlongest_box, file = "OHR_analysis/Bmori_v_Pmacdb_OHR_plots.pdf", height = 5, width = 4)


full_sum <- full %>% group_by(genome) %>% summarise(n = n(), 
                                                    n_90_longest = sum(OHRlongest > 0.95), 
                                                    n_90_sum = sum(OHRsum > 0.90), 
                                                    n_50_id= sum(Identity > 90))

full_sub <- full %>% select(genome, protID,OHRlongest) %>% 
  spread(key = genome, value = OHRlongest) 
p1 <- ggplot(full_sub, aes(x = unpol)) + 
  geom_jitter(aes(y = Ind_pol), method = "lm", size = 0.5, color = mypal[1], alpha = .5, width = 0.005, height = 0.005) +
  geom_jitter(aes(y = Mums_pol), method = "lm", size = 0.5, color = mypal[3], alpha = .5, width = 0.005, height = 0.005) +
  geom_abline(slope = 1, intercept = 0.05, linetype = "dashed") +
  geom_abline(slope = 1, intercept = -0.05, linetype = "dashed") +
  labs(y = "OHR of longest ortholog\nin polished assembly", x = "OHR of longest ortholog\n in upolished assembly") +
  theme_bw() +theme(panel.grid = element_blank())
p1
full_sub <- full %>% select(genome, protID,OHRlongest) %>% 
  spread(key = genome, value = OHRlongest) %>% 
  gather(key = genome, value = OHRlongest, -c(protID, unpol)) %>% 
  mutate(pol_effect = OHRlongest-unpol) %>% 
  filter(pol_effect>0.05)

p2 <- ggplot(na.omit(full_sub), aes(x = genome, y = pol_effect)) + 
  geom_quasirandom(aes(color = genome, fill = genome), alpha = 0.25, size = 0.5) +
  scale_color_manual(values = mypal[c(1,3)], guide = FALSE) +
  scale_fill_manual(values = mypal[c(1,3)], guide = FALSE) +
  scale_x_discrete(labels= c("Individual\npolished", "Pool\npolished")) +
  labs(y = expression(Delta ~OHR), x = "Assembly") +
  theme_bw() +theme(panel.grid = element_blank()) +
  stat_compare_means(label.y = 1)
p2
full_sub <- full %>% select(genome, protID,OHRlongest) %>% 
  spread(key = genome, value = OHRlongest) %>% 
  gather(key = genome, value = OHRlongest, -c(protID, unpol)) %>% 
  mutate(pol_effect = OHRlongest-unpol) %>% 
  filter(pol_effect< -0.05)
length(unique(full_sub$protID))
546/13599 

p3 <- ggplot(full_sub, aes(x = genome, y = pol_effect)) + 
  geom_quasirandom(aes(color = genome, fill = genome), alpha = 0.25, size = 0.5) +
  scale_color_manual(values = mypal[c(1,3)], guide = FALSE) +
  scale_fill_manual(values = mypal[c(1,3)], guide = FALSE) +
  scale_x_discrete(labels= c("Individual\npolished", "Pool\npolished")) +
  labs(y = expression(Delta ~OHR), x = "Assembly") +
  theme_bw() +theme(panel.grid = element_blank()) +
  stat_compare_means(label.y =0)

full_sub <- full %>% select(genome, protID,OHRlongest) %>% 
  spread(key = genome, value = OHRlongest) %>% 
  gather(key = genome, value = OHRlongest, -c(protID, unpol)) %>% 
  mutate(pol_effect = OHRlongest-unpol) %>% 
  filter(pol_effect>= -0.01 & pol_effect <= 0.01)
length(unique(full_sub$protID))
11526/13599 
10451/13599

panel2 <- ggarrange(p1,ggarrange(p2 +theme(axis.title.x = element_blank()),p3, nrow =2, widths = c(1, 1), labels = c("B", "C"), align = "hv"), labels = c("A", NA), widths = c(1,0.5) )
panel2
ggsave(plot = panel2, file = "OHR_analysis/Bmori_v_Pmacdb_OHR_plots2.pdf", height = 6, width = 9)
OHRlongest_box

panel3 <- ggarrange(OHRlongest_box,p1,ggarrange(p2 +theme(axis.title.x = element_blank()),p3, nrow =2, widths = c(1, 1), labels = c("C", "D"), align = "hv"), nrow = 1, labels = c("A","B", NA), widths = c(0.5,1,0.5) )
panel3
ggsave(plot = panel3, file = "OHR_analysis/Bmori_v_Pmacdb_OHR_plots3.pdf", height = 6, width = 12)

