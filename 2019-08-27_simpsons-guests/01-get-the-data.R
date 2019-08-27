library(tidyverse)

simpsons_raw <- readr::read_delim("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-27/simpsons-guests.csv", delim = "|", quote = "")

simpsons <- simpsons_raw %>%
  separate_rows(
    role,
    sep = ";",
    convert = TRUE
  ) %>%
  mutate(
    episode_title = str_replace(episode_title,fixed(";"), "")
  )

save(
  simpsons_raw,
  simpsons,
  file = here::here("2019-08-27_simpsons-guests/simpsons-guests.Rdata")
)

