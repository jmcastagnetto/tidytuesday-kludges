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

actors <- tibble(
  id = V(net)$id,
  actor = V(net)$name,
  indeg = V(net)$indeg_std,
  btwn = V(net)$btwn_std,
  clsns = V(net)$clsns_std,
  pgrank = V(net)$pgrank_std
) %>%
  arrange(
    desc(pgrank), desc(btwn), desc(clsns), desc(indeg), actor
  )

hist(actors$indeg)
hist(actors$pgrank)
hist(actors$btwn)
hist(actors$clsns)

top_pgrank <- subgraph(net, V(net)$pgrank_std >= 0.15)

plot(top_pgrank, edge.arrow.size = 0, edge.label = NA,
     vertex.label = NA, vertex.size = 1)

library(ggraph)
ggraph(top_pgrank, layout = "igraph", algorithm = "nicely",
       aes(fill = indeg)) +
  geom_edge_link() +
  geom_node_voronoi()
