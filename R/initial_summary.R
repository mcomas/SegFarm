

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

