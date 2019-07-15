library(tidyverse)
library(echarts4r)

load(
  here::here("2019-07-16-r4ds-members/data/r4ds_members.Rdata")
)

r4ds_members %>%
  mutate(
    pct_active = daily_active_members / total_membership,
    year = lubridate::year(date)
  ) %>%
  group_by(year) %>%
  e_charts(date) %>%
  e_calendar(range = "2017", top = "40") %>%
  e_calendar(range = "2018", top = "260") %>%
  e_calendar(range = "2019", top = "480") %>%
  e_heatmap(pct_active, coord_system = "calendar") %>%
  e_visual_map(pct_active) %>%
  e_tooltip("item", formatter = e_tooltip_item_formatter("percent"))
