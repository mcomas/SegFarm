library(gdata)
library(lubridate)
library(dplyr)
library(reshape2)

guard_mes = read.xls("OF_Guardia_Febrer.xls", encoding= 'latin1', stringsAsFactors = F)
suppressWarnings(rel_ofabs <- read.xls("Relacio_OF_ABS.xls", pattern = "N.Of.", encoding= 'latin1', stringsAsFactors = F))
res = read.xls("Resultats_Enquesta_guardies_novembre_11desembre-2.xls", encoding= 'latin1', stringsAsFactors = F)
guard_mes$Numero.Oficina = as.numeric(gsub(',', '', guard_mes$Numero.Oficina))


res$data = as.Date(res$data, "%Y-%m-%d")
res$tipus = with(rel_ofabs, Tipus.ABS[match(res$OFnum, N.Of.)])

summ = function(.data) summarize(.data,
  'producte' = length(idenquesta), 
  'urgent' = sprintf("%d/%d (%5.2f%%)", sum(criteriurgencia == 'Si'), length(idenquesta), 100*mean(criteriurgencia == 'Si')))

(df.idenquesta <- group_by(res, idenquesta) %>%  summ)

(df.OFnum <- group_by(res, OFnum) %>% summ)

(df.tipus <- group_by(res, tipus) %>% summ)

(df.tipus <- group_by(res, procedencia) %>% summ)

dcast(df.procedencia_tipus <- group_by(res, procedencia, tipus) %>% summ, formula = procedencia~tipus, value.var = 'urgent')


df = group_by(res, data) %>% summarize(
  'n' = length(idenquesta),
  'urgent' = mean(criteriurgencia == 'Si'))

df$day = ifelse(as.POSIXlt(df$data)$wday %in% c(0,6), 'weekend', 'laboral')

nrow( res[res$OFnum %in% unique( res$OFnum[which(is.na(res$tipus))] ),1:4] )


#df = melt(df, id.vars = c('data', 'weekday'))

library(ggplot2)

ggplot(data=df, aes(x=data, y=urgent, col=day)) + geom_point() + theme_bw()

df

