library(gdata)
library(lubridate)
library(dplyr)
library(reshape2)
library(stringr)

ROOT = ''
if(exists('Rmd_script')) ROOT = '../'

#Guardies del mes
guard_mes = read.xls(paste0(ROOT, "data/2015-02/OF_Participants_Enq_Guardies_Febrer.xls"), encoding='latin1', stringsAsFactors = F)
guard_mes = guard_mes %>% mutate(
  Dia = as.Date(Dia, "%Y-%m-%d"))


rel_ofabs <- read.xls(paste0(ROOT, "data/Relacio_OF_ABS.xls"), pattern = "N.Of.", encoding= 'latin1', stringsAsFactors = F)
rel_ofabs = rbind(rel_ofabs,
                  c(NA,126,NA, NA,NA,"Urbanes",  NA,  NA,  NA),
                  c(NA,351,NA, NA,NA,"Semiurbana",  NA,  NA,  NA))
#Dispensacions del mes
res = read.xls(paste0(ROOT, "data/2015-02/Enquesta_guardies_febrer.xls"), encoding= 'latin1', stringsAsFactors = F)
res = res %>% mutate(
  data = as.Date(data, "%Y-%m-%d"),
  hora = as.numeric(str_sub(hora, 1, 2)),
  horari = ifelse( 22 <= hora | hora <= 8, 'nocturn (22h-9h)', 'diurn (9h-22h)'),
  h = factor(str_sub(res$hora, 1, 2), levels=sprintf("%02d", c(9:23, 0:8))),
  tipus = rel_ofabs$Tipus.ABS[match(OFnum, rel_ofabs$N.Of.)])

