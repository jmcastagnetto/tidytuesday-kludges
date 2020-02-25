library(tidyverse)
measles_raw <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-25/measles.csv')

skimr::skim(measles_raw)

measles <- measles_raw %>%
  mutate(
    xrel = as.numeric(xrel), # fix type for xrel
    type = replace_na(type, "Unknown")
  ) %>%
  mutate_at( # let's impute the NA's to 0.0%
    vars(xrel, xmed, xper),
    replace_na, 0.0
  ) %>%
  mutate_at( # and convert the -1 to NA's
    vars(overall, mmr),
    na_if, -1
  )

save(
  measles_raw, measles,
  file = here::here("2020-02-25_measles-vaccination/measles-vaccination.Rdata")
)
