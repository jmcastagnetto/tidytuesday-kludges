library(tidyverse)

load(here::here("2020-01-21_song-genres", "spotify-songs.Rdata"))

ggplot(
  spotify_songs,
  aes(x = valence, y = playlist_subgenre, fill = playlist_genre)
) +
  ggridges::geom_density_ridges(
    show.legend = FALSE,
    panel_scaling = FALSE,
    quantile_lines = TRUE,
    quantiles = c(.05, .95),
    alpha = .7
  ) +
  facet_wrap(~playlist_genre, scales = "free_y") +
  scale_x_continuous(limits = c(0, 1)) +
  ggridges::theme_ridges() +
  labs(
    y = ""
  )
