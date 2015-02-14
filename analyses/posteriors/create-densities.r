require("RSQLite")
require("ggplot2")

drv <- dbDriver("SQLite")
con <- dbConnect(drv, "samples.sqlite")


data <- dbGetQuery(con, "select sampling_method, (sampling_method || '-' || n_iterations) 
                   as combination, node, _value as parameter  from run where sampling_method != 'STD' and (
                   (sampling_method = 'STAN' and variable = 'meanSample') or 
                   (sampling_method != 'STAN' and variable = 'naturalParam'))")

p <- ggplot(data, aes(x = parameter, colour = sampling_method))  + geom_density(adjust=1/2) + facet_grid(combination ~ node) + scale_x_continuous(limits=c(0, 5))
  
  

ggsave("densities.pdf", p, width = 9, height = 7)
