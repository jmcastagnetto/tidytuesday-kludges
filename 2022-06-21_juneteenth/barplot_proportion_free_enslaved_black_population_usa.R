library(tidyverse)
library(patchwork)
library(sysfonts)

font_add("Copperplate", "/System/Library/Fonts/Supplemental/Copperplate.ttc")
font_add("PT Mono", "/System/Library/Fonts/Supplemental/PTMono.ttc")


census <- read_csv(
  "https://github.com/rfordatascience/tidytuesday/raw/master/data/2022/2022-06-21/census.csv",
  col_types = cols(
    .default = col_integer(),
    region = col_character(),
    division = col_character()
  )
)

usa <- census %>%
  filter(region == "USA Total") %>%
   select(
    region,
    year,
    black_free,
    black_slaves
  ) %>%
  pivot_longer(
    cols = c(
      black_free,
      black_slaves),
    names_to = "status",
    values_to = "population"
  ) %>%
  mutate(
    status = str_replace(status, "black_", "") %>%
      str_to_sentence()
  )

p_usa <- ggplot(usa, aes(x = year, y = population,
                group = status,
                fill = status)) +
  geom_col(position = "fill") +
  scale_fill_manual(
    values = c(
      "Free" = "lightgreen",
      "Slaves" = "darkred"
    )
  ) +
  ggthemes::theme_few(base_family = "Copperplate") +
  labs(
    x = "",
    y = "",
    subtitle = "Nationwide",
    fill = "Status"
  ) +
  scale_y_continuous(labels = scales::percent) +
  theme(
    plot.subtitle = element_text(color = "grey50", size = 18, face = "bold"),
    legend.position = "top",
    legend.text = element_text(size = 12),
    legend.title = element_text(face = "bold", size = 14)
  )

by_region <- census %>%
  filter(region != "USA Total" & is.na(division)) %>%
  select(
    region,
    year,
    black_free,
    black_slaves
  ) %>%
  pivot_longer(
    cols = c(
      black_free,
      black_slaves),
    names_to = "status",
    values_to = "population"
  ) %>%
  mutate(
    status = str_replace(status, "black_", "") %>%
      str_to_sentence()
  )

p_region <- ggplot(by_region, aes(x = year, y = population,
                group = status,
                fill = status)) +
  geom_col(position = "fill", show.legend = FALSE) +
  scale_fill_manual(
    values = c(
      "Free" = "lightgreen",
      "Slaves" = "darkred"
    )
  ) +
  ggthemes::theme_few(base_family = "Copperplate") +
  labs(
    x = "",
    y = "",
    subtitle = "By region",
    fill = "Status"
  ) +
  scale_y_continuous(labels = scales::percent) +
  facet_wrap(~region) +
  theme(
    plot.subtitle = element_text(color = "grey50", size = 18, face = "bold"),
    strip.text = element_text(size = 14, color = "grey70", face = "bold.italic")
  )

p_combined <- p_usa + p_region +
  plot_annotation(
    title = "Proportion of Free and Enslaved Black Population in USA (1790 - 1870)",
    caption = "Source: #TidyTuesday 2022-06-21\n@jmcastagnetto, Jesus M. Castagnetto"
  ) &
  theme(
    plot.title = element_text(family = "Copperplate", size = 24),
    plot.caption = element_text(family = "PT Mono", size = 14)
  )

ggsave(
  plot = p_combined,
  filename = "2022-06-21_juneteenth/proportion_free_enslaved_black_population_1790_1870.png",
  width = 16,
  height = 8
)
