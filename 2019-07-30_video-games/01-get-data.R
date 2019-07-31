library(tidyverse)
library(lubridate)

video_games <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-07-30/video_games.csv")

video_games <- video_games %>%
  mutate(
    release_date = mdy(release_date),
    release_year = year(release_date),
    developer = as.factor(developer),
    publisher = as.factor(publisher),
    owners = str_replace_all(owners, ",", "")
  ) %>%
  extract(
    col = owners,
    into = c("min_owners", "max_owners"),
    regex = "(\\d+)[^\\d]+(\\d+)",
    convert = TRUE
  ) %>%
  mutate(
    owners = forcats::fct_reorder(paste(min_owners, max_owners, sep = " - "), min_owners, .desc = TRUE),
    price_range = cut(price, breaks = c(0, 20, 40, 600))
  )

save(
  video_games,
  file = here::here("2019-07-30_video-games/data/video-games.Rdata")
  )
