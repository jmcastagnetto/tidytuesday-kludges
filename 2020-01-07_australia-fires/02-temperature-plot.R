library(tidyverse)

load(here::here("2020-01-07_australia-fires/rawdata.Rdata"))

# ggplot(temperature,
#        aes(x = date, y = temperature, group = temp_type)) +
#   geom_point(aes(color = temp_type), size = .5, alpha = .3) +
#   geom_smooth(aes(color = temp_type), size = 2) +
#   facet_wrap(~city_name) +
#   theme_minimal() +
#   theme(
#     legend.position = "none"
#   )
#
# temp_ym <- temperature %>%
#   mutate(
#     yr = lubridate::year(date),
#     mn = lubridate::month(date)
#   )
#
# ggplot(temp_ym %>% filter(city_name == "PERTH"),
#        aes(x = factor(yr), y = temperature)) +
#   ggthemes::geom_tufteboxplot(
#     aes(color = temp_type),
#     median.type = "line",
#     hoffset = 0,
#     width = 3
#     ) +
#   facet_wrap(~temp_type) +
#   ggthemes::theme_tufte() +
#   theme(
#     legend.position = "none",
#     axis.text.x = element_text(angle = 90)
#   )
#
#
# ggplot(temp_ym %>% filter(city_name == "PERTH"),
#        aes(x = yr, y = temperature,
#            group = temp_type, color = temp_type)) +
#   geom_point(
#     size = 0.3,
#     alpha = 0.3
#   ) +
#   geom_smooth(
#     color = "black", method = "gam"
#   ) +
#   ggthemes::geom_rangeframe() +
#   facet_wrap(~temp_type) +
#   ggthemes::theme_tufte() +
#   theme(
#     legend.position = "none"
#   )

temp_ym_summ <- temperature %>%
  mutate(yr = lubridate::year(date),
         mn = lubridate::month(date)) %>%
  group_by(city_name, yr, mn, temp_type) %>%
  summarise(
    avg = mean(temperature, na.rm = TRUE),
    sd = sd(temperature, na.rm = TRUE),
    min = min(temperature, na.rm = TRUE),
    max = max(temperature, na.rm = TRUE)
  ) %>%
  ungroup() %>%
  mutate(
    city_name = str_to_title(city_name),
    ym = glue::glue("{y}-{m}-01", y = yr, m = mn) %>%
      lubridate::ymd(),
    temp_type_lbl = ifelse(temp_type == "min",
                           "Minimum",
                           "Maximum") %>% factor()
  )

ggplot(temp_ym_summ,
       aes(x = ym, y = avg)) +
  geom_point(aes(color = temp_type), size = .2, alpha = .3) +
  geom_smooth(method = "gam", color = "yellow") +
  labs(
    y = "Monthly average temperature (°C)",
    x = "",
    title = "A steady increase in average monthly temperatures for major cities in Australia",
    subtitle = "Source: BOM Climate Data Online - http://www.bom.gov.au/climate/data/index.shtml",
    caption = "#TidyTuesday 2020-01-07 // @jmcastagnetto, Jesús M. Castagnetto"
  ) +
  facet_grid(temp_type_lbl ~ city_name) +
  scale_color_manual(values = c("red", "blue")) +
  ggdark::dark_theme_minimal(18) +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 90),
    plot.caption = element_text(family = "Inconsolata"),
    plot.subtitle = element_text(family = "Inconsolata"),
    strip.text = element_text(family = "Open Sans", face = "bold"),
    strip.background.x = element_rect(color = "peru"),
    legend.position = "none"
  )

ggsave(
  filename = here::here("2020-01-07_australia-fires/20200107-increase-temp-aus.png"),
  width = 12,
  height = 8
)
