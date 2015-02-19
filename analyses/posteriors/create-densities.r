require("RSQLite")
require("ggplot2")

drv <- dbDriver("SQLite")
con <- dbConnect(drv, "samples.sqlite")


data <- dbGetQuery(con, "select sampling_method, (sampling_method || '-' || n_iterations) 
                   as combination, node, _value as parameter  from run where 
                   sampling_method == 'DC' and 
                   variable = 'naturalParam' and
                   n_iterations = '10000'")

p <- ggplot(data, aes(x = parameter))  + 
  geom_density(adjust=1) + 
  scale_x_continuous(limits=c(0, 5)) +
  facet_grid(. ~ node) + 
  theme_bw() +
  coord_flip() +
  xlab("Mean parameter") +
  ylab("Posterior density approximation") +
  theme(strip.background = element_blank(),
        panel.border = element_rect(colour = "black"))
  
ggsave("densities.pdf", p, width = 6, height = 2)

# total n gibbs sweeps: 950
# to transform into # iteration: multiply by 3555

# large run: (950 - 100) * 3555 = 3.02 M ::  iter > 100
# smaller run: (100 - 10) * 3555 = 320 k :: iter > 10 and iter < 101

dataBigGibbs <- dbGetQuery(con, "select sampling_method, (sampling_method || '-3M') 
                   as combination, node, _value as parameter  from run where 
                   sampling_method = 'GIBBS' and 
                   cast(iteration as decimal) > 100 and 
                   variable = 'varSample'")

dataSmallGibbs <- dbGetQuery(con, "select sampling_method, (sampling_method || '-0.3M') 
                   as combination, node, _value as parameter  from run where 
                   sampling_method = 'GIBBS' and 
                   cast(iteration as decimal) > 10 and 
                   cast(iteration as decimal) < 101 and 
                   variable = 'varSample'")

dataOthers <- dbGetQuery(con, "select sampling_method, (sampling_method || '-' || n_iterations) 
                   as combination, node, _value as parameter  from run where 
                   cast(n_iterations as decimal) > 20 and sampling_method != 'GIBBS' and
                   variable = 'varSample'")

data <- rbind(dataBigGibbs,dataSmallGibbs,dataOthers)

data <- as.data.frame(lapply(data,function(x) if(is.character(x)|is.factor(x)) gsub("GIBBS-1000","GIBBS-3M",x) else x))

p <- ggplot(data, aes(x = parameter, colour = sampling_method)) + 
  facet_grid(combination ~ node) + 
  geom_density() + 
  scale_x_continuous(limits=c(0, 2)) + 
  scale_y_continuous(limits=c(0, 10)) +
  theme_bw() +
  xlab("Variance parameter value") +
  ylab("Posterior density approximation") +
  theme(strip.background = element_blank(),
        panel.border = element_rect(colour = "black"))

ggsave("densities-var.pdf", p, width = 10, height = 12)



