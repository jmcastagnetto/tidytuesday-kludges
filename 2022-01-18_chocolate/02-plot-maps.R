library(tidyverse)
library(tmap)

data("World")

rating_country <- readRDS("2022-01-18_chocolate/chocolate.rds") %>%
  group_by(
    country
  ) %>%
  summarise(
    n = n(),
    mean_pct = mean(cocoa_percent),
    mean_rating = mean(rating)
  )

world_df <- World %>%
  left_join(
    rating_country,
    by = c("iso_a3" = "country")
  )

map1 <- tm_shape(world_df %>% filter(iso_a3 != "ATA")) +
  tm_polygons(
    col = "mean_rating",
    n = 5,
    colorNA = "grey85",
    palette = "Purples",
    title = "Average Rating",
    style = "cont",
    border.col = "grey50",
    border.alpha = .5,
    legend.reverse = TRUE,
    legend.is.portrait = TRUE
  ) +
  tm_layout(
    main.title = "Chocolate ratings by provenance of beans (#TidyTuesday, 2022-01-18)",
    title = "@jmcastagnetto, Jesus M. Castagnetto",
    title.position = c(.55, .05),
    title.size = 1,
    title.fontfamily = "Inconsolata",
    title.bg.alpha = 0,
    main.title.size = 2,
    main.title.fontfamily = "Lobster Two",
    frame = FALSE,
    legend.title.fontfamily = "Lobster Two"
  )
tmap_save(
  map1,
  "2022-01-18_chocolate/map-chocolate-ratings.png",
  height = 5,
  width = 11
)

map2 <- tm_shape(world_df %>% filter(iso_a3 != "ATA")) +
  tm_polygons(
    col = "mean_pct",
    n = 5,
    colorNA = "grey85",
    palette = "YlOrBr",
    title = "Average percentage of Cocoa",
    style = "cont",
    border.col = "grey50",
    border.alpha = .5,
    legend.reverse = TRUE,
    legend.is.portrait = TRUE
  ) +
  tm_layout(
    main.title = "Cocoa contents by provenance of beans (#TidyTuesday, 2022-01-18)",
    title = "@jmcastagnetto, Jesus M. Castagnetto",
    title.position = c(.55, .05),
    title.size = 1,
    title.fontfamily = "Inconsolata",
    title.bg.alpha = 0,
    main.title.size = 2,
    main.title.fontfamily = "Lobster Two",
    frame = FALSE,
    legend.title.fontfamily = "Lobster Two"
  )
tmap_save(
  map2,
  "2022-01-18_chocolate/map-chocolate-cocoa-pct.png",
  height = 5,
  width = 11
)


