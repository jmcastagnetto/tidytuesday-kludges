library(tidyverse)
library(lubridate)

ufo_sightings <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-06-25/ufo_sightings.csv")

ufo_sightings <- ufo_sightings %>%
  mutate(
    date_time = mdy_hm(date_time)
  )

save(ufo_sightings, file = here::here("2019-06-25_ufo-sightings/data/ufo_sightings.Rdata"))
