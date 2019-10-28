library(tidyverse)
library(igraph)
library(ggraph)

load(
  here::here("2019-10-22_horror-movies/actors-network-metrics.Rdata")
)

# centrality of the network
# centr_degree(net)$centralization
# centr_clo(net)$centralization
# centr_betw(net)$centralization
# centr_eigen(net)$centralization
# > centr_degree(net)$centralization
# [1] 0.001439259
# > centr_clo(net)$centralization
# [1] 4.801063e-05
# > centr_betw(net)$centralization
# [1] 0.08419203
# > centr_eigen(net)$centralization
# [1] 0.9978583

# diameter(net)
# > diameter(net)
# [1] 96

vertex_attr_names(net)
edge_attr_names(net)

# plot(net, edge.arrow.size = 0, edge.label = NA,
#      vertex.label = NA, vertex.size = 1)

actors <- tibble(
  id = V(net)$id,
  actor = V(net)$name,
  indeg = V(net)$indeg,
  indeg_grp_lbl = V(net)$indeg_grp_lbl,
  btwn = V(net)$btwn,
  btwn_grp_lbl = V(net)$btwn_grp_lbl,
  clsns = V(net)$clsns,
  clsns_grp_lbl = V(net)$clsns_grp_lbl,
  pgrank = V(net)$pgrank,
  pgrank_grp_lbl = V(net)$pgrank_grp_lbl,
  cluster = V(net)$cluster
) %>%
  arrange(
    desc(pgrank), desc(btwn), desc(clsns), desc(indeg), actor
  )

top10_actors_by_metric <- bind_rows(
  actors %>%
    arrange(desc(pgrank)) %>%
    top_n(10, pgrank) %>%
    select(
      actor
    ) %>%
    mutate(
      metric = "Page Rank",
      value = row_number()
    ),
  actors %>%
    arrange(desc(indeg)) %>%
    top_n(10, indeg) %>%
    select(
      actor
    ) %>%
    mutate(
      metric = "Incoming Degree",
      value = row_number()
    ),
  actors %>%
    arrange(desc(btwn)) %>%
    top_n(10, btwn) %>%
    select(
      actor
    ) %>%
    mutate(
      metric = "Betweeness",
      value = row_number()
    ),
  actors %>%
    arrange(desc(clsns)) %>%
    top_n(10, clsns) %>%
    select(
      actor
    ) %>%
    mutate(
      metric = "Closeness",
      value = row_number()
    )
)

#
#
# hist(actors$indeg)
# hist(actors$pgrank)
# hist(actors$btwn)
# hist(actors$clsns)
#
# top_pgrank <- induced_subgraph(net,
#                                V(net)$pgrank_grp_lbl == "p100",
#                                impl = "auto")
#
# plot(top_pgrank,
#      edge.arrow.size = 0,
#      edge.label = NA,
#      vertex.label = NA,
#      vertex.size = 20*(V(top_pgrank)$pgrank/max(V(net)$pgrank)),
#      vertex.color = V(top_pgrank)$indeg_grp)
#
#
