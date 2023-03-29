library(tidyverse)
library(sf)
library(rnaturalearth)

timezones <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-28/timezones.csv')

transitions <- read_csv(
  'https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2023/2023-03-28/transitions.csv',
  col_types = cols(
    zone = col_character(),
    begin = col_datetime(),
    end = col_datetime(),
    offset = col_number(),
    dst = col_logical(),
    abbreviation = col_character()
  )
)

dst_locations <- transitions %>%
  filter(dst == TRUE) %>%
  group_by(zone) %>%
  summarise(
    start_year = year(min(begin)),
    end_year = year(max(end)),
    .groups = "drop"
  ) %>%
  mutate(
    yr_diff = if_else(
      end_year > 2023,
      end_year - start_year + 1,
      2023 - start_year + 1      # threshold to 2023
    ),
    decade = end_year - (end_year %% 10)
  ) %>%
  left_join(
    timezones %>% select(-comments),
    by = "zone"
  ) %>%
  filter(!is.na(longitude) & !is.na(latitude)) %>%
  st_as_sf( # convert to sf dataframe
    coords = c("longitude", "latitude"),
    crs = "+proj=longlat +datum=WGS84"
  )

world_map <- ne_countries(scale = "small", returnclass = "sf")

dst_map <- ggplot() +
  geom_sf(
    data = world_map,
    fill = "white",
    color = "grey70"
  ) +
  geom_sf(
    data = dst_locations,
    size = 2.5,
    aes(color = as.factor(decade)),
    show.legend = FALSE
  ) +
  labs(
    title = "Locations that use (or have used) DST by their last registered decade",
    subtitle = "#TidyTuesday 2023-03-28, Time zones dataset",
    caption = "@jmcastagnetto@mastodon.social, Jesus M. Castagnetto"
  ) +
  coord_sf(crs="+proj=robin") +
  theme_minimal(
    base_family = "Atkinson Hyperlegible",
    base_size = 30,
  ) +
  theme(
    legend.position = c(.17, .3),
    legend.key.height = unit(2, "cm"),
    legend.text = element_text(size = 14),
    legend.title = element_text(size = 16),
    plot.title = element_text(face = "bold", size = 42),
    plot.subtitle = element_text(color = "gray40"),
    plot.caption = element_text(family = "Inconsolata"),
    plot.background = element_rect(color = "white", fill = "white")
  ) +
  facet_wrap(~decade)

ggsave(
  plot = dst_map,
  filename = "2023-03-28_time-zones/locations-with-dst-by-last-decade.png",
  width = 27,
  height = 14
)
