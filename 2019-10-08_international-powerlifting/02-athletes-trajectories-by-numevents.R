library(tidyverse)
library(ggdark)
library(showtext)
library(ggforce)

load(
  here::here("2019-10-08_international-powerlifting/ipf.Rdata")
)

font_add_google("Special Elite", "sp_elite")
font_add_google("Frijole", "frijole")
font_add_google("Inconsolata", "inconsolata")

showtext_auto(TRUE)

mk_event_lift_plot <- function(df) {
  ggplot(athlete_trajectory, aes(x = age)) +
    geom_count(aes(y = weight_lifted, color = weight_event),
               alpha = 0.2, show.legend = FALSE) +
    geom_smooth(aes(y = weight_lifted),
                color = "white") +
    labs(
      x = "Age (years)",
      y = "Weight lifted (kg)"
    ) +
    ylim(0, 500) +
    scale_color_discrete(name = "Lift type") +
    theme_minimal() +
    theme(
      legend.position = "bottom"
    ) +
    facet_grid(weight_event~n_range)
}

custom_theme_opt <-   dark_theme_light() +
  theme(
    strip.text = element_text(color = "yellow"),
    plot.title = element_text(family="sp_elite", size = 32),
    plot.subtitle = element_text(family="sp_elite", size = 24),
    plot.caption = element_text(family = "inconsolata", size = 14),
    plot.margin = unit(rep(1, 4), "cm")
  )

mk_event_lift_plot(athlete_trajectory) +
  labs(
    title = "Changes in an athlete's weight-lifting capacity with age",
    subtitle = "By number of competition events attended, and type of lifting",
    caption = "#TidyTueday, International Powerlifting, 2019-10-08\n@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  custom_theme_opt

female_ath_traj <- athlete_trajectory %>%
  filter(sex == "F")

mk_event_lift_plot(female_ath_traj) +
  labs(
    title = "Changes in a female athlete's weight-lifting capacity with age",
    subtitle = "By number of competition events attended, and type of lifting",
    caption = "#TidyTueday, International Powerlifting, 2019-10-08\n@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  custom_theme_opt

male_ath_traj <- athlete_trajectory %>%
  filter(sex == "M")

mk_event_lift_plot(male_ath_traj) +
  labs(
    title = "Changes in a male athlete's weight-lifting capacity with age",
    subtitle = "By number of competition events attended, and type of lifting",
    caption = "#TidyTueday, International Powerlifting, 2019-10-08\n@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  custom_theme_opt

model <- glm(weight_lifted ~ age + sex + weight_event + n_range,
             data = athlete_trajectory, )


athlete_trajectory$pred <- predict(model, athlete_trajectory, type = "response" )

athlete_trajectory <- athlete_trajectory %>%
  mutate(
    sex = ifelse(sex == "F", "Female", "Male")
  )

ggplot(athlete_trajectory,
       aes(x = weight_lifted, y = pred, group = sex)) +
  geom_hex(bins = 30) +
  #scale_color_discrete(name = "Gender") +
  #scale_fill_gradientn(colors = terrain.colors(10)) +
  xlim(0, 500) +
  guides(color = "none") +
  facet_grid(weight_event~n_range) +
  dark_theme_light()

