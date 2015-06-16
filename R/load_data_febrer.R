library(readxl)
library(lubridate)
library(dplyr)
library(reshape2)
library(stringr)

ROOT = ''
if(exists('Rmd_script')) ROOT = '../'

#Guardies del mes
guard_mes = read_excel(paste0(ROOT, "data/2015-02/OF_Participants_Enq_Guardies_Febrer.xls"), 
                       col_names = c('Dia', 'Num.Of', 'rsocial', 'tel', 'email', 'mun', 'OF.Participant', 'OF.activa'), 
                       col_types = c('date', 'numeric', 'text', 'text', 'text', 'text', 'numeric', 'numeric'), skip=1) %>%
  mutate(Dia = as.Date(Dia))

rel_ofabs = read_excel(paste0(ROOT, "data/Relacio_OF_ABS.xls"), skip=1) %>% setNames( c('count', 'num', 'nom', 'tef', 'abs', 'tipus') )
rel_ofabs = rbind(rel_ofabs,
                  c(NA,126,NA, NA,NA,"Urbanes",  NA,  NA,  NA),
                  c(NA,351,NA, NA,NA,"Semiurbana",  NA,  NA,  NA))

#Dispensacions del mes
res = read_excel(paste0(ROOT, "data/2015-02/Enquesta_guardies_febrer.xls")) %>%
  setNames(c("idenquesta", "OFnum", "data", "hora", "sensedispensacio", "procedencia", "observacions",
             "numproducte", "tipus", "codi", "descripcio", "preu", "receptamedica", "dispensaciourgent",
             "tipusproducte", "criteriurgencia", "numunitats", "grupterapeutic")) %>%
  mutate(
    data = as.Date(data),
    OFnum = as.numeric(OFnum),
    hora2 = as.numeric(str_sub(hora, 1, 2)),
    horari = ifelse( 22 <= hora2 | hora2 <= 8, 'nocturn (22h-9h)', 'diurn (9h-22h)'),
    h = factor(str_sub(hora, 1, 2), levels=sprintf("%02d", c(9:23, 0:8))),
    tipus = rel_ofabs$tipus[match(OFnum, rel_ofabs$num)]
  )
