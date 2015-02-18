require("RSQLite")
require("ggplot2")

drv <- dbDriver("SQLite")
con <- dbConnect(drv, "timing.sqlite")


data <- dbGetQuery(con, "select coalesce(sampling_method,'STAN') as sampling_method, 
                   coalesce(sampling_method,'STAN') || '-' || coalesce(dc_n_particles,n_iteration) as combination,(cast(end_time as decimal) - cast(start_time as decimal))/1000 as run_time_sec from run 
                   where end_time != '[empty]'")

sampling_method <- c('GIBBS', 'STAN')
combination <- c('GIBBS-3M', 'STAN-200000')
run_time_sec <- c(21600,708189)

gibbs.time <- data.frame(sampling_method, combination, run_time_sec)
data <- rbind(data, gibbs.time)

p <- ggplot(data, aes(x = combination, y = run_time_sec, colour = sampling_method)) + 
  geom_boxplot()  + 
  coord_flip() + 
  scale_y_log10(breaks=c(60,100,1000,3600,10000,86400),labels=c('1min','100s','1000s','1h','10000s','1d')) +
  ylab("Wall-clock time (log scale)") +
  xlab("Algorithm configuration") +
  theme_bw() +
  theme(
    panel.grid.minor = element_blank()
  )

ggsave("timing.pdf", p, width = 10, height = 4)
