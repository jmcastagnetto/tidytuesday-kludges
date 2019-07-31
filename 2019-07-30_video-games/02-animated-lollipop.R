library(tidyverse)
library(ggalt)
library(gganimate)

load(
  here::here("2019-07-30_video-games/data/video-games.Rdata")
)

ggplot(video_games %>%
         group_by(release_year, price_range, owners) %>%
         summarise(n = n()),
       aes(x = owners, y = n, color = price_range)) +
  geom_col(position = "dodge") +
  theme_minimal() +
  scale_fill_viridis_d(option = "magma") +
  coord_flip() +
  facet_wrap(~price_range, ncol = 2) +
  labs(
    title = "Distribution of game ownership by release year",
    subtitle = "Release Year: {closest_state}",
    x = "Range of ownership",
    caption = "@jcastagnetto (Jesus M. Castagnetto)"
  ) +
  theme(
    legend.position = "none"
  ) +
  transition_states(
    release_year
  ) +
  enter_grow() +
  exit_shrink()
