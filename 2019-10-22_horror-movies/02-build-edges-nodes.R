library(tidyverse)
library(igraph)

load(
  here::here("2019-10-22_horror-movies/horro-movies.Rdata")
)

nodes <- horror_movies_actor %>%
  select(actor) %>%
  distinct() %>%
  mutate(id = labels(actor)) %>%
  filter(!is.na(actor)) %>%
  select(actor, id)

edges <- horror_movies_actor %>%
  group_by(title) %>%
  mutate(to_actor = lead(actor)) %>%
  ungroup() %>%
  rename(from_actor = actor) %>%
  select(from_actor, to_actor) %>%
  left_join(nodes,
            by = c("from_actor" = "actor")) %>%
  rename(from_id = id) %>%
  left_join(nodes,
            by = c("to_actor" = "actor")) %>%
  rename(to_id = id) %>%
  filter(!is.na(from_actor) & !is.na(to_actor)) %>%
  group_by(from_actor, to_actor, from_id, to_id) %>%
  tally() %>%
  rename(
    weight = n
  ) %>%
  select(from_actor, to_actor, from_id, to_id, weight)
  #select(from_id, to_id, from_actor, to_actor, weight)

net <- graph_from_data_frame(
  d = edges,
  vertices = nodes,
  directed = FALSE
)

save(
    nodes, edges, net,
    file = here::here("2019-10-22_horror-movies/actors-network.Rdata")
)

