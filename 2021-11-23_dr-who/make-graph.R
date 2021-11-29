library(tidyverse)
library(tidygraph)
library(ggraph)

directors <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/directors.csv')
#episodes <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/episodes.csv')
writers <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/writers.csv')
#imdb <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/imdb.csv')

dir_wri <- directors %>%
  full_join(
    writers,
    by = "story_number"
  ) %>%
  left_join(
    episodes %>%
      select(story_number, season_number, episode_number, episode_title, type),
    by = "story_number"
  )

dw <- dir_wri %>%
  group_by(director, writer) %>%
  tally(name = "Times they worked together") %>%
  mutate(
    `Times they worked together` = factor(`Times they worked together`)
  )

dw_graph <- as_tbl_graph(dw)

set.seed(23815)
g1 <- ggraph(dw_graph, layout = "dh") +
  geom_edge_link(aes(color = `Times they worked together`),
                width = 1) +
  geom_node_point() +
  geom_node_label(aes(label = name),
                  repel = TRUE,
                  size = 4,
                  fill = rgb(1, 1, 1, .7),
                  label.size = 0) +
  labs(
    title = "Who worked with Who in \"Dr. Who\" (Directors and Writers)",
    subtitle = "#TidyTuesday \"Dr. Who\" dataset (2021-11-23)",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  scale_edge_color_brewer(palette = "Dark2") +
  theme_graph() +
  theme(
    plot.title = element_text(size = 34),
    plot.subtitle = element_text(color = "grey40", size = 26),
    plot.caption = element_text(family = "Inconsolata", face = "plain", size = 16),
    legend.position = "bottom",
    legend.text = element_text(size = 16)
  )
#g1
ggsave(
  g1,
  filename = "2021-11-23_dr-who/who-worked-with-who.png",
  width = 14,
  height = 14
)
