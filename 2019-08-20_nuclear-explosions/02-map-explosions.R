library(tidyverse)
library(echarts4r)
library(echarts4r.assets)

load(here::here("data/sipri.Rdata"))

sipri %>%
  filter(
    !is.na(yield_u)
  ) %>%
  mutate(
    decade = (year %/% 10 ) * 10
  ) %>%
  arrange(decade) %>%
  group_by(decade) %>%
  e_charts(longitude, timeline = TRUE, axisType = "value") %>%
  e_geo(roam = TRUE) %>%
  e_effect_scatter(
    latitude,
    size = yield_u,
    coord_system = "geo",
    symbol = ea_icons("crosshair"),
    rippleEffect = list(brushType = "fill"),
    legend = FALSE, animation = TRUE
  ) %>%
  e_toolbox_feature(
    feature = c("saveAsImage", "restore")
  ) %>%
  e_visual_map(scale = e_scale,
               type = "continuous",
               calculable = FALSE,
               serie = yield_u) %>%
  e_theme("infographic") %>%
  e_rm_axis("x") %>% e_rm_axis("y") %>%
  e_title(
    "Nuclear explosions over the years",
    "Data: SIPRI, 2000 (@jmcastagnetto, Jesus M. Castagnetto)",
    sublink = "https://github.com/data-is-plural/nuclear-explosions"
  )

# sipri %>%
#   filter(
#     !is.na(yield_u)
#   ) %>%
#   mutate(
#     ly = log10(yield_u + 1)
#   ) %>%
#   e_charts(longitude) %>%
#   e_geo_3d() %>%
#   e_bar_3d(
#     latitude,
#     ly,
#     coord_system = "geo3D"
#   )
#

sipri %>%
  filter(
    !is.na(yield_u)
  ) %>%
  mutate(
    decade = (year %/% 10 ) * 10,
    z = -100 * depth
  ) %>%
  group_by(decade) %>%
  e_charts(longitude) %>%
  e_rm_axis("x") %>%
  e_rm_axis("y") %>%
  e_globe(
    environment = ea_asset("starfield"),
    base_texture = ea_asset("world"),
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
    size = yield_u,
    coord_system = "globe",
    color = decade,
    legend = FALSE,
    animation = TRUE
  ) %>%
  e_visual_map(
               type = "continuous",
               calculable = TRUE,
               serie = yield_u) %>%
  e_theme("infographic") %>%
  e_toolbox_feature(
    feature = c("saveAsImage", "restore")
  ) %>%
  e_title(
    "Nuclear explosions over the years",
    "Data: SIPRI, 2000 (@jmcastagnetto, Jesus M. Castagnetto)",
    sublink = "https://github.com/data-is-plural/nuclear-explosions"
  )
