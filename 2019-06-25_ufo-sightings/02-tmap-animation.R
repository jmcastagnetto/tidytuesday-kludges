library(tidyverse)
library(lubridate)
library(tmap)
library(tmaptools)
library(countrycode)

load(here::here("2019-06-25_ufo-sightings/data/ufo_sightings.Rdata"))

data("World")

ufo <- World %>%
  inner_join(
    ufo_sightings %>%
      mutate(
        iso3 = countrycode(country, "iso2c", "iso3c")
      ) %>%
      group_by(year(date_time), iso3) %>%
      summarise(
        n = n()
      ) %>%
      rename(
        yr = 1
      ),
    by = c("iso_a3" = "iso3")
  ) %>%
  arrange(
    yr, iso_a3
  )

yrs <- unique(ufo$yr)
countries <- World %>%
  filter(iso_a3 %in% ufo$iso_a3)

breaks <- seq(0, 7000, by = 1000)

mk_tmap_anim <- function(basemap, df, breaks, years) {
  df <- subset(df, yr %in% years)
  fname <- paste0("animation_", min(years), "-", max(years), ".gif")
  map1 <- tm_shape(basemap) +
    tm_polygons(NA) +
    tm_shape(df) +
    tm_polygons("n", breaks = breaks, title = "Number of sightings") +
    tm_facets(along = "yr", free.coords = FALSE, free.scales = FALSE)
  tmap_animation(map1,
                 filename = here::here("2019-06-25_ufo-sightings/", fname))
}

mk_tmap_anim(countries, ufo, breaks, yrs[1:20])
mk_tmap_anim(countries, ufo, breaks, yrs[21:40])
mk_tmap_anim(countries, ufo, breaks, yrs[41:60])
mk_tmap_anim(countries, ufo, breaks, yrs[61:83])

# small multiples (static) from 2011-2014 (for twitter)
multmap <- tm_shape(countries) +
  tm_polygons(NA) +
  tm_shape(ufo %>% filter(yr %in% yrs[80:83])) +  # 2011-2014
  tm_polygons("n", breaks = breaks, title = "Number of sightings") +
  tm_facets(by = "yr", free.coords = FALSE, free.scales = FALSE, ncol = 2) +
  tm_layout(legend.position = c("right", "bottom"))

tmap_save(multmap,
          filename = here::here("2019-06-25_ufo-sightings/tmap-facets-ufo-sightings.png"),
          width = 1200, height = 600)

