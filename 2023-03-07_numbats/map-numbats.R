library(tidyverse)
library(sf)
library(geodata)
library(osmdata)
library(patchwork)

csv_url <- "https://github.com/rfordatascience/tidytuesday/raw/master/data/2023/2023-03-07/numbats.csv"

if (!file.exists("2023-03-07_numbats/numbat.png")) {
  download.file(
    url = "https://github.com/rfordatascience/tidytuesday/blob/master/data/2023/2023-03-07/pic1.png?raw=true",
    destfile = "2023-03-07_numbats/numbat.png"
  )
}

numbat_img <- png::readPNG(
  source = "2023-03-07_numbats/numbat.png",
  native = TRUE
)

numbats_raw <- read_csv(csv_url)

numbats_coord <- numbats_raw %>%
  filter(
    !is.na(decimalLatitude) &
      !is.na(decimalLongitude) &
      !is.na(eventDate)
  ) %>%
  mutate(
    event = as.Date(eventDate)
  ) %>%
  select(
    lat = decimalLatitude,
    lon = decimalLongitude,
    event,
    dryandra
  ) %>%
  arrange(
    dryandra,
    event
  )

numbats_dryandra <- numbats_coord %>%
  filter(dryandra) %>%
  select(-dryandra)

# base map
western_australia <- gadm("Australia", level = 2,
                          path = "2023-03-07_numbats/") %>%
  st_as_sf() %>%
  filter(NAME_1 == "Western Australia")

# bounding box
dryandra_bb <- getbb(
  place_name = "Dryandra Woodland National Park",
  featuretype = "leisure"
)

# OSM features
streets <- dryandra_bb %>%
  opq() %>%
  add_osm_feature(
    key = "highway",
    value = c("motorway", "primary",
              "secondary", "tertiary")
  ) %>%
  osmdata_sf()

small_streets <- dryandra_bb %>%
  opq() %>%
  add_osm_feature(
    key = "highway",
    value = c(
      "residential",
      "living_street",
      "unclassified",
      "service",
      "footway"
    )
  ) %>%
  osmdata_sf()

historic <- dryandra_bb %>%
  opq()%>%
  add_osm_feature(key = "historic") %>%
  osmdata_sf()

river <- dryandra_bb %>%
  opq()%>%
  add_osm_feature(key = "waterway", value = "river") %>%
  osmdata_sf()

train <- dryandra_bb %>%
  opq()%>%
  add_osm_feature(key = "railway") %>%
  osmdata_sf()

# National Park
dryandra_sf <- osmdata::getbb(
  place_name = "Dryandra Woodland National Park",
  featuretype = "leisure",
  format_out = "sf_polygon"
)

numbats_map <- ggplot() +
  geom_sf(data = western_australia, fill = "white") +
  geom_sf(
    data = dryandra_sf$multipolygon, fill = "yellow"
  ) +
  geom_sf(
    data = streets$osm_lines,
    inherit.aes = FALSE,
    color = "black",
    linewidth = 1,
    alpha = .8
  ) +
  geom_sf(
    data = small_streets$osm_lines,
    inherit.aes = FALSE,
    color = "grey30",
    linewidth = .5,
    alpha = .8
  ) +
  geom_sf(
    data = river$osm_lines,
    inherit.aes = FALSE,
    color = "cyan",
    linewidth = 2,
    alpha = .6
  ) +
  geom_sf(
    data = train$osm_lines,
    inherit.aes = FALSE,
    color = "black",
    linewidth = 1.2,
    alpha = .8,
    linetype = "dotdash"
  ) +
  geom_point(
    data = numbats_dryandra,
    aes(x = lon, y = lat),
    position = position_jitter(seed = 135, width = .02, height = .02),
    shape = "🐾",
    size = 4.5
  ) +
  geom_sf(
    data = historic$osm_points,
    inherit.aes = FALSE,
    color = "brown",
    shape = "🏛",
    size = 3
  ) +
  geom_sf_label(
    data = western_australia,
    aes(label = NAME_2),
    size = 6,
    label.size = 0,
    alpha = .7
  ) +
  coord_sf(
    xlim = c(116.6, 117.3),
    ylim = c(-33.0, -32.5)
  ) +
  theme_void()

combined_plot <- numbats_map +
  inset_element(
    p = numbat_img,
    left = 0,
    bottom = 0.6,
    right = 0.2,
    top = 0.8
  ) +
  plot_annotation(
    title = "Numbats observed in the\nDryandra Woodland National Park",
    subtitle = glue::glue("#TidyTuesday 2023-03-07 - From {min(year(numbats_dryandra$event))} to {max(year(numbats_dryandra$event))}"),
    caption = "@jmcastagnetto@mastodon.social, Jesús M. Castagnetto"
  ) &
  theme(
    plot.title.position = "plot",
    plot.title = element_text(size = 36, face = "bold"),
    plot.subtitle = element_text(size = 22, color = "grey30"),
    plot.caption = element_text(family = "Inconsolata", size = 18),
    plot.background = element_rect(fill = "white", color = "white"),
    plot.margin = unit(rep(1, 4), "cm")
  )

ggsave(
  plot = combined_plot,
  filename = "2023-03-07_numbats/map-numbats-dryandra-woodland-national-park.png",
  width = 16,
  height = 14
)
