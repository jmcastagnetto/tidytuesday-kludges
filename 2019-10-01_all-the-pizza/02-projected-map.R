library(tidyverse)
library(sf)
library(rnaturalearth)
library(tmap)

load(
  here::here("2019-10-01_all-the-pizza/all_the_piza.Rdata")
)

usa <- ne_states(iso_a2 = "us", returnclass = "sf")
countries <- ne_countries(returnclass = "sf")
graticules <- ne_download(type = "graticules_15",
                         category = "physical",
                         returnclass = "sf")
bb <- ne_download(type = "wgs84_bounding_box",
                  category = "physical",
                  returnclass = "sf")

pizza_loc <- st_as_sf(pizza_locations,
                      coords = c("longitude", "latitude"),
                      crs = 4326)

ggplot() +
  geom_sf(data = bb, col = "lightblue", fill = "transparent") +
  #geom_sf(data = graticules, col = "grey20", lwd = 0.1) +
  geom_sf(data = countries, fill = "grey80", col = "grey40",
          lwd = 0.3) +
  geom_sf(data = pizza_loc, size = 0.5, alpha = 0.6) +
  #coord_sf(crs = "+proj=aea") +
  #coord_sf(crs = "+proj=eqdc +lat_1=55 +lat_2=60") +
  #coord_sf(crs = "+proj=gnom +lat_0=90 +lon_0=-50") + Hmmm
  #coord_sf(crs = "+proj=igh") +
  coord_sf(crs = "+proj=laea +lon_0=-90 +lat_0=60") +
  #coord_sf(crs = "+proj=poly") +
  #coord_sf(crs = "+proj=robin") +
  #coord_sf(crs = "+proj=tissot +lat_1=60 +lat_2=65") +
  #coord_sf(crs = "+proj=ups") + check with tmap
  ggthemes::theme_map() +
  theme(
    axis.text = element_blank(),
    plot.background = element_rect(fill = "lightblue"),
    panel.background = element_rect(fill = "lightblue")
    )

tproj <- "+proj=laea +lon_0=-90 +lat_0=60"

# pizza colors: https://www.color-hex.com/color-palette/5261

tm_shape(countries, projection = tproj) +
  tm_fill(col = "#e12301", ) +
  tm_borders(col = "#ffffff") +
tm_shape(pizza_loc, projection = tproj) +
  tm_dots() +
  tm_layout(
    bg.color = "#e1d800",
    frame = FALSE
  )


# check also: https://www.r-spatial.org/r/2018/10/25/ggplot2-sf.html

# See: https://github.com/mtennekes/tmap/issues/228
