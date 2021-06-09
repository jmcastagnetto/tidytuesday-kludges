library(tidyverse)
library(ggforce)
library(cowplot)
library(units)

replace_vector <- c(
  "Amercian Eel" = "American Eel",
  "Bullheads" = "Bullhead",
  "Channel catfish" = "Channel Catfish",
  "Chubs" = "Chub",
  "chubs" = "Chub",
  "Crappies" = "Crappie",
  "Lake Trout - siscowet" = "Lake Trout",
  "Pacific salmon" = "Pacific Salmon",
  "White bass" = "White Bass"
)

fishing <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/fishing.csv') %>%
  mutate(
    species = str_replace_all(species, pattern = replace_vector) %>%
      str_replace(fixed(" and "), ",")
  )

fish_df <- fishing %>%
  select(year, lake, species, grand_total) %>%
  distinct() %>%
  mutate(
    lake = paste0("Lake ", lake)
  ) %>%
  group_by(year, lake) %>%
  summarise(
    total = (sum(grand_total, na.rm = TRUE) * 1000) %>%
      set_units(pounds)
  ) %>%
  mutate(
    decade = as.character((year %/% 10) * 10)
  ) %>%
  ungroup()

median_df <- fish_df %>%
  group_by(decade, lake) %>%
  summarise(median = median(total)) %>%
  ungroup()

pantone_lake_blue <- rgb(0, 142 / 255, 154 / 255, .5)

p1 <- ggplot(
  fish_df %>% filter(lake != "Lake Michigan"),
  aes(x = decade, y = total, group = decade)
) +
  geom_boxplot(outlier.size = .5, outlier.colour = "red", varwidth = TRUE) +
  geom_line(
    data = median_df %>% filter(lake != "Lake Michigan"),
    aes(x = decade, y = median, group = lake),
    color = "blue",
    inherit.aes = FALSE
  ) +
  scale_y_unit(name = "Total",
               unit = "metric_ton",
               labels = scales::comma) +
  facet_wrap(~lake, scales = "free_y") +
  theme_linedraw(14) +
  theme(
    plot.title.position = "plot",
    plot.title = element_text(size = 32),
    plot.subtitle = element_text(color = "grey40", size = 24),
    plot.caption = element_text(family = "Inconsolata", size = 16),
    strip.text = element_text(size = 16, color = "black"),
    strip.background = element_rect(fill = pantone_lake_blue),
    axis.text.x = element_text(angle = 90, vjust = .5)
  ) +
  labs(
    x = "Decade",
    title = "Historical total observed fish weight in the lakes",
    subtitle = "Weight in metric tons - #TidyTuesday 2021-06-08, Commercial Fishing dataset",
    caption = "@jmcastagnetto, Jesus M. Castagnetto."
  )

txt <- "Every lake has had a very different history in terms of the observed fish weight, and nowadays they have fallen from their best figures. Lake Erie peaked in the 1950s-1960s, and again in the 1980s. Lake Huron had its best in the 1890s, whereas Lake Ontario had a good decade in the 1920s and Lake Superior did the same in the 1930s. Lake Saint Clair, which has the smallest volume of fish peaked in the 1890s and again in the 1950s."

pcombined <- ggdraw(p1) +
  draw_label(
    str_wrap(txt, 35),
    x = .7,
    y = .4,
    hjust = 0,
    vjust = 1,
    fontfamily = "GnuTypewriter",
    size = 16
  )

ggsave(
  plot = pcombined,
  filename = "2021-06-08_commercial-fishing/fish-weight-in-lakes.png",
  width = 16.5,
  height = 9
)
