library(tidyverse)
library(sf)
library(raster)
library(spData)
library(spDataLarge)
library(rnaturalearth)
library(rnaturalearthdata)
library(rnaturalearthhires)
library(units)

states <- ne_states(iso_a2 = "US", returnclass = "sf")

ny <- states %>%
  filter(iso_3166_2 == "US-NY")

# nyc sf object

geo_url <- "https://data.cityofnewyork.us/api/geospatial/fxpq-c8ku?method=export&format=GeoJSON"

# read in geojson of tract geometry and calculate area of each tract in sq mi
tract_sf <- read_sf(geo_url) %>%
  st_transform(2263) %>%   # convert to same projection as above
  select(boro_name, boro_ct2010) %>%
  mutate(area = set_units(st_area(.), mi^2))
manhattan <- tract_sf %>% filter(boro_name == "Manhattan")


# https://mattherman.info/blog/point-in-poly/