library(tidyverse)
library(rnaturalearth)
library(sf)
library(ggspatial)


seasons <- read_csv("2023-01-24_alone/seasons.csv") %>%
  select(country, season, place = location, lat, lon) %>%
  mutate(
    location = glue::glue("S{season}: {place}, {country}")
  )

countries <- seasons %>%
  select(country) %>%
  distinct() %>%
  mutate(alone = TRUE)

world <- ne_countries(scale = 110, returnclass = "sf") %>%
  left_join(
    countries,
    by = c("name" = "country")
  )

moves <- seasons %>%
  mutate(
    next_place = lead(place),
    next_location = lead(location),
    next_lat = lead(lat),
    next_lon = lead(lon)
  ) %>%
  filter(
    !is.na(next_location)
  )

set.seed(2468)
seasons_map <- ggplot() +
  annotation_map_tile(
     #opentopomap tiles
     type = "https://a.tile.opentopomap.org/${z}/${x}/${y}.png",
     zoomin = 0
  ) +
  geom_sf(
    data = world,
    aes(fill = alone),
    color = "black",
    alpha = 0.4,
    show.legend = FALSE
  ) +
  scale_fill_manual(
    values = c("darkgreen"),
    na.value = NA
  ) +
  geom_spatial_segment(
    data = moves,
    aes(
      x = lon,
      y = lat,
      xend = next_lon,
      yend = next_lat
    ),
    color = "darkblue",
    linewidth = 1,
    arrow = arrow(angle = 15, length = unit(4, "mm"), type = "closed"),
    crs = 4326
  ) +
  geom_spatial_point(
    data = seasons,
    aes(x = lon, y = lat),
    size = 3,
    color = "darkorange",
    crs = 4326
  ) +
  geom_spatial_label_repel(
    data = seasons,
    aes(x = lon, y = lat, label = paste0("S", season)),
    label.size = 0,
    max.overlaps = 20
  ) +
  annotate(
    geom = "label",
    x = -100E5,
    y = -35E5,
    label = paste(seasons$location, collapse = "\n"),
    hjust = 0,
    size = 3.5,
    fill = rgb(1, 1, 1, 0.5)
  ) +
  coord_sf(
    crs = "+proj=laea +lon_0=-90 +lat_0=45"
  ) +
  theme_minimal(base_family = "Atkinson Hyperlegible") +
  theme(
    axis.title = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    plot.title.position = "plot",
    plot.title = element_text(size = 28, face = "bold"),
    plot.subtitle = element_text(size = 17, color = "gray40"),
    plot.caption = element_text(family = "Inconsolata", size = 14),
    plot.background = element_rect(fill = "white", colour = "white")
  ) +
  labs(
    title = "How the locations of the \"Alone\"\nseries changed over the seasons",
    subtitle = "#TidyTuesday (2023-01-24): 'Alone data'",
    caption = "Jesus M. Castagnetto, @jmcastagnetto@mastodon.social"
  )

ggsave(
  plot = seasons_map,
  filename = "2023-01-24_alone/seasons-locations.png",
  width = 9,
  height = 10
)
