library(tidyverse)
library(sf)
library(raster)
library(spData)
library(spDataLarge)
library(units)

#library(rnaturalearth)
#library(rnaturalearthdata)
#library(rnaturalearthhires)

# states <- ne_states(iso_a2 = "US", returnclass = "sf")
# ny <- states %>%
#   filter(iso_3166_2 == "US-NY")

# nyc sf object
geo_url <- "https://data.cityofnewyork.us/api/geospatial/fxpq-c8ku?method=export&format=GeoJSON"

# read in geojson of tract geometry and calculate area of each tract in sq mi
nyc <- read_sf(geo_url) %>%
  st_transform(2263) %>%   # convert to same projection as above
  #dplyr::select(boro_name, boro_ct2010) %>%
  mutate(area = set_units(st_area(.), mi^2))

save(
  nyc,
  file = here::here("2019-10-27_nyc-squirrel-census/nyc-sf.Rdata")
)

manhattan <- nyc %>%
  dplyr::select(boro_name, boro_ct2010, ntaname, area) %>%
  filter(boro_name == "Manhattan")
plot(manhattan)

central_park <- manhattan %>%
  filte(boro_ct2010 == "1014300")

cp_surrounding <- manhattan %>%
  dplyr::select(-area) %>%
  filter(
    boro_ct2010 == "1014300" |
    ntaname %in% c("Midtown-Midtown South", "Midtown-Midtown South",
                   "Upper East Side-Carnegie Hill", "Upper West Side",
                   "East Harlem South", "East Harlem North",
                   "Central Harlem South", "Lincoln Square",
                   "Morningside Heights", "Yorkville",
#                   "Hudson Yards-Chelsea-Flatiron-Union Square",
                   "Clinton"

                   )
  )

plot(cp_surrounding)

# https://mattherman.info/blog/point-in-poly/