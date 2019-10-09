library(tidyverse)
library(ggdark)
library(showtext)

load(
  here::here("2019-10-08_international-powerlifting/ipf.Rdata")
)

font_add_google("Special Elite", "sp_elite")
font_add_google("Inconsolata", "inconsolata")

showtext_auto(TRUE)

custom_theme_opt <- dark_theme_light() +
  theme(
    axis.title = element_text(size = 18),
    axis.text = element_text(size = 14),
    strip.text = element_text(color = "yellow", size = 20),
    plot.title = element_text(family="sp_elite", size = 42),
    plot.subtitle = element_text(family="sp_elite", size = 32),
    plot.caption = element_text(family = "inconsolata", size = 18),
    plot.margin = unit(rep(1, 4), "cm")
  )

caption_str <- "#TidyTueday, International Powerlifting, 2019-10-08 // @jmcastagnetto, Jesus M. Castagnetto"

# weightlifting vs age, by type and gender for each athlete
# pick only athletes with 20 or more data points ----

tplot <- ggplot(athlete_trajectory %>% filter(n >= 20),
       aes(x = age, y = weight_lifted, group = name)) +
  geom_point(color = "grey50", size = 0.2, alpha = 0.3) +
  geom_smooth(aes(color = weightlifting_type), method = "glm",
              formula = y ~ poly(x, 2, raw = TRUE),
              size = 0.2, se = FALSE, show.legend = FALSE) +
  labs(
    x = "Age (years)",
    y = "Weight lifted (kg)",
    title = "How age affects weight lifted for each athlete",
    subtitle = "Using those who participated in 20+ events. Peak lifting capacity at approx. the 30s",
    caption = caption_str
  ) +
  facet_grid(weightlifting_type ~ sex) +
  custom_theme_opt

ggsave(
  plot = tplot,
  filename = here::here("2019-10-08_international-powerlifting/weightlifting-age-trajectory.png"),
  width = 8,
  height = 6
)

# weightlifting capacity by age, number of events attended and gender

mk_lift_type_plot <- function(df) {
  ggplot(df, aes(x = age)) +
    geom_count(aes(y = weight_lifted, color = weightlifting_type),
               alpha = 0.2, show.legend = FALSE) +
    geom_smooth(aes(y = weight_lifted), color = "white",
                method = "glm", formula = y ~ poly(x, 2, raw = TRUE), se = FALSE) +
    labs(
      x = "Age (years)",
      y = "Weight lifted (kg)"
    ) +
    ylim(0, 500) +
    scale_color_discrete(name = "Lift type") +
    theme(
      legend.position = "bottom"
    ) +
    facet_grid(weightlifting_type~n_range)
}

all_plot <- mk_lift_type_plot(athlete_trajectory) +
  labs(
    title = "Changes in weight-lifting capacity with age for all athletes",
    subtitle = "By number of competition events attended, and type of lifting",
    caption = caption_str
  ) +
  custom_theme_opt

ggsave(
  plot = all_plot,
  filename = here::here("2019-10-08_international-powerlifting/all-athletes-weighlifting-age-events-type.png"),
  width = 8,
  height = 6
)

female_ath_traj <- athlete_trajectory %>%
  filter(sex == "Female")

female_ath_plot <- mk_lift_type_plot(female_ath_traj) +
  labs(
    title = "Changes in female athletes weight-lifting capacity with age",
    subtitle = "By number of competition events attended, and type of lifting",
    caption = caption_str
  ) +
  custom_theme_opt

ggsave(
  plot = female_ath_plot,
  filename = here::here("2019-10-08_international-powerlifting/female-athletes-weighlifting-age-events-type.png"),
  width = 8,
  height = 6
)

male_ath_traj <- athlete_trajectory %>%
  filter(sex == "Male")

male_ath_plot <- mk_lift_type_plot(male_ath_traj) +
  labs(
    title = "Changes in male athletes weight-lifting capacity with age",
    subtitle = "By number of competition events attended, and type of lifting",
    caption = caption_str
  ) +
  custom_theme_opt

ggsave(
  plot = male_ath_plot,
  filename = here::here("2019-10-08_international-powerlifting/male-athletes-weighlifting-age-events-type.png"),
  width = 8,
  height = 6
)
