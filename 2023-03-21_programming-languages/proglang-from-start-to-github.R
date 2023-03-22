library(tidyverse)
library(tidygraph)
library(ggraph)
library(ggh4x)

langs <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-21/languages.csv')

pl <- langs %>%
  filter(type == "pl" & !is.na(github_repo_created)) %>%
  select(
    title,
    number_of_users,
    from = appeared,
    to = github_repo_created
  ) %>%
  mutate(
    from = as.integer(from),
    to = if_else(from > to, from, to) %>%
      as.integer(), # sanity check
    diff = to - from,
    edge_color = case_when(
      number_of_users < 1e5 ~ "grey40",
      number_of_users >= 1e5 & diff >= 10 ~ "darkblue",
      number_of_users >= 1e5 & diff < 10 ~ "lightgreen"
    ),
    edge_width = if_else(number_of_users >= 1e5, 1, .5),
    edge_alpha = if_else(number_of_users >= 1e5, 1, .4),
    title = str_wrap(title, 15)
  ) %>%
  arrange(
    desc(diff)
  )

pl_edges <- tbl_graph(edges = pl, directed = TRUE)

p1 <- ggraph(pl_edges, layout = "linear") +
  geom_edge_link(color = "grey40") + # ugly trick to get a line below the arcs
  geom_edge_arc0(
    aes(color = edge_color,
        width = edge_width,
        alpha = edge_alpha),
    show.legend = FALSE
  ) +
  geom_text(
    data = pl %>% filter(number_of_users >= 1e5),
    aes(x = from, y = -4, label = title),
    angle = 90, size = 7,
    vjust = 0.5,
    hjust = 0
  ) +
  geom_point(
    data = pl %>% filter(number_of_users >= 1e5),
    aes(x = from),
    y = 0,
    size = 5,
    fill = "black",
    shape = 25
  ) +
  scale_x_continuous(
    position = "top",
    breaks = seq(1980, 2020, by = 5),
    minor_breaks = seq(1980, 2022, by = 1)
  ) +
  annotate(
    geom = "text",
    x = 1984,
    y = -.5,
    hjust = 0,
    vjust = 1,
    fontface = "italic",
    family = "Atkinson Hyperlegible",
    label = str_wrap("PHP took quite some time, because it went from CVS, to SVN, to its own git server, and finally a mirror in gihub.", 32),
    size = 6
  ) +
  labs(
    x = "",
    y = "",
    title = "Programming Languages: from start to creation of a github repo",
    subtitle = "Highlighted are programming languages with 100K users of more, and with a github repository",
    caption = "#TidyTuesday 2023-03-21 // @jmcastagnetto@mastodon.social, Jesus Castagnetto"
  ) +
  scale_edge_color_identity() +
  guides(
    x = "axis_minor"
  ) +
  theme_graph(base_family = "Atkinson Hyperlegible") +
  theme(
    plot.title = element_text(size = 34),
    plot.subtitle = element_text(size = 24, color = "grey40"),
    plot.caption = element_text(family = "Inconsolata", face = "plain", size = 18),
    axis.text.x = element_text(size = 24),
    axis.ticks.x = element_line(color = "grey50"),
    axis.ticks.length.x = unit(0.7, "cm"),
    ggh4x.axis.ticks.length.minor = rel(0.3)
  )

ggsave(
  plot = p1,
  filename = "2023-03-21_programming-languages/proglang-start_to_github.png",
  width = 16,
  height = 11
)
