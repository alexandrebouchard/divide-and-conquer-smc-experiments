require("RSQLite")
require("ggplot2")

drv <- dbDriver("SQLite")
con <- dbConnect(drv, "logZ.sqlite")

data <- dbGetQuery(con, "select * from run")

p <- ggplot(data, aes(x = factor(n_particles), y = log_zestimate)) +
  geom_boxplot() + #aes(fill = sampling_method)) +
  geom_hline(aes(yintercept=true_log_z)) + 
  ylab("Estimate of log(Z)") +
  xlab("Number of particles (log scale)") +
  theme_bw() + 
  theme(legend.justification=c(1,0), legend.position=c(1,0))

ggsave("logZ-small.pdf", p, width = 7, height = 5)
