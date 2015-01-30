library(gdata)
library(lubridate)
library(dplyr)
library(reshape2)
library(stringr)

ROOT = ''
if(exists('Rmd_script')) ROOT = '../'

guard_mes = read.xls(paste0(ROOT, "data/OF_Guardia_novembre-desembre.xls"), encoding= 'latin1', stringsAsFactors = F)
suppressWarnings(rel_ofabs <- read.xls(paste0(ROOT, "data/Relacio_OF_ABS.xls"), pattern = "N.Of.", encoding= 'latin1', stringsAsFactors = F))
res = read.xls(paste0(ROOT, "data/Resultats_Enquesta_guardies_novembre_11desembre-2.xls"), encoding= 'latin1', stringsAsFactors = F)

### Correccions inicials de les taules importades
res$preu = ifelse(res$preu == "", '0', res$preu)
res$preu =  gsub(';', '.', res$preu)
res$preu =  gsub(':', '.', res$preu)
res$preu = as.numeric(res$preu)
guard_mes$OF.núm. = as.numeric(gsub(',', '', guard_mes$OF.núm.))
res$OFnum[res$OFnum == 943] = 94
rel_ofabs = rbind(rel_ofabs,
                  c(NA,126,NA, NA,NA,"Urbanes",  NA,  NA,  NA),
                  c(NA,351,NA, NA,NA,"Semiurbana",  NA,  NA,  NA))

guard_mes$Dia = as.Date(guard_mes$Dia, "%Y-%m-%d")
res$data = as.Date(res$data, "%Y-%m-%d")
hora = as.numeric(str_sub(res$hora, 1, 2))
res$horari = ifelse( 22 <= hora | hora <= 8, 'nocturn (22h-9h)', 'diurn (9h-22h)')
res$h = factor(str_sub(res$hora, 1, 2), levels=sprintf("%02d", c(9:23, 0:8)))

res$tipus = with(rel_ofabs, Tipus.ABS[match(res$OFnum, N.Of.)])