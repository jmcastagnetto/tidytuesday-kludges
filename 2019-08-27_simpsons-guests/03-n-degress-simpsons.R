library(tidyverse)
library(igraph)
library(visNetwork)
library(networkD3)

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

plot(cl, ug, layout=layout_nicely, vertex.size = 0.5, vertex.label = "")

# estimate node distances
d <- distances(ug)
# get the maximum distance
diameter(ug)

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
  )

ggplot(dist_nodes, aes(x = value)) +
  geom_bar()


# create a visNetwork from igraph

vn <- visIgraph(ug) %>%
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

