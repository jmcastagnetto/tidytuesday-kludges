library(tidyverse)
library(geogrid)
library(tmap)
library(cowplot)

load(
  here::here("2019-10-01_all-the-pizza/all_the_piza.Rdata")
)


# maps
usa_sf <- rnaturalearth::ne_states(iso_a2 = "US", returnclass = "sf")
hex_cells <- calculate_grid(usa_sf,
                            grid_type = "hexagonal",
                            learning_rate = 0.03,
                            seed = 2)

usa_hex <- assign_polygons(usa_sf, hex_cells)

pizza_loc_shape <- sf::st_as_sf(rated_pizza_locations,
                            coords = c("longitude", "latitude"))

regular_map <- tm_shape(usa_sf, simplify = 1,
         bbox = sf::st_bbox(
           c(xmin = -169, xmax = - 60,
             ymin = 10, ymax = 71.3577635769)
         )
) +
  tm_borders(alpha = 0.2)

hex_map <- tm_shape(usa_hex) +
  tm_fill(col = "lightblue", alpha = 0.5)

pizza_map <- tm_shape(sf::st_as_sf(rated_pizza_locations,
                    coords = c("longitude", "latitude"))) +
  tm_dots(col = "barstool_score",
          size = 0.07,
          palette = colorblindr::palette_OkabeIto,
          title = "Barstool") +
  tm_layout(
    frame = FALSE,
  )

regular_map + pizza_map +
  tm_layout(
    title = "(B) Regular map",
    title.position = c("center", "top")
  )
p1 <- grid::grid.grab()

hex_map + pizza_map+
  tm_layout(
    title = "(C) Hex map",
    title.position = c("center", "top")
  )
p2 <- grid::grid.grab()

regular_map + hex_map + pizza_map +
  tm_layout(
    title = "(A) Combined map",
    title.position = c("center", "top")
  )
p3 <- grid::grid.grab()

p12 <- plot_grid(p1, p2, ncol = 1)

title <- ggdraw() +
  draw_label(
    "Geolocated and rated (Barstool's score) pizza shops",
    fontface = 'bold',
    x = 0,
    hjust = 0
  ) +
  theme(
    plot.margin = margin(0, 0, 0, 7)
  )

caption <- ggdraw() +
  draw_label(
    "#TidyTuesday - All the pizza, 2019-10-01 // @jmcastagnetto, Jesus M. Castagnetto",
    fontfamily = "fixed",
    x = .98,
    hjust = 1
  )

p123 <- plot_grid(p3, p12, ncol = 2, rel_widths = c(2,1), scale = c(.8, .7))

plot_grid(title, p123, caption, nrow = 3, rel_heights = c(.1, 1, .1))

