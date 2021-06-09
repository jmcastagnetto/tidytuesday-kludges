library(tidyverse)

fishing <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-08/fishing.csv')

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

fish_df <- fishing %>%
  select(year, species, lake) %>%
  distinct() %>%
  mutate(
    species = str_replace_all(species, pattern = replace_vector) %>%
      str_replace(fixed(" and "), ",")
  ) %>%
  separate_rows(
    species,
    sep = ","
  ) %>%
  group_by(year, lake) %>%
  summarise(
    n_species = n_distinct(species, na.rm = TRUE)
  )

p1 <- ggplot(
  fish_df,
  aes(x = year, y = n_species, color = lake)
) +
  geom_jitter(size = .5, width = .2, height = .2) +
  geom_smooth(method = "gam", se = FALSE) +
  scale_color_brewer(type = "qual", palette = "Dark2") +
  labs(
    y = "Number of different species",
    x = "",
    color = "Lakes",
    title = "How the number of species described changed in each lake",
    subtitle = "#TidyTuesday 2021-06-08, Commercial Fishing dataset",
    caption = "@jmcastagnetto, Jesus M. Castagnetto."
  ) +
  ggthemes::theme_tufte(base_size = 18) +
  theme(
    legend.position = c(.1, .7),
    legend.text = element_text(size = 14),
    plot.subtitle = element_text(color = "grey40")
  )

ggsave(
  plot = p1,
  filename = "2021-06-08_commercial-fishing/number-of-species-in-lakes.png",
  width = 9,
  height = 6
)

