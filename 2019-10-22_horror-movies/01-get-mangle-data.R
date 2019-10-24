library(tidyverse)
library(lubridate)

get_year <- function(dt) {
  yr =  ifelse(
    str_detect(dt, fixed("-")),
    year(dmy(dt)),
    as.numeric(dt)
  )
}

horror_movies <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-10-22/horror_movies.csv") %>%
  mutate(
    release_yr = get_year(release_date)
  )

horror_movies_actor <- horror_movies %>%
  separate_rows(
    cast,
    sep = "\\|"
  ) %>%
  mutate(
    cast = factor(str_trim(cast))
  ) %>%
  rename(
    actor = cast
  ) %>%
  select(
    title,
    release_yr,
    release_country,
    actor
  ) %>%
  distinct()

horror_movies_genre <- horror_movies %>%
  separate_rows(
    genres,
    sep = "\\|"
  ) %>%
  select(
    title,
    release_yr,
    release_country,
    genres
  ) %>%
  rename(
    genre = genres
  ) %>%
  mutate(
    genre = factor(str_trim(genre))
  ) %>%
  distinct()

save(
  horror_movies, horror_movies_actor, horror_movies_genre,
  file = here::here("2019-10-22_horror-movies/horror-movies.Rdata")
)
