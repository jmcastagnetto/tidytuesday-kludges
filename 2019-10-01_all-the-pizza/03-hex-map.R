library(tidyverse)
library(geogrid)
library(sf)
library(tmap)
library(rnaturalearth)

load(
  here::here("2019-10-01_all-the-pizza/all_the_piza.Rdata")
)

usa_sf <- ne_states(iso_a2 = "US", returnclass = "sf")

par(mfrow = c(5, 5), mar = c(0, 0, 2, 0))
for (i in 1:25) {
  new_cells <- calculate_grid(shape = usa_sf,
                              grid_type = "hexagonal",
                              seed = i)
  plot(new_cells, main = paste("Seed", i, sep = " "))
}

# using seed = 2

hex_cells <- calculate_grid(usa_sf,
                            grid_type = "hexagonal",
                            learning_rate = 0.03,
                            seed = 2)

pizza_state <- pizza_locations %>%
  filter(only_pizza == 1) %>%
  group_by(state) %>%
  tally()

more_pizza_state <- pizza_locations %>%
  filter(only_pizza == 0) %>%
  group_by(state) %>%
  tally()

usa_pizza <- usa_sf %>%
  left_join(
    pizza_state,
    by = c("postal" = "state")
  )

usa_hex <- assign_polygons(usa_pizza, hex_cells)

pizza_loc_shape <- st_as_sf(pizza_locations,
                            coords = c("longitude", "latitude"))

tm_shape(usa_sf, simplify = 1,
         bbox = st_bbox(
           c(xmin = -169, xmax = - 60,
             ymin = 10, ymax = 71.3577635769)
         )
) +
  tm_borders(alpha = 0.5) +
tm_shape(usa_hex) +
  tm_fill(col = "#e1d800", alpha = 0.5) +
  # tm_polygons(col = "n", palette = "-viridis",
  #             alpha = 0.5) +
  tm_shape(st_as_sf(pizza_datafiniti,
                    coords = c("longitude", "latitude"))) +
  tm_bubbles(col = "price_range", size = 0.07, )


tm_shape(pizza_loc_shape) +
  tm_dots(size = 0.05, col = "only_pizza") +
  tm_layout(
    bg.color = "lightblue", frame = FALSE
  )


tm_shape(usa_hex) +
  tm_borders() +
tm_shape(st_as_sf(pizza_datafiniti,
                  coords = c("longitude", "latitude"))) +
  tm_bubbles(col = "price_range", size = 0.07, )


