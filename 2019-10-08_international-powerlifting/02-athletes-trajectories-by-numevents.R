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

custom_theme_opt <- dark_theme_light() +
  theme(
    axis.title = element_text(size = 14),
    axis.text = element_text(size = 12),
    strip.text = element_text(color = "yellow", size = 14),
    plot.title = element_text(family="sp_elite", size = 32),
    plot.subtitle = element_text(family="sp_elite", size = 24),
    plot.caption = element_text(family = "inconsolata", size = 14),
    plot.margin = unit(rep(1, 4), "cm")
  )

caption_str <- "#TidyTueday, International Powerlifting, 2019-10-08\n@jmcastagnetto, Jesus M. Castagnetto"

# weightlifting vs age, by type and gender for each athlete
# pick only athletes with 20 or more data points

ggplot(athlete_trajectory %>% filter(n >= 20),
       aes(x = age, y = weight_lifted, group = name)) +
  geom_point(color = "grey50", size = 0.2) +
  geom_smooth(aes(color = weightlifting_type), method = "glm", formula = y ~ poly(x, 2, raw = TRUE),
              size = 0.1, se = FALSE, show.legend = FALSE) +
  labs(
    x = "Age (years)",
    y = "Weight lifted (kg)",
    title = "How age affects weight lifted for each athlete",
    subtitle = "Considering only those who participated en 20 or more events",
    caption = caption_str
  ) +
  facet_grid(weightlifting_type ~ sex) +
  custom_theme_opt


# weightlifting capacity by age, number of events attended and gender

mk_event_lift_plot <- function(df) {
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

mk_event_lift_plot(athlete_trajectory) +
  labs(
    title = "Changes in weight-lifting capacity with age for all athletes",
    subtitle = "By number of competition events attended, and type of lifting",
    caption = caption_str
  ) +
  custom_theme_opt

female_ath_traj <- athlete_trajectory %>%
  filter(sex == "Female")

mk_event_lift_plot(female_ath_traj) +
  labs(
    title = "Changes in female athletes weight-lifting capacity with age",
    subtitle = "By number of competition events attended, and type of lifting",
    caption = caption_str
  ) +
  custom_theme_opt

male_ath_traj <- athlete_trajectory %>%
  filter(sex == "Male")

mk_event_lift_plot(male_ath_traj) +
  labs(
    title = "Changes in male athletes weight-lifting capacity with age",
    subtitle = "By number of competition events attended, and type of lifting",
    caption = caption_str
  ) +
  custom_theme_opt

# Can we model this?
model <- glm(weight_lifted ~ age + sex + weightlifting_type + n + equipment + bodyweight_kg,
             data = athlete_trajectory)

athlete_trajectory$pred <- predict(model, athlete_trajectory, type = "response" )

summ_corr <- athlete_trajectory %>%
  group_by(weightlifting_type, sex) %>%
  summarise(
    n = n(),
    na_pred = sum(is.na(pred)),
    cor = cor(weight_lifted, pred, use = "complete.obs")
  ) %>%
  mutate(
    label = paste("corr=", round(cor, 2))
  )

ggplot(athlete_trajectory,
       aes(x = weight_lifted, y = pred, group = sex)) +
  geom_abline(slope = 1, intercept = 0, color = "white", alpha = 0.3, size = 0.2) +
  geom_hex(bins = 30, na.rm = TRUE) +
  geom_text(data = summ_corr, aes(label = label),
            x = 450, y = 200, hjust = 0, color = "white") +
  ylim(0, 500) +
  labs(
    title = "Predicted vs actual weight lifted by athletes",
    subtitle = "Shown grouped by gender and weighlifting type",
    caption = caption_str,
    x = "Weight Lifted (kg)",
    y = "Predicted value (kg)"
  ) +
  scale_fill_viridis_c(name = "", option = "plasma", guide = "colorbar") +
  facet_grid(weightlifting_type~sex) +
  custom_theme_opt +
  guides(fill = guide_colorbar(draw.llim = TRUE, draw.ulim = TRUE,
                               barheight = unit(5, "cm")))

