library(tidyverse)

load(
  here::here("2019-10-08_international-powerlifting/ipf.Rdata")
)

mk_event_lift_plot <- function(df) {
  ggplot(athlete_trajectory, aes(x = age)) +
    geom_count(aes(y = weight_lifted, color = weight_event),
               alpha = 0.1, show.legend = FALSE) +
    geom_smooth(aes(y = weight_lifted),
                color = "black") +
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

mk_event_lift_plot(athlete_trajectory)


female_ath_traj <- athlete_trajectory %>%
  filter(sex == "F")

mk_event_lift_plot(female_ath_traj) +
  labs(
    title = "Female Athletes"
  )

male_ath_traj <- athlete_trajectory %>%
  filter(sex == "M")

mk_event_lift_plot(male_ath_traj) +
  labs(
    title = "Male Athletes"
  )

model <- glm(weight_lifted ~ age + sex + weight_event + n_range,
             data = athlete_trajectory)

athlete_trajectory$pred <- predict(model, athlete_trajectory, type = "response" )


ggplot(athlete_trajectory) +
  geom_count(aes(x = weight_lifted, y = pred, color = sex),
             alpha = .3) +
  scale_color_discrete(name = "Gender", labels = c("Female", "Male")) +
  guides(size = "none") +
  facet_grid(weight_event~n_range)

