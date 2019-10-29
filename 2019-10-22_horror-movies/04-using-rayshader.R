library(tidyverse)
library(igraph)
library(ggraph)
library(ggdark)
library(showtext)
library(rayshader)

load(
  here::here("2019-10-22_horror-movies/actors-network-metrics.Rdata")
)

# rayshade the network plot

load(
  here::here("2019-10-22_horror-movies/networkplot.Rdata")
)

plot_gg(p1,
        multicore = TRUE,
        width=6,
        height=6,
        scale=250,
        windowsize=c(1400,866),
        zoom = 0.55, phi = 40, theta = 330, fov = 70)
render_depth(focus = 0.68, focallength = 200)
render_snapshot()

render_movie(
  filename = here::here("2019-10-22_horror-movies/topconnectedactors.mp4"),
  type = "oscillate",
  frames = 180,
  phi = 40, theta = 330,
  zoom = 0.6
)

# make a hex plot to rayshade
# actors <- tibble(
#   id = V(net)$id,
#   actor = V(net)$name,
#   indeg = V(net)$indeg / max(V(net)$indeg),
#   btwn = V(net)$btwn / max(btwn = V(net)$btwn),
#   pgrank = V(net)$pgrank / max(V(net)$pgrank),
#   pgrank_grp = V(net)$pgrank_grp_lbl
# ) %>%
#   arrange(
#     desc(pgrank), desc(btwn), desc(indeg), actor
#   )
#
# p2 <- ggplot(actors, aes(x = pgrank, y = btwn, z = indeg)) +
#   geom_contour() +
#   #geom_hex(bins = 20) +
#   scale_fill_viridis() +
#   theme_minimal()
#   #facet_wrap(~pgrank_grp, scales = "free")
# p2
#
# plot_gg(p2,
#         multicore = TRUE,
#         width=6,
#         height=6,
#         scale=250,
#         windowsize=c(1400,866),
#         zoom = 0.55, phi = 40, theta = 330, fov = 70)

# top10_actors_by_metric <- bind_rows(
#   actors %>%
#     arrange(desc(pgrank)) %>%
#     top_n(10, pgrank) %>%
#     select(
#       actor
#     ) %>%
#     mutate(
#       metric = "Page Rank",
#       value = row_number()
#     ),
#   actors %>%
#     arrange(desc(indeg)) %>%
#     top_n(10, indeg) %>%
#     select(
#       actor
#     ) %>%
#     mutate(
#       metric = "Incoming Degree",
#       value = row_number()
#     ),
#   actors %>%
#     arrange(desc(btwn)) %>%
#     top_n(10, btwn) %>%
#     select(
#       actor
#     ) %>%
#     mutate(
#       metric = "Betweeness",
#       value = row_number()
#     ),
#   actors %>%
#     arrange(desc(clsns)) %>%
#     top_n(10, clsns) %>%
#     select(
#       actor
#     ) %>%
#     mutate(
#       metric = "Closeness",
#       value = row_number()
#     )
# )
