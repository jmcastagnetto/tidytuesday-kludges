library(tidyverse)
library(forcats)

load(
  here::here("2019-07-09_womens-world-cup-results/data/orig/wwc_results.Rdata")
)

wwc_sum <- wwc_outcomes %>%
  group_by(country) %>%
  summarise(
    win_game_ratio = round(sum(win_status == "Won") / n(), 2)
  ) %>%
  arrange(
    -win_game_ratio
  ) %>%
  top_n(20, win_game_ratio)

min_yr <- min(wwc_outcomes$year)
max_yr <- max(wwc_outcomes$year)

ggplot(wwc_sum,
       aes(x = fct_reorder(country, win_game_ratio),
           y = win_game_ratio)) +
  geom_point(size = 2, color = "blue") +
  geom_segment(aes(xend = fct_reorder(country, win_game_ratio),
                   y = 0, yend = win_game_ratio),
               size = 1) +
  coord_flip() +
  labs(
    x = "", y = "",
    title = "Top 20 teams by overall Wins/Games ratio",
    subtitle = glue::glue("years: ({min_yr}, {max_yr}) - #TidyTuesday, 2019-07-09"),
    caption = "Jesus M. Castagnetto (@jmcastagnetto)"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.direction = "horizontal"
  )

ggsave(
  filename = here::here("2019-07-09_womens-world-cup-results/20190709-wwcr-lollipop_plot.png")
)
