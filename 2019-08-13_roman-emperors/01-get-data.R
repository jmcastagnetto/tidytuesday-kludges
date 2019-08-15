library(tidyverse)
library(lubridate)

emperors <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-08-13/emperors.csv")

df <- emperors %>%
  mutate(
    prev_reign_end = lag(reign_end),
    interregno = interval(prev_reign_end, reign_start),
    interr_days = int_length(interregno) / (3600 * 24),
    interr_mnths = interr_days / 30
  ) %>%
  select(
    index,
    name,
    reign_start,
    reign_end,
    interr_days,
    interr_mnths
  )
