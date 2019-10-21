library(tidyverse)
library(ggpirate)
library(devout)

load(
  here::here("2019-10-15_big-epa-cars/big-epa.Rdata")
)

electric_only <- big_epa_cars %>%
  filter(fuelType1 == "Electricity") %>%
  select(
    comb08,
    hybrid
  ) %>%
  rename(
    mpg = 1
  )

electric_hybrids <- big_epa_cars %>%
  filter(fuelType2 == "Electricity") %>%
  select(
    combA08,
    hybrid
  ) %>%
  rename(
    mpg = 1
  )

electric_cars <- bind_rows(electric_only, electric_hybrids) %>%
  mutate(
    is_hybrid = ifelse(hybrid, "Hybrid car", "Normal car")
  )

p3 <- ggplot(electric_cars,
       aes(x = is_hybrid, y = mpg, color = is_hybrid)) +
  geom_pirate(
    bars = FALSE
  ) +
  theme_minimal() +
  labs(
    y = "Fuel economy (mpg)",
    x = "",
    title = "Fuel economy in electric cars",
    subtitle = "Fully electric perform better than hybrid cars",
    caption = "#TidyTuesday, 2019-10-15\n@jmcastagnetto, Jesus M. Castagnetto"
  ) + theme(
    plot.margin = unit(rep(1, 4), "cm"),
    plot.title = element_text(size = 34),
    plot.subtitle = element_text(size = 24, face = "italic"),
    plot.caption = element_text(family = "fixed", size = 12),
    strip.text = element_text(size = 18),
    axis.text = element_text(size = 14),
    axis.title = element_text(size = 16)
  )


ascii(width = 80, height = 40,
      filename = here::here("2019-10-15_big-epa-cars/04-hybrid-vs-normal-electric_ascii.txt"))
ggplot(electric_cars,
             aes(x = is_hybrid, y = mpg, col = is_hybrid)) +
  geom_violin(show.legend = FALSE, draw_quantiles = TRUE) +
  ylim(0, 150) +
  theme_bw() +
  labs(
    y = "mpg",
    x = "",
    title = "Fuel economy in electric cars",
    subtitle = "Fully electric perform better than hybrid cars",
    caption = "#TidyTuesday, 2019-10-15 // @jmcastagnetto, Jesus M. Castagnetto"
  )
dev.off()