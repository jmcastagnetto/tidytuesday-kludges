library(tidyverse)
library(echarts4r)
library(echarts4r.assets)

load(here::here("2019-08-20_nuclear-explosions/sipri.Rdata"))

d <- sipri %>%
  filter(
    !is.na(r_blast)
  ) %>%
  mutate(
    ts = lubridate::ymd(
      paste0(
        sprintf("%08d", as.integer(date_long))
      )
    ),
    yield_value = max(yield_lower, yield_upper, na.rm = TRUE)
  ) %>%
  arrange(
    ts
  ) %>%
  mutate(
    ycumul = cumsum(yield_value)
  )

d %>%
  e_charts(ts, animation = TRUE) %>%
  e_line(ycumul, legend = FALSE, animation = TRUE) %>%
  e_theme("infographic")

d %>%
  mutate(
    decade = (year %/% 10 ) * 10
  ) %>%
  group_by(country, decade) %>%
  summarise(
    ycumul = sum(yield_value, na.rm = TRUE)
  ) %>%
  ggplot(aes(x = decade, y = ycumul / 1e3, fill = country)) +
  geom_col() +
#  scale_y_log10() +
  labs(
    title = "Cummulative yields in Megatons per country and decade"
  ) +
  xlab("") +
  ylab("") +
  jmcastagnetto_style() +
  theme(
    legend.position = "none"
  ) +
  facet_wrap(~country, ncol = 4, scales = "free_y")
