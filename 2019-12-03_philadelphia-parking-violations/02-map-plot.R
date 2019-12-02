library(tidyverse)

load(
  here::here("2019-12-03_philadelphia-parking-violations",
             "philly-data.Rdata")
  )


#philly_map <-

ggplot() +
  geom_sf(
    data = streets$osm_lines,
    inherit.aes = FALSE,
    color = "skyblue",
    alpha = .8,
    size = .5
  ) +
  geom_sf(
    data = small_streets$osm_lines,
    inherit.aes = FALSE,
    color = "lightcoral",
    alpha = .8,
    size = .3
  ) +
  geom_sf(
    data = river$osm_lines,
    inherit.aes = FALSE,
    color = "white",
    alpha = .8,
    size = 2
  ) +
  geom_sf(
    data = trains$osm_lines,
    inherit.aes = FALSE,
    color = "yellow",
    alpha = .8,
    size = 1.2,
    linetype = "dotdash"
  ) +
  coord_sf(
    xlim = c(-75.2803, -74.95583),
    ylim = c(39.8670, 40.13796),
    expand = FALSE
  ) +
  geom_point(
    data = ph_df,
    aes(x = lon, y = lat, color = violation_desc),
    size = .2,
    alpha = .5,
    show.legend = FALSE
  )
