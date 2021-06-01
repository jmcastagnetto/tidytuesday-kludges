library(tidyverse)
viewers <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-01/viewers.csv')

viewers <- viewers %>%
  mutate(
    # days from beginning of series
    ndays = as.numeric(episode_date - min(episode_date)) + 1
  )
saveRDS(viewers, file = "2021-06-01_survivor/viewers.rds")