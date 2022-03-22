library(tidyverse)
library(ggbump)

maorinames <- read_csv("https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-03-22/maorinames.csv") %>%
  janitor::clean_names()


y2015 <- maorinames %>%
  filter(year == 2015)

y2016 <- maorinames %>%
  filter(year == 2016 & born == "NZ")

y2016_overseas <- maorinames %>%
  filter(year == 2016 & born == "Overseas")

maori_df <- y2015 %>%
  select(-year, -born, -source) %>%
  rename(rank_2015 = rank) %>%
  full_join(
    y2016 %>%
      select(-year, -born, -source) %>%
      rename(rank_2016 = rank),
    by = c("sex", "name")
  ) %>%
  full_join(
    y2016_overseas %>%
      select(-year, -born, -source) %>%
      rename(rank_2016_overseas = rank),
    by = c("sex", "name")
  ) %>%
  arrange(sex, rank_2015) %>%
  rowwise() %>%
  mutate(
    n_points = sum(
      !is.na(rank_2015),
      !is.na(rank_2016),
      !is.na(rank_2016_overseas)
    )
  ) %>%
  filter(n_points >= 2) %>%
  select(-n_points)

maori_long_df <- maori_df %>%
  pivot_longer(
    cols = c(starts_with("rank_")),
    names_to = "class",
    names_prefix = "rank_",
    values_to = "rank"
  ) %>%
  mutate(
    class = str_replace_all(
      class,
      c(
        "2015" = "2015 NZ",
        "^2016$" = "2016 NZ",
        "2016_overseas" = "2016 Overseas"
      )
    )
  )


mk_bumplot <- function(df, type) {
  txt1 <- df %>%
    filter(class == "2015 NZ")
  txt2 <- df %>%
    filter(class == "2016 NZ")
  txt3 <- df %>%
    filter(class == "2016 Overseas")
  ggplot(
    df,
    aes(x = class, y = rank, group = name, color = name)
  ) +
    geom_bump(size = 2) +
    scale_y_reverse() +
    geom_point(size = 4) +
    geom_text(
      data = txt1,
      aes(label = name),
      nudge_y = 0.4,
      hjust = 1,
      size = 5,
      fontface = "bold",
      color = "white"
    ) +
    geom_text(
      data = txt2,
      aes(label = name),
      nudge_y = 0.4,
      size = 5,
      fontface = "bold",
      color = "white"
    ) +
    geom_text(
      data = txt3,
      hjust = 0,
      aes(label = name),
      nudge_y = 0.4,
      size = 5,
      fontface = "bold",
      color = "white"
    ) +
    annotate(
      geom = "segment",
      x = 0.6,
      y = 16,
      xend = 0.6,
      yend = 3,
      color = "grey70",
      size = 6,
      arrow = arrow(ends = "last",
                    type = "closed",
                    length = unit(2, "line"))
    ) +
    annotate(
      geom = "text",
      x = 0.6,
      y = 2,
      vjust = 0,
      label = "Top\nranked",
      color = "white",
      size = 6,
      fontface = "italic"
    ) +
    ggdark::dark_theme_minimal(base_family = "Lato") +
    theme(
      legend.position = "none",
      axis.line = element_blank(),
      panel.grid = element_blank(),
      axis.ticks = element_blank(),
      axis.text.y = element_blank(),
      axis.text.x = element_text(size = 18, color = "white"),
      panel.background = element_rect(fill = "black", color = "black"),
      plot.background = element_rect(fill = "black"),
      plot.title = element_text(size = 28),
      plot.subtitle = element_text(size = 24, color = "grey80"),
      plot.caption = element_text(family = "Cousine", size = 16)
    ) +
    labs(
      x = "",
      y = "",
      title = glue::glue("Changes in rankings for Maori {type} baby names\nbetween 2015 and 2016 (New Zealand and Overseas)"),
      subtitle = "#TidyTuesday (2022-03-22): \"Baby names\" dataset",
      caption = "@jmcastagnetto, Jesus M. Castagnetto"
    )
}

p1 <- mk_bumplot(
  maori_long_df %>%
    filter(sex == "Male" & !is.na(rank)),
  "male"
)
ggsave(
  p1,
  filename = "2022-03-22_baby-names/rankings-male-maori-names.png",
  width = 12,
  height = 12
)

p2 <- mk_bumplot(
  maori_long_df %>%
    filter(sex == "Female" & !is.na(rank)),
  "female"
)
ggsave(
  p2,
  filename = "2022-03-22_baby-names/rankings-female-maori-names.png",
  width = 12,
  height = 12
)



