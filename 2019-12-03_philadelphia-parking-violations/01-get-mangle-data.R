library(tidyverse)
library(tidytuesdayR)
library(osmdata)


tt <- tidytuesdayR::tt_load("2019-12-03")
ph_df <- tt$tickets

ggplot(ph_df, aes(x = lon, y = lat, color = violation_desc)) +
  geom_count(show.legend = FALSE)


philly <- getbb("Philadelphia, Pennsylvania, USA")

streets <- philly %>%
  opq() %>%
  add_osm_feature(
    key = "highway",
    value = c(
      "motorway",
      "primary",
      "secondary",
      "tertiary"
    )
  ) %>%
  osmdata_sf()

small_streets <- philly %>%
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

trains <- philly %>%
  opq() %>%
  add_osm_feature(
    key = "railway",
    value = c(
      "level crossing",
      "crossing",
      "rail",
      "station"
    )
  ) %>%
  osmdata_sf()

river <-  philly %>%
  opq() %>%
  add_osm_feature(key = "waterway",
                  value = "river") %>%
  osmdata_sf()

save(
  ph_df,
  philly,
  streets,
  small_streets,
  river,
  trains,
  file = here::here("2019-12-03_philadelphia-parking-violations", "philly-data.Rdata")
)
