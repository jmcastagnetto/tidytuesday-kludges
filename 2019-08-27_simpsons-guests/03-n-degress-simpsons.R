library(tidyverse)
library(igraph)
library(visNetwork)
library(networkD3)

source("common/my_style.R")
source("common/build_plot.R")

load(
  here::here("2019-08-27_simpsons-guests/simpsons-guests.Rdata")
)

episodes_2plus <- simpsons %>%
  filter(
    number != "M1"
  ) %>%
  mutate(
    season = forcats::as_factor(season)
  ) %>%
  group_by(season, episode_title) %>%
  nest() %>%
  mutate(
    n_guests = purrr::map_dbl(data, ~{length(unique(.x$guest_star))})
  ) %>%
  filter(
    n_guests > 1  # two or more guests
  )

nodes <- episodes_2plus %>%
  unnest(
    cols = c(data)
  ) %>%
  ungroup() %>%
  select(
    guest_star
  ) %>%
  distinct() %>%
  arrange(
    guest_star
  )

edges <- episodes_2plus %>%
  mutate(
    links = purrr::map(data,
                       ~(arrangements::combinations(unique(.x$guest_star),
                                                    2,
                                                    layout = "list")))
  ) %>%
  ungroup() %>%
  purrr::pluck(
    "links"
  ) %>%
  unlist() %>%
  matrix(ncol = 2, byrow = TRUE) %>%
  as_tibble(name_repair = "minimal") %>%
  rename(
    from = V1,
    to = V2
  ) %>%
  distinct()

# generate network graph
ug <- graph_from_data_frame(edges, vertices = nodes, directed = FALSE)

# find the clusters of nodes
cl <- cluster_louvain(ug)
# assign the clusters as colors to the nodes
V(ug)$color = cl$membership

set.seed(20190827)

# estimate node distances
write_graph(
  ug,
  file = here::here("2019-08-27_simpsons-guests/guests-network.graphml")
)

d <- distances(ug)
# get the maximum distance
diameter(ug)

plot(cl, ug, layout=layout_nicely,
     main = "The Simpsons 7 degrees of separation",
     sub = "#TidyTuesday, 2019-08-27 / @jmcastagnetto",
     vertex.size = 0.5, vertex.label = "")

write_graph(ug,
            file = here::here("2019-08-27_simpsons-guests/guests-network.graphml"),
            format = "graphml")

# A plot of the frecuency of inter-guests distances
dist_nodes <- as_tibble(
  d,
  name_repair = "minimal",
  rownames = "From"
) %>%
  pivot_longer(
    cols = 2:ncol(.)
  ) %>%
  filter(
    value > 0 & value != Inf
  ) %>%
  group_by(value) %>%
  summarise(
    freq = n()
  ) %>%
  mutate(
    label = format(freq, big.mark=",")
  )

p1 <- ggplot(dist_nodes, aes(x = as.factor(value), y=freq,
                             label=label, fill = as.factor(freq))) +
  geom_col(show.legend = FALSE) +
  geom_text_repel(nudge_y = 1000,
                  show.legend = FALSE, color = "black") +
  scale_fill_viridis_d(option = "plasma") +
  labs(
    title = "The Simpsons guests are usually 3 steps apart",
    subtitle = "#TidyTuesday, 2019-08-27",
    x = "Distance between guests",
    y = "Number of pairs\nwith a given distance"
  ) +
  jmcastagnetto_style() +
  theme(axis.text.y = element_blank())

pf1 <- build_plot(p1)
pf1

ggsave(
  plot = pf1,
  filename = here::here("2019-08-27_simpsons-guests/guests-in-groups.png")
)

# create a visNetwork from igraph
vn_data <- toVisNetworkData(ug)
vn <- visNetwork(nodes = vn_data$nodes, edges = vn_data$edges,
                 main = "A network view of \"The Simpsons\" guests",
                 submain = "The longest distance between guest is 7 / #TidyTuesday, 2019-08-27 / @jmcastagnetto, Jesus M. Castagnetto") %>%
  visIgraphLayout() %>%
  visOptions(
    highlightNearest = list(enabled = TRUE, hover = TRUE),
    nodesIdSelection = TRUE
  ) %>%
  visInteraction(
    navigationButtons = TRUE
  )

# save interactive viz
visSave(vn,
        file = here::here("2019-08-27_simpsons-guests/visnetwork-interactive.html"),
        selfcontained = TRUE)


# extract the membership of the clusters to group the nodes
members <- membership(cl)
# create a networkD3 from igraph
nd3 <- igraph_to_networkD3(ug, group = members)

popup <- 'alert("You clicked on " + d.name)'

nd3viz <- forceNetwork(Links = nd3$links, Nodes = nd3$nodes,
             Group = "group",
             Source = "source", Target = "target",
             NodeID = "name",
             zoom = TRUE,
             opacity = 1,
             clickAction = popup
             )

saveNetwork(nd3viz,
            file = here::here("2019-08-27_simpsons-guests/networkd3-viz.html"),
            selfcontained = TRUE)

