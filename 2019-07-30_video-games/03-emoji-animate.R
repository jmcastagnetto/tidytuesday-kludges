library(tidyverse)
library(ggalluvial)
library(gganimate)
library(ggimage)

load(
  here::here("2019-07-30_video-games/data/video-games.Rdata")
)

video_games <- video_games %>%
  mutate(
    owners = forcats::fct_lump_min(owners, min = 500),
    developer = forcats::fct_lump_min(developer, min = 50) %>%
      forcats::fct_explicit_na(),
    publisher = forcats::fct_lump_min(publisher, min = 50) %>%
      forcats::fct_explicit_na(),
    price_range = forcats::fct_explicit_na(price_range)
  )


%>%
  group_by(
    release_year,
    owners,
    developer,
    price_range
  ) %>%
  tally() %>%
  mutate(
    p = 1.5*n/max(n)
  )

a_plot <- ggplot(video_games, aes(y = owners, x = price_range)) +
  ggimage::geom_emoji(aes(image = "1f47e", color = developer), alpha = 0.3,
                      position = position_jitter(width = 0.2, height = 0.2)) +
  scale_fill_viridis_d(option = "magma", direction = -1) +
  theme_minimal() +
  labs(
    title = "Games released on {closest_state} and number of people owning them",
    subtitle = "#Tidyverse - 2019-07-30, Video games dataset",
    x = "Price Range",
    y = "Number of owners of the game",
    caption = "@jmcastagnetto (Jesus M. Castagnetto), 2019"
  ) +
  theme(
    legend.position = "none"
  ) +
  transition_states(release_year) +
  ease_aes("elastic-in-out")

#animate(a_plot, nframes = 360, renderer = gifski_renderer(width = 1200, height = 500))
anim_save(
  filename = here::here("2019-07-30_video-games/animation.gif"),
  animation = a_plot,
  nframes = 200,
  renderer = gifski_renderer(width = 1200, height = 500)
)
