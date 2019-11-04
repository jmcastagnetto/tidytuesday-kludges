library(tidyverse)
library(brickr)
library(rayshader)

sqmap <- png::readPNG(
  here::here("2019-10-27_nyc-squirrel-census/squirrel-activities-for-mosaic.png")
)

mosaic <- image_to_mosaic(sqmap, img_size = c(120, 96))
#mosaic %>% build_mosaic()

brk <- bricks_from_mosaic(mosaic, highest_el = "dark")
#build_bricks(brk)

build_bricks_rayshader(brk)
render_snapshot(
  filename = here::here("2019-10-27_nyc-squirrel-census/squirrel-activities-brickr.png"),
  clear = TRUE
)
