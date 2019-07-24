library(tidyverse)
library(forcats)
library(ggridges)

load(
  here::here("2019-07-09_womens-world-cup-results/data/orig/wwc_results.Rdata")
)

p1 <- ggplot(squads,
       aes(x = age,
           y = fct_reorder(country, age, .fun = median, .desc = TRUE),
           fill = ..x..)) +
  geom_density_ridges_gradient(
    quantile_lines = TRUE,
    quantiles = 2,
    vline_color = "white",
    vline_size = 1) +
  scale_fill_viridis_c(
    name = "Ages\n(years)",
    direction = -1,
    option = "plasma") +
  theme_minimal() +
  labs(x = "", y = "",
    title = "Age distribution in Women's Worl Cup Squads (2019)",
    subtitle = "By youngest median age, #TidyTuesday, 2019-07-09",
    caption = "Jesus M. Castagnetto (@jmcastagnetto)"
  ) +
  theme(
    legend.direction = "horizontal",
    legend.position = "bottom"
  )

ggsave(
  filename = here::here("2019-07-09_womens-world-cup-results/20190709-wwcr-ridges_plot.png"),
  plot = p1, width = 6, height = 9
)
