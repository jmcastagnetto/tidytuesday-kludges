library(tidyverse)
library(igraph)
library(ggraph)
library(ggdark)
library(showtext)

font_add_google("Lakki Reddy", "lred")
font_add_google("Amita", "amita")
showtext_auto()

load(
  here::here("2019-10-22_horror-movies/actors-network-metrics.Rdata")
)

vertex_attr_names(net)
edge_attr_names(net)

V(net)$pgrank_scaled <- V(net)$pgrank / max(V(net)$pgrank)

top_nodes_pgrank <- ego(
  graph = net,
  order = 1,
  nodes = (V(net)$pgrank_scaled >= 0.3),
  mode = "all"
) %>%
  unlist() %>%
  unique()

top_nodes_graph <- induced_subgraph(
  graph = net,
  vids = top_nodes_pgrank,
  impl = "auto"
)

V(top_nodes_graph)$label <- ifelse(
  V(top_nodes_graph)$pgrank_scaled > 0.5,
  V(top_nodes_graph)$name,
  ""
)

# plot(
#   top_nodes_graph,
#   edge.arrow.size = 0,
#   edge.label = NA,
#   vertex.label = NA,
#   vertex.size = V(top_nodes_graph)$pgrank_scaled * 10,
#   vertex.color = V(top_nodes_graph)$pgrank_grp
# )

p1 <- ggraph(top_nodes_graph, layout = "igraph", algorithm = "nicely") +
  geom_edge_arc(alpha = 0.3, color = "yellow") +
  geom_node_point(aes(size = pgrank_scaled * 5,
                      color = pgrank_scaled * 5),
                  show.legend = FALSE) +
  geom_node_text(aes(label = label), size = 10) +
  labs(
    title = "The invasion of the connected actors!!!",
    subtitle = "Actors scored by PageRank (shown ~1000), top 10 shown.",
    caption = "#TidyTuesday, 2019-10-22 -- Horror movies dataset //  @jmcastagnetto, Jesus M. Castagnetto"
  ) +
  dark_theme_minimal() +
  theme(
    plot.title = element_text(family = "lred", size = 64),
    plot.subtitle = element_text(family = "lred", size = 42),
    plot.caption = element_text(family = "amita", size = 28),
    plot.margin = unit(rep(1, 4), "cm"),
    panel.grid = element_blank(),
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.title = element_blank()
  )
p1
ggsave(
  filename = here::here("2019-10-22_horror-movies/topconnectedactors.png"),
  width = 6,
  height = 6
)

save(
  p1,
  file = here::here("2019-10-22_horror-movies/networkplot.Rdata")
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
#
#
# hist(actors$indeg)
# hist(actors$pgrank)
# hist(actors$btwn)
# hist(actors$clsns)
