library(tidyverse)
library(ggtext)

df <- readRDS("2021-01-26_plastic-pollution/plastic-pollution.rds") %>%
  pivot_longer(
    cols = c(empty, hdpe, ldpe, o, pet, pp, ps, pvc),
    names_to = "type",
    values_to = "qty"
  ) %>%
  group_by(year, continent, type) %>%
  summarise(
    total = sum(qty, na.rm = TRUE)
  ) %>%
  mutate(
    continent = replace_na(continent, "Undefined") %>% as.factor(),
    year = factor(year),
    type = case_when(
      type == "empty" ~ "Not Classified",
      type == "o" ~ "Other",
      TRUE ~ str_to_upper(type)
    )
  )

p1 <- ggplot(
  df,
  aes(x = type, y = total,
      fill = type, color = type)
) +
  geom_col(width = .3) +
  coord_polar() +
  scale_y_log10() +
  facet_grid(year ~ continent, shrink = TRUE, drop = TRUE) +
  labs(
    title = "Profiles of plastic pollutants",
    subtitle = "The *relative amounts of different plastics* are not constant year over year in each continent,<br/>but there are patterns that differ between them (Oceania might be the exception)",
    caption = "2021-01-26 #TidyTuesday dataset // @jmcastagnetto, Jesus M. Castagnetto",
    x = "",
    y = "",
    color = "Type of plastic",
    fill = "Type of plastic"
  ) +
  scale_color_brewer(palette = "Dark2", type = "qual") +
  scale_fill_brewer(palette = "Dark2", type = "qual") +
  ggdark::dark_theme_minimal(26) +
  theme(
    plot.title = element_text(family = "Special Elite", size = 32),
    plot.subtitle = element_textbox(size = 20),
    plot.caption = element_text(family = "Inconsolata"),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    legend.text = element_text(size = 20),
    legend.title = element_text(size = 22),
    legend.background = element_rect(fill = "black", color = "black"),
    legend.position = c(.92, .25)
  )

ggsave(
  p1,
  filename = "2021-01-26_plastic-pollution/plastic-pollution-profiles.png",
  width = 18,
  height = 8.66
)

