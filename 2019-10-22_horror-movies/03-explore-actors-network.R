library(tidyverse)
library(igraph)

load(
  here::here("2019-10-22_horror-movies/actors-network.Rdata")
)

load(
  here::here("2019-10-22_horror-movies/actors-network-metrics.Rdata")
)

# centrality of the network
centr_degree(net)$centralization
centr_clo(net)$centralization
centr_betw(net)$centralization
centr_eigen(net)$centralization

# > centr_degree(net)$centralization
# [1] 0.001439259
# > centr_clo(net)$centralization
# [1] 4.801063e-05
# > centr_betw(net)$centralization
# [1] 0.08419203
# > centr_eigen(net)$centralization
# [1] 0.9978583

diameter(net)

# > diameter(net)
# [1] 96

cl <- components(net)
V(net)$cluster = cl$membership
