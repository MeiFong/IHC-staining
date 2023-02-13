
library(tidyverse)
library(data.table)
library(readxl)

setwd("L:/Lab_GlenB/Mei Fong/Experiments/Mouse work/Histology/pErk")

Erk <- read_xlsx("pErk data.xlsx", skip = 1) %>%
  rename(group = '...1') %>%
  select("group", "MM649", "MM96L") %>%
  separate(group, c("ID", "group"), sep = " ") %>%
  replace_na(list(group = 'C')) %>%
  mutate(Percent_MM649 = MM649*100,
         Percent_MM96L = MM96L*100) %>%
  mutate(group = factor(group, levels = c("C", "D")))

library(lmtest)
library(emmeans)

analysis <- function(a, b) {
  model <- lm(log(b) ~ ID*group, data = a)
  
  margin <- emmeans(model, ~ ID*group, type = "response" ) 
  
  c <- contrast(margin, method= "revpairwise", by="ID", adjust = "none", infer =T) %>%  # adjust= for p-value adjustment
    as.data.frame()
  
  filename <- paste0(deparse(substitute(b)), "_vsControl.csv")
  write.csv(c, filename, row.names =F)
  
  d <- contrast(margin, "revpairwise", interaction = TRUE, adjust = "none") %>% # 
    as.data.frame()
  
  filename2 <- paste0(deparse(substitute(b)), "_vsGroup.csv")
  write.csv(d, filename2, row.names =F)
  
  return(list(c, d))
}

Erk_MM649 <- analysis(Erk, Erk$Percent_MM649)
Erk_MM96L <- analysis(Erk, Erk$Percent_MM96L)

setwd("L:/Lab_GlenB/Mei Fong/Experiments/Mouse work/Histology/pFAK")

FAK <- read_xlsx("pFAK data.xlsx", skip = 1) %>%
  rename(group = '...1') %>%
  select("group", "MM649", "MM96L") %>%
  separate(group, c("ID", "group"), sep = " ") %>%
  replace_na(list(group = 'C')) %>%
  mutate(Percent_MM649 = MM649*100,
         Percent_MM96L = MM96L*100) %>%
  mutate(group = factor(group, levels = c("C", "D")))

FAK_MM649 <- analysis(FAK, FAK$Percent_MM649)
FAK_MM96L <- analysis(FAK, FAK$Percent_MM96L)