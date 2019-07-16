library(tidyverse)
library(echarts4r)

load(
  here::here("2019-07-16-r4ds-members/data/r4ds_members.Rdata")
)

calchart <- r4ds_members %>%
  mutate(
    pct_active = daily_active_members / total_membership,
    pct_msg = daily_members_posting_messages / daily_active_members,
    year = lubridate::year(date)
  ) %>%
  group_by(year) %>%
  e_charts(date) %>%
  e_title(
    text = "Percentage of active members who post messages",
    subtext = "#TidyTuesday: 2019-07-16 R4DS Members",
    sublink = "https://github.com/rfordatascience/tidytuesday/tree/master/data/2019/2019-07-16"
  ) %>%
  e_text_g(
    style = list(
      text = "@jmcastagnetto (Jesus M. Castagnetto)"
    ),
    left = "70%",
    top = 600
    ) %>%
  e_calendar(range = "2017", top = "80") %>%
  e_calendar(range = "2018", top = "260") %>%
  e_calendar(range = "2019", top = "440") %>%
  e_heatmap(pct_msg,
            coord_system = "calendar") %>%
  e_visual_map(pct_msg,
               formatter = e_axis_formatter("percent"),
               orient = "horizontal",
               left = "center",
               top = 600) %>%
  e_tooltip("item",
            formatter = e_tooltip_item_formatter("percent")) %>%
  e_toolbox_feature()

htmlwidgets::saveWidget(
  widget = calchart,
  file =  here::here("2019-07-16-r4ds-members/calendar-chart.html"),
  title = "Calendar chart"
)

