library(tidyverse)
library(mgcv)

by_season <- readRDS("2021-06-01_survivor/viewers.rds")%>%
  group_by(season) %>%
  summarise(
    mean_v = mean(viewers, na.rm = TRUE),
    sd_v = sd(viewers, na.rm = TRUE),
    median_v = median(viewers, na.rm = TRUE),
    min_v = min(viewers, na.rm = TRUE),
    max_v = max(viewers, na.rm = TRUE)
  )

m1 <- gam(mean_v ~ s(season), data = by_season)
summary(m1)
gam.check(m1)

m2 <- gam(median_v ~ s(season), data = by_season)
summary(m2)
gam.check(m2)

plot_df <- bind_rows(
  by_season %>%
    select(season, median_v) %>%
    add_column(type = "GAM Estimation", label = NA_character_, desc = NA_character_),
  tibble(
    season = (max(by_season$season)):(max(by_season$season) + 5),
    median_v = NA_real_,
    type = "GAM Forecasting",
    label = "Could it have gone for\nfive more seasons?",
    desc = "Probably not, as the median number of viewers did not seem to be improving."
  )
)

pred <- predict(m2, newdata = plot_df, se.fit = TRUE)
plot_df$fit <- pred$fit
plot_df$se.fit <- pred$se.fit

plot_df <- plot_df %>%
  mutate(
    lower = fit - 1.96 * se.fit,
    upper = fit + 1.96 * se.fit
  )

p1 <- ggplot(
  plot_df,
  aes(x = season)
) +
  geom_ribbon(aes(ymin = lower, ymax = upper), fill = "grey85") +
  geom_point(aes(y = median_v)) +
  geom_line(aes(y = fit, linetype = type), color = "blue", size = 1) +
  ggforce::geom_mark_circle(
    data = plot_df %>% filter(type == "GAM Forecasting"),
    aes(y = fit, group = type, label = label, description = desc),
    label.fontsize = 14,
    label.width = unit(8, "cm")
  ) +
  ggtext::geom_textbox(
    aes(
      x = 1,
      y = 10,
      label = "The median number of viewers per season, shows a steady decline over time, perhaps because people started to lose interest in the series or there were other alternative shows with a similar premise."
    ),
    vjust = 1,
    hjust = 0,
    size = 6,
    width = unit(10, "cm"),
    box.colour = NA
  ) +
  labs(
    y = "Number of viewers (in millions)",
    x = "Season",
    linetype = "",
    title = "Survivor: How the median number of viewers evolved over the seasons",
    subtitle = "Source: 2021-06-01 #TidyTuesday dataset",
    caption = "@jmcastagnetto, Jesus M. Castagnetto (2021-06-01)"
  ) +
  theme_classic(base_size = 16) +
  theme(
    legend.position = "bottom",
    plot.title.position = "plot",
    plot.title = element_text(size = 24),
    plot.subtitle = element_text(size = 20, color = "grey50"),
    plot.caption = element_text(family = "Inconsolata", size = 16)
  )

ggsave(
  plot = p1,
  filename = "2021-06-01_survivor/median-viewers-per-season.png",
  width = 11,
  height = 9
)
