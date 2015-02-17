require("RSQLite")
require("ggplot2")

drv <- dbDriver("SQLite")
con <- dbConnect(drv, "samples.sqlite")


data <- dbGetQuery(con, "select sampling_method, (sampling_method || '-' || n_iterations) 
                   as combination, node, _value as parameter  from run where sampling_method != 'STD' and (
                   (sampling_method = 'STAN' and variable = 'meanSample' and cast(n_iterations as decimal) > 20) or 
                   (sampling_method != 'STAN' and variable = 'naturalParam'))")

p <- ggplot(data, aes(x = parameter, colour = sampling_method))  + geom_density(adjust=1/2) + facet_grid(combination ~ node) + scale_x_continuous(limits=c(0, 5))
  
  ggsave("densities.pdf", p, width = 9, height = 7)


data <- dbGetQuery(con, "select sampling_method, (sampling_method || '-' || n_iterations) 
                   as combination, node, _value as parameter  from run where 
                   cast(n_iterations as decimal) > 20 and 
                   variable = 'varSample'")

data <- as.data.frame(lapply(data,function(x) if(is.character(x)|is.factor(x)) gsub("GIBBS-1000","GIBBS-3M",x) else x))

p <- ggplot(data, aes(x = parameter, colour = sampling_method))  + facet_grid(combination ~ node) + geom_density() + scale_x_continuous(limits=c(0, 2)) + scale_y_continuous(limits=c(0, 10))

ggsave("densities-var.pdf", p, width = 10, height = 12)

con <- dbConnect(drv, "deeper-samples.sqlite")

data <- dbGetQuery(con, "select sampling_method, (sampling_method || '-' || n_iterations) 
                   as combination, node, _value as parameter  from run where 
                   variable = 'naturalParam'")

p <- ggplot(data, aes(x = parameter, colour = sampling_method))  + geom_density(adjust=1/2) + facet_grid(combination ~ node) + scale_x_continuous(limits=c(0, 5))
  
ggsave("densities-deep.pdf", p, width = 49, height = 2)


data <- dbGetQuery(con, "select sampling_method, (sampling_method || '-' || n_iterations) 
                   as combination, node, _value as parameter  from run where 
                   variable = 'varSample'")

p <- ggplot(data, aes(x = parameter, colour = sampling_method))  + facet_grid(combination ~ node) + geom_density() + scale_x_continuous(limits=c(0, 2)) + scale_y_continuous(limits=c(0, 10))


ggsave("densities-var-deep.pdf", p, width = 49, height = 2)


