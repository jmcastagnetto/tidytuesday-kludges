library(tidyverse)
library(echarts4r)
library(echarts4r.assets)

load(here::here("2019-08-20_nuclear-explosions/sipri.Rdata"))

sipri %>%
  filter(
    !is.na(r_therm)
  ) %>%
  mutate(
    diameter = 2 * r_therm
  ) %>%
  arrange(year) %>%
  group_by(year) %>%
  e_charts(longitude, timeline = TRUE, axisType = "value") %>%
  e_geo(roam = TRUE) %>%
  e_effect_scatter(
    latitude,
    size = diameter,
    coord_system = "geo",
    symbol = ea_icons("crosshair"),
    rippleEffect = list(brushType = "fill"),
    legend = FALSE, animation = TRUE
  ) %>%
  e_toolbox_feature(
    feature = c("saveAsImage", "restore")
  ) %>%
  e_theme("infographic") %>%
  e_rm_axis("x") %>% e_rm_axis("y") %>%
  e_title(
    "Nuclear explosions over the years (Thermal range)",
    "Source: SIPRI (1945-1998) / #TidyTuesday 2019-08-20 / @jmcastagnetto, Jesus M. Castagnetto",
    sublink = "https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-08-20"
  )

sipri %>%
  filter(
    !is.na(r_blast)
  ) %>%
  mutate(
    z = -100 * depth,
    diameter = 2 * r_blast
  ) %>%
  group_by(year) %>%
  e_charts(longitude) %>%
  e_rm_axis("x") %>%
  e_rm_axis("y") %>%
  e_globe(
    environment = ea_asset("starfield"),
    #base_texture = ea_asset("world"),
    base_texture = ea_asset("world topo"),
    height_texture = ea_asset("world topo"),
    displacementScale = 0.05,
    layers = list(
      list(
        type = "overlay",
        shading = "lambert",
        texture = ea_asset("clouds trans"),
        distance = 5
      )
    ),
    globeOuterRadius = 100
  ) %>%
  e_scatter_3d(
    latitude,
    z,
    size = diameter,
    coord_system = "globe",
    color = "red",
    blendMode = "lighter",
    legend = FALSE,
    animation = FALSE
  ) %>%
  e_theme("infographic") %>%
  e_toolbox_feature(
    feature = c("saveAsImage", "restore")
  ) %>%
  e_title(
    "Nuclear explosions over the years (Blast range)",
    "Source: SIPRI (1945-1998) / #TidyTuesday 2019-08-20 / @jmcastagnetto, Jesus M. Castagnetto",
    sublink = "https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-08-20"
  )
