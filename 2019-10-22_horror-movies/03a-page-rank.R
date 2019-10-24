library(tidyverse)
library(igraph)

load(
  here::here("2019-10-22_horror-movies/actors-network.Rdata")
)


# page rank

pgrank <- page.rank(net)

save(
  pgrank,
  file = here::here("2019-10-22_horror-movies/pagerank.Rdata")
)
