library(tidyverse)

park_visits <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-17/national_parks.csv")
state_pop <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-17/state_pop.csv")
gas_price <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-09-17/gas_price.csv")

df <- park_visits %>%
  group_by(year, state) %>%
  summarise(
    tot_visitors = sum(visitors, na.rm = TRUE),
    n_parks = n()
  ) %>%
  ungroup() %>%
  mutate(
    year = as.numeric(year)
  ) %>%
  left_join(
    state_pop,
    by = c("year", "state")
  ) %>%
  mutate(
    ratio = tot_visitors / pop
  )

save(
  df,
  park_visits,
  state_pop,
  gas_price,
  file = here::here("2019-09-17_national-park-visits/park-visits.Rdata")
)
