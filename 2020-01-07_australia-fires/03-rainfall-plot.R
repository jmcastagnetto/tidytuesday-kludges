library(tidyverse)

load(here::here("2020-01-07_australia-fires/rawdata.Rdata"))

rf_good <- rainfall %>%
  filter(quality == "Y" & !is.na(rainfall)) %>%
  mutate(
    # impute to period = 1 if rainfall = 0.0
    period = ifelse(rainfall == 0.0, 1, period),
    avg_rainfall = rainfall / period,
    decade = (year %/% 10) * 10
  )

# rf_good_summ <- rf_good %>%
#   group_by(city_name, decade) %>%
#   summarise(
#     avg = mean(avg_rainfall),
#     min = min(avg_rainfall),
#     max = max(avg_rainfall),
#   ) %>%
#   ungroup()

# ggplot(rf_good_summ,
#        aes(x = decade, y = avg)) +
#   geom_point(color = "lightblue") +
#   geom_smooth(aes(x = decade, y = avg),
#               method = "loess", color = "blue") +
#   geom_segment(
#     aes(x = decade, xend = decade,
#         y = min, yend = max),
#     color = "lightblue"
#   ) +
#   scale_y_log10() +
#   annotation_logticks(sides = "l", linetype = "dashed") +
#   facet_wrap(~city_name) +
#   ggdark::dark_theme_bw()
#
#
# ggplot(rf_good %>% filter(decade >= 1950),
#        aes(x = decade, y = avg_rainfall, group = decade)) +
#   #geom_violin(draw_quantiles = c(.25, .5, .75)) +
#   geom_boxplot(outlier.colour = "red", outlier.size = .2) +
#   stat_summary(fun = mean, geom = "point", shape = 20,
#                color = "lightblue", fill = "lightblue") +
#   # geom_point(color = "lightblue") +
#   # geom_smooth(aes(x = decade, y = avg),
#   #             method = "loess", color = "blue") +
#   # geom_segment(
#   #   aes(x = decade, xend = decade,
#   #       y = min, yend = max),
#   #   color = "lightblue"
#   # ) +
#   scale_y_log10() +
#   annotation_logticks(sides = "l", linetype = "dashed", color = "white") +
#   facet_wrap(~city_name) +
#   ggdark::dark_theme_minimal()


ggplot(rf_good,
       aes(x = date, y = avg_rainfall, group = city_name)) +
  #geom_jitter(color = "lightblue", size = .1, alpha = .3) +
  geom_hex(show.legend = FALSE) +
  geom_smooth(method = "gam") +
  #geom_violin(aes(group = decade), fill = NA) +
  geom_boxplot(aes(group = decade),
               outlier.shape = NA, fill = NA,
               notch = TRUE, varwidth = TRUE) +
  scale_y_log10() +
  annotation_logticks(sides = "l", color = "white") +
  labs(
    x = "",
    y = "Rainfall (mm)",
    title = "Changes in rainfall for major cities in Australia",
    subtitle = "Including distributions per decade\nSource: BOM Climate Data Online - http://www.bom.gov.au/climate/data/index.shtml",
    caption = "#TidyTuesday 2020-01-07 // @jmcastagnetto, Jesús M. Castagnetto"
  ) +
  facet_wrap(~city_name, scales = "free") +
  ggdark::dark_theme_minimal(18) +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    panel.grid.minor = element_blank(),
    plot.caption = element_text(family = "Inconsolata"),
    plot.subtitle = element_text(family = "Inconsolata"),
    strip.text = element_text(family = "Open Sans", face = "bold"),
    strip.background.x = element_rect(color = "peru"),
    legend.position = "none"
  )
