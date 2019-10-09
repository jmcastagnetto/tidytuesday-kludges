# Trying a GLM model
library(tidyverse)
library(ggdark)
library(showtext)

load(
  here::here("2019-10-08_international-powerlifting/ipf.Rdata")
)

model <- glm(weight_lifted ~ age + sex + weightlifting_type +
               n + equipment + bodyweight_kg,
               data = athlete_trajectory)

athlete_trajectory$pred <- predict(model, athlete_trajectory,
                                   type = "response" )

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

# make a hex plot

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


glm_plot <- ggplot(athlete_trajectory,
       aes(x = weight_lifted, y = pred, group = sex)) +
  geom_abline(slope = 1, intercept = 0, color = "white", alpha = 0.3, size = 0.2) +
  geom_hex(bins = 30, na.rm = TRUE) +
  geom_text(data = summ_corr, aes(label = label),
            x = 450, y = 200, hjust = 0, color = "white") +
  ylim(0, 500) +
  labs(
    title = "Predicted vs actual weight lifted by athletes",
    subtitle = "Using GLM. Shown grouped by gender and weighlifting type.",
    caption = caption_str,
    x = "Weight Lifted (kg)",
    y = "Predicted value (kg)"
  ) +
  scale_fill_viridis_c(name = "", option = "plasma", guide = "colorbar") +
  facet_grid(weightlifting_type~sex) +
  custom_theme_opt +
  guides(fill = guide_colorbar(draw.llim = TRUE, draw.ulim = TRUE,
                               barheight = unit(5, "cm")))

ggsave(
  plot = glm_plot,
  filename = here::here("2019-10-08_international-powerlifting/glm_model_weightlifted_predicted.png"),
  width = 8,
  height = 6
)

