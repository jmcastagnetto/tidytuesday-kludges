library(tidyverse)
library(igraph)
library(ggraph)

load(
  here::here("2019-08-13_roman-emperors/emperors.Rdata")
)

links_df <- df %>%
  filter(index > 1) %>%
  mutate(
    link_label = paste0("(", cause, ", ", rise, ")")
  ) %>%
  rename(
    from = prev_emperor,
    to = index
  ) %>%
  select(
    from,
    to,
    link_label
  )

nodes_df <- emperors %>%
  mutate(
    node_label = paste0("Name: ", name,
                        "\nDynasty: ", dynasty,
                        "\nEra: ", era),
    shape = ifelse(
      era == "Principate",
      "square",
      "circle"
    )
  ) %>%
  select(
    index,
    name,
    node_label,
    shape,
    cause,
    era,
    dynasty
  )

g <- graph_from_data_frame(links_df,
                           vertices = nodes_df,
                           directed = TRUE)


# Using ggraph
set.seed(1453)
ggraph(g, layout = "graphopt") +
  geom_edge_link2(
    arrow = grid::arrow(ends = "last",
                        type = "open",
                        length = unit(.8, "cm"))) +
  geom_node_label(aes(label = name,
                      color = as.factor(dynasty))) +
  labs(
    title = "A network of roman emperors",
    subtitle = "#TidyTuesday, dataset from 2019-08-13",
    caption = "@jmcastagnetto / Jesus M. Castagnetto",
    color = "Dynasty"
  ) +
  theme_void() +
  theme(

    plot.margin = unit(rep(.5, 4), "cm"),
  )

