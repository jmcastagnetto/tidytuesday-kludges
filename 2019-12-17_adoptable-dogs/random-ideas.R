library(igraph)
library(tidygraph)
library(ggraph)
library(visNetwork)

g <- graph_from_data_frame(breeds_per_state, directed = FALSE)

V(g)$group <- c(rep("State", 51), rep("Breed", 216))
E(g)$value <- E(g)$n

visIgraph(g,
          layout = "layout_in_circle",
          physics = FALSE) %>%
 visOptions(nodesIdSelection = TRUE) %>%
 # visOptions(highlightNearest = list(enabled = T,
  #                                   degree = 1,
   #                                  hover = T),
    #         nodesIdSelection = T) %>%
  visNodes(size = 10) %>%
  visGroups(groupname = "State", color = "yellow") %>%
  visGroups(groupname = "Breed", color = "lightblue") %>%
  visLegend()

