library(tidyverse)
library(rnaturalearth)
library(sf)
library(patchwork)

water <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-05-04/water.csv')
saveRDS(water, "2021-05-04_water-sources/water_sources.rds")

water_uganda <- water %>%
  filter(country_name == "Uganda") %>%
  mutate(
    type = case_when(
      str_detect(water_source, "Well") ~ "Well",
      str_detect(water_source, "Spring") ~ "Spring",
      str_detect(water_source, "Rainwater") ~ "Rainwater",
      is.na(water_source) ~ "Unkown",
      water_source == "Borehole" ~ "Borehole",
      TRUE ~ "Other"
    ) %>%
      fct_infreq(),
    status_lbl = case_when(
      status_id == "u" ~ "Unknown",
      status_id == "n" ~ "Not Working",
      status_id == "y" ~ "Working"
    ) %>%
      fct_infreq()
  )

# Picked Uganda, because it was the country with most information
# and because I knew very little about that country

africa <- ne_countries(continent = "Africa", scale = 10, returnclass = "sf")
uganda_border <- ne_countries(country = "Uganda", returnclass = "sf")
uganda <- ne_states(country = "Uganda", returnclass = "sf")
uganda_bb <- st_bbox(uganda)


# RDS converted from SHP file from https://www.naturalearthdata.com/downloads/10m-physical-vectors/
rivers <- readRDS("2021-05-04_water-sources/ne_rivers_10m.rds")

type_colors <- RColorBrewer::brewer.pal(6, "Dark2")

p1 <- ggplot() +
  geom_sf(data = africa, fill = "white") +
  geom_sf(data = uganda, fill = "white") +
  geom_point(
    data = water_uganda,
    aes(y = lat_deg, x = lon_deg, color = type),
    size = .2, alpha = .7) +
  geom_sf_text(data = uganda_border,
               aes(label = formal_en),
               angle = 45,
               size = 9,
               fontface = "bold",
               alpha = .5) +
  scale_color_manual(values = type_colors) +
  geom_sf(data = rivers, color = "blue", size = 2, alpha = .6) +
  geom_sf_label(data = rivers, aes(label = name), size = 2) +
  coord_sf(
    xlim = c(uganda_bb[1], uganda_bb[3]),
    ylim = c(uganda_bb[2], uganda_bb[4])
  ) +
  guides(color = guide_legend(override.aes = list(size = 5))) +
  theme_void() +
  theme(
    legend.text = element_text(size = 12),
    legend.title = element_text(size = 14, face = "bold")
  ) +
  labs(
    color = "Source type"
  )

p2 <- ggplot() +
  geom_sf(data = africa, fill = "white") +
  geom_sf(data = uganda, fill = "white") +
  geom_point(
    data = water_uganda,
    aes(y = lat_deg, x = lon_deg, color = status_lbl),
    size = .2, alpha = .7) +
  geom_sf_text(data = uganda_border,
               aes(label = formal_en),
               angle = 45,
               size = 9,
               fontface = "bold",
               alpha = .5) +
  scale_color_manual(
    values = c("Working" = "green",
               "Not Working" = "red",
               "Unknown" = "grey30")
  ) +
  geom_sf(data = rivers, color = "blue", size = 2, alpha = .6) +
  geom_sf_label(data = rivers, aes(label = name), size = 2) +
  coord_sf(
    xlim = c(uganda_bb[1], uganda_bb[3]),
    ylim = c(uganda_bb[2], uganda_bb[4])
  ) +
  guides(color = guide_legend(override.aes = list(size = 5))) +
  theme_void() +
  theme(
    legend.text = element_text(size = 12),
    legend.title = element_text(size = 14, face = "bold")
  ) +
  labs(
    color = "Status\nof source"
  )

p_comb <- (p1 + p2) +
  plot_annotation(
    title = "Water sources in Uganda",
    subtitle = "Data sources: #TidyTuesday (2021-05-04) and Natural Earth",
    caption = "@jmcastagnetto, Jesus M. Castagnetto (2021-05-05)"
  ) &
  theme(
    plot.title = element_text(size = 32),
    plot.subtitle = element_text(size = 22, colour = "grey30"),
    plot.caption = element_text(family = "Inconsolata", size = 18),
    plot.margin = unit(rep(.5, 4), "cm")
  )

ggsave(
  plot = p_comb,
  filename = "2021-05-04_water-sources/water-sources-in-uganda.png",
  width = 12,
  height = 6
)
