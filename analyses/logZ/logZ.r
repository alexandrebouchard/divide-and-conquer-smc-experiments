require("RSQLite")
require("ggplot2")

drv <- dbDriver("SQLite")
con <- dbConnect(drv, "logZ.sqlite")

data <- dbGetQuery(con, "select sampling_method, dc_n_particles, estimate from run  where cast(dc_n_particles as decimal) > 10 and model_use_uniform_variance = 'false'")

p <- ggplot(data, aes(x = factor(dc_n_particles), y = estimate)) +
  geom_boxplot(aes(fill = sampling_method)) +
  ylab("Estimate of log(Z)") +
  xlab("Number of particles (log scale)") +
  theme_bw() + 
  theme(legend.justification=c(1,0), legend.position=c(1,0))

ggsave("logZ.pdf", p, width = 7, height = 5)
