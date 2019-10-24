library(tidyverse)
library(igraph)
library(ggraph)

load(
  here::here("2019-10-22_horror-movies/actors-network-metrics.Rdata")
)

vertex_attr_names(net)
edge_attr_names(net)

plot(net, edge.arrow.size = 0, edge.label = NA,
     vertex.label = NA, vertex.size = 1)
