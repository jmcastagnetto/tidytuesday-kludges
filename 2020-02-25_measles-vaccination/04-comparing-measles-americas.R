library(tidyverse)
library(readxl)


measles1 <- read_xls(
  path = here::here("2020-02-25_measles-vaccination/who-data/incidence_series.xls"),
  sheet = 5
) %>%
  pivot_longer(
    cols = 5:43,
    names_to = "year",
    values_to = "total"
  ) %>%
  mutate(
    year = as.integer(year)
  ) %>%
  janitor::clean_names() %>%
  rename(
    region = who_region,
    country = cname,
    iso3 = iso_code
  )

measles2 <- read_xls(
  path = here::here("2020-02-25_measles-vaccination/who-data/measlescasesbycountrybymonth.xls"),
  sheet = 2
) %>%
  pivot_longer(
    cols = January:December,
    names_to = "month",
    values_to = "cases"
  ) %>%
  janitor::clean_names() %>%
  mutate(
    cases = as.integer(cases),
    ts = lubridate::ymd(
      glue::glue("{y}-{m}-{d}", y = year, m = month, d = "01")
    )
  )

measles_cntry_year <- measles2 %>%
  group_by(region, country, iso3, year) %>%
  summarise(
    total = sum(cases, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  bind_rows(
    measles1 %>%
      select(region, country, iso3, year, total)
  ) %>%
  arrange(
    region, country, iso3, year
  )

ggplot(measles_cntry_year %>% filter(region == "AMR"),
       aes(x = year,
           y = total, fill = iso3)) +
  # geom_segment(
  #   aes(xend = year, yend = 0),
  #   show.legend = FALSE
  # ) +
  # geom_point(show.legend = FALSE) +
  geom_col(show.legend = FALSE, width = 1) +
  scale_y_log10() +
  scale_color_viridis_d(direction = -1) +
  annotation_logticks(sides = "l") +
  facet_wrap(~iso3) +
  theme_minimal(14) +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, size = 9),
    axis.text.y = element_text(size = 9),
    axis.ticks = element_blank(),
    strip.background = element_rect(fill = "grey90", color = "grey90"),
    strip.text = element_text(size = 9, color = "black"),
    plot.margin = unit(rep(1, 4), "cm")
  ) +
  labs(
    y = "",
    x = "",
    title = "Evolution of measles cases in the Americas (1980-2020): Not all countries managed to reduce or eliminate cases.",
    subtitle = "Source: WHO 'Measles and Rubella Surveillance Data' (Downloaded: 2020-02-26T09:22:00 PET)",
    caption = "2020-02-27, @jmcastagnetto, Jesus M. Castagnetto"
  )

ggsave(
  filename = here::here("2020-02-25_measles-vaccination/historical-measles-in-americas.png"),
  width = 14,
  height = 12
)
