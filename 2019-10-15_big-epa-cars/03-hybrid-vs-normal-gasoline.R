library(tidyverse)

load(
  here::here("2019-10-15_big-epa-cars/big-epa.Rdata")
)

table(big_epa_cars$fuelType1, big_epa_cars$fuelType2, useNA = "ifany")

gasoline_df <- big_epa_cars %>%
  filter(str_detect(fuelType1, "Gasoline") &
           !str_detect(fuelType1, "Midgrade")) %>%
  mutate(
    is_hybrid = ifelse(hybrid, "Hybrid car", "Normal car")
  )

library(ggpirate)

ggplot(gasoline_df,
       aes(x = is_hybrid, y = comb08, color = is_hybrid)) +
  geom_sina(size = 0.5, alpha = 0.5, show.legend = FALSE) +
  geom_boxplot(color = "black", alpha = 0.5, show.legend = FALSE) +
  ylim(0,60) +
  theme_bw() +
  labs(
    y = "Fuel economy (mpg)",
    x = "",
    title = "Fuel economy: hybrid and normal cars",
    subtitle = "Using Gasoline as fuel: Hybrids perform better with Premium Gasoline\nthan with Regular, relative to normal cars",
    caption = "#TidyTuesday, 2019-10-15\n@jmcastagnetto, Jesus M. Castagnetto"
  ) +
  coord_flip() +
  theme(
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 34),
    plot.subtitle = element_text(size = 24, face = "italic"),
    plot.caption = element_text(family = "fixed", size = 12),
    strip.text = element_text(size = 18),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 16)
  ) +
  facet_wrap(~fuelType1)


