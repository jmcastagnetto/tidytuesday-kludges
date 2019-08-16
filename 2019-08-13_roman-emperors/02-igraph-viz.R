library(tidyverse)
library(igraph)

load(
  here::here("2019-08-13_roman-emperors/emperors.Rdata")
)

# Using igraph

links_df <- df %>%
  filter(index > 1) %>%
  mutate(
    link_label = paste0("(", cause, ", ", rise, ")")
  ) %>%
  rename(
    from = prev_emperor,
    to = index
  ) %>%
  select(
    from,
    to,
    link_label
  )

nodes_df <- emperors %>%
  mutate(
    node_label = paste0("Name: ", name,
                        "\nDynasty: ", dynasty,
                        "\nEra: ", era),
    shape = ifelse(
      era == "Principate",
      "square",
      "circle"
    )
  ) %>%
  select(
    index,
    name,
    node_label,
    shape,
    cause,
    era,
    dynasty
  )

g <- graph_from_data_frame(links_df,
                           vertices = nodes_df,
                           directed = TRUE)


set.seed(1453)
graph_attr(g, "layout") <- layout_with_graphopt
plot(
  g,
  vertex.label = V(g)$name,
  vertex.label.cex = 1,
  vertex.label.dist = 1,
  vertex.size = 5,
  vertex.label.color = "black",
  vertex.shape = V(g)$shape,
  vertex.color = NA,
  vertex.frame.color = as.factor(V(g)$cause),
  edge.arrow.size = 0.05,
  edge.curved = 0.3,
  main = "A network of Roman emperors (#TidyTuesday, 2019-08-13)",
  sub = "@jmcastagnetto / Jesus M. Castagnetto"
)

set.seed(1453)
clp <- cluster_infomap(g)
graph_attr(g, "layout") <- layout_with_graphopt
plot(
  clp,
  g,
  vertex.label = V(g)$name,
  vertex.label.cex = 1,
  vertex.label.dist = 1,
  vertex.size = 5,
  vertex.label.color = "black",
  vertex.shape = V(g)$shape,
  vertex.color = NA,
  vertex.frame.color = as.factor(V(g)$cause),
  edge.arrow.size = 0.05,
  edge.curved = 0.3,
  main = "A network of Roman emperors (#TidyTuesday, 2019-08-13)",
  sub = "@jmcastagnetto / Jesus M. Castagnetto"
)
