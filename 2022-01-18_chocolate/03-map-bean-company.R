library(tidyverse)
library(sf)
library(rnaturalearth)
library(gganimate)

countries <- ne_countries(returnclass = "sf") %>%
  filter(adm0_a3 != "ATA")

# country lat lon from: https://www.kaggle.com/eidanch/counties-geographic-coordinates
centroids <- read_csv("2022-01-18_chocolate/countries.csv") %>%
  mutate(
    iso3c = countrycode::countrycode(country,
                                     origin = "iso2c",
                                     destination = "iso3c")
  ) %>%
  filter(!is.na(iso3c))

data("World", package = "tmap")

chocolate_df <- readRDS("2022-01-18_chocolate/chocolate.rds")

sum_df <- chocolate_df %>%
  group_by(country_company, country, review_date) %>%
  tally() %>%
  ungroup() %>%
  mutate(
    country_name_company = countrycode::countrycode(
      country_company,
      origin = "iso3c",
      destination = "country.name.en"
      ),
    country_name_company = replace_na(country_name_company, "Unkown"),
    country_name_bean = countrycode::countrycode(
      country,
      origin = "iso3c",
      destination = "country.name.en"
      ),
    country_name_bean = replace_na(country_name_bean, "Unkown")
  ) %>%
  ungroup() %>%
  rename(country_bean = country) %>%
  left_join(
    centroids %>%
      select(
        iso3c,
        lat_company = latitude,
        lon_company = longitude
      ),
    by = c("country_company" = "iso3c")
  ) %>%
  left_join(
    centroids %>%
      select(
        iso3c,
        lat_bean = latitude,
        lon_bean = longitude
      ),
    by = c("country_bean" = "iso3c")
  )

map1 <- ggplot() +
  geom_sf(
    data = countries,
    fill = "grey20"
  ) +
  geom_segment(
    data = sum_df,
    aes(
      x = lon_bean,
      xend = lon_company,
      y = lat_bean,
      yend = lat_company,
    ),
    color = "white",
    alpha = .6,
    size = .15
  ) +
  scale_color_viridis_c(direction = -1, option = "inferno") +
  geom_point(
    data = sum_df,
    aes(x = lon_company, y = lat_company),
    size = 1.5,
    color = "yellow"
  ) +
  geom_point(
    data = sum_df,
    aes(x = lon_bean, y = lat_bean),
    shape = "square",
    size = 1.5,
    color = "chocolate"
  ) +
  ggdark::dark_theme_void(14)

map2 <- map1 +
  facet_wrap(~review_date) +
  labs(
    title = "Chocolate: from <span style='color:chocolate;'>source</span> to <span style='color:yellow;'>manufacturer</span>",
    subtitle = "#TidyTuesday, 2022-01-18: \"Chocolate ratings\"",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  theme(
    strip.text = element_text(face = "bold.italic", size = 14),
    plot.title = ggtext::element_markdown(size = 32),
    plot.subtitle = element_text(color = "grey80"),
    plot.caption = element_text(family = "Inconsolata"),
    plot.margin = unit(rep(.5, 4), "cm")
  )
#map2

ggsave(
  plot = map2,
  filename = "2022-01-18_chocolate/map-source-manufacturer-faceted.png",
  width = 18,
  height = 9
)

anim <- map1 +
  labs(
    title = "Chocolate: from <span style='color:chocolate;'>source</span> to <span style='color:yellow;'>manufacturer</span> - Year: {closest_state}",
    subtitle = "#TidyTuesday, 2022-01-18: \"Chocolate ratings\"",
    caption = "@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  theme(
    strip.text = element_text(face = "bold.italic", size = 14),
    plot.title = ggtext::element_markdown(size = 32),
    plot.subtitle = element_text(color = "grey80"),
    plot.caption = element_text(family = "Inconsolata"),
    plot.margin = unit(rep(.5, 4), "cm")
  ) +
  transition_states(review_date, transition_length = 5, state_length = 5)

#anim
anim_save(
  anim,
  file = "2022-01-18_chocolate/map-source-manufacturer-anim.gif",
  nframes = 160,
  fps = 5,
  width = 960,
  height = 480
)

