library(tidyverse)

#library(tidytuesdayR)
# ttd <- tidytuesdayR::tt_load('2020-01-07')
#
# save(
#   ttd,
#   file = here::here("2020-01-07_australia-fires/rawdata.Rdata")
# )

# Get the Data
rainfall <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-07/rainfall.csv')

rainfall <- rainfall %>%
  mutate_at(
    vars(station_code, city_name, station_name, quality),
    fct_explicit_na
  ) %>%
  mutate(
    date = lubridate::ymd(glue::glue("{y}-{m}-{d}", y = year, m = month, d = day))
  )

temperature <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-07/temperature.csv')

temperature <- temperature %>%
  mutate_at(
    vars(city_name, temp_type, site_name),
    fct_explicit_na
  )

nasa_fire <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-01-07/MODIS_C6_Australia_and_New_Zealand_7d.csv')

nasa_fire <- nasa_fire %>%
  mutate_at(
    vars(satellite, version, daynight),
    fct_explicit_na
  ) %>%
  mutate(
    timestamp = glue::glue("{d} {h}:{m}:00",
                 d = acq_date,
                 h = substr(acq_time, 1, 2),
                 m = substr(acq_time, 3, 4)) %>%
      lubridate::ymd_hms()
  )

url <- "http://www.rfs.nsw.gov.au/feeds/majorIncidents.json"
aus_fires <- sf::st_read(url)

save(
  rainfall, temperature, nasa_fire, aus_fires,
  file = here::here("2020-01-07_australia-fires/rawdata.Rdata")
)
