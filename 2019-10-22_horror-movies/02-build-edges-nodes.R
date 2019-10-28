library(tidyverse)
library(igraph)

load(
  here::here("2019-10-22_horror-movies/horror-movies.Rdata")
)

actors <- horror_movies_actor %>%
  select(actor) %>%
  distinct()

nodes <- horror_movies_actor %>%
  select(actor) %>%
  distinct() %>%
  mutate(id = labels(actor)) %>%
  filter(!is.na(actor)) %>%
  select(actor, id) %>%
  arrange(actor)

edges <- horror_movies_actor %>%
  group_by(title) %>%
  mutate(to_actor = lead(actor)) %>%
  ungroup() %>%
  rename(from_actor = actor) %>%
  select(from_actor, to_actor, title, release_yr, release_country) %>%
  left_join(nodes,
            by = c("from_actor" = "actor")) %>%
  rename(from_id = id) %>%
  left_join(nodes,
            by = c("to_actor" = "actor")) %>%
  rename(to_id = id) %>%
  filter(!is.na(from_actor) & !is.na(to_actor)) %>%
  group_by(from_actor, to_actor, from_id, to_id, title, release_yr, release_country) %>%
  tally() %>%
  rename(
    weight = n
  )

net <- graph_from_data_frame(
  d = edges,
  vertices = nodes,
  directed = FALSE
)

vertex_attr_names(net)
edge_attr_names(net)

#-- Add attributes to network

# calculate connections for each node
V(net)$indeg <- degree(net)
#V(net)[V(net)$indeg == max(V(net)$indeg)]
#hist(V(net)$indeg)
qt <- quantile(V(net)$indeg, probs = seq(0.8, 1, .1))
V(net)$indeg_grp = cut(V(net)$indeg,
                       breaks = c(0, qt))
V(net)$indeg_grp_lbl = case_when(
  V(net)$indeg_grp == 1 ~ "p80",
  V(net)$indeg_grp == 2 ~ "p90",
  V(net)$indeg_grp == 3 ~ "p100"
  )

connected_actors <- tibble(
  id = V(net)$id,
  actor = V(net)$name,
  connections = V(net)$indeg,
  conn_grp = V(net)$indeg_grp,
  conn_grp_lbl = V(net)$indeh_grp_lbl
) %>%
  arrange(desc(connections), actor)

# vertex betweenness
V(net)$btwn <- betweenness(net)
hist(V(net)$btwn)
qt <- quantile(V(net)$btwn, probs = seq(0.2, 1, .2))
V(net)$btwn_grp = cut(V(net)$btwn,
                       breaks = c(0, qt))
V(net)$btwn_grp_lbl = paste0("p", V(net)$btwn_grp * 20)

btwn_actors <- tibble(
  id = V(net)$id,
  actor = V(net)$name,
  btwn = V(net)$btwn,
  btwn_grp = V(net)$btwn_grp,
  btwn_grp_lbl = V(net)$btwn_grp_lbl
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
hist(V(net)$clsns)
qt <- quantile(V(net)$clsns, probs = seq(0, 1, .2))
V(net)$clsns_grp = cut(V(net)$clsns,
                      breaks = c(0, qt))
V(net)$clsns_grp_lbl = paste0("p", (V(net)$clsns_grp - 1)*20)

clsns_actors <- tibble(
  id = V(net)$id,
  actor = V(net)$name,
  clsns = V(net)$clsns,
  clsns_grp = V(net)$clsns_grp,
  clsns_grp_lbl = V(net)$clsns_grp_lbl
) %>%
  arrange(desc(clsns), actor)


# page rank
V(net)$pgrank <- page.rank(net)[[1]]
hist(V(net)$pgrank)
qt <- quantile(V(net)$pgrank, probs = seq(.2, 1, .2))
V(net)$pgrank_grp = cut(V(net)$pgrank,
                       breaks = c(0, qt))
V(net)$pgrank_grp_lbl = paste0("p", V(net)$pgrank_grp*20)

pgrank_actors <- tibble(
 id = V(net)$id,
 actor = V(net)$name,
 pgrank = V(net)$pgrank,
 pgrank_grp = V(net)$pgrank_grp,
 pgrank_grp_lbl = V(net)$pgrank_grp_lbl
)

# clusters
cl <- components(net)
V(net)$cluster = cl$membership
cl_df <- as.data.frame(table(cl$membership)) %>%
  rename(
    cluster = 1,
    qty = 2
  ) %>%
  arrange(desc(qty)) %>%
  mutate(
    csum = cumsum(qty),
    cpct = csum / sum(qty)
  )


save(
  nodes, edges, net,
  net, connected_actors, btwn_actors,
  clsns_actors, edge_btwns,
  pgrank_actors, cl_df,
  file = here::here("2019-10-22_horror-movies/actors-network-metrics.Rdata")
)

write_graph(
  net,
  file = here::here("2019-10-22_horror-movies/horror-movies-actors-network.graphml"),
  format = "graphml"
)
