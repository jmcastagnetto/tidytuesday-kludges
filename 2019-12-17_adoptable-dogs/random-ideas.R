library(tidyverse)
library(igraph)
library(tidygraph)
library(ggraph)
library(visNetwork)
library(geofacet)

load(here::here("2019-12-17_adoptable-dogs/datasets-adoptable-dogs.Rdata"))

g <- graph_from_data_frame(top3_breeds_per_state, directed = FALSE)

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

ggplot(top3_breeds_per_state,
       aes(x = fct_reorder(breed_primary, n, .desc = TRUE),
           y = n,
           group = breed_primary,
           fill = breed_primary)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  theme_bw(10) +
  scale_x_discrete(labels = function(s){str_wrap(s, 10)}) +
  theme(
    plot.margin = unit(rep(1, 4), "cm")
  ) +
  facet_geo(~contact_state, scales = "free")


