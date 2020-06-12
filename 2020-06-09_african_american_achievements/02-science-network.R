library(tidyverse)
library(tidygraph)
library(ggraph)

load(here::here("2020-06-09_african_american_achievements/african-american-achievements.Rdata"))

science <- science_raw %>%
  select(name, occupation_s) %>%
  rename(
    occupation = occupation_s
  ) %>%
  mutate(
    occupation = occupation %>%
      str_replace(fixed("[citation needed]"), "") %>%
      str_replace("ZoologistexplorerAnthropologist",
                  "Zoologist;explorer;Anthropologist") %>%
      str_replace("Woods Hole Marine Biology Institute ", "") %>%
      str_replace(fixed("chemist (electronics/specialty chemicals)"),
                  "chemist;electronics;specialty chemicals")
  ) %>%
  separate_rows(
    occupation,
    sep = "(and|;)"
  ) %>%
  mutate(
    occupation = str_squish(occupation) %>%
      str_trim() %>%
      str_to_sentence()
  ) %>%
  filter(occupation != "") %>%
  mutate(
    occup_lbl = occupation
  )

nodes <- data.frame(
  node = unique(c(science$name, science$occupation))
) %>%
  mutate(
    node_name = node
  )

g_science <- tbl_graph(
  nodes = nodes,
  edges = science
) %>%
  mutate(
    connections = centrality_degree(mode = "in")
  )

set.seed(20200609)

n_science <- ggraph(
  g_science,
  layout = "dh"
) +
  geom_edge_bend2(aes(color = occup_lbl),
                show.legend = FALSE, width = 2) +
  geom_node_label(aes(label = str_wrap(node_name, 10),
                      size = 6*connections + 3),
                 show.legend = FALSE,
                 alpha = .7) +
  labs(
    title = "A network of contributions by African Americans",
    subtitle = "Source: #TidyTuesday \"African American Achievements\" (2020-06-09)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  theme_graph() +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    plot.caption = element_text(family = "Inconsolata",
                                face = "plain", size = 18),
    plot.title = element_text(size = 48),
    plot.subtitle = element_text(size = 32)
  )

fname <- here::here("2020-06-09_african_american_achievements/network-science-occupations.png")

ggsave(
  plot = n_science,
  filename = fname,
  width = 14,
  height = 10
)

fname_resized <- here::here("2020-06-09_african_american_achievements/network-science-occupations-resized.png")

img <- magick::image_read(fname)
img_resized <- magick::image_scale(img, "20%")
magick::image_write(
  img_resized,
  fname_resized
)
