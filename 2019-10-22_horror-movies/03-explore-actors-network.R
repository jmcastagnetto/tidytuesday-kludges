library(tidyverse)
library(igraph)

load(
  here::here("2019-10-22_horror-movies/actors-network.Rdata")
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
cliq <- largest_cliques(net)

# calculate connections for each node
V(net)$indeg <- degree(net)
V(net)[V(net)$indeg == max(V(net)$indeg)]

connected_actors <- tibble(
  id = V(net)$id,
  actor = V(net)$name,
  connections = V(net)$indeg
) %>%
  arrange(desc(connections), actor)

# vertex betweenness
V(net)$btwn <- betweenness(net)

btwn_actors <- tibble(
  id = V(net)$id,
  actor = V(net)$name,
  btwn = V(net)$btwn
) %>%
  arrange(desc(btwn), actor)

E(net)$btwn <- edge_betweenness(net)

edge_btwns <- tibble(
  edge = attr(E(net), "vnames"),
  btwn = E(net)$btwn
) %>%
  rownames_to_column() %>%
  arrange(
    desc(btwn), edge
  )

# closeness
V(net)$clsns <- closeness(net)

clsns_actors <- tibble(
  id = V(net)$id,
  actor = V(net)$name,
  clsns = V(net)$clsns
) %>%
  arrange(desc(clsns), actor)

# page rank

#V(net)$pgrank <- page.rank(net)
#
#pgrank_actors <- tibble(
#  id = V(net)$id,
#  actor = V(net)$name,
#  pgrank = V(net)$pgrank
#)

load(
  here::here("2019-10-22_horror-movies/pagerank.Rdata")
)

V(net)$pgrank = pgrank[[1]]

pgrank_actors <- tibble(
  id = V(net)$id,
  actor = V(net)$name,
  pgrank = V(net)$pgrank
)

save(
  cliq, cl, net, connected_actors, btwn_actors,
  clsns_actors, edge_btwns,
  pgrank_actors,
  file = here::here("2019-10-22_horror-movies/actors-network-metrics.Rdata")
)

write_graph(
  net,
  file = here::here("2019-10-22_horror-movies/horror-movies-actors-network.graphml"),
  format = "graphml"
)


write_graph(
  net,
  file = here::here("2019-10-22_horror-movies/horror-movies-actors-network.dot"),
  format = "dot"
)
