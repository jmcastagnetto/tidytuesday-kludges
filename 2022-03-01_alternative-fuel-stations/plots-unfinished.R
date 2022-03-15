library(OpenStreetMap)
library(ggplot2)

bb <- getbb("San Diego, CA")

map <- openmap(
  c(bb[2,2], bb[1,2]),
  c(bb[2,1], bb[1,1]),
  type =
)
map.latlon <- openproj(map, projection = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")


OpenStreetMap::autoplot.OpenStreetMap(map.latlon) +
  geom_point(
    data = san_diego,
    aes(y = LATDD, x = LONGDD),
    inherit.aes = FALSE
  )

san_diego_map <-  getbb("San Diego, CA")%>%
  opq()%>%
  add_osm_feature(
    key = "highway",
    value = c(
      "motorway",
      "primary",
      "motorway_link",
      "primary_link"
    )
  ) %>%
  osmdata_sf()


san_diego <- stations %>%
  filter(
    STATE == "CA" &
      CITY == "San Diego" &
      FUEL_TYPE_CODE == "ELEC" &
      STATUS_CODE == "E"
  ) %>%
  filter(
    between(LATDD, bb[2, 1], bb[2, 2]) &
      between(LONGDD, bb[1, 1], bb[1, 2])
  )

ggplot(
  san_diego,
  aes(x = LONGDD, y = LATDD)
) +
  geom_point() +
  coord_map()
