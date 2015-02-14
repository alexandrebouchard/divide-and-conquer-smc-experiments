require("RSQLite")
require("ggplot2")

drv <- dbDriver("SQLite")
con <- dbConnect(drv, "timing.sqlite")


data <- dbGetQuery(con, "select coalesce(sampling_method,'STAN') as method, 
                   coalesce(sampling_method,'STAN') || '-' || coalesce(dc_n_particles,n_iteration) as combination,(cast(end_time as decimal) - cast(start_time as decimal))/1000 as run_time_sec from run 
                   where end_time != '[empty]'")



p <- ggplot(data, aes(x = factor(combination), y = run_time_sec, colour = method)) + geom_boxplot()  + coord_flip() + scale_y_log10(breaks=c(60,100,1000,3600,10000,21600),labels=c('1min','100s','1000s','1h','10000s','6h'))


ggsave("timing.pdf", p, width = 7, height = 4)
